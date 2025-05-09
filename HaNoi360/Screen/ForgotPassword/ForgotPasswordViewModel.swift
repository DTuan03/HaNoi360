//
//  ForgotPasswordViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 1/4/25.
//

import RxSwift
import RxCocoa
import FirebaseAuth

class ForgotPasswordViewModel {
    var isSendMail = BehaviorRelay(value: false)
    var forgotPassError =  BehaviorRelay(value: "")
    
    var emailInput = BehaviorRelay(value: "")
    
    func sendMail() {
        AuthRepository.shared.resetPassword(email: emailInput.value, completion: { result in
            switch result {
            case .success(_):
                self.isSendMail.accept(true)
            case .failure(let error):
                let error = self.getAuthErrorMessage(error)
                self.forgotPassError.accept(error)
                self.isSendMail.accept(false)
            }
        })
    }
    
    private func getAuthErrorMessage(_ error: Error) -> String {
        if let errorCode = AuthErrorCode.Code(rawValue: error as NSError as! Int) {
            switch errorCode {
            case .userNotFound:
                return "Email không tồn tại!"
            case .networkError:
                return "Kiểm tra internet."
            case .tooManyRequests:
                return "Gửi quá nhiều yêu cầu. Thử lại!"
            default:
                return "Hãy thử lại."
            }
        }
        return "Lỗi không xác định."
    }
}
