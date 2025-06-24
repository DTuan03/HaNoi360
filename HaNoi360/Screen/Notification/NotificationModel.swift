//
//  NotificationModel.swift
//  HaNoi360
//
//  Created by Tuấn on 14/6/25.
//

import Foundation

struct NotificationModel: Codable {
    let notificationId: String?
    var isRead: Bool?
    let message: String?
    let reviewContent: String?
    let reportedId: String?
    let authorId: String?
    let createdAt: Date?
}
