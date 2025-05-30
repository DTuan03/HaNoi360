//
//  MyProfileVM.swift
//  HaNoi360
//
//  Created by Tuấn on 30/5/25.
//

import RxSwift
import RxCocoa


class MyProfileVM: BaseVM {
    var itemsPlace = BehaviorRelay<[BlogPost]>(value: [])
    
    func getPlaces(authorId: String, completion: @escaping () -> Void)  {
        blogService.fetchWhereEqualTo(field: "authorId", value: authorId) { result in
            switch result {
            case .success(let places):
                self.itemsPlace.accept(places)
            case .failure(let error):
                print("Loi")
            }
            completion()
        }
    }
}
