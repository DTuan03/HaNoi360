//
//  UITextView.swift
//  HaNoi360
//
//  Created by Tuấn on 10/4/25.
//

import UIKit

extension UITextView: UITextViewDelegate {
    
    private struct AssociatedKeys {
        static var fullText = "fullText"
        static var isExpanded = "isExpanded"
        static var maxLines = "maxLines"
    }
    
    private var fullText: String {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.fullText) as? String ?? "" }
        set { objc_setAssociatedObject(self, &AssociatedKeys.fullText, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var isExpanded: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.isExpanded) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.isExpanded, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var maxLines: Int {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.maxLines) as? Int ?? 3 }
        set { objc_setAssociatedObject(self, &AssociatedKeys.maxLines, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public func configureExpandableText(text: String, maxLines: Int = 3) {
        self.fullText = text
        self.maxLines = maxLines
        self.delegate = self
        self.isEditable = false
        self.isScrollEnabled = false
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        showCollapsedText()
    }

    private func showCollapsedText() {
        guard let font = self.font else { return }
        
        let maxHeight = font.lineHeight * CGFloat(maxLines)
        var visibleText = fullText
        var fits = false
        
        while !fits && visibleText.count > 0 {
            let testText = visibleText + "... Read More"
            let size = (testText as NSString).boundingRect(
                with: CGSize(width: frame.width, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil
            )
            if size.height <= maxHeight {
                fits = true
            } else {
                visibleText = String(visibleText.dropLast())
            }
        }
        
        let attributed = NSMutableAttributedString(string: visibleText, attributes: [.font: font])
        let readMore = NSAttributedString(string: "... Read More", attributes: [
            .font: font,
            .foregroundColor: UIColor.systemBlue,
            .link: "readmore://"
        ])
        attributed.append(readMore)
        
        self.attributedText = attributed
        self.isExpanded = false
    }

    private func showFullText() {
        guard let font = self.font else { return }

        let attributed = NSMutableAttributedString(string: fullText, attributes: [.font: font])
        let readLess = NSAttributedString(string: " Read Less", attributes: [
            .font: font,
            .foregroundColor: UIColor.systemBlue,
            .link: "readless://"
        ])
        attributed.append(readLess)
        
        self.attributedText = attributed
        self.isExpanded = true
    }

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "readmore://":
            showFullText()
            return false
        case "readless://":
            showCollapsedText()
            return false
        default:
            return true
        }
    }
}
