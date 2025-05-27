//
//  ImageCell.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import SnapKit

class ImageCell: UITableViewCell {
    lazy var iv = ImageViewFactory.createImageView(image: UIImage(named: "placeholderImage2"), contentMode: .scaleAspectFill)
    
    lazy var paddingView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var onImagePicked: ((UIImage) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        setupUI()
        setupEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([iv, paddingView])
        iv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        paddingView.snp.makeConstraints { make in
            make.top.equalTo(iv.snp.bottom)
            make.bottom.equalToSuperview()

            make.right.left.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    func configure(with image: UIImage) {
        iv.image = image
    }
    
    func setupEvent() {
        let ivTap = UITapGestureRecognizer(target: self, action: #selector(ivAction))
        iv.addGestureRecognizer(ivTap)
    }
    
    @objc func ivAction() {
        ImagePickerHelper.pickImage { [weak self] image in
            guard let self = self, let image = image else { return }
            self.iv.image = image
            self.onImagePicked?(image)
        }
    }
}
