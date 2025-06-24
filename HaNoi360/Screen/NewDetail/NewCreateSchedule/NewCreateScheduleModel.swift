//
//  NewCreateScheduleModel.swift
//  HaNoi360
//
//  Created by Tuấn on 29/5/25.
//
import Foundation

struct NewCreateScheduleModel: Codable {
    let scheduleId: String
    let blogId: String
    let avatarBlog: String
    let title: String
    let address: String
    let avgRating: Double
    let date: String
    let createAt: Date
}
