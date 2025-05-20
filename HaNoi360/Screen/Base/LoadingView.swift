//
//  LoadingV.swift
//  HaNoi360
//
//  Created by Tuấn on 10/5/25.
//

import UIKit
import Lottie
import SnapKit

class LoadingView: UIView {
    private let animationView = LottieAnimationView(name: "loading")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.backgroundColor = UIColor.white.cgColor
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.center.equalToSuperview()
        }
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }

    func startAnimating() {
        isHidden = false
        animationView.play()
    }

    func stopAnimating() {
        animationView.stop()
        isHidden = true
    }
}
