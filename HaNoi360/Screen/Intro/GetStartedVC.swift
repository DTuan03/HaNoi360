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
                                                                                   titleButton: "getStart.skip".localized,
                                                                                   delegate: self)
    lazy var titleLabel = LabelFactory.createLabel(text: "getStart.slogan".localized,
                                                   font: .bold32,
                                                   textAlignment: .center)
    
    lazy var image = ImageViewFactory.createImageView(image: .getStarted)
    
    lazy var startButton = ButtonFactory.createButton("getStart.start".localized)
    
    lazy var signInLabel = LabelFactory.createLabel(text: "auth.login.existing".localized,
                                                            font: .light18,
                                                    highLighText: "getStart.login".localized,
                                                            highLightFont: .bold18)
    
    override func setupUI() {
        view.addSubviews([navigation, titleLabel, image, startButton, signInLabel])
        navigation.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(4)
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
