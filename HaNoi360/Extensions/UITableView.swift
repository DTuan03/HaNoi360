//
//  UITableView.swift
//  HaNoi360
//
//  Created by Tuấn on 18/5/25.
//
import UIKit
import Lottie
import SnapKit

extension UITableView {
    func setLottieBackground(name: String, title: String, message: String) {
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = .loop
        animationView.play()
        
        let title = LabelFactory.createLabel(text: title, font: .medium20, textColor: UIColor(hex: "#374151"))
        let message = LabelFactory.createLabel(text: message, font: .regular16, textColor: UIColor(hex: "#374151"), textAlignment: .center)

        let stv = [title, message].vStack(8, alignment: .center)
        let container = UIView(frame: self.bounds)
        container.addSubviews([animationView, stv])
        animationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(48)
            make.top.equalToSuperview().offset(120)
        }
        
        stv.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(animationView.snp.bottom).offset(4)
        }

        self.backgroundView = container
    }
    
    func setImageBackground(image: String, title: String, message: String) {
        let animationView = ImageViewFactory.createImageView(image: UIImage(named: image))
        
        let title = LabelFactory.createLabel(text: title, font: .medium20, textColor: UIColor(hex: "#374151"))
        let message = LabelFactory.createLabel(text: message, font: .regular16, textColor: UIColor(hex: "#374151"))

        let stv = [title, message].vStack(8, alignment: .center)
        let container = UIView()
        container.layer.borderColor = UIColor(hex: "#F3F4F6").cgColor
        container.layer.borderWidth = 1
        container.layer.cornerRadius = 16
        addSubviews(container)
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
        }
        container.addSubviews([animationView, stv])
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        
        stv.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(animationView.snp.bottom).offset(6)
        }

        self.backgroundView = container
    }

    func clearBackground() {
        self.backgroundView = nil
    }
}
