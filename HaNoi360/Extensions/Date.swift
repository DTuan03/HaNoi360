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
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(format: String = "dd/MM/yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
}

import Foundation

extension Date {
    func displayRelativeTime() -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day, .hour], from: self, to: now)
        
        if let hour = components.hour, components.day == 0, hour < 24 {
            return "\(hour) giờ trước"
        } else if let day = components.day, day < 7 {
            return "\(day) ngày trước"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: self)
        }
    }
}
