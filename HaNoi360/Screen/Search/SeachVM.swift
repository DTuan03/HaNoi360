//
//  SeachVM.swift
//  HaNoi360
//
//  Created by Tuấn on 18/5/25.
//

import RxSwift
import RxCocoa

class SeachVM: BaseVM {
    var recentSearch = BehaviorRelay<[SearchModel]?>(value: nil)
}
