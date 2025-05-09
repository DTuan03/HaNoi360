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
        CategoryModel(id: "amThuc", name: "Ẩm thực", img: "amThuc"),
        CategoryModel(id: "tamLinh", name: "Tâm linh", img: "tamLinh"),
        CategoryModel(id: "traiNghiem", name: "Trải nghiệm", img: "traiNghiem"),
        CategoryModel(id: "muaSam", name: "Mua sắm", img: "muaSam"),
        CategoryModel(id: "maoHiem", name: "Mạo hiểm", img: "maoHiem"),
        CategoryModel(id: "canhQuan", name: "Cảnh quan", img: "canhQuan")
    ]
    let itemCategoies = BehaviorRelay<[CategoryModel]>(value: [])
    
    init() {
        itemCategoies.accept(categories)
    }
}
