//
//  CategoryViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 13/4/25.
//

import RxSwift
import RxCocoa

class CategoryViewModel {
    let categories: [CategoryModel] = [
        CategoryModel(id: "amThuc", name: "category.food".localized, img: "amThuc"),
        CategoryModel(id: "tamLinh", name: "category.spirituality".localized, img: "tamLinh"),
        CategoryModel(id: "traiNghiem", name: "category.experience".localized, img: "traiNghiem"),
        CategoryModel(id: "muaSam", name: "category.shopping".localized, img: "muaSam"),
        CategoryModel(id: "maoHiem", name: "category.adventure".localized, img: "maoHiem"),
        CategoryModel(id: "canhQuan", name: "category.landscape".localized, img: "canhQuan")
    ]
    let itemCategoies = BehaviorRelay<[CategoryModel]>(value: [])
    
    init() {
        itemCategoies.accept(categories)
    }
}
