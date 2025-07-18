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

import RealmSwift
import FirebaseAuth

class ScheduleModel: Object {
    @objc dynamic var scheduleId: String?
    @objc dynamic var blogId: String?
    @objc dynamic var avatarBlog: String?
    @objc dynamic var title: String?
    @objc dynamic var address: String?
    @objc dynamic var avgRating: Double = 0.0
    @objc dynamic var date: String?
    @objc dynamic var createAt: Date?
    @objc dynamic var userId: String?

    override static func primaryKey() -> String? {
        return "scheduleId"
    }

    convenience init(scheduleId: String,
                     blogId: String,
                     avatarBlog: String,
                     title: String,
                     address: String,
                     avgRating: Double,
                     date: String,
                     createAt: Date) {
        self.init()
        self.scheduleId = scheduleId
        self.blogId = blogId
        self.avatarBlog = avatarBlog
        self.title = title
        self.address = address
        self.avgRating = avgRating
        self.date = date
        self.createAt = createAt
        self.userId = Auth.auth().currentUser?.uid
    }
}
