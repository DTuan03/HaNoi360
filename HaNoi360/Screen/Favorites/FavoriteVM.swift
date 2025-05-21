//
//  FavoriteVM.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import RxSwift
import RxCocoa

class FavoriteVM: BaseVM {
    var placeFavorite = BehaviorRelay<[FavoriteModel]?>(value: nil)
    var placeId = BehaviorRelay<String>(value: "")
    var isLoading = BehaviorRelay<Bool?>(value: nil)
    var isSuccess = PublishRelay<Bool>()
    
    func featchPlace() {
        isLoading.accept(true)
        favoriteService.fetchWhereEqualTo(field: "userId", value: userId) { result in
            self.isLoading.accept(false)
            switch result {
            case .success(let places):
                self.placeFavorite.accept(places)
            case .failure(let error):
                print("Loi: \(error)")
            }
        }
    }
    
    
    func deleteFavorite() {
        isLoading.accept(true)
        favoriteService.delete(id: placeId.value) { result in
            self.isLoading.accept(false)
            switch result {
            case .success():
                self.isSuccess.accept(true)
            case .failure( _):
                print("loi")
            }
        }
    }
}
