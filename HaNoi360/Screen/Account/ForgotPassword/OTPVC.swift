//
//  OTPVC.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//


import UIKit

class OTPVC: BaseVC {
    lazy var navigation = NavigationViewFactory.createNavigationViewWithBackButtonOnly(image: .back,
                                                                                       delegate: self)
    lazy var titleLabel = LabelFactory.createLabel(text: "Mã OTP",
                                                   font: .bold24,
                                                   textColor: .primaryTextColor,
                                                   textAlignment: .center)
    lazy var descriptionLabel = LabelFactory.createLabel(text: "Mã OTP đã được gửi đến số điện thoại đã chỉ định. Vui lòng kiểm tra điện thoại của bạn để nhận mã xác thực.",
                                                         font: .regular16,
                                                         textColor: .secondaryTextColor,
                                                         textAlignment: .center)
    
    lazy var arrTextField: [UITextField] = {
        var textFields: [UITextField] = []
        for item in 0...4 {
            var textField = TextFieldFactory.createTextField(placeholder: nil,
                                                            font: .medium32,
                                                            textAlignment: .center)
            textField.keyboardType = .numberPad
            textField.snp.makeConstraints { make in
                make.height.equalTo(58)
            }
            textFields.append(textField)
        }
        return textFields
    }()
    
    lazy var stackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillEqually
        for textField in self.arrTextField {
            sv.addArrangedSubview(textField)
        }
        return sv
    }()
    
    lazy var signInBtn = ButtonFactory.createButton("Xác nhận",
                                                    font: .bold16,
                                                    textColor: .textButtonColor,
                                                    bgColor: .secondaryButtonColor)
    
    lazy var resendOTPLabel = {
        let text = "Gửi lại mã"
        let label = LabelFactory.createLabel(text: text,
                                             font: .regular16,
                                             textColor: .secondaryTextColor,
                                             textAlignment: .center)
        let attributedString = NSMutableAttributedString(string: text)

        let range = NSRange(location: 0, length: text.count)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)

        label.attributedText = attributedString
        return label
        
    }()
    
    override func setupUI() {
        view.addSubviews([navigation, titleLabel, descriptionLabel, stackView, signInBtn, resendOTPLabel])
        
        navigation.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(50)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        signInBtn.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        resendOTPLabel.snp.makeConstraints { make in
            make.top.equalTo(signInBtn.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
}

extension OTPVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        print("quay lai")
    }
}
