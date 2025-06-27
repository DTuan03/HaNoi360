//
//  NewCreatePostVM.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import RxSwift
import RxCocoa
import Foundation
import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

class NewCreatePostVM {
    let districts: [District] = [
        District(id: "TH1", name: "Ba Đình"),
        District(id: "TH2", name: "Ba Vì"),
        District(id: "TH3", name: "Bắc Từ Liêm"),
        District(id: "TH4", name: "Cầu Giấy"),
        District(id: "TH5", name: "Chương Mỹ"),
        District(id: "TH6", name: "Đan Phượng"),
        District(id: "TH7", name: "Đống Đa"),
        District(id: "TH8", name: "Đông Anh"),
        District(id: "TH9", name: "Gia Lâm"),
        District(id: "TH10", name: "Hà Đông"),
        District(id: "TH11", name: "Hai Bà Trưng"),
        District(id: "TH12", name: "Hoài Đức"),
        District(id: "TH13", name: "Hoàn Kiếm"),
        District(id: "TH14", name: "Hoàng Mai"),
        District(id: "TH15", name: "Long Biên"),
        District(id: "TH16", name: "Mê Linh"),
        District(id: "TH17", name: "Mỹ Đức"),
        District(id: "TH18", name: "Nam Từ Liêm"),
        District(id: "TH19", name: "Phú Xuyên"),
        District(id: "TH20", name: "Phúc Thọ"),
        District(id: "TH21", name: "Quốc Oai"),
        District(id: "TH22", name: "Sơn Tây"),
        District(id: "TH23", name: "Sóc Sơn"),
        District(id: "TH24", name: "Tây Hồ"),
        District(id: "TH25", name: "Thạch Thất"),
        District(id: "TH26", name: "Thanh Oai"),
        District(id: "TH27", name: "Thanh Trì"),
        District(id: "TH28", name: "Thanh Xuân"),
        District(id: "TH29", name: "Thường Tín"),
        District(id: "TH30", name: "Ứng Hòa")
    ]
    let categories: [CategoryModel] = [
        CategoryModel(id: "amThuc", name: "category.food".localized, img: "amThuc"),
        CategoryModel(id: "tamLinh", name: "category.spirituality".localized, img: "tamLinh"),
        CategoryModel(id: "traiNghiem", name: "category.experience".localized, img: "traiNghiem"),
        CategoryModel(id: "muaSam", name: "category.shopping".localized, img: "muaSam"),
        CategoryModel(id: "maoHiem", name: "category.adventure".localized, img: "maoHiem"),
        CategoryModel(id: "canhQuan", name: "category.landscape".localized, img: "canhQuan")
    ]
    var avatarIV = BehaviorRelay<UIImage?>(value: nil)
    var avatarUrl = BehaviorRelay<String?>(value: nil)
    var title = BehaviorRelay<String?>(value: nil)
    var categoryId = BehaviorRelay<[String]?>(value: nil)
    var coordinate = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    var idAddress = BehaviorRelay<String?>(value: nil)
    var contentBlocks = BehaviorRelay<[CreateBlock]>(value: [])
    
    var uploadedImageURLs: [Int: String] = [:]
    
    let userId = Auth.auth().currentUser?.uid
    let userName = UserDefaults.standard.string(forKey: "userName")
    let userAvatar = UserDefaults.standard.string(forKey: "avatarUrl") ?? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"
    
    let blogService = BaseFirestoreService<CreateBlogPost>(collectionPath: "blogs")
    
    var isLoading = PublishRelay<Bool>()
    var isSuccess = PublishRelay<Bool>()
    
    var blogId = Firestore.firestore().collection("blogs").document().documentID
    
    let blog = BehaviorRelay<BlogPost?>(value: nil)
    
    private let disposeBag = DisposeBag()

