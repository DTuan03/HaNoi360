//
//  ProfileCell.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

class AccountCell: UITableViewCell {
    lazy var iconIV = ImageViewFactory.createImageView()
    lazy var titleLabel = LabelFactory.createLabel(font: .medium16)
    lazy var nextIV = ImageViewFactory.createImageView()
    
    lazy var separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F3F4F6")
        return view
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
        contentView.addSubviews([iconIV, titleLabel, nextIV, separatorView])
        
        iconIV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
        
        nextIV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
        }
    }
    
    func configData(accountModel: AccountModel) {
        iconIV.image = UIImage(named: accountModel.icon ?? "")
        titleLabel.text = accountModel.title
        nextIV.image = UIImage(named: accountModel.nextIcon)
    }
}
