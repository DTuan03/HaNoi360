//
//  AllReviewVM.swift
//  HaNoi360
//
//  Created by Tuấn on 6/6/25.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

class AllReviewVM: BaseVM {
    var blogId = BehaviorRelay<String?>(value: nil)
    var review = BehaviorRelay<[ReviewModel]?>(value: nil)

    func featchReview(completion: @escaping () -> Void) {
        guard let placeId = blogId.value else {
            return
        }
        
        let query = Firestore.firestore()
            .collection("reviews")
            .whereField("blogId", isEqualTo: placeId)
            .whereField("isFlagged", isEqualTo: false)
//            .order(by: "createAt", descending: true)
        
        query.getDocuments { result, error  in
            if let error = error {
                print("Lỗi khi fetch reviews: \(error.localizedDescription)")
            } else {
                let reviews = result?.documents.compactMap {
                    try? $0.data(as: ReviewModel.self)
                } ?? []
                self.review.accept(reviews)
            }
            completion()
        }
    }

}
