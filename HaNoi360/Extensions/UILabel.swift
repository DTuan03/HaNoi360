//
//  UILabel.swift
//  HaNoi360
//
//  Created by Tuấn on 9/4/25.
//

import UIKit

extension UILabel {
    func addReadMore(trailingText: String = " Đọc thêm", trailingFont: UIFont? = nil, trailingColor: UIColor? = nil) {
        guard let originalText = self.text else { return }

        let visibleTextLength = self.visibleTextLength()
        let trimmedText = String(originalText.prefix(visibleTextLength))
        
        let fullText = trimmedText + trailingText
        
        let attributed = NSMutableAttributedString(string: fullText, attributes: [
            .font: self.font ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: self.textColor ?? .label
        ])
        
        let readMoreRange = NSRange(location: trimmedText.count, length: trailingText.count)
        
        attributed.addAttributes([
            .font: trailingFont ?? UIFont.boldSystemFont(ofSize: self.font.pointSize),
            .foregroundColor: trailingColor ?? UIColor.systemBlue
        ], range: readMoreRange)
        
        self.attributedText = attributed
        self.isUserInteractionEnabled = true
    }

    private func visibleTextLength() -> Int {
        guard let text = self.text else { return 0 }

        let font = self.font ?? UIFont.systemFont(ofSize: 15)
        let labelWidth = self.bounds.width
        let labelHeight = self.bounds.height

        let sizeConstraint = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let boundingRect = text.boundingRect(
            with: sizeConstraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )

        let maxLines = self.numberOfLines
        let lineHeight = font.lineHeight
        let maxHeight = lineHeight * CGFloat(maxLines)

        if boundingRect.height <= maxHeight {
            return text.count
        }

        // Cắt từng ký tự cho đến khi vừa số dòng
        var index = text.count
        while index > 0 {
            let trimmed = String(text.prefix(index)) + "..."
            let rect = trimmed.boundingRect(
                with: sizeConstraint,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil
            )
            if rect.height <= maxHeight {
                return index
            }
            index -= 1
        }

        return text.count
    }
}
