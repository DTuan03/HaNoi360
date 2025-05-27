//
//  HomeModel.swift
//  HaNoi360
//
//  Created by Tuấn on 3/4/25.
//

struct District {
    let id: String
    let name: String
}

struct BlogModel: Codable {
    let placeId: String
    let placeImage: String
    let title: String
    let authorName: String
    let avgRating: Double
}
