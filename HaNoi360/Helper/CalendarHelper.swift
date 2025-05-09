//
//  CalendarHelper.swift
//  HaNoi360
//
//  Created by Tuấn on 4/4/25.
//

import Foundation

class CalendarHelper {
    static let shared = CalendarHelper()
    
    func format(date: Date, format: String = "dd MMMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
        return formatter.string(from: date)
    }
}
