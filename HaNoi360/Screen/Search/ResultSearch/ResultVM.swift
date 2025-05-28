//
//  ResultVM.swift
//  HaNoi360
//
//  Created by Tuấn on 18/5/25.
//

import RxSwift
import RxCocoa

class ResultVM: BaseVM {
    var keyWord = BehaviorRelay<String?>(value: nil)
    var categoryFilter = BehaviorRelay<[String]>(value: [])
    var resultSearch = BehaviorRelay<[BlogPost]?>(value: nil)
}
