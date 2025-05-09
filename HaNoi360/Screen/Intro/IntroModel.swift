//
//  IntroModel.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

struct IntroModel {
    var title: String
    var highLight: String
    var description: String
    var image: String
    var numberPageControl: Int
    
    init(title: String, highLight: String, description: String, image: String, numberPageControl: Int) {
        self.title = title
        self.highLight = highLight
        self.description = description
        self.image = image
        self.numberPageControl = numberPageControl
    }
}
