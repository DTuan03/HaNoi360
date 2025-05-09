//
//  UITextField.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//

import UIKit

extension UITextField {
    func imageLeftView(image: UIImage, placeholder: String = "", tinColor: UIColor = .black) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 56))
        let imageView = UIImageView(image: image)
        imageView.tintColor = tinColor
        imageView.frame = CGRect(x: 24, y: 16, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFill
        paddingView.addSubview(imageView)
        
        self.leftView = paddingView
        self.leftViewMode = .always
        self.keyboardType = .default
        if placeholder == "passWord" {
            self.isSecureTextEntry = true
        }
    }
    
    func imageRightView(image: UIImage?, placeholder: String = "") {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 50))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 24, y: 17, width: 16, height: 16)
        imageView.contentMode = .scaleAspectFill
        paddingView.addSubview(imageView)
        
//        if !placeholder.isEmpty {
//            self.placeholder = NSLocalizedString(placeholder, comment: "")
//        }
        self.rightView = paddingView
        self.rightViewMode = .always
        self.keyboardType = .default

        let tap = UITapGestureRecognizer(target: self, action: #selector((toggleSecureTextEntry(_:))))
        paddingView.addGestureRecognizer(tap)
    }
    
    @objc func toggleSecureTextEntry(_ sender: UITapGestureRecognizer) {
        if let paddingView = sender.view, let imageView = paddingView.subviews.first as? UIImageView {
            if self.isSecureTextEntry {
                self.isSecureTextEntry = false
                imageView.image = UIImage(systemName: "eye")
            } else {
                self.isSecureTextEntry = true
                imageView.image = UIImage(systemName: "eye.slash.fill")
            }
        }
    }
    
    func imageDeleteRightView(image: UIImage?, placeholder: String = "") {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 50))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .lightGray
        imageView.frame = CGRect(x: 16, y: 17, width: 8, height: 16)
        imageView.contentMode = .scaleAspectFill
        paddingView.addSubview(imageView)
        
        self.rightView = paddingView
        self.rightViewMode = .always
        self.keyboardType = .default
        self.rightView?.isHidden = true

        let tap = UITapGestureRecognizer(target: self, action: #selector((deleteImageView(_:))))
        paddingView.addGestureRecognizer(tap)
        
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        if let text = self.text, !text.isEmpty {
            self.rightView?.isHidden = false
        } else {
            self.rightView?.isHidden = true
        }
    }
    
    @objc func deleteImageView(_ sender: UITapGestureRecognizer) {
        self.text = ""
        if let text = self.text, !text.isEmpty {
            self.rightView?.isHidden = false
        } else {
            self.rightView?.isHidden = true
        }
    }
}
