//
//  SignInViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 1/4/25.
//

import RxSwift
import RxCocoa
import FirebaseAuth

class SignInViewModel {
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var emailInput = BehaviorRelay<String>(value: "")
    var passwordInput = BehaviorRelay<String>(value: "")
    
    var signUpSuccess = BehaviorRelay<Bool>(value: false)
    var signUpError = PublishRelay<String>()
    
    func signIn() {
        isLoading.accept(true)
        if !emailInput.value.isEmpty && !passwordInput.value.isEmpty {
            AuthRepository.shared.signIn(email: emailInput.value, password: passwordInput.value, completion: { result in
                switch result {
                case .success(let (userId, userName, avatarUrl)):
                    UserDefaults.standard.set(userName, forKey: "userName")
                    UserDefaults.standard.set(avatarUrl, forKey: "avatarUrl")
                    self.signUpSuccess.accept(true)
                    self.isLoading.accept(false)
                case .failure(let error):
                    let error = AuthRepository.shared.getAuthErrorMessage(error)
                    self.signUpError.accept(error)
                    self.isLoading.accept(false)
                }
            })
        } else {
            self.isLoading.accept(false)
            signUpError.accept("auth.validation.fill.all".localized)
        }
    }
}
