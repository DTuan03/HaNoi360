//
//  ButtonFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 25/3/25.
//

import UIKit
import SnapKit

class ButtonFactory {
    static func createButton(_ title: String? = nil,
                             font: UIFont = .bold16,
                             textColor: UIColor = .textButtonColor,
                             bgColor: UIColor = .primaryButtonColor,
                             rounded: Bool = true,
                             height: Int = 58) -> UIButton {
        let button = UIButton()
        button.setTitle(NSLocalizedString(title ?? "", comment: ""), for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = rounded ? 16 : 0
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        return button
    }
    
    static func createImageButton(withImage image: UIImage?, title: String? = nil, tinColor: UIColor? = .black, radius: CGFloat? = nil) -> UIButton {
        let button = UIButton()
        guard let image = image else { return button }
        button.setImage(image, for: .normal)
        button.tintColor = tinColor
        if let titleButton = title {
            button.setTitle(NSLocalizedString(titleButton, comment: ""), for: .normal)
            button.setTitleColor(.primaryTextColor, for: .normal)
            button.titleLabel?.font = .medium16
        }
        
        if let radius = radius {
            button.layer.cornerRadius = radius
        }
        return button
    }
}
