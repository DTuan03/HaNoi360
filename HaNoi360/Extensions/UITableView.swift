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
    func setLottieBackground(name: String) {
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = .loop
        animationView.play()

        let container = UIView(frame: self.bounds)
        container.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(40)
        }

        self.backgroundView = container
    }

    func clearBackground() {
        self.backgroundView = nil
    }
}
