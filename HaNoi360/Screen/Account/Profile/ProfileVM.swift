//
//  ProfileVM.swift
//  HaNoi360
//
//  Created by Tuấn on 3/6/25.
//

import RxSwift
import RxCocoa
import UIKit

class ProfileVM: BaseVM {
    var isLoading = PublishRelay<Bool>()
    var isValidate = PublishRelay<Bool>()
    var user = BehaviorRelay<ProfileModel?>(value: nil)
    var avatarUrl = BehaviorRelay<String?>(value: nil)
    var avatarIv = BehaviorRelay<UIImage?>(value: nil)
    
    func featchUser() {
        userService.fetchWhereEqualTo(field: "userId", value: userId) { result in
            switch result {
            case .success(let profile):
                self.user.accept(profile[0])
            case .failure(_):
                print("loi")
            }
        }
    }
    
    func updateProfile(field: String, value: String, completion: @escaping () -> Void) {
        let updateData: [String: Any] = [
            field: value
        ]
        isLoading.accept(true)
        userService.updateFields(for: userId, data: updateData) { result in
            switch result {
            case .success(_):
                self.isLoading.accept(false)
                print("Ok")
            case .failure(_):
                print("loi")
            }
            completion()
        }
    }
    
    func uploadAvatar() {
        guard let image = avatarIv.value else { return }
        CloudinaryService.shared.uploadImage(image: image) { result in
            switch result {
            case .success(let url):
                self.avatarUrl.accept(url)
            case .failure(let error):
                print("Lỗi upload: \(error.localizedDescription)")
            }
        }
    }
}
