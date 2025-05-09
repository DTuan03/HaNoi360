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
    
    func featchPlace() {
        favoriteService.fetchWhereEqualTo(field: "userId", value: userId ?? "") { result in
            switch result {
            case .success(let places):
                self.placeFavorite.accept(places)
            case .failure(let error):
                print("Loi: \(error)")
            }
        }
    }
}