    func extractDistrictName(from input: String) {
        let components = input.components(separatedBy: ". ")
        let districtName = components.count > 1 ? components[1].trimmingCharacters(in: .whitespacesAndNewlines) : input.trimmingCharacters(in: .whitespacesAndNewlines)
        let codeDistrict = districts.first(where: { $0.name == districtName })?.id
        idAddress.accept(codeDistrict)
    }
    
    func isContentBlocksValid(_ blocks: [CreateBlock]) -> Bool {
        for block in blocks {
            switch block.type {
            case .text, .heading:
                if block.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                    return false
                }
            case .image:
                if block.image == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func uploadImageAvatar(completion: @escaping () -> Void) {
        guard let image = avatarIV.value else { return }
        
        let path = "blogs/\(blogId)/gallery/\(UUID().uuidString).jpg"
        FirebaseStorageService.shared.uploadImage(image, to: path) { result in
            switch result {
            case .success(let url):
                self.avatarUrl.accept(url)
            case .failure(let error):
                print("Lỗi upload: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    func uploadImageContent(completion: @escaping () -> Void) {
        let imageBlocks = contentBlocks.value.enumerated().filter {
            if case .image = $0.element.type, $0.element.image != nil {
                return true
            }
            return false
        }

        guard !imageBlocks.isEmpty else {
            completion()
            return
        }
        let dispatchGroup = DispatchGroup()
        
        for (index, block) in imageBlocks {
//            guard case .image = block.type, let image = block.image else { continue }
            guard let image = block.image else { continue }

            dispatchGroup.enter()
            guard let userId = userId else { return }
            let path = "users/\(userId)/blogs/\(blogId)/gallery/\(UUID().uuidString).jpg"
            FirebaseStorageService.shared.uploadImage(image, to: path) { result in
                switch result {
                case .success(let url):
                    self.uploadedImageURLs[index] = url
                case .failure(let error):
                    print("Lỗi upload: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    
    func mapToContentBlocks(from blocks: [CreateBlock], uploadedImageURLs: [Int: String]) -> [ContentBlock] {
        var result: [ContentBlock] = []
        print(uploadedImageURLs)

        for (index, block) in blocks.enumerated() {
            switch block.type {
            case .heading(_):
                result.append(ContentBlock(type: .heading, value: block.text))
            case .text(_):
                result.append(ContentBlock(type: .text, value: block.text))
            case .image:
                if let imageURL = uploadedImageURLs[index] {
                    result.append(ContentBlock(type: .image, value: imageURL))
                } else {
                    print("Thiếu URL ảnh ở index \(index)")
                }
            }
        }
        return result
    }

    
    private func savePost() {
        guard
            let title = title.value,
            let placeImage = avatarUrl.value,
            let address = districts.first(where: { $0.id == idAddress.value})?.name,
            let categories = categoryId.value,
            let coordinate = coordinate.value,
            let authorId = userId,
            let authorName = userName,
            let districId = idAddress.value
        else { return }
                
        let contentBlocks = mapToContentBlocks(from: contentBlocks.value, uploadedImageURLs: uploadedImageURLs)
        
        let newPost = CreateBlogPost(
            blogId: blogId,
            title: title,
            avatarBlog: placeImage,
            address: address,
            category: categories,
            coordinates: Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude),
            authorId: authorId,
            authorName: authorName,
            authorAvatar: userAvatar,
            districId: districId,
            avgRating: 0,
            contentBlocks: contentBlocks,
            keyword: KeyWord.shared.generateAllSearchKeywords(from: title),
            createAt: Date()
        )
        
        blogService.set(newPost, withId: blogId) { [weak self] result in
            self?.isLoading.accept(false)
            switch result {
            case .success():
                self?.isSuccess.accept(true)
            case .failure(_):
                self?.isSuccess.accept(false)
            }
        }
    }
    
    func createPost() {
        self.isLoading.accept(true)
        uploadImageAvatar {
            self.uploadImageContent {
                self.savePost()
            }
        }
    }
}
