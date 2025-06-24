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
    let blogId: String?
    let title: String
    let avatarBlog: String?
    let address: String?
    let category: [String]?
    let coordinates: Coordinate
    let authorId: String?
    let authorName: String?
    let authorAvatar: String?
    let districId: String?
    let avgRating: Double?
    let contentBlocks: [ContentBlock]
    let keyword: [String]?
    let createAt: Date?
}

struct ReviewModel: Codable {
    let reviewId: String?
    let blogId: String?
    let authorId: String?
    let authorName: String?
    let authorAvatar: String?
    let content: String?
    let rating: Int?
    var reporterId: String = ""
    var report: Bool = false
    var isFlagged: Bool = false
    var hasUserAppealed: Bool = false
    var isSendNoti: String = "unSent"
    var createAt: Date = Date()
}
