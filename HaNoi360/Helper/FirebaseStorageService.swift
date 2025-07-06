//
//  ImgurUploader.swift
//  HaNoi360
//
//  Created by Tuấn on 15/4/25.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseStorageService {

    static let shared = FirebaseStorageService()
    private let storage = Storage.storage()
    
    private init() {}

    func uploadImage(_ image: UIImage, to path: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Không thể chuyển UIImage thành JPEG"])))
            return
        }
        
        let storageRef = storage.reference().child(path)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadURL = url {
                    completion(.success(downloadURL.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "DownloadURLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Không lấy được URL"])))
                }
            }
        }
    }

    func deleteImage(at path: String, completion: ((Error?) -> Void)? = nil) {
        let storageRef = storage.reference().child(path)
        storageRef.delete(completion: completion)
    }
}
