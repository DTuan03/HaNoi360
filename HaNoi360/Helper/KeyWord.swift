//
//  KeyWord.swift
//  HaNoi360
//
//  Created by Tuấn on 18/5/25.
//

class KeyWord {
    static let shared = KeyWord()
    
    private func removeVietnameseDiacritics(_ text: String) -> String {
        let normalized = text.folding(options: .diacriticInsensitive, locale: .current)
        return normalized.replacingOccurrences(of: "đ", with: "d")
                         .replacingOccurrences(of: "Đ", with: "D")
    }

    func generateAllSearchKeywords(from text: String) -> [String] {
        let lowercased = text.lowercased()
        let noAccent = removeVietnameseDiacritics(lowercased)
        
        var prefixes = Set<String>()
        
        for i in 1...lowercased.count {
            let withDiacriticsPrefix = String(lowercased.prefix(i))
            let noDiacriticsPrefix = String(noAccent.prefix(i))
            prefixes.insert(withDiacriticsPrefix)
            prefixes.insert(noDiacriticsPrefix)
        }
        
        return Array(prefixes).sorted()
    }
}
