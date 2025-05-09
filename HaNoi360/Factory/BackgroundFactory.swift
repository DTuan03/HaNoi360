//
//  BackgroundFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 5/5/25.
//

import UIKit

class BackgroundFactory {
    static func addBackground(view: UIView, image: String) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: image)
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
}
