//
//  CustomPageControl.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//

import UIKit
import SnapKit

class CustomPageControl: UIStackView {
    var numberOfPages: Int = 3 {
        didSet {
            setupDots()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateDots()
        }
    }
    
    private var dots: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
        spacing = 8
        alignment = .center
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupDots()
    }
    
    private func setupDots() {
        dots.forEach { $0.removeFromSuperview() }
        dots.removeAll()
        
        for i in 0..<numberOfPages {
            let dot = UIView()
            dot.layer.cornerRadius = 3
            dot.backgroundColor = i == currentPage ? UIColor.orange : UIColor.orange.withAlphaComponent(0.3)
            
            addArrangedSubview(dot)
            dots.append(dot)
        }
        updateDots()
    }
    
    private func updateDots() {
        for (i, dot) in dots.enumerated() {
            let isSelected = i == currentPage
            let width: CGFloat = isSelected ? 35 : 6
            let height: CGFloat = 7
            
            dot.snp.removeConstraints()
            
            dot.snp.makeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            
            UIView.animate(withDuration: 0.3) {
                dot.backgroundColor = isSelected ? UIColor.orange : UIColor.orange.withAlphaComponent(0.3)
            }
        }
    }
}

