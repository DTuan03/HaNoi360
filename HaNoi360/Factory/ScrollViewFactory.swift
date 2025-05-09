//
//  ScrollViewFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//
import UIKit

class ScrollViewFactory {
    static func createScrollView(backgroundColor: UIColor = .white, isPagingEnabled: Bool = false, showsVerticalScrollIndicator: Bool = false, showsHorizontalScrollIndicator: Bool = false, bounces: Bool = true) -> UIScrollView {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = backgroundColor
        scrollView.isPagingEnabled = isPagingEnabled
        scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        scrollView.bounces = bounces
        
        return scrollView
    }
}
