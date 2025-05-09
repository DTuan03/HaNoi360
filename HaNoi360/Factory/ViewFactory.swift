//
//  ViewFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

import UIKit
import SnapKit

class UIViewFactory {
    static func createLineView() -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        
        let lineView = UIView()
        lineView.frame.size.width = screenWidth
        lineView.backgroundColor = UIColor(hex: "#F9FAFB")
        
        return lineView
    }
}
