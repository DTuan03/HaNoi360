//
//  Int.swift
//  HaNoi360
//
//  Created by Tuấn on 29/5/25.
//

extension Int {
    var formattedText: String {
        if self < 1_000 {
            return "\(self)"
        } else if self < 1_000_000 {
            let value = Double(self) / 1_000
            return String(format: "%.1fk", value).replacingOccurrences(of: ".", with: ",")
        } else {
            let value = Double(self) / 1_000_000
            return String(format: "%.1fTr", value).replacingOccurrences(of: ".", with: ",")
        }
    }
}
