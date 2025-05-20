//
//  UIColor.swift
//  HaNoi360
//
//  Created by Tuấn on 25/3/25.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let backgroundColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#FEFEFE") : UIColor(hex: "#111827")
    }
    
    static let backgroundPopupColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#202020")
    }
    
    static let primaryColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#F97316") : UIColor(hex: "#F97316")
    }
    
    static let primaryTextColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#000000") : UIColor(hex: "#FEFEFE")
    }
    
    static let secondaryTextColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#6B7280") : UIColor(hex: "#F3F4F6")
    }
    
    static let primaryButtonColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#F97316") : UIColor(hex: "#F97316")
    }
    
    static let textButtonColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#F9FAFB") : UIColor(hex: "#F9FAFB")
    }
    
    static let secondaryButtonColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#FB923C") : UIColor(hex: "#FB923C")
    }
    
    static let signInOtherButtonColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#F9FAFB") : UIColor(hex: "#F3F4F6")
    }
    
    static let hightlightColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#FF3E00") : UIColor(hex: "#FF3E00")
    }
    
    static let textTextFiledColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#111827") : UIColor(hex: "#FEFEFE")
    }
    
    static let textFiledColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#F3F4F6") : UIColor(hex: "#374151")
    }
    
    static let textNavigationColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#111827") : UIColor(hex: "#FEFEFE")
    }

    static let forgotPassLabelColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#0369A1") : UIColor(hex: "#0EA5E9")
    }
    
    static let waitingImageColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#F5F5F5") : UIColor(hex: "#F5F5F5")
    }
    
    static let tableViewCellColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#F3F4F6") : UIColor(hex: "#111827")
    }
    
    static let backgroundTableViewCellColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? UIColor(hex: "#FEE2E2") : UIColor(hex: "#FEE2E2")
    }
}
