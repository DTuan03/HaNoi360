//
//  AuthRepository.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class AuthRepository {
    static let shared = AuthRepository()
    private let db = Firestore.firestore()
    
    func signUp(name: String, email: String, password: String, role: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else { return }
            
            user.sendEmailVerification { error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    completion(.success(user))
                }
            }
        }
    }
    
    func saveUserInfoToFirestore(user: User, name: String, role: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "userId": user.uid,
            "name": name,
            "email": user.email ?? "",
            "role": role
        ]) { error in
            completion(error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<(String, String, String), Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = result?.user else { return }
            
            self.db.collection("users").document(user.uid).getDocument { (document, error) in
                if error != nil {
                    return
                }
                guard let document = document else {
                    return
                }
                let data = document.data()
                let userId = data?["userId"] as? String ?? ""
                let userName = data?["name"] as? String ?? ""
                let role = data?["role"] as? String ?? ""
                completion(.success((userId, userName, role)))
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func getAuthErrorMessage(_ error: Error) -> String {
        let nsError = error as NSError
        if let errorCode = AuthErrorCode.Code(rawValue: nsError.code) {
            switch errorCode {
            case .userNotFound:
                return "Tài khoản không tồn tại."
            case .emailAlreadyInUse:
                return "Email đã được sử dụng."
            case .wrongPassword:
                return "Sai mật khẩu."
            case .networkError:
                return "Lỗi kết nối. Vui lòng kiểm tra internet."
            case .invalidEmail:
                return "Email không đúng định dạng."
            default:
                return "Lỗi hệ thống. Vui lòng thử lại."
            }
        }
        return "Lỗi không xác định."
    }

}
