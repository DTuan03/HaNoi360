//
//  ImagePickerHelper.swift
//  HaNoi360
//
//  Created by Tuấn on 26/5/25.
//

import UIKit

class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private static var completion: ((UIImage?) -> Void)?

    static func pickImage(completion: @escaping (UIImage?) -> Void) {
        guard let topVC = UIApplication.shared.keyWindow?.rootViewController else { return }

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = shared
        ImagePickerHelper.completion = completion

        topVC.present(picker, animated: true)
    }

    private static let shared = ImagePickerHelper()

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage
        Self.completion?(image)
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        Self.completion?(nil)
        picker.dismiss(animated: true)
    }
}
