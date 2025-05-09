//
//  SignUpViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//
import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class SignUpViewModel {
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isEmail = BehaviorRelay<Bool>(value: false)
    var isName = BehaviorRelay<Bool>(value: false)
    var isPassword = BehaviorRelay<Bool>(value: false)
    
    var nameInput = BehaviorRelay<String>(value: "")
    var emailInput = BehaviorRelay<String>(value: "")
    var passwordInput = BehaviorRelay<String>(value: "")
    
    var signUpSuccess = BehaviorRelay<Bool>(value: false)
    var signUpError = PublishRelay<String>()
    
    func isValidateName(_ name: String) {
        let isValidName = !name.isEmpty
        isName.accept(isValidName)
    }
    
    func isValidEmail(_ email: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let isValidEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        isEmail.accept(isValidEmail)
    }
    
    func isValidPassword(_ password: String) {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}$"
        let isValidPass = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        isPassword.accept(isValidPass)
    }
    
    func signUp() {
        isLoading.accept(true)
        if isName.value && isEmail.value && isPassword.value {
            AuthRepository.shared.signUp(name: nameInput.value,
                                         email: emailInput.value,
                                         password: passwordInput.value,
                                         role: "user") { result in
                switch result {
                case .success(_):
                    self.signUpSuccess.accept(true)
                    self.isLoading.accept(false)
                case .failure(let error):
                    let error = AuthRepository.shared.getAuthErrorMessage(error)
                    self.signUpError.accept(error)
                    self.isLoading.accept(false)
                }
            }
        }
        else {
            self.isLoading.accept(false)
            self.signUpError.accept("Nhập đủ thông tin!")
        }
    }
    
//    func signUpWithGG() {
//        isLoading.accept(true)
//        AuthRepository.shared.signInWithGG(completion: { result in
//            switch result {
//            case .success(let success):
//                self.signUpSuccess.accept(true)
//                self.isLoading.accept(false)
//            case .failure(let failure):
//                let error = self.getAuthErrorMessage(error)
//                self.signUpError.accept(error)
//                self.isLoading.accept(false)
//            }
//        })
//    }
    
    

}
