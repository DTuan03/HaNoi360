//
//  NewCreateScheduleModel.swift
//  HaNoi360
//
//  Created by Tuấn on 29/5/25.
//
import Foundation

struct NewCreateScheduleModel: Codable {
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
