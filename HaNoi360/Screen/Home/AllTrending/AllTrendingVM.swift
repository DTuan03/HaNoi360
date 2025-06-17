//
//  AllTrendingVM.swift
//  HaNoi360
//
//  Created by Tuấn on 3/6/25.
//

import RxSwift
import RxCocoa

class AllTrendingVM: BaseVM {
    var itemsTrendingPlace = BehaviorRelay<[BlogPost]>(value: [])
        
    func getTrendingPlace(completion: @escaping () -> Void) {
        blogService.fetchTopRatedPlaces(limit: nil) { result in
            switch result {
            case .success( let places):
                self.itemsTrendingPlace.accept(places)
            case .failure(_):
                print("Loi")
            }
            completion()
        }
    }
}
