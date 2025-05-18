//
//  FilterVM.swift
//  HaNoi360
//
//  Created by Tuấn on 4/5/25.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

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
    
    var categoriesId = BehaviorRelay<Set<String>>(value: ["tatCa"])
    var minReview = BehaviorRelay<Double?>(value: nil)
    var maxReview = BehaviorRelay<Double?>(value: nil)
    var districtId = BehaviorRelay<[String]?>(value: nil)
    override init() {
        itemsCategory.accept(categories)
    }
    
    func filter(completion: @escaping (Result<[DetailModel], Error>) -> Void) {
        let districts = districtId.value!

        guard !districts.isEmpty else {
            completion(.success([])) // Không có quận nào được chọn
            return
        }

        let query = Firestore.firestore()
            .collection("places")
            .whereField("districId", in: districts)

        query.getDocuments { result, error in
            if let error = error {
                print("Lỗi khi fetch theo quận huyện: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                let places = result?.documents.compactMap {
                    try? $0.data(as: DetailModel.self)
                } ?? []
                let filteredPlaces = self.filterPlacesLocally(places)
                completion(.success(filteredPlaces))
            }
        }
    }
    
    func filterPlacesLocally(_ places: [DetailModel]) -> [DetailModel] {
        // Bỏ "tatCa" nếu có
        let selectedCategoryIds = categoriesId.value.subtracting(["tatCa"])
        
        // Kiểm tra có cần lọc theo category hay không
        let shouldFilterCategory = !categoriesId.value.contains("tatCa") && selectedCategoryIds.count < 6

        let minRating = minReview.value
        let maxRating = maxReview.value

        return places.filter { place in
            var isValid = true

            // 1. Lọc theo category nếu cần
            if shouldFilterCategory {
                let intersection = Set(place.category!).intersection(selectedCategoryIds)
                if intersection.isEmpty {
                    isValid = false
                }
            }

            // 2. Lọc theo khoảng ratingReview nếu có
            if minRating ?? 2.0 > 0 && place.avgRating! < minRating ?? 2.0 {
                isValid = false
            }
            if maxRating ?? 4.0 > 0 && place.avgRating! > maxRating ?? 4.0 {
                isValid = false
            }

            return isValid
        }
    }


}
