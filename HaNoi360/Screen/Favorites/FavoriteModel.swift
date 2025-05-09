//
//  FavoriteModel.swift
//  HaNoi360
//
//  Created by Tuấn on 20/4/25.
//

import Foundation

struct FavoriteModel: Codable {
    let favoriteId: String?
    let placeId: String?
    let userId: String?
    let placeImage: String?
    let name: String?
    let address: String?
    let avgRating: Double?
    var createdAt: Date?
}
