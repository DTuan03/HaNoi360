//
//  NotiCell.swift
//  HaNoi360
//
//  Created by Tuấn on 14/6/25.
//

import UIKit
import SnapKit
import Kingfisher

class NotiCell: UITableViewCell {
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .tableViewCellColor
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.boderColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
        
    lazy var iv = ImageViewFactory.createImageView(image: .notiDetail, tintColor: .blue, contentMode: .scaleAspectFit, radius: 8)
    
    lazy var iconIV = ImageViewFactory.createImageView(image: UIImage(systemName: "calendar"), tintColor: .secondaryTextColor)
    
    lazy var timeLb = LabelFactory.createLabel(text: "07 tháng 4 2025", font: .regular12, textColor: .secondaryTextColor)
    
    lazy var firstSV = [iconIV, timeLb].hStack(4)
    
    lazy var titleLb = LabelFactory.createLabel(text: "Ho Tay", font: .medium14, textColor: .primaryTextColor, numberOfLines: 1)
    
    lazy var contentLb = LabelFactory.createLabel(text: "Ho Tay, Ha Noi", font: .light14, textColor: .secondaryTextColor, numberOfLines: 1)
    
    lazy var stackView = [titleLb, contentLb].vStack(4)
    
    lazy var isRead = ImageViewFactory.createImageView(image: UIImage(systemName: "circle.fill"), tintColor: .red)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubviews([iv, firstSV, stackView, isRead])
        iv.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        firstSV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalTo(iv.snp.right).offset(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(firstSV.snp.bottom).offset(8)
            make.left.equalTo(iv.snp.right).offset(24)
            make.right.equalToSuperview().inset(4)
        }
        
        isRead.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(16)
        }
    }
    
    func configDate(model: NotificationModel) {
        timeLb.text = model.createdAt!.toString()
        titleLb.text = "account.noti".localized
        contentLb.text = model.message
        isRead.isHidden = model.isRead!
    }
}
