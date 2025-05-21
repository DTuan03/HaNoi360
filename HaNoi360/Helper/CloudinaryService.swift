//
//  ImgurUploader.swift
//  HaNoi360
//
//  Created by Tuấn on 15/4/25.
//

import Cloudinary

class CloudinaryService {
    static let shared = CloudinaryService()
    
    private let cloudinary: CLDCloudinary
    
    private init() {
        let config = CLDConfiguration(cloudName: "dwzowi6pl", secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    func uploadImages(images: [UIImage], completion: @escaping (Result<[String], Error>) -> Void) {
        var uploadedUrls: [String] = []
        var errorOccurred: Error?
        let group = DispatchGroup()
        
        for image in images {
            group.enter()
            uploadImage(image: image) { result in
                switch result {
                case .success(let url):
                    uploadedUrls.append(url)
                case .failure(let error):
                    errorOccurred = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = errorOccurred {
                completion(.failure(error))
            } else {
                completion(.success(uploadedUrls))
            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Không thể convert ảnh"])))
            return
        }
        
        let params = CLDUploadRequestParams()
        params.setUploadPreset("HaNoi360")
        
        cloudinary.createUploader().upload(data: data, uploadPreset: "HaNoi360", params: params)
            .response { result, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = result?.secureUrl {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "UploadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Không lấy được đường dẫn ảnh"])))
                }
            }
    }
}
