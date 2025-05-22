//
//  DetailViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 20/4/25.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

class DetailVM: BaseVM {
    var placeId = BehaviorRelay<String?>(value: nil)
    var place = BehaviorRelay<DetailModel?>(value: nil)
    
    var isAddFavorite = PublishRelay<Bool>()
    var isFavorite = BehaviorRelay<Bool>(value: false)
    var placeFavorite = BehaviorRelay<FavoriteModel?>(value: nil)
    var idFavorite = BehaviorRelay<String>(value: "")
    
    var isDeleteFavorite = PublishRelay<Bool>()
    
    var isCalendar = PublishRelay<Bool>()
    
    var countReview = BehaviorRelay<Int>(value: 0)
    
    var isLoading = BehaviorRelay<Bool>(value: true)
    
    var contentReview = BehaviorRelay<String>(value: "")
    var rating = BehaviorRelay<Int>(value: 1)
    var isReview = BehaviorRelay<Bool>(value: false)
    var review = BehaviorRelay<[ReviewModel]?>(value: nil)

    func featchPlace(completion: @escaping () -> Void) {
        guard let id = placeId.value else {
            return
        }
        placeService.fetchWhereEqualTo(field: "placeId", value: id) { result in
            self.isLoading.accept(false)
            switch result {
            case .success(let place):
                self.place.accept(place.first)
            case .failure(let error):
                print("Loi: \(error)")
            }
            completion()
        }
    }
    
    func isFavoritePlace(completion: @escaping () -> Void) {
        isLoading.accept(true)
        guard let placeId = placeId.value else {
            return
        }
        let fields = [
            "placeId": placeId,
            "userId": userId
        ]
        favoriteService.fetchDocumentsByFields(fields: fields as [String : Any]) { result in
            switch result {
            case .success(let places):
                if !places.isEmpty {
                    self.isFavorite.accept(true)
                    self.placeFavorite.accept(places.first)
                }
            case .failure(let error):
                self.isFavorite.accept(false)
            }
            completion()
        }
    }
    
    func addFavorite() {
//        let id = Firestore.firestore().collection("favorites").document().documentID
        idFavorite.accept(placeId.value!)
        let favoritePlace = FavoriteModel(favoriteId: placeId.value,
                                          placeId: placeId.value,
                                          userId: userId,
                                          placeImage: place.value?.placeImage,
                                          name: place.value?.name,
                                          address: place.value?.address,
                                          avgRating: place.value?.avgRating,
                                          createdAt: Date())
        favoriteService.set(favoritePlace, withId: placeId.value!) { result in
            switch result {
            case .success():
                self.isAddFavorite.accept(true)
                self.isFavorite.accept(true)
            case .failure( _):
                self.isAddFavorite.accept(false)
            }
        }
    }
    
    func deleteFavorite() {
        if idFavorite.value.isEmpty {
            favoriteService.delete(id: placeFavorite.value!.favoriteId ?? "") { result in
                switch result {
                case .success():
                    self.isDeleteFavorite.accept(true)
                    self.isFavorite.accept(false)
                case .failure( _):
                    self.isDeleteFavorite.accept(false)
                }
            }
        } else {
            favoriteService.delete(id: idFavorite.value) { result in
                switch result {
                case .success():
                    self.isDeleteFavorite.accept(true)
                    self.isFavorite.accept(false)
                case .failure( _):
                    self.isDeleteFavorite.accept(false)
                }
            }
        }
    }
    
    func addReview() {
        isLoading.accept(true)
        let id = Firestore.firestore().collection("reviews").document().documentID
        let review = ReviewModel(reviewId: id,
                                 placeId: placeId.value,
                                 authorId: userId,
                                 authorName: nameUser,
                                 avatarUser: avatarUser,
                                 content: contentReview.value,
                                 rating: rating.value)
        reviewService.set(review, withId: id) { [weak self] result in
            self?.isLoading.accept(false)
            switch result {
            case .success():
                self?.isReview.accept(true)
            case .failure(_):
                print("Them faild")
            }
        }
    }
    
    func featchReview() {
        guard let placeId = placeId.value else {
            return
        }
        
        let query = Firestore.firestore()
            .collection("reviews")
            .whereField("placeId", isEqualTo: placeId)
            .order(by: "createAt", descending: true)
            .limit(to: 3)
        
        query.getDocuments { result, error  in
            if let error = error {
                print("Lỗi khi fetch reviews: \(error.localizedDescription)")
            } else {
                let reviews = result?.documents.compactMap {
                    try? $0.data(as: ReviewModel.self)
                } ?? []
                self.review.accept(reviews)
            }
        }
    }
}
