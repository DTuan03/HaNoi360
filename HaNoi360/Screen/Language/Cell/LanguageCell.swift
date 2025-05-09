//
//  LanguageCell.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

class LanguageCell: UITableViewCell {
    lazy var titleLabel = LabelFactory.createLabel(text: "Tiếng Việt",
                                                   font: .regular16)
    
    lazy var checkIV = ImageViewFactory.createImageView(tintColor: .primaryColor)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([titleLabel])
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(checkIV)
        checkIV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
        }
    }
    
    func configData(title: String, isChecked: Bool) {
        titleLabel.text = title
        checkIV.image = isChecked ? UIImage(systemName: "checkmark") : nil
    }
}
