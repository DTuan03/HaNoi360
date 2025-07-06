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
    var avatarUser = UserDefaults.standard.string(forKey: "avatarUrl") ?? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"
    
    lazy var calendarService = BaseFirestoreService<NewCreateScheduleModel>(collectionPath: "users/\(userId)/calendars")
    lazy var favoriteService = BaseFirestoreService<FavoriteModel>(collectionPath: "users/\(userId)/favorites")
    let reviewService = BaseFirestoreService<ReviewModel>(collectionPath: "reviews")
    let blogService = BaseFirestoreService<BlogPost>(collectionPath: "blogs")
    lazy var checkInService = BaseFirestoreService<CheckInModel>(collectionPath: "users/\(userId)/checkIn")
    lazy var userService = BaseFirestoreService<ProfileModel>(collectionPath: "users")
    lazy var followingService = BaseFirestoreService<ProfileModel>(collectionPath: "users/\(userId)/following")
    lazy var notiService = BaseFirestoreService<NotificationModel>(collectionPath: "notifications")
}
