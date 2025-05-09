//
//  UIStackView.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//
import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
    
    func removeArrangedSubviews(_ views: UIView...) {
        views.forEach { self.removeArrangedSubview($0) }
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(views.flatMap({ $0.constraints }))
        // Remove the views from self
        views.forEach({ $0.removeFromSuperview() })
    }
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func hideViews(_ views: UIView...) {
        views.forEach { $0.isHidden = true }
    }
    
    func showViews(_ views: UIView...) {
        views.forEach { $0.isHidden = false }
    }
    
}

extension Array where Element: UIView {
    func hStack(_ spacing: CGFloat = 0, alignment: UIStackView.Alignment? = nil, distribution: UIStackView.Distribution? = nil) -> UIStackView {
        let stack = UIStackView(axis: .horizontal, spacing: spacing)
        if let alignment = alignment { stack.alignment = alignment }
        if let distribution = distribution { stack.distribution = distribution }
        self.forEach { stack.addArrangedSubview($0) }
        return stack
    }
    
    func vStack(_ spacing: CGFloat = 0, alignment: UIStackView.Alignment? = nil, distribution: UIStackView.Distribution? = nil) -> UIStackView {
        let stack = UIStackView(axis: .vertical, spacing: spacing)
        if let alignment = alignment { stack.alignment = alignment }
        if let distribution = distribution { stack.distribution = distribution }
        self.forEach { stack.addArrangedSubview($0) }
        return stack
    }
    
    func removeFromSuperview() {
        for view in self {
            view.removeFromSuperview()
        }
    }
}
