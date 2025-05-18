//
//  SignInVC.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast_Swift

class SignInVC: BaseVC {
    let viewModel = SignInViewModel()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonOnly(image: .back,
                                                                                           isHiddenBtn: true,
                                                                                           delegate: self)
    lazy var titleLabel = LabelFactory.createLabel(text: "Xin chào !",
                                                   font: .bold24,
                                                   textAlignment: .center)
    
    lazy var descriptionLabel = LabelFactory.createLabel(text: "Chào mừng đến với HaNoi360",
                                                         font: .regular16,
                                                         textColor: .secondaryTextColor,
                                                         textAlignment: .center)
    
    lazy var emailTextField = {
        let tf = TextFieldFactory.createTextField(placeholder: "Email")
        tf.imageLeftView(image: .mail)
        return tf
    }()
    
    lazy var passwordTF = {
        let tf = TextFieldFactory.createTextField(placeholder: "Mật khẩu")
        tf.isSecureTextEntry = true
        tf.imageLeftView(image: .lock)
        tf.imageRightView(image: UIImage(systemName: "eye.slash.fill"), placeholder: "password")
        return tf
    }()
    
    lazy var forgotPassLabel = LabelFactory.createLabel(text: "Quên mật khẩu ?",
                                                        font: .bold14,
                                                        textColor: .forgotPassLabelColor,
                                                        textAlignment: .right)
    lazy var signInBtn = ButtonFactory.createButton("Đăng nhập",
                                                    font: .bold16,
                                                    textColor: .textButtonColor)
    
    lazy var signUpLabel = LabelFactory.createLabel(text: "Bạn chưa có tài khoản ? Đăng ký",
                                                    font: .light18,
                                                    textAlignment: .center,
                                                    highLighText: "Đăng ký",
                                                    highLightFont: .bold18)
    lazy var stackView = [emailTextField, passwordTF, forgotPassLabel, signInBtn, signUpLabel].vStack(20)
    
    lazy var activityIndicator =  {
        let aI = UIActivityIndicatorView(style: .medium)
        aI.hidesWhenStopped = true
        aI.color = .white
        return aI
    }()
    
    override func setupUI() {
        view.addSubviews([navigationView ,titleLabel, descriptionLabel, stackView])
            navigationView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        signInBtn.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-55)
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
        
        passwordTF.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {
                if let passText = self.passwordTF.text {
                    self.viewModel.passwordInput.accept(passText)
                }
            })
            .disposed(by: disposeBag)
        
        signInBtn.rx.tap
            .subscribe(onNext: {
                self.addDismissKeyboard()
                self.viewModel.signIn()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.signUpSuccess
            .subscribe(onNext: { success in
                if success {
                    self.navigationController?.pushViewController(TabBarVC(), animated: true)
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "isLoggedIn")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.signUpError
            .subscribe(onNext: { errorMessage in
                Toast.showToast(message: errorMessage, image: "toast_error")
            })
            .disposed(by: disposeBag)
        
        let signUpLabelTap = UITapGestureRecognizer(target: self, action: #selector(signInLabelAction))
        signUpLabel.addGestureRecognizer(signUpLabelTap)
        
        let forgotPassLabelTap = UITapGestureRecognizer(target: self, action: #selector(forgotPassLabelAction))
        forgotPassLabel.addGestureRecognizer(forgotPassLabelTap)
    }
    
    @objc func signInLabelAction() {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
    @objc func forgotPassLabelAction() {
        navigationController?.pushViewController(ForgotPasswordVC(), animated: true)
    }
}

extension SignInVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
