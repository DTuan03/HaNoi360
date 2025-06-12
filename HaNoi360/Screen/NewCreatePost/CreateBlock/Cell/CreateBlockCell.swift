//
//  CreateBlockCell.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import SnapKit

protocol CreateBlockCellDelegate: AnyObject {
    func didTapChooseIV(indexPath: IndexPath?)
}

class CreateBlockCell: UITableViewCell {
    lazy var nameLabel = LabelFactory.createLabel(text: "Tiêu đề", font: .medium18)
    
    lazy var chooseIv = ImageViewFactory.createImageView(image: UIImage(systemName: "circle"), tintColor: .primaryColor, contentMode: .scaleAspectFill)
    
    weak var delegate: CreateBlockCellDelegate?
    var indexPath: IndexPath!
    
    var selectedIndex: IndexPath?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        let chooseIvTap = UITapGestureRecognizer(target: self, action: #selector(chooseIvAction))
        chooseIv.addGestureRecognizer(chooseIvTap)
    }
    
    @objc func chooseIvAction() {
        delegate?.didTapChooseIV(indexPath: indexPath)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        contentView.addSubviews([nameLabel, chooseIv])
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chooseIv.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.bottom.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    func configData(model: CreateBlockModel, isSelected: Bool) {
        nameLabel.text = model.name
        chooseIv.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
    }
}
