//
//  NewCreatePostModel.swift
//  HaNoi360
//
//  Created by Tuấn on 27/5/25.
//
import UIKit

enum CreateBlockType {
    case heading(String)
    case text(String)
    case image(UIImage?)
}

struct CreateBlock {
    let type: CreateBlockType
    var text: String?
    var image: UIImage?
}

struct CreateBlogPost: Codable {
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

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}
