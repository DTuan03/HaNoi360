//
//  FullImageVC.swift
//  HaNoi360
//
//  Created by Tuấn on 26/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FullImageVC: BaseVC {
    lazy var backView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        let iv = ImageViewFactory.createImageView(image: UIImage(systemName: "chevron.backward"), tintColor: .iconColor)
        view.addSubview(iv)
        iv.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    
    lazy var saveView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        let iv = ImageViewFactory.createImageView(image: UIImage(systemName: "square.and.arrow.down"), tintColor: .iconColor)
        view.addSubview(iv)
        iv.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    
    lazy var imageView = ImageViewFactory.createImageView(contentMode: .scaleAspectFit)
    
    override func setupUI() {
        view.addSubviews([imageView, backView, saveView])
        backView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(8)
            make.height.width.equalTo(40)
        }
        backView.layer.cornerRadius = 20
        backView.clipsToBounds = true
        
        saveView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().inset(8)
            make.height.width.equalTo(40)
        }
        saveView.layer.cornerRadius = 20
        saveView.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupEvent() {
        let backViewTap = UITapGestureRecognizer(target: self, action: #selector(backViewAction))
        backView.addGestureRecognizer(backViewTap)

        let saveViewTap = UITapGestureRecognizer(target: self, action: #selector(saveViewAction))
        saveView.addGestureRecognizer(saveViewTap)
    }
    
    @objc func backViewAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveViewAction() {
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            Toast.showToast(message: "image.save.failed".localized, image: "toast_error")
        } else {
            Toast.showToast(message: "image.save.success".localized, image: "toast_success")
        }
    }

}
