//
//  ConfirmEmailViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 4/4/25.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class ConfirmEmailViewModel {
    let isConfirm = PublishRelay<Bool>()
    private let db = Firestore.firestore()
    
    func confirm(name: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.reload { error in
            if error != nil {
                self.isConfirm.accept(false)
                return
            }
            
            if user.isEmailVerified {
                AuthRepository.shared.saveUserInfoToFirestore(user: user, name: name, role: "user", completion: {_ in
                    self.isConfirm.accept(true)
                })
            } else {
                self.isConfirm.accept(false)
            }
        }
    }
}
