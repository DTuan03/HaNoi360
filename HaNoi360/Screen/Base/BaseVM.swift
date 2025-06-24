//
//  BaseVM.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class BaseVM {
    var userId: String {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        }
        return ""
    }
    
    var nameUser: String {
        UserDefaults.standard.string(forKey: "userName") ?? "unknown"
    }
    var avatarUser = UserDefaults.standard.string(forKey: "avatarUrl")
    
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    init() {
//        setupListener()
    }
    
    func setupListener() {
        listener = db.collection("notifications")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let _ = self else { return }
                guard let snapshot = snapshot else {
                    print("Lỗi: \(error?.localizedDescription ?? "Không rõ lỗi")")
                    return
                }
                
                for diff in snapshot.documentChanges {
                    switch diff.type {
                    case .added:
                        print("Thêm mới: \(diff.document.data())")
                    case .modified:
                        print("Sửa: \(diff.document.data())")
                    case .removed:
                        print("Xóa: \(diff.document.data())")
                    }
                }
            }
    }
    
    deinit {
        listener?.remove()
    }
    
    lazy var calendarService = BaseFirestoreService<NewCreateScheduleModel>(collectionPath: "users/\(userId)/calendars")
    lazy var favoriteService = BaseFirestoreService<FavoriteModel>(collectionPath: "users/\(userId)/favorites")
    let reviewService = BaseFirestoreService<ReviewModel>(collectionPath: "reviews")
    let blogService = BaseFirestoreService<BlogPost>(collectionPath: "blogs")
    lazy var checkInService = BaseFirestoreService<CheckInModel>(collectionPath: "users/\(userId)/checkIn")
    lazy var userService = BaseFirestoreService<ProfileModel>(collectionPath: "users")
    lazy var followingService = BaseFirestoreService<ProfileModel>(collectionPath: "users/\(userId)/following")
    lazy var notiService = BaseFirestoreService<NotificationModel>(collectionPath: "notifications")
}
