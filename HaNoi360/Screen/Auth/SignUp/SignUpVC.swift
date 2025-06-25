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
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class SignUpVC: BaseVC {
    let viewModel = SignUpViewModel()
    
    lazy var scrollView = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor)
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var navigation = NavigationViewFactory.createNavigationViewWithBackButtonOnly(image: .back,
                                                                                       isHiddenBtn: true,
                                                                                       delegate: self)
    lazy var titleLabel = LabelFactory.createLabel(text: "auth.get.started".localized,
                                                   font: .bold24,
                                                   textAlignment: .center)
    
    lazy var descriptionLabel = LabelFactory.createLabel(text: "auth.signup.instruction".localized,
                                                         font: .regular16,
                                                         textColor: .secondaryTextColor,
                                                         textAlignment: .center)
    
    lazy var nameTextField = {
        let tf = TextFieldFactory.createTextField(placeholder: "auth.fullname".localized)
        tf.imageLeftView(image: .user)
        return tf
    }()
    
    lazy var errorName = LabelFactory.createLabel(text: "auth.error.name.empty".localized,
                                                  font: .light12,
                                                  textColor: .erorrColor)
    
    lazy var nameStv = [nameTextField, errorName].vStack(4)
    
    lazy var emailTextField = {
        let tf = TextFieldFactory.createTextField(placeholder: "Email")
        tf.imageLeftView(image: .mail)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    lazy var errorEmail = LabelFactory.createLabel(text: "auth.error.email.invalid".localized,
                                                   font: .light12,
                                                   textColor: .erorrColor)
    
    lazy var emailStv = [emailTextField, errorEmail].vStack(4)
    
    lazy var passwordTF = {
        let tf = TextFieldFactory.createTextField(placeholder: "auth.password".localized)
        tf.isSecureTextEntry = true
        tf.imageLeftView(image: .lock)
        tf.imageRightView(image: UIImage(systemName: "eye.slash.fill"), placeholder: "password")
        return tf
    }()
    
    lazy var errorPass = LabelFactory.createLabel(text: "auth.error.password.weak".localized,
                                                  font: .light12,
                                                  textColor: .erorrColor)
    
    lazy var passStv = [passwordTF, errorPass].vStack(4)
    
    lazy var signUpBtn = ButtonFactory.createButton("auth.signup.button".localized,
                                                    font: .bold16,
                                                    textColor: .textButtonColor)
    
    lazy var signUpLabel = LabelFactory.createLabel(text: "auth.login.existing".localized,
                                                    font: .light18,
                                                    textAlignment: .center,
                                                    highLighText: "auth.login.button".localized,
                                                    highLightFont: .bold18)
    
    lazy var stackView = [nameStv, emailStv, passStv, signUpBtn].vStack(22)
    
    lazy var orSignInLabel = LabelFactory.createLabel(text: "auth.login.or".localized,
                                                      font: .medium16,
                                                      textColor: .secondaryTextColor,
                                                      textAlignment: .center)
    
    lazy var appleBtn = {
        let btn = ButtonFactory.createButton("      Đăng nhập bằng Apple ID", font: .medium18, textColor: UIColor(hex: "#111827"), bgColor: .signInOtherButtonColor, rounded: true)
        btn.setImage(.apple, for: .normal)
        return btn
    }()
    
    lazy var googleBtn = {
        let btn = ButtonFactory.createButton("auth.login.with.google".localized, font: .medium18, textColor: UIColor(hex: "#111827"), bgColor: .signInOtherButtonColor, rounded: true)
        btn.setImage(.google, for: .normal)
        return btn
    }()
    
    lazy var signUpOtherSv = ([appleBtn, googleBtn]).vStack(20)
    
    lazy var signInLabel = LabelFactory.createLabel(text: "auth.login.existing".localized,
                                                    font: .light18,
                                                    textAlignment: .center,
                                                    highLighText: "auth.login.button".localized,
                                                    highLightFont: .bold18)
    
    lazy var activityIndicator =  {
        let aI = UIActivityIndicatorView(style: .medium)
        aI.hidesWhenStopped = true
        aI.color = .white
        return aI
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTF.text = ""
    }
    
    override func setupUI() {
        view.addSubviews([scrollView])
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubviews([navigation ,titleLabel, descriptionLabel, stackView, orSignInLabel, signUpOtherSv, signInLabel])
        
        navigation.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
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
            make.bottom.equalToSuperview().inset(10)
        }
     
        errorName.isHidden = true
        errorEmail.isHidden = true
        errorPass.isHidden = true
        appleBtn.isHidden = true
        
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
                    print("NameTextField: \(nameText)")
                    print("Name VM: \(self.viewModel.nameInput.value)")
                }
                
                if self.viewModel.isName.value {
                    self.errorName.isHidden = true
                    self.nameTextField.layer.borderWidth = 0
                } else {
                    self.errorName.isHidden = false
                    self.nameTextField.layer.borderColor = UIColor.erorrColor.cgColor
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
                    self.emailTextField.layer.borderColor = UIColor.erorrColor.cgColor
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
                    self.passwordTF.layer.borderColor = UIColor.erorrColor.cgColor
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
                    let confirmEmailVC = ConfirmEmailVC(nameUser: self.viewModel.nameInput.value)
                    self.navigationController?.pushViewController(confirmEmailVC, animated: true)
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
        
        googleBtn.rx.tap
            .subscribe(onNext: {
                self.signInWithGoogle()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func signInLabelAction() {
        navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            if let error = error {
                print("Lỗi:", error.localizedDescription)
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Thiếu idToken hoặc accessToken")
                return
            }
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase đăng nhập thất bại:", error.localizedDescription)
                    return
                }
                
                self?.isLoading.accept(true)
                // Thành công → Lưu vào Firestore qua AuthRepository
                if let firebaseUser = result?.user {
                    AuthRepository.shared.saveUser(firebaseUser) {
                        self?.navigationController?.pushViewController(TabBarVC(), animated: true)
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "isLoggedIn")
                    }
                }
            }
        }
    }
}

extension SignUpVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
