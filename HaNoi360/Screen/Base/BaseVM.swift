//
//  BaseVM.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import RxSwift
import RxCocoa

class BaseVM {
    var userId: String {
        UserDefaults.standard.string(forKey: "userId") ?? "unknown"
    }

    lazy var calendarService = BaseFirestoreService<AddCalendarModel>(collectionPath: "users/\(userId)/calendars")
    let placeService = BaseFirestoreService<DetailModel>(collectionPath: "places")
    lazy var favoriteService = BaseFirestoreService<FavoriteModel>(collectionPath: "users/\(userId)/favorites")
}
