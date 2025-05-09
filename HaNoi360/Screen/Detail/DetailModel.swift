//
//  DetailModel.swift
//  HaNoi360
//
//  Created by Tuấn on 20/4/25.
//

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
