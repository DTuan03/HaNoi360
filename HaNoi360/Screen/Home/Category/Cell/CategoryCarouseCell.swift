//
//  CategoryCarouseCell.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import UIKit
import SnapKit

class CategoryCarouseCell: UICollectionViewCell {
    lazy var image = ImageViewFactory.createImageView(image: .category,
                                                      contentMode: .scaleAspectFill,
                                                      radius: 8)
    
    lazy var titleLabel = LabelFactory.createLabel(text: "Trải nghiệm",
                                                   font: .medium16,
                                                   textColor: .white,
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
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        image.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.72)
            make.width.equalTo(image.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
    func configData(model: CategoryModel) {
        image.image = UIImage(named: model.img ?? "")
        titleLabel.text = model.name
    }
    
    func updateFontWeight(isCenter: Bool) {
        titleLabel.font = isCenter ? .bold16 : .medium16
    }
}
