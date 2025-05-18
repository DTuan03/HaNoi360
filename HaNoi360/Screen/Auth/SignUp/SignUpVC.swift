//
//  SignUpVC.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast_Swift

class SignUpVC: BaseVC {
    let viewModel = SignUpViewModel()
    lazy var navigation = NavigationViewFactory.createNavigationViewWithBackButtonOnly(image: .back,
                                                                                       isHiddenBtn: true,
                                                                                       delegate: self)
    lazy var titleLabel = LabelFactory.createLabel(text: "Bắt đầu thôi",
                                                   font: .bold24,
                                                   textAlignment: .center)
    
    lazy var descriptionLabel = LabelFactory.createLabel(text: "Vui lòng điền thông tin và tạo tài khoản.",
                                                         font: .regular16,
                                                         textColor: .secondaryTextColor,
                                                         textAlignment: .center)
    
    lazy var nameTextField = {
        let tf = TextFieldFactory.createTextField(placeholder: "Họ tên")
        tf.imageLeftView(image: .user)
        return tf
    }()
    
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
    
    lazy var errorName = LabelFactory.createLabel(text: "❗Tên không được để trống",
                                                  font: .light12,
                                                  textColor: .red)

    lazy var errorEmail = LabelFactory.createLabel(text: "❗Kiểm tra định dạng email",
                                                    font: .light12,
                                                   textColor: .red)

    lazy var errorPass = LabelFactory.createLabel(text: "❗Nhập mật khẩu mạnh hơn, gồm 8 ký tự hoa, số, đặc biệt",
                                                    font: .light12,
                                                   textColor: .red)
 
    lazy var signUpBtn = ButtonFactory.createButton("Đăng ký",
                                                    font: .bold16,
                                                    textColor: .textButtonColor)
    
    lazy var signUpLabel = LabelFactory.createLabel(text: "Bạn đã có tài khoản ? Đăng nhập",
                                                    font: .light18,
                                                    textAlignment: .center,
                                                    highLighText: "Đăng nhập",
                                                    highLightFont: .bold18)
    
    lazy var stackView = [nameTextField, emailTextField, passwordTF, signUpBtn].vStack(22)
    
    lazy var orSignInLabel = LabelFactory.createLabel(text: "Hoặc sử dụng Đăng ký ngay lập tức.",
                                                      font: .medium16,
                                                      textColor: .secondaryTextColor,
                                                      textAlignment: .center)
    
    lazy var appleBtn = {
        let btn = ButtonFactory.createButton("      Đăng nhập bằng Apple ID", font: .medium18, textColor: UIColor(hex: "#111827"), bgColor: .signInOtherButtonColor, rounded: true)
        btn.setImage(.apple, for: .normal)
        return btn
    }()
    
    lazy var googleBtn = {
        let btn = ButtonFactory.createButton("      Đăng nhập bằng Google", font: .medium18, textColor: UIColor(hex: "#111827"), bgColor: .signInOtherButtonColor, rounded: true)
        btn.setImage(.google, for: .normal)
        return btn
    }()
    
    lazy var signUpOtherSv = ([appleBtn, googleBtn]).vStack(20)
    
    lazy var signInLabel = LabelFactory.createLabel(text: "Bạn đã có tài khoản ? Đăng nhập",
                                                    font: .light18,
                                                    textAlignment: .center,
                                                    highLighText: "Đăng nhập",
                                                    highLightFont: .bold18)
    
    lazy var activityIndicator =  {
        let aI = UIActivityIndicatorView(style: .medium)
        aI.hidesWhenStopped = true
        aI.color = .white
        return aI
    }()

    override func setupUI() {
        view.addSubviews([navigation ,titleLabel, descriptionLabel, stackView, orSignInLabel, signUpOtherSv, signInLabel, errorName, errorEmail, errorPass])
        
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
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        orSignInLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        signUpOtherSv.snp.makeConstraints { make in
            make.top.equalTo(orSignInLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(20)
        }
        
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpOtherSv.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
        }
        
        errorName.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(2)
            make.left.equalTo(nameTextField.snp.left).offset(5)
        }
        
        errorEmail.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(2)
            make.left.equalTo(emailTextField.snp.left).offset(5)
        }
        
        errorPass.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(2)
            make.left.equalTo(passwordTF.snp.left).offset(5)
        }
        errorName.isHidden = true
        errorEmail.isHidden = true
        errorPass.isHidden = true

        signUpBtn.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-50)
        }
    }
    
    override func setupEvent() {
        nameTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {
                if let nameText = self.nameTextField.text {
                    self.viewModel.isValidateName(nameText)
                    self.viewModel.nameInput.accept(nameText)
                }
                
                if self.viewModel.isName.value {
                    self.errorName.isHidden = true
                    self.nameTextField.layer.borderWidth = 0
                } else {
                    self.errorName.isHidden = false
                    self.nameTextField.layer.borderColor = UIColor(hex: "#FF3030").cgColor
                    self.nameTextField.layer.borderWidth = 1
                }
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {
                if let emailText = self.emailTextField.text {
                    self.viewModel.isValidEmail(emailText)
                    self.viewModel.emailInput.accept(emailText)
                }
                
                if self.viewModel.isEmail.value {
                    self.errorEmail.isHidden = true
                    self.emailTextField.layer.borderWidth = 0
                } else {
                    self.errorEmail.isHidden = false
                    self.emailTextField.layer.borderColor = UIColor(hex: "#FF3030").cgColor
                    self.emailTextField.layer.borderWidth = 1
                }
            })
            .disposed(by: disposeBag)
        
        passwordTF.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {
                if let passText = self.passwordTF.text {
                    self.viewModel.isValidPassword(passText)
                    self.viewModel.passwordInput.accept(passText)
                }
                
                if self.viewModel.isPassword.value {
                    self.errorPass.isHidden = true
                    self.passwordTF.layer.borderWidth = 0
                } else {
                    self.errorPass.isHidden = false
                    self.passwordTF.layer.borderColor = UIColor(hex: "#FF3030").cgColor
                    self.passwordTF.layer.borderWidth = 1
                }
            })
            .disposed(by: disposeBag)
        
        signUpBtn.rx.tap
            .subscribe(onNext: {
                self.addDismissKeyboard()
                self.viewModel.signUp()
            })
            .disposed(by: disposeBag)
                
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.signUpSuccess
            .subscribe(onNext: { success in
                if success {
                    self.nameTextField.text = ""
                    self.emailTextField.text = ""
                    self.passwordTF.text = ""
                    let confirmEmailVC = ConfirmEmailVC()
                    confirmEmailVC.nameUser = self.nameTextField.text
                    self.navigationController?.pushViewController(ConfirmEmailVC(), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.signUpError
            .subscribe(onNext: { errorMessage in
                Toast.showToast(message: errorMessage, image: "toast_error")
            })
            .disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(signInLabelAction))
        signInLabel.addGestureRecognizer(tap)
    }
    
    @objc func signInLabelAction() {
        navigationController?.pushViewController(SignInVC(), animated: true)
    }
}

extension SignUpVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
