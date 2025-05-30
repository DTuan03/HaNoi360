//
//  ProfileCell.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

class ProfileCell: UITableViewCell {
    lazy var titleLabel = LabelFactory.createLabel(text: "Ho ten", font: .medium16)
    
    lazy var textField = {
        let tx = UITextField()
        tx.textAlignment = .right
        tx.font = .regular16
        tx.textColor = .primaryTextColor
        tx.text = "Thinh Minh Lan"
        return tx
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([titleLabel, textField])
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.centerY.equalToSuperview().offset(2)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(4)
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    func configData(title: String) {
        titleLabel.text = title
    }
}
