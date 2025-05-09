//
//  NavigationFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//
import UIKit
import SnapKit

protocol NavigationViewDelegate: AnyObject {
    func didTapButton(in view: UIView)
}

class NavigationViewFactory {
    static func createNavigationViewWithBackButtonOnly(image: UIImage? = .back,
                                                       isHiddenBtn: Bool = false,
                                                       delegate: NavigationViewDelegate? = nil) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        let backButton = createButton(withImage: image)
        backButton.isHidden = isHiddenBtn
        
        let lineView = UIViewFactory.createLineView()
        
        backButton.addTargetClosure { _ in
            delegate?.didTapButton(in: view)
        }
        
        view.addSubviews([backButton, lineView])
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
            make.height.equalTo(1)
        }
        
        return view
    }
    
    static func createNavigationViewWithTitleOnly(title: String? = nil) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        let titleLabel = LabelFactory.createLabel(text: title, font: .medium18, textColor: .textNavigationColor, textAlignment: .center)
        
        let lineView = UIViewFactory.createLineView()
        
        view.addSubviews([lineView, titleLabel])
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
            make.height.equalTo(1)
        }
        
        return view
    }
    
    static func createNavigationViewWithBackButtonAndTitle(image: UIImage? = nil,
                                                           title: String? = nil,
                                                           delegate: NavigationViewDelegate? = nil) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        let backButton = createButton(withImage: image)
        backButton.contentHorizontalAlignment = .left
        
        let titleLabel = LabelFactory.createLabel(text: title, font: .medium18, textColor: .textNavigationColor, textAlignment: .center)
        
        let lineView = UIViewFactory.createLineView()
        
        backButton.addTargetClosure { _ in
            delegate?.didTapButton(in: view)
        }
        
        view.addSubviews([backButton, lineView, titleLabel])
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
            make.height.equalTo(1)
        }
        
        return view
    }
    
    static func createNavigationViewWithSkipButton(image: UIImage? = nil,
                                                   titleButton: String? = nil,
                                                   delegate: NavigationViewDelegate? = nil) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        let skipButton = createButton(withImage: image, title: titleButton)
        skipButton.contentHorizontalAlignment = .left
        skipButton.semanticContentAttribute = .forceRightToLeft
        
        let lineView = UIViewFactory.createLineView()
        
        skipButton.addTargetClosure { _ in
            delegate?.didTapButton(in: view)
        }
        
        view.addSubviews([skipButton, lineView])
        skipButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
            make.height.equalTo(1)
        }
        
        return view
    }
    
    static func createNavigationViewWithNotiButton(image: UIImage? = nil,
                                                   delegate: NavigationViewDelegate? = nil) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor(hex: "#D1D5DB").cgColor
        containerView.layer.borderWidth = 1
        
        let skipButton = createButton(withImage: image)
        skipButton.contentHorizontalAlignment = .left
        
        containerView.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        skipButton.addTargetClosure { _ in
            delegate?.didTapButton(in: view)
        }
        
        view.addSubviews([containerView])
        containerView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        return view
    }
    
    private static func createButton(withImage image: UIImage?, title: String? = nil) -> UIButton {
        let button = UIButton()
        guard let image = image else { return button }
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        if let titleButton = title {
            button.setTitle(NSLocalizedString(titleButton, comment: ""), for: .normal)
            button.setTitleColor(.primaryTextColor, for: .normal)
            button.titleLabel?.font = .medium16
        }
        return button
    }
}
