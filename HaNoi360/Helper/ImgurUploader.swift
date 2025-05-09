//
//  ImgurUploader.swift
//  HaNoi360
//
//  Created by Tuấn on 15/4/25.
//

import Foundation
import UIKit
import RxSwift

class ImgurUploader {
    private let clientID: String = "8a144603ddb6aab" // Client-ID
    
    // Upload 1 ảnh → trả về link ảnh    
    func upload(image: UIImage) -> Observable<String> {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return Observable.error(NSError(domain: "ImgurError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Không thể convert ảnh"]))
            }

            return Observable.create { observer in
                let url = URL(string: "https://api.imgur.com/3/image")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Client-ID \(self.clientID)", forHTTPHeaderField: "Authorization")

                // Tạo multipart form
                let boundary = UUID().uuidString
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                var body = Data()
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)

                request.httpBody = body

                // Gửi request
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }

                    guard let data = data else {
                        observer.onError(NSError(domain: "ImgurError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Không có dữ liệu trả về"]))
                        return
                    }

                    // In JSON để debug (tùy chọn)
                    if let raw = String(data: data, encoding: .utf8) {
                        print("🌐 JSON từ Imgur:\n\(raw)")
                    }

                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let dataDict = json["data"] as? [String: Any],
                           let link = dataDict["link"] as? String {
                            observer.onNext(link)
                            observer.onCompleted()
                        } else {
                            observer.onError(NSError(domain: "ImgurError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Không parse được link từ JSON"]))
                        }
                    } catch {
                        observer.onError(error)
                    }
                }

                task.resume()
                return Disposables.create { task.cancel() }
            }
        }

    // Upload nhiều ảnh → trả về mảng link
    func upload(images: [UIImage]) -> Observable<[String]> {
        guard !images.isEmpty else {
            return Observable.just([])
        }

        let uploadObservables = images.map { upload(image: $0) }
        return Observable.zip(uploadObservables)
    }

}
