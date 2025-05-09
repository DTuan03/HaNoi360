//
//  FilterDistrictVM.swift
//  HaNoi360
//
//  Created by Tuấn on 4/5/25.
//

import RxSwift
import RxCocoa

struct FilterDistrictModel {
    let id: String
    let name: String
}

class FilterDistrictVM {
    let districts: [FilterDistrictModel] = [
        FilterDistrictModel(id: "TH1", name: "Ba Đình"),
        FilterDistrictModel(id: "TH2", name: "Ba Vì"),
        FilterDistrictModel(id: "TH3", name: "Bắc Từ Liêm"),
        FilterDistrictModel(id: "TH4", name: "Cầu Giấy"),
        FilterDistrictModel(id: "TH5", name: "Chương Mỹ"),
        FilterDistrictModel(id: "TH6", name: "Đan Phượng"),
        FilterDistrictModel(id: "TH7", name: "Đống Đa"),
        FilterDistrictModel(id: "TH8", name: "Đông Anh"),
        FilterDistrictModel(id: "TH9", name: "Gia Lâm"),
        FilterDistrictModel(id: "TH10", name: "Hà Đông"),
        FilterDistrictModel(id: "TH11", name: "Hai Bà Trưng"),
        FilterDistrictModel(id: "TH12", name: "Hoài Đức"),
        FilterDistrictModel(id: "TH13", name: "Hoàn Kiếm"),
        FilterDistrictModel(id: "TH14", name: "Hoàng Mai"),
        FilterDistrictModel(id: "TH15", name: "Long Biên"),
        FilterDistrictModel(id: "TH16", name: "Mê Linh"),
        FilterDistrictModel(id: "TH17", name: "Mỹ Đức"),
        FilterDistrictModel(id: "TH18", name: "Nam Từ Liêm"),
        FilterDistrictModel(id: "TH19", name: "Phú Xuyên"),
        FilterDistrictModel(id: "TH20", name: "Phúc Thọ"),
        FilterDistrictModel(id: "TH21", name: "Quốc Oai"),
        FilterDistrictModel(id: "TH22", name: "Sơn Tây"),
        FilterDistrictModel(id: "TH23", name: "Sóc Sơn"),
        FilterDistrictModel(id: "TH24", name: "Tây Hồ"),
        FilterDistrictModel(id: "TH25", name: "Thạch Thất"),
        FilterDistrictModel(id: "TH26", name: "Thanh Oai"),
        FilterDistrictModel(id: "TH27", name: "Thanh Trì"),
        FilterDistrictModel(id: "TH28", name: "Thanh Xuân"),
        FilterDistrictModel(id: "TH29", name: "Thường Tín"),
        FilterDistrictModel(id: "TH30", name: "Ứng Hòa")
    ]

    let itemDistricts = BehaviorRelay<[FilterDistrictModel]>(value: [])
    
    init() {
        itemDistricts.accept(districts)
    }
}
