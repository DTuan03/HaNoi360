//
//  ViewFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

import UIKit
import SnapKit

class UIViewFactory {
    static func createLineView(height: CGFloat = 1, bgColor: UIColor = UIColor(hex: "#F9FAFB")) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        
        let lineView = UIView()
        lineView.frame.size.width = screenWidth
        lineView.backgroundColor = bgColor
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        return lineView
    }
    
    static func overlayView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
}
