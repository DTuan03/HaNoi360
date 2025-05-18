//
//  ForgotPasswordVC.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//

import UIKit
import Toast_Swift

class ForgotPasswordVC: BaseVC {
    let viewModel = ForgotPasswordViewModel()
    lazy var navigation = NavigationViewFactory.createNavigationViewWithBackButtonOnly(image: .back,
                                                                                       delegate: self)
    var titleForgotPasswordVC: String = "Quên mật khẩu"
    lazy var titleLabel = LabelFactory.createLabel(text: titleForgotPasswordVC,
                                                   font: .bold24,
                                                   textColor: .primaryTextColor,
                                                   textAlignment: .center)
    lazy var descriptionLabel = LabelFactory.createLabel(text: "Nhập địa chỉ email của bạn để đặt lại mật khẩu",
                                                         font: .regular16,
                                                         textColor: .secondaryTextColor,
                                                         textAlignment: .center)
    lazy var emailTextField = {
        let tf = TextFieldFactory.createTextField(placeholder: "Email")
        tf.imageLeftView(image: .mail)
        return tf
    }()
    
    lazy var requestBtn = ButtonFactory.createButton("Gửi",
                                                     font: .bold16,
                                                     textColor: .textButtonColor)
    
    override func setupUI() {
        view.addSubviews([navigation, titleLabel, descriptionLabel, emailTextField, requestBtn])
        
        navigation.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(58)
        }
        
        requestBtn.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    override func setupEvent() {
        emailTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {
                if let emailText = self.emailTextField.text {
                    self.viewModel.emailInput.accept(emailText)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isSendMail
            .subscribe(onNext: { isSendMail in
                if isSendMail {
                    Toast.showToast(message: "Đã gửi mail xác nhận!", image: "toast_success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    Toast.showToast(message: self.viewModel.forgotPassError.value, image: "toast_error")
                }
            })
            .disposed(by: disposeBag)
        
        requestBtn.rx.tap
            .subscribe(onNext: {
                self.view.endEditing(true)
                self.viewModel.sendMail()
            })
            .disposed(by: disposeBag)
    }
}

extension ForgotPasswordVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
