//
//  FilterVM.swift
//  HaNoi360
//
//  Created by Tuấn on 4/5/25.
//

import RxSwift
import RxCocoa

class FilterVM: BaseVM {
    let categories: [CategoryModel] = [
        CategoryModel(id: "tatCa", name: "Tất cả", img: "amThuc"),
        CategoryModel(id: "amThuc", name: "Ẩm thực", img: "amThuc"),
        CategoryModel(id: "maoHiem", name: "Mạo hiểm", img: "maoHiem"),
        CategoryModel(id: "traiNghiem", name: "Trải nghiệm", img: "traiNghiem"),
        CategoryModel(id: "tamLinh", name: "Tâm linh", img: "tamLinh"),
        CategoryModel(id: "canhQuan", name: "Cảnh quan", img: "canhQuan"),
        CategoryModel(id: "muaSam", name: "Mua sắm", img: "muaSam")
    ]

    var itemsCategory = BehaviorRelay<[CategoryModel]>(value: [])
    
    override init() {
        itemsCategory.accept(categories)
    }
    
}
