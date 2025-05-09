//
//  NameDistrictCell.swift
//  HaNoi360
//
//  Created by Tuấn on 3/4/25.
//

import UIKit
import SnapKit

class NameDistrictCell: UICollectionViewCell {
    
    lazy var nameLabel = LabelFactory.createLabel(font: .regular16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configData(model: District, indexPath: IndexPath, selectedItem: IndexPath) {
        nameLabel.text = model.name
        if indexPath.row == selectedItem.row {
            nameLabel.textColor = .primaryColor
            nameLabel.font = .medium16
        } else {
            nameLabel.textColor = .primaryTextColor
            nameLabel.font = .regular16
        }
    }
}
