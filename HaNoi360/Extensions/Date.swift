//
//  Date.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(format: String = "dd/MM/yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "vi_VN") // nếu bạn dùng định dạng Việt
        formatter.timeZone = TimeZone.current          // hoặc cụ thể: TimeZone(identifier: "Asia/Ho_Chi_Minh")
        return formatter.date(from: self)
    }
}
