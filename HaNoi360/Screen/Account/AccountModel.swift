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
    AccountModel(icon: "profile", title: "account.profile".localized, nextIcon: "next"),
    AccountModel(icon: "security", title: "account.security".localized, nextIcon: "next"),
    AccountModel(icon: "notification", title: "account.noti".localized, nextIcon: "next"),
    AccountModel(icon: "language", title: "account.langugae.interface".localized, nextIcon: "next"),
    AccountModel(icon: "logout", title: "account.logout".localized, nextIcon: "")
]
