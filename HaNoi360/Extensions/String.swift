//
//  String.swift
//  HaNoi360
//
//  Created by Tuấn on 25/6/25.
//

import Foundation

enum LocalizableTableType: String {
    case localizable = "Localizable"
    case usageGuide = "UsageGuide"
}

private var currentLanguageBundle: Bundle {
    let langCode = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
    
    if let path = Bundle.main.path(forResource: langCode, ofType: "lproj"),
       let bundle = Bundle(path: path) {
        return bundle
    }
    
    return Bundle.main
}

extension String {
    
    var localized: String {
        return currentLanguageBundle.localizedString(forKey: self, value: "", table: nil)
    }

    func localized(value: String? = nil, table: LocalizableTableType = .localizable) -> String {
        return currentLanguageBundle.localizedString(forKey: self, value: (value ?? ""), table: table.rawValue)
    }

    func localizedFormat(_ args: CVarArg...) -> String {
        let localizedString = currentLanguageBundle.localizedString(forKey: self, value: "", table: nil)
        return String(format: localizedString, arguments: args)
    }
}
