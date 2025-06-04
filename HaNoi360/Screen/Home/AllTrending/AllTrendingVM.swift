//
//  AllTrendingVM.swift
//  HaNoi360
//
//  Created by Tuấn on 3/6/25.
//

import RxSwift
import RxCocoa

class AllTrendingVM {
    var itemsTrendingPlace = BehaviorRelay<[BlogModel]>(value: [])
    
    let blogService = BaseFirestoreService<BlogModel>(collectionPath: "blogs")
    
    func getTrendingPlace(completion: @escaping () -> Void) {
        blogService.fetchTopRatedPlaces() { result in
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
