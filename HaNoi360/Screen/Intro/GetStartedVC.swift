//
//  GetStartedVC.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

import UIKit
import RxSwift
import RxCocoa

class GetStartedVC: BaseVC {
    lazy var navigation = NavigationViewFactory.createNavigationViewWithSkipButton(image: .skip,
                                                                                   titleButton: "Bỏ qua",
                                                                                   delegate: self)
    lazy var titleLabel = LabelFactory.createLabel(text: "Đắm mình trong hành \n trình, tìm thấy mình \n qua phiêu lưu.",
                                                   font: .bold32,
                                                   textAlignment: .center)
    
    lazy var image = ImageViewFactory.createImageView(image: .getStarted)
    
    lazy var startButton = ButtonFactory.createButton("Bắt đầu")
    
    lazy var signInLabel = LabelFactory.createLabel(text: "Bạn đã có tài khoản ? Đăng nhập",
                                                            font: .light18,
                                                            highLighText: "Đăng nhập",
                                                            highLightFont: .bold18)
    
    override func setupUI() {
        view.addSubviews([navigation, titleLabel, image, startButton, signInLabel])
        navigation.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setupEvent() {
        UserDefaults.standard.set(true, forKey: "isIntro")
        startButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else {return}
                navigationController?.pushViewController(IntroVC(), animated: true)
            })
            .disposed(by: disposeBag)
        let tap = UITapGestureRecognizer(target: self, action: #selector(signInLabelAction))
        signInLabel.addGestureRecognizer(tap)
    }
    
    @objc func signInLabelAction() {
        navigationController?.pushViewController(SignInVC(), animated: true)
    }
}

extension GetStartedVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        let signInVC = SignInVC()
        navigationController?.pushViewController(signInVC, animated: true)
    }
}
