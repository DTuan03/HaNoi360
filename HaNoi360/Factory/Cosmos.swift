//
//  Cosmos.swift
//  HaNoi360
//
//  Created by Tuấn on 10/4/25.
//


import UIKit
import Cosmos

class CosmosViewFactory {
    static func createCosmosView(starSize: CGFloat = 18,
                                 starMargin: CGFloat = 9,
                                 emptyImage: UIImage? = UIImage(named: "starEmpty"),
                                 updateOnTouch: Bool = true,
                                 filledImage: UIImage? = UIImage(named: "starFill"),
                                 emptyBorderColor: UIColor = .gray,
                                 filledBorderColor: UIColor = UIColor(hex: "#FFC107")) -> CosmosView {
        let cosmosView = CosmosView()
        cosmosView.settings.starSize = starSize
        cosmosView.settings.starMargin = starMargin
        cosmosView.settings.updateOnTouch = updateOnTouch
        cosmosView.settings.fillMode = .full
        cosmosView.settings.emptyImage = emptyImage
        cosmosView.settings.filledImage = filledImage
        cosmosView.settings.emptyBorderColor = emptyBorderColor
        cosmosView.settings.filledBorderColor = filledBorderColor
        cosmosView.rating = 1
        
        return cosmosView
    }
}
