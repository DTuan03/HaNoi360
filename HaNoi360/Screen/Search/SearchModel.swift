//
//  SearchModel.swift
//  HaNoi360
//
//  Created by Tuấn on 18/5/25.
//

import Foundation
import RealmSwift

class SearchModel: Object {
    @objc dynamic var searchId: String?
    @objc dynamic var userId: String?
    @objc dynamic var textSearch: String?
    @objc dynamic var createAt: Date?
    
    override static func primaryKey() -> String? {
        return "searchId"
    }
    
    convenience init(searchId: String, textSearch: String) {
        self.init()
        self.searchId = searchId
        self.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        self.textSearch = textSearch
        self.createAt = Date()
    }
}
