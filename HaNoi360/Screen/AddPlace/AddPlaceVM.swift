//
//  AddPlaceViewModel.swift
//  HaNoi360
//
//  Created by Tuấn on 15/4/25.
//

import RxSwift
import RxCocoa
import UIKit
import CoreLocation
import FirebaseFirestore

class AddPlaceVM {
    var placeImage = BehaviorRelay<UIImage?>(value: nil)
    var subPlaceImage = BehaviorRelay<[UIImage]?>(value: nil)
    var name = BehaviorRelay<String?>(value: nil)
    var addressDetail = BehaviorRelay<String?>(value: nil)
    var descriptionPlace = BehaviorRelay<String?>(value: nil)
    var category = BehaviorRelay<[String]?>(value: nil)
    var coordinate = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    var idAddress = BehaviorRelay<String?>(value: nil)
    
    var urlAvatar = BehaviorRelay<String?>(value: nil)
    var urlSubImage = BehaviorRelay<[String]?>(value: nil)
    var isAvatarUploaded = BehaviorRelay<Bool>(value: false)
    var isSubImageUploaded = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    var isEnabled = BehaviorRelay<Bool>(value: false)
    var isSuccess = PublishRelay<Bool>()
    var isLoading = PublishRelay<Bool>()
    
    let placeService = BaseFirestoreService<AddPlaceModel>(collectionPath: "places")
    
    let userId = UserDefaults.standard.string(forKey: "userId")
    let userName = UserDefaults.standard.string(forKey: "userName")
    
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
    
    func bindState() {
        let inputs = Observable.combineLatest(
            placeImage, subPlaceImage, name, addressDetail, descriptionPlace, category, coordinate
        )
        
        let isFormValid = inputs.map { (placeImage, subPlaceImage, name, addressDetail, descriptionPlace, category, coordinate) in
            return placeImage != nil &&
            subPlaceImage != nil &&
            name != nil &&
            addressDetail != nil &&
            descriptionPlace != nil &&
            category != nil &&
            coordinate != nil
        }
        
        isFormValid
            .bind(to: isEnabled)
            .disposed(by: disposeBag)
    }
    
    func uploadAvatar() {
        guard let image = placeImage.value else { return }
        CloudinaryService.shared.uploadImage(image: image) { result in
            switch result {
            case .success(let url):
                self.urlAvatar.accept(url)
                self.isAvatarUploaded.accept(true)
            case .failure(let error):
                print("Lỗi upload: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadSubImages() {
        guard let images = subPlaceImage.value else { return }
        CloudinaryService.shared.uploadImages(images: images) { result in
            switch result {
            case .success(let url):
                self.urlSubImage.accept(url)
                self.isSubImageUploaded.accept(true)
            case .failure(let error):
                print("Lỗi upload: \(error.localizedDescription)")
            }
        }
    }
    
    func extractDistrictName(from input: String) {
        let components = input.components(separatedBy: ". ")
        let districtName = components.count > 1 ? components[1].trimmingCharacters(in: .whitespacesAndNewlines) : input.trimmingCharacters(in: .whitespacesAndNewlines)
        let codeDistrict = districts.first(where: { $0.name == districtName })?.id
        idAddress.accept(codeDistrict)
    }
    
    func addPlace() {
        uploadAvatar()
        uploadSubImages()
        
        Observable.combineLatest(isAvatarUploaded, isSubImageUploaded)
            .filter { $0 && $1 }
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _, _ in
                self?.savePlace()
            })
            .disposed(by: disposeBag)
    }
    
    private func savePlace() {
        guard
            let coordinate = coordinate.value,
            let userId = userId,
            let userName = userName,
            let avatar = urlAvatar.value,
            let subImages = urlSubImage.value,
            let name = name.value,
            let address = addressDetail.value,
            let description = descriptionPlace.value,
            let categories = category.value,
            let idAddress = idAddress.value
        else { return }
        
        let id = Firestore.firestore().collection("places").document().documentID
        let newPlace = AddPlaceModel(
            placeId: id,
            placeImage: avatar,
            subPlaceImage: subImages,
            name: name,
            description: description,
            address: address,
            category: categories,
            coordinates: Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude),
            authorId: userId,
            authorName: userName,
            districId: idAddress,
            avgRating: 0,
            totalReviews: 0,
            keyword: KeyWord.shared.generateAllSearchKeywords(from: name)
        )
        
        placeService.set(newPlace, withId: id) { [weak self] result in
            self?.isLoading.accept(true)
            switch result {
            case .success():
                self?.isSuccess.accept(true)
            case .failure(let error):
                self?.isLoading.accept(false)
                self?.isSuccess.accept(false)
            }
        }
    }
}
