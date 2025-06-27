//
//  ProfileModel.swift
//  HaNoi360
//
//  Created by Tuấn on 3/6/25.
//

struct ProfileModel: Codable {
    let userId: String?
    let avatarUrl: String?
    let name: String?
    let email: String?
    let phone: String?
    let interest: String?
    let date: String?
    let address: String?
    let followers: [FollowersModel]?
    let following: [FollowingModel]?
}

struct FollowingModel: Codable {
    let followerId: String?
    let avatarFollowing: String?
    let name: String?
}

struct FollowersModel: Codable {
    let followerId: String?
    let avatarFollower: String?
    let name: String?
}
