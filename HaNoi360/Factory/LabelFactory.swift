//
//  LabelFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 26/3/25.
//
import UIKit

class LabelFactory {
    static func createLabel(text: String? = nil,
                            font: UIFont = .medium14,
                            textColor: UIColor = .primaryTextColor,
                            numberOfLines: Int = 0,
                            textAlignment: NSTextAlignment = .left,
                            highLighText: String? = nil,
                            highLightColor: UIColor = .hightlightColor,
                            highLightFont: UIFont = .medium14) -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString(text ?? "", comment: "")
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        if let highLighText, let text = text {
            let mutableAttributedString =  NSMutableAttributedString(string: text)
            let range = (text as NSString).range(of: highLighText)
            mutableAttributedString.addAttribute(.foregroundColor, value: highLightColor, range: range)
            mutableAttributedString.addAttribute(.font, value: highLightFont, range: range)
            label.attributedText = mutableAttributedString
        }
        label.isUserInteractionEnabled = true
        return label
    }
}
