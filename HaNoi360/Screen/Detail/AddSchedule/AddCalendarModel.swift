//
//  AddCalendarModel.swift
//  HaNoi360
//
//  Created by Tuấn on 21/4/25.
//

import Foundation

struct AddCalendarModel: Codable {
    let scheduleId: String
    let placeId: String
    let placeImage: String
    let name: String
    let address: String
    let avgRating: Double
    let userId: String
    let date: String
    let createAt: Date
}
