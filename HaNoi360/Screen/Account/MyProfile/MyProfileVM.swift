//
//  MyProfileVM.swift
//  HaNoi360
//
//  Created by Tuấn on 30/5/25.
//

import RxSwift
import RxCocoa
import FirebaseFirestore


class MyProfileVM: BaseVM {
    var blogsPost = BehaviorRelay<[BlogPost]>(value: [])
    var image = BehaviorRelay<UIImage?>(value: nil)
    var url = BehaviorRelay<String?>(value: nil)
    var isUploaded = BehaviorRelay<Bool>(value: false)
    var isLoading = PublishRelay<Bool>()
    var checkIn = BehaviorRelay<[CheckInModel]?>(value: nil)
    var user = BehaviorRelay<ProfileModel?>(value: nil)
    var allUrlImage = BehaviorRelay<[String]>(value: [])
    var isFollowing = BehaviorRelay<Bool>(value: false)
    var isDelete = PublishRelay<Bool>()

    func getPlaces(authorId: String, completion: @escaping () -> Void)  {
        blogService.fetchWhereEqualTo(field: "authorId", value: authorId) { result in
            switch result {
            case .success(let places):
                self.blogsPost.accept(places)
            case .failure(let error):
                print("Loi")
            }
            completion()
        }
    }
    
    func addImageCheckIn(completion: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("users").document(userId).collection("checkIn").document(Date().toString(format: "dd-MM-yyyy"))

        docRef.setData([
            "url": FieldValue.arrayUnion([url.value ?? ""])
        ], merge: true) { error in
            if let error = error {
                print("Lỗi update: \(error.localizedDescription)")
                self.isLoading.accept(false)
            } else {
                self.isLoading.accept(false)
                print("Đã thêm link mới")
            }
            completion()
        }

    }
    
    func uploadImage() {
        guard let image = image.value else { return }
        isLoading.accept(true)
        
        let path = "avatars/\(userId).jpg"
        FirebaseStorageService.shared.uploadImage(image, to: path) { result in
            switch result {
            case .success(let url):
                self.url.accept(url)
                self.isUploaded.accept(true)
            case .failure(let error):
                print("Lỗi upload: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchAllCheckIn(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let checkInRef = db.collection("users").document(userId).collection("checkIn")
        
        checkInRef.getDocuments { snapshot, error in
            if let error = error {
                print("Lỗi: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion()
                return
            }
            
            let checkIns: [CheckInModel] = documents.compactMap { doc in
                guard let urls = doc.data()["url"] as? [String] else { return nil }
                let date = doc.documentID
                return CheckInModel(createAt: date, url: urls)
            }
            self.checkIn.accept(checkIns)
            completion()
        }
    }
    
    func fetchInfoUser(userId: String, completion: @escaping () -> Void) {
        isLoading.accept(true)

        userService.fetchWhereEqualTo(field: "userId", value: userId) { result in
            switch result {
            case .success(let profiles):
                guard var profile = profiles.first else {
                    self.isLoading.accept(false)
                    completion()
                    return
                }

                let db = Firestore.firestore()
                let userRef = db.collection("users").document(userId)

                let group = DispatchGroup()

                group.enter()
                userRef.collection("followers").getDocuments { snapshot, error in
                    if let documents = snapshot?.documents {
                        let followers = documents.compactMap { try? $0.data(as: FollowersModel.self) }
                        profile = ProfileModel(
                            userId: profile.userId,
                            avatarUrl: profile.avatarUrl,
                            name: profile.name,
                            email: profile.email,
                            phone: profile.phone,
                            interest: profile.interest,
                            date: profile.date,
                            address: profile.address,
                            followers: followers,
                            following: profile.following
                        )
                    }
                    group.leave()
                }

                group.enter()
                userRef.collection("following").getDocuments { snapshot, error in
                    if let documents = snapshot?.documents {
                        let following = documents.compactMap { try? $0.data(as: FollowingModel.self) }
                        profile = ProfileModel(
                            userId: profile.userId,
                            avatarUrl: profile.avatarUrl,
                            name: profile.name,
                            email: profile.email,
                            phone: profile.phone,
                            interest: profile.interest,
                            date: profile.date,
                            address: profile.address,
                            followers: profile.followers,
                            following: following
                        )
                    }
                    group.leave()
                }

                group.notify(queue: .main) {
                    self.user.accept(profile)
                    self.isLoading.accept(false)
                    completion()
                }

            case .failure(_):
                print("Lỗi khi fetch user")
                self.isLoading.accept(false)
                completion()
            }
        }
    }
    
    func filterImageAlbum() {
        let blogPosts = blogsPost.value
        
        let allImageUrls = blogPosts.flatMap { blogPost in
            blogPost.contentBlocks
                .filter { $0.type == .image && $0.value != nil }
                .compactMap { $0.value }
        }
        self.allUrlImage.accept(allImageUrls)
    }
    
    func followUser(currentUserId: String, targetUserId: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        let currentUserData: [String: Any] = [
            "followeeId": targetUserId,
            "avatarUrl": self.user.value?.avatarUrl ?? "",
            "name": self.user.value?.name ?? ""
        ]
        
        let targetUserData: [String: Any] = [
            "followerId": currentUserId,
            "avatarUrl": self.avatarUser ?? "",
            "name": self.nameUser
        ]
        
        let followerRef = db.collection("users").document(targetUserId).collection("followers").document(currentUserId)
        let followingRef = db.collection("users").document(currentUserId).collection("following").document(targetUserId)
        
        let batch = db.batch()
        batch.setData(targetUserData, forDocument: followerRef)
        batch.setData(currentUserData, forDocument: followingRef)
        
        batch.commit { error in
            if let error = error {
                print("Follow failed: \(error)")
            } else {
                print("Followed successfully")
                completion()
            }
        }
    }

    func unfollowUser(currentUserId: String, targetUserId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        let followerRef = db.collection("users").document(targetUserId).collection("followers").document(currentUserId)
        let followingRef = db.collection("users").document(currentUserId).collection("following").document(targetUserId)
        
        let batch = db.batch()
        batch.deleteDocument(followerRef)
        batch.deleteDocument(followingRef)
        
        batch.commit { error in
            if let error = error {
                print("Unfollow failed: \(error)")
                completion(false)
            } else {
                print("Unfollowed successfully")
                completion(true)
            }
        }
    }

    func deleteBlog(blogId: String, completion: @escaping () -> Void) {
        isLoading.accept(true)
        blogService.delete(id: blogId) { result in
            self.isLoading.accept(false)
            switch result {
            case .success():
                self.isDelete.accept(true)
            case .failure(_):
                self.isDelete.accept(false)
            }
        }
    }
}
