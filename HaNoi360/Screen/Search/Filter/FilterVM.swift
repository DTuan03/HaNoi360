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
        CategoryModel(id: "amThuc", name: "category.food".localized, img: "amThuc"),
        CategoryModel(id: "tamLinh", name: "category.spirituality".localized, img: "tamLinh"),
        CategoryModel(id: "traiNghiem", name: "category.experience".localized, img: "traiNghiem"),
        CategoryModel(id: "muaSam", name: "category.shopping".localized, img: "muaSam"),
        CategoryModel(id: "maoHiem", name: "category.adventure".localized, img: "maoHiem"),
        CategoryModel(id: "canhQuan", name: "category.landscape".localized, img: "canhQuan")
    ]

    var itemsCategory = BehaviorRelay<[CategoryModel]>(value: [])
    
    var categoriesId = BehaviorRelay<Set<String>>(value: ["tatCa"])
    var minReview = BehaviorRelay<Double?>(value: nil)
    var maxReview = BehaviorRelay<Double?>(value: nil)
    var districtId = BehaviorRelay<[String]?>(value: nil)
    
    var isLoading = PublishRelay<Bool>()
    
    override init() {
        itemsCategory.accept(categories)
    }
    
    func filter(completion: @escaping (Result<[BlogPost], Error>) -> Void) {
        isLoading.accept(true)
        
        let districts = districtId.value!

        guard !districts.isEmpty else {
            completion(.success([])) // Không có quận nào được chọn
            return
        }

        let query = Firestore.firestore()
            .collection("blogs")
            .whereField("districId", in: districts)

        query.getDocuments { result, error in
            if let error = error {
                print("Lỗi khi fetch theo quận huyện: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                let places = result?.documents.compactMap {
                    try? $0.data(as: BlogPost.self)
                } ?? []
                let filteredPlaces = self.filterPlacesLocally(places)
                self.isLoading.accept(false)
                completion(.success(filteredPlaces))
            }
        }
    }
    
    func filterPlacesLocally(_ places: [BlogPost]) -> [BlogPost] {
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
