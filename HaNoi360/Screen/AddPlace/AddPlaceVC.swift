//
//  AddPlaceVC.swift
//  HaNoi360
//
//  Created by Tuấn on 2/4/25.
//

import UIKit
import SnapKit
import CoreLocation
import Toast_Swift

enum ImagePickerSource {
    case avatar
    case subImage
}

class AddPlaceVC: BaseViewController {
    let viewModel = AddPlaceViewModel()
    
    lazy var scrollView = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor,
                                                             showsVerticalScrollIndicator: true)
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back,
                                                                                               title: "Thêm bài viết",
                                                                                               delegate: self)
    
    lazy var avatarImageView = {
        let iv = ImageViewFactory.createImageView(contentMode: .scaleAspectFill, radius: 20)
        iv.backgroundColor = .waitingImageColor
        return iv
    }()
    
    lazy var addImageBtn = {
        let btn = ButtonFactory.createButton("➕  Thêm ảnh",
                                             font: .regular16,
                                             textColor: .primaryTextColor,
                                             bgColor: .clear)
        return btn
    }()
    
    lazy var subImageView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .waitingImageColor
        return view
    }()
    
    lazy var addImageLabel = LabelFactory.createLabel(text: "Thêm ảnh",
                                                      font: .medium12,
                                                      textColor: .primaryTextColor)
    
    lazy var numberImageLabel = LabelFactory.createLabel(text: "0/5",
                                                         font: .medium12,
                                                         textColor: .primaryTextColor)
    
    lazy var subImageChooseSV = [addImageLabel, numberImageLabel].vStack(5,
                                                                         alignment: .center)
    
    lazy var containerImageScroll = {
        let sv = ScrollViewFactory.createScrollView(showsHorizontalScrollIndicator: true)
        sv.layer.cornerRadius = 10
        return sv
    }()
        
    lazy var subImageSV = [].hStack(10)
    
    lazy var selectedImages: [UIImage] = []
    
    lazy var namePlaceTF = {
        let tf = TextFieldFactory.createTextField(placeholder: "Tên địa điểm")
        tf.imageLeftView(image: UIImage(systemName: "globe.central.south.asia.fill")!)
        tf.imageDeleteRightView(image: UIImage(systemName: "multiply"))
        tf.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        return tf
    }()
    
    lazy var addressTF = {
        let tf = TextFieldFactory.createTextField(placeholder: "Địa chỉ cụ thể")
        tf.imageLeftView(image: .location)
        tf.imageDeleteRightView(image: UIImage(systemName: "multiply"))
        tf.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        return tf
    }()
    
    lazy var descriptionTV: UITextView = {
        let tv = TextViewFactory.createTextView(
            font: .regular16,
            textColor: .textTextFiledColor,
            cornerRadius: 16,
            borderWidth: 0,
            placeholder: "    Mô tả ngắn địa điểm"
        )
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        return tv
    }()

    lazy var tagBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "tag"), title: "   Thêm thẻ", tinColor: .primaryColor)
        btn.backgroundColor = .textFiledColor
        btn.layer.cornerRadius = 16
        btn.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        return btn
    }()
    
    lazy var mapBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "mappin"), title: "  Thêm địa chỉ", tinColor: .primaryColor)
        btn.backgroundColor = .textFiledColor
        btn.layer.cornerRadius = 16
        btn.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        return btn
    }()
    
    lazy var tagAndMapSV = [tagBtn, mapBtn].hStack(10, distribution: .fillEqually)
    
    lazy var clearBtn = {
        let btn = ButtonFactory.createButton("Xoá", font: .medium14, textColor: .secondaryTextColor, bgColor: .clear)
        btn.layer.cornerRadius = 30
        btn.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
//        btn.isHidden = true
        btn.setTitleColor(.clear, for: .normal)
        return btn
    }()
    
    lazy var sendBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "arrow.right"), tinColor: .white)
        btn.backgroundColor = .primaryColor
        btn.layer.cornerRadius = 25
        btn.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        return btn
    }()
    
    lazy var clearBtnAndSendBtnSV = [clearBtn, sendBtn].hStack(32, alignment: .leading, distribution: .equalSpacing)
    
    lazy var stackView = [namePlaceTF, addressTF, descriptionTV, tagAndMapSV, clearBtnAndSendBtnSV].vStack(20)
    
    var currentImagePickerSource: ImagePickerSource?
    
    var subImage: [UIImage] = []
    
    override func setupUI() {
        view.addSubviews([navigationView, scrollView])

        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubviews([avatarImageView, subImageView, containerImageScroll, stackView])
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
        avatarImageView.addSubview(addImageBtn)
        addImageBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subImageView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(100)
        }
        
        subImageView.addSubview(subImageChooseSV)
        subImageChooseSV.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        containerImageScroll.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.left.equalTo(subImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        containerImageScroll.addSubview(subImageSV)
        subImageSV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        descriptionTV.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
    
    override func setupEvent() {
        let subImageViewTap = UITapGestureRecognizer(target: self, action: #selector(subImageViewAction))
        subImageView.addGestureRecognizer(subImageViewTap)
        
        let avatarViewTap = UITapGestureRecognizer(target: self, action: #selector(avatarViewAction))
        avatarImageView.addGestureRecognizer(avatarViewTap)
        
        mapBtn.rx.tap
            .subscribe(onNext: {
                let mapVC = MapVC()
                mapVC.delegate = self
                self.navigationController?.pushViewController(mapVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        tagBtn.rx.tap
            .subscribe(onNext: {
                let categoryVC = AddCategoryVC()
                categoryVC.modalTransitionStyle = .coverVertical
                categoryVC.modalPresentationStyle = .overCurrentContext
                categoryVC.delegate = self
                self.present(categoryVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        sendBtn.rx.tap
            .subscribe(onNext: {
                let vc = LoadingVC()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
                self.viewModel.addPlace()
            })
            .disposed(by: disposeBag)
    }
    
    override func bindState() {
        viewModel.bindState()
        namePlaceTF.rx.text.orEmpty
            .subscribe(onNext: { text in
                self.viewModel.name.accept(text)
            })
            .disposed(by: disposeBag)
        
        addressTF.rx.text.orEmpty
            .subscribe(onNext: { text in
                self.viewModel.addressDetail.accept(text)
            })
            .disposed(by: disposeBag)
        
        namePlaceTF.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)

        addressTF.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        descriptionTV.rx.text.orEmpty
            .subscribe(onNext: { text in
                self.viewModel.descriptionPlace.accept(text)
            })
            .disposed(by: disposeBag)
        
        viewModel.isEnabled
            .bind(to: sendBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isEnabled
            .subscribe(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.sendBtn.backgroundColor = isEnabled ? .primaryColor : .lightGray
            })
            .disposed(by: disposeBag)
        
        viewModel.isSuccess
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("show pop up")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: {_ in 
                self.dismiss(animated: false)
            }).disposed(by: disposeBag)
    }
    
    @objc func avatarViewAction() {
        currentImagePickerSource = .avatar
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc func subImageViewAction() {
        if selectedImages.count < 5 {
            subImageView.isUserInteractionEnabled = true
            currentImagePickerSource = .subImage
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true)
        } else {
            subImageView.isUserInteractionEnabled = false
        }
    }
}

extension AddPlaceVC: CategoryDelegate {
    func didSelected(_ data: [String]) {
        tagBtn.setTitle("   Đã chọn", for: .normal)
        viewModel.category.accept(data)
    }
}

extension AddPlaceVC: MapVCDelegate {
    func didMaped(district: String, coordinate: CLLocationCoordinate2D) {
        self.mapBtn.setTitle(district, for: .normal)
        viewModel.coordinate.accept(coordinate)
        viewModel.extractDistrictName(from: district)
    }
}

extension AddPlaceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch currentImagePickerSource {
        case .avatar:
            if let image = info[.originalImage] as? UIImage {
                addImageBtn.isHidden = true
                avatarImageView.image = image
                viewModel.placeImage.accept(avatarImageView.image)
                picker.dismiss(animated: true)
            }
        case .subImage:
            if let image = info[.originalImage] as? UIImage {
                addSubImage(image)
                subImage.append(image)
            }
            viewModel.subPlaceImage.accept(subImage)
            numberImageLabel.text = "\(selectedImages.count)/5"
            picker.dismiss(animated: true)
        default:
            return
        }
    }
    
    func addSubImage(_ image: UIImage) {
        selectedImages.append(image)
        
        let containerView = UIView()
        
        let imageView = ImageViewFactory.createImageView(image: image, contentMode: .scaleAspectFill ,radius: 10)
        let deleteBtn = ButtonFactory.createButton("×", font: .medium16, bgColor: .lightGray, rounded: false, height: 20)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        
        containerView.addSubviews([imageView, deleteBtn])
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(20)
        }
        
        subImageSV.addArrangedSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
    }
    
    @objc func deleteBtnAction(_ sender: UIButton) {
        guard let containerView = sender.superview else { return}
        
        if let index = subImageSV.arrangedSubviews.firstIndex(of: containerView) {
            selectedImages.remove(at: index)
            subImage.remove(at: index)
        }
        viewModel.subPlaceImage.accept(subImage)

        UIView.animate(withDuration: 0.3, animations: {
            containerView.alpha = 0
        }) { _ in
            self.numberImageLabel.text = "\(self.selectedImages.count)/5"
            self.subImageSV.removeArrangedSubviews(containerView)
            containerView.removeFromSuperview()
        }
    }
}

extension AddPlaceVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
