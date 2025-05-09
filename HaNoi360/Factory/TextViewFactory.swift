//
//  TextViewFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 6/4/25.
//

import UIKit

class TextViewFactory {
    static func createTextView(
        text: String? = nil,
        font: UIFont = .systemFont(ofSize: 16),
        textColor: UIColor = .black,
        textAlignment: NSTextAlignment = .left,
        isEditable: Bool = true,
        isSelectable: Bool = true,
        isScrollEnabled: Bool = true,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .default,
        backgroundColor: UIColor = .textFiledColor,
        cornerRadius: CGFloat = 8,
        borderColor: UIColor = .lightGray,
        borderWidth: CGFloat = 1,
        placeholder: String? = nil
    ) -> UITextView {
        let textView = PlaceholderTextView()
        textView.text = text
        textView.font = font
        textView.textColor = textColor
        textView.textAlignment = textAlignment
        textView.isEditable = isEditable
        textView.isSelectable = isSelectable
        textView.isScrollEnabled = isScrollEnabled
        textView.keyboardType = keyboardType
        textView.returnKeyType = returnKeyType
        textView.backgroundColor = backgroundColor

        textView.layer.cornerRadius = cornerRadius
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.borderWidth = borderWidth

        textView.placeholder = placeholder

        return textView
    }
}

import UIKit

class PlaceholderTextView: UITextView {

    private let placeholderLabel = UILabel()

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.frame = CGRect(x: 5, y: 8, width: frame.width - 10, height: 20)
    }

    private func setup() {
        placeholderLabel.font = self.font
        placeholderLabel.textColor = .lightGray
        addSubview(placeholderLabel)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
