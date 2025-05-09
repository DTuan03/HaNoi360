//
//  UIButton.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

import UIKit

extension UIButton {
    @objc func titleAndIcon(hspacing: CGFloat) {
        let insetAmount = hspacing / 2
        switch semanticContentAttribute {
        case .forceRightToLeft:
          self.imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
          self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        default:
          self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
          self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        }
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
      }
    
}

private var ActionKey: UInt8 = 0

extension UIButton {
    private class ClosureWrapper: NSObject {
        let closure: (UIButton) -> ()
        init(_ closure: @escaping (UIButton) -> ()) {
            self.closure = closure
        }
    }

    func addTargetClosure(closure: @escaping (UIButton) -> ()) {
        objc_setAssociatedObject(self, &ActionKey, ClosureWrapper(closure), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(invokeAction), for: .touchUpInside)
    }

    @objc private func invokeAction() {
        if let wrapper = objc_getAssociatedObject(self, &ActionKey) as? ClosureWrapper {
            wrapper.closure(self)
        }
    }
}


