//
//  SearchCell.swift
//  HaNoi360
//
//  Created by Tuấn on 29/5/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchCell: UITableViewCell {
    lazy var containerView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var timeIv = ImageViewFactory.createImageView(image: UIImage(systemName: "clock"), tintColor: .black)
            
    lazy var textSearchLb = LabelFactory.createLabel(text: "Ho Tay", font: .regular15, textColor: .primaryTextColor, numberOfLines: 1)
        
    lazy var closeIv = ImageViewFactory.createImageView(image: UIImage(systemName: "xmark"), tintColor: .black)
    
    var onDelete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
//        self.layer.cornerRadius = 8
        setupUI()
        setupEvent()
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
        
        containerView.addSubviews([timeIv, textSearchLb, closeIv])
        timeIv.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        textSearchLb.snp.makeConstraints { make in
            make.left.equalTo(timeIv.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        closeIv.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.width.equalTo(20)
        }
    }
    
    func setupEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeIvAction))
        closeIv.addGestureRecognizer(tap)
    }
    
    @objc func closeIvAction() {
        onDelete?()
    }
    
    func configData(model: SearchModel) {
        textSearchLb.text = model.textSearch
    }
}
