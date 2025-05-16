//
//  FilterCell.swift
//  HaNoi360
//
//  Created by Tuấn on 3/5/25.
//

import UIKit
import SnapKit

class FilterCell: UICollectionViewCell {
    
    lazy var titleLabel = LabelFactory.createLabel(font: .regular16,
                                                   textColor: .black,
                                                   numberOfLines: 1,
                                                   textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.layer.borderColor = UIColor(hex: "#6B7280").cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 21
        contentView.layer.masksToBounds = true
        contentView.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    func configData(model: CategoryModel, isSelected: Bool) {
        titleLabel.text = model.name
        if isSelected {
            contentView.layer.borderColor = UIColor.white.cgColor
            contentView.backgroundColor = .primaryColor
            titleLabel.textColor = .white
            titleLabel.font = UIFont.medium16
        } else {
            contentView.layer.borderColor = UIColor(hex: "#6B7280").cgColor
            contentView.backgroundColor = .clear
            titleLabel.textColor = .black
            titleLabel.font = UIFont.regular16
        }
    }
}
