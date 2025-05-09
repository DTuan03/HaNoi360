//
//  CategoryVM.swift
//  HaNoi360
//
//  Created by Tuấn on 30/4/25.
//

import RxSwift
import RxCocoa

class CategoryVM: BaseVM {
    let categories: [CategoryModel] = [
        CategoryModel(id: "amThuc", name: "Ẩm thực", img: "amThuc"),
        CategoryModel(id: "tamLinh", name: "Tâm linh", img: "tamLinh"),
        CategoryModel(id: "traiNghiem", name: "Trải nghiệm", img: "traiNghiem"),
        CategoryModel(id: "muaSam", name: "Mua sắm", img: "muaSam"),
        CategoryModel(id: "maoHiem", name: "Mạo hiểm", img: "maoHiem"),
        CategoryModel(id: "canhQuan", name: "Cảnh quan", img: "canhQuan")
    ]

    var itemsCategory = BehaviorRelay<[CategoryModel]>(value: [])
    var categoryId = BehaviorRelay<String?>(value: nil)
    var categoryImg = BehaviorRelay<String>(value: "amThuc")
    var initialIndex = BehaviorRelay<Int>(value: 0)
    var categoryTitle = BehaviorRelay<String>(value: "Ẩm thực")
    
    var placesForCategory = BehaviorRelay<[DetailModel]?>(value: nil)
    
    override init() {
        itemsCategory.accept(categories)
    }
    
    func featchPlace() {
        placeService.fetchByCategory(categoryId.value ?? "") { result in
            switch result {
            case .success(let places):
                self.placesForCategory.accept(places)
            case .failure(let error):
                print("Loi")
            }
        }
    }
}
