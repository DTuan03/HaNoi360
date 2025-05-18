//
//  HomeViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 3/4/25.
//

import RxSwift
import RxCocoa

class HomeVM {
    let districts: [District] = [
        District(id: "TH1", name: "Ba Đình"),
        District(id: "TH2", name: "Ba Vì"),
        District(id: "TH3", name: "Bắc Từ Liêm"),
        District(id: "TH4", name: "Cầu Giấy"),
        District(id: "TH5", name: "Chương Mỹ"),
        District(id: "TH6", name: "Đan Phượng"),
        District(id: "TH7", name: "Đống Đa"),
        District(id: "TH8", name: "Đông Anh"),
        District(id: "TH9", name: "Gia Lâm"),
        District(id: "TH10", name: "Hà Đông"),
        District(id: "TH11", name: "Hai Bà Trưng"),
        District(id: "TH12", name: "Hoài Đức"),
        District(id: "TH13", name: "Hoàn Kiếm"),
        District(id: "TH14", name: "Hoàng Mai"),
        District(id: "TH15", name: "Long Biên"),
        District(id: "TH16", name: "Mê Linh"),
        District(id: "TH17", name: "Mỹ Đức"),
        District(id: "TH18", name: "Nam Từ Liêm"),
        District(id: "TH19", name: "Phú Xuyên"),
        District(id: "TH20", name: "Phúc Thọ"),
        District(id: "TH21", name: "Quốc Oai"),
        District(id: "TH22", name: "Sơn Tây"),
        District(id: "TH23", name: "Sóc Sơn"),
        District(id: "TH24", name: "Tây Hồ"),
        District(id: "TH25", name: "Thạch Thất"),
        District(id: "TH26", name: "Thanh Oai"),
        District(id: "TH27", name: "Thanh Trì"),
        District(id: "TH28", name: "Thanh Xuân"),
        District(id: "TH29", name: "Thường Tín"),
        District(id: "TH30", name: "Ứng Hòa")
    ]

    var itemsNameDistrict = BehaviorRelay<[District]>(value: [])
    var itemsPlace = BehaviorRelay<[PlaceModel]>(value: [])

    let placeService = BaseFirestoreService<PlaceModel>(collectionPath: "places")
    
    let categories: [CategoryModel] = [
        CategoryModel(id: "amThuc", name: "Ẩm thực", img: "amThuc"),
        CategoryModel(id: "tamLinh", name: "Tâm linh", img: "tamLinh"),
        CategoryModel(id: "traiNghiem", name: "Trải nghiệm", img: "traiNghiem"),
        CategoryModel(id: "muaSam", name: "Mua sắm", img: "muaSam"),
        CategoryModel(id: "maoHiem", name: "Mạo hiểm", img: "maoHiem"),
        CategoryModel(id: "canhQuan", name: "Cảnh quan", img: "canhQuan")
    ]
    var itemsCategory = BehaviorRelay<[CategoryModel]>(value: [])
    
    var itemsTrendingPlace = BehaviorRelay<[PlaceModel]>(value: [])
    
    init() {
        itemsNameDistrict.accept(districts)
        itemsCategory.accept(categories)
        getPlaces(idDistrict: "TH1")
        getTrendingPlace()
    }
    
    func getPlaces(idDistrict: String) {
        placeService.fetchWhereEqualTo(field: "districId", value: idDistrict) { result in
            switch result {
            case .success(let places):
                self.itemsPlace.accept(places)
            case .failure(let error):
                print("Loi")
            }
        }
    }
    
    func getTrendingPlace() {
        placeService.fetchTopRatedPlaces() { result in
            switch result {
            case .success( let places):
                self.itemsTrendingPlace.accept(places)
            case .failure(let error):
                print("Loi")
            }
        }
    }

}
