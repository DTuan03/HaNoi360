//
//  ProfileCell.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

protocol ProfileCellDelegate: AnyObject {
    func didTapEdit(in cell: ProfileCell)
}

class ProfileCell: UITableViewCell {
    lazy var titleLabel = LabelFactory.createLabel(text: "Ho ten", font: .regular12, textColor: .secondaryTextColor)
    
    lazy var valueLabel = LabelFactory.createLabel(text: "Dang Anh Tuan", font: .medium14)
    
    lazy var editLabel = LabelFactory.createLabel(text: "Chỉnh sửa", font: .regular12, textColor: UIColor(hex: "#3366FF"))
    
    weak var delegate: ProfileCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        setupUI()
        setupEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        contentView.addSubviews([titleLabel, valueLabel, editLabel])
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.top.equalToSuperview().offset(8)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(24)
        }
        
        editLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalToSuperview().inset(4)
        }
    }
    
    func setupEvent() {
        let editLabelTap = UITapGestureRecognizer(target: self, action: #selector(editLabelAction))
        editLabel.addGestureRecognizer(editLabelTap)
    }
    
    @objc func editLabelAction() {
        delegate?.didTapEdit(in: self)
    }
    
    func configData(title: String, index: Int, model: ProfileModel) {
        titleLabel.text = title
        
        switch index {
            case 0:
                valueLabel.text = model.name
            case 1:
                valueLabel.text = model.email
            case 2:
                valueLabel.text = model.phone ?? "Chưa có giá trị"
            case 3:
                valueLabel.text = model.interest
            case 4:
                valueLabel.text = model.date
            case 5:
                valueLabel.text = model.address
            default:
                valueLabel.text = ""
            }
    }
}
