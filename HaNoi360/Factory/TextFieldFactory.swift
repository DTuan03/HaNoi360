//
//  TextFieldFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//
import UIKit
import SnapKit

class TextFieldFactory {
    static func createTextField(placeholder: String?,
                                placeholderColor: UIColor = .lightGray,
                                font: UIFont = .regular16,
                                bgColor: UIColor = .textFiledColor,
                                textColor: UIColor = .textTextFiledColor,
                                textAlignment: NSTextAlignment = .left,
                                rounded: CGFloat = 16) -> UITextField {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        textField.font = font
        textField.backgroundColor = bgColor
        textField.textColor = textColor
        textField.textAlignment = textAlignment
        textField.layer.cornerRadius = rounded
        return textField
    }
}
