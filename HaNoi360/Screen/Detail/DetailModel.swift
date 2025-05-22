//
//  DetailModel.swift
//  HaNoi360
//
//  Created by Tuấn on 20/4/25.
//

import Foundation

struct DetailModel: Codable {
    let placeId: String?
    let placeImage: String?
    let subPlaceImage: [String]?
    let name: String?
    let description: String?
    let address: String?
    let category: [String]?
    let coordinates: Coordinate
    let authorId: String?
    let authorName: String?
    let districId: String?
    let avgRating: Double?
    let totalReviews: Int?
}

struct ReviewModel: Codable {
    let reviewId: String?
    let placeId: String?
    let authorId: String?
    let authorName: String?
    let avatarUser: String?
    let content: String?
    let rating: Int?
    var report: Bool = false
    var isFlagged: Bool = false
    var checkedByModel: Bool = false
    var createAt: Date = Date()
}
