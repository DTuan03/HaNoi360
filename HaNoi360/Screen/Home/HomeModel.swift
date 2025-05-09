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

struct PlaceModel: Codable {
    let placeId: String
    let placeImage: String
    let name: String
    let address: String
    let avgRating: Double
}
