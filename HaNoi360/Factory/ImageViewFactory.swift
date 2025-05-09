//
//  ImageFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

import UIKit

class ImageViewFactory {
    static func createImageView(image: UIImage? = nil, tintColor: UIColor? = nil, contentMode: UIView.ContentMode? = nil, radius: CGFloat = 0) -> UIImageView {
        let iv = UIImageView()
        iv.image = image
        iv.contentMode = contentMode ?? .scaleAspectFit
        if let tintColor = tintColor {
            iv.tintColor = tintColor
        }
        iv.layer.cornerRadius = radius
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true

        return iv
    }
}
