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
    let containerView = UIView()
    private let animationView = LottieAnimationView(name: "loading")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubviews(containerView)
        containerView.backgroundColor = .clear
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        containerView.addSubview(animationView)

        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(150)
            make.center.equalToSuperview()
        }
    }

    func play() {
        animationView.play()
    }

    func stop() {
        animationView.stop()
    }
}
