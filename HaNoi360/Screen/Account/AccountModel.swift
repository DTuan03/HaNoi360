//
//  AccountModel.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

struct AccountModel {
    let icon: String?
    let title: String?
    let nextIcon: String
}

let accountData = [
    AccountModel(icon: "profile", title: "Hồ sơ", nextIcon: "next"),
    AccountModel(icon: "security", title: "Bảo mật", nextIcon: "next"),
    AccountModel(icon: "notification", title: "Thông báo", nextIcon: "next"),
    AccountModel(icon: "language", title: "Ngôn ngữ", nextIcon: "next"),
    AccountModel(icon: "logout", title: "Đăng xuất", nextIcon: "")
]
