//
//  CategoryCell.swift
//  HaNoi360
//
//  Created by Tuấn on 3/4/25.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    lazy var image = ImageViewFactory.createImageView(image: .category,
                                                      contentMode: .scaleAspectFill,
                                                      radius: 8)
    
    lazy var titleLabel = LabelFactory.createLabel(text: "Ẩm thực",
                                                   font: .medium14,
                                                   textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([image, titleLabel])
        image.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.72)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
    func configData(model: CategoryModel) {
        image.image = UIImage(named: model.img ?? "")
        titleLabel.text = model.name ?? ""
    }
}
