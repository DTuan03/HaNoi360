//
//  AuthRepository.swift
//  HaNoi360
//
//  Created by Tuấn on 28/3/25.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

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
    
    func signIn(email: String, password: String, completion: @escaping (Result<(String, String, String, String), Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = result?.user else { return }
            
            if user.isEmailVerified {
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
                    let avatarUrl = data?["avatarUrl"] as? String ?? ""
                    completion(.success((userId, userName, role, avatarUrl)))
                }
            } else {
                let notVerifiedError = NSError(domain: "", code: -1001, userInfo: [NSLocalizedDescriptionKey: "Chưa xác minh email"])
                completion(.failure(notVerifiedError))
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Lỗi sign out: \(error.localizedDescription)")
                }
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
        
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                return "Không có kết nối Internet."
            case NSURLErrorTimedOut:
                return "Kết nối quá hạn. Vui lòng thử lại."
            default:
                return "Lỗi mạng. Vui lòng kiểm tra kết nối."
            }
        }
        
        if let authError = AuthErrorCode(_bridgedNSError: nsError) {
            switch authError.code {
            case .userNotFound:
                return "Tài khoản không tồn tại."
            case .emailAlreadyInUse:
                return "Email đã được sử dụng."
            case .wrongPassword:
                return "Sai mật khẩu."
            case .invalidEmail:
                return "Email không đúng định dạng."
            case .networkError:
                return "Lỗi kết nối. Vui lòng kiểm tra Internet."
            case .tooManyRequests:
                return "Thiết bị tạm thời bị chặn do hoạt động bất thường. Vui lòng thử lại sau."
            case .userDisabled:
                return "Tài khoản đã bị vô hiệu hóa."
            case .weakPassword:
                return "Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn."
            case .requiresRecentLogin:
                return "Hành động yêu cầu đăng nhập lại gần đây."
            default:
                return "Lỗi hệ thống. Vui lòng thử lại sau."
            }
        }
        
        return "Lỗi không xác định. Vui lòng thử lại."
    }
    
    
    
    func saveUser(_ user: User, completion: @escaping () -> Void) {
        let userData: [String: Any] = [
            "userId": user.uid,
            "email": user.email ?? "",
            "name": user.displayName ?? "",
            "avatarUrl": user.photoURL?.absoluteString ?? ""
        ]
        UserDefaults.standard.set(user.uid, forKey: "userId")
        UserDefaults.standard.set(user.displayName, forKey: "userName")
        UserDefaults.standard.set("user", forKey: "role")
        UserDefaults.standard.set(user.photoURL?.absoluteString, forKey: "avatarUrl")
        db.collection("users").document(user.uid).setData(userData, merge: true)
        completion()
    }
}
