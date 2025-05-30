//
//  NewDetailModel.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import Foundation

enum ContentBlockType: String, Codable {
    case heading
    case text
    case image
}

struct ContentBlock: Codable {
    let type: ContentBlockType
    var value: String?
}

struct BlogPost: Codable {
    let placeId: String?
    let title: String
    let placeImage: String?
    let address: String?
    let category: [String]?
    let coordinates: Coordinate
    let authorId: String?
    let authorName: String?
    let authorAvatar: String?
    let districId: String?
    let avgRating: Double?
    let totalReviews: Int?
    let totalFavorites: Int?
    let contentBlocks: [ContentBlock]
    let createAt: Date?
}
