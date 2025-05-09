//
//  BaseVM.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import RxSwift
import RxCocoa

class BaseVM {
    let calendarService = BaseFirestoreService<AddCalendarModel>(collectionPath: "calendars")
    let placeService = BaseFirestoreService<DetailModel>(collectionPath: "places")
    let favoriteService = BaseFirestoreService<FavoriteModel>(collectionPath: "favorites")
    
    var isLoading = PublishRelay<Bool>()
    
    let userId = UserDefaults.standard.string(forKey: "userId")

}
