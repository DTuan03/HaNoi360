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
    
    func addImageCheckIn() {
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
        }

    }
    
    func uploadImage() {
        guard let image = image.value else { return }
        isLoading.accept(true)
        CloudinaryService.shared.uploadImage(image: image) { result in
            switch result {
            case .success(let url):
                self.url.accept(url)
                print(url)
                self.isUploaded.accept(true)
            case .failure(let error):
                print("Lỗi upload: \(error.localizedDescription)")
            }
        }
    }
    
    func featchCheckIn(completion: @escaping () -> Void) {
        checkInService.fetchAll { result in
            switch result {
            case .success(let checkIn):
                self.checkIn.accept(checkIn)
            case .failure(_):
                print("Loi")
            }
            completion()
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
    
    func fetchInfoUser() {
        userService.fetchWhereEqualTo(field: "userId", value: userId) { result in
            switch result {
            case .success(let profile):
                self.user.accept(profile[0])
            case .failure(_):
                print("loi")
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

}
