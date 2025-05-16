
//
//  FilterDistrictCel.swift
//  HaNoi360
//
//  Created by Tuấn on 4/5/25.
//

import UIKit
import SnapKit

protocol FilterDistrictCellDelegate: AnyObject {
    func didTapChooseIV(in cell: FilterDistrictCell)
}

class FilterDistrictCell: UITableViewCell {
    lazy var nameLabel = LabelFactory.createLabel(text: "Ba Dinh", font: .medium18)
    
    lazy var chooseIv = ImageViewFactory.createImageView(image: UIImage(systemName: "circle"), tintColor: .primaryColor, contentMode: .scaleAspectFill)
    
    weak var delegate: FilterDistrictCellDelegate?
    var indexPath: IndexPath!
    
    var selectedIndex: [IndexPath] = []
    
    var isSelectedIndex: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        let chooseIvTap = UITapGestureRecognizer(target: self, action: #selector(chooseIvAction))
        chooseIv.addGestureRecognizer(chooseIvTap)
    }
    
    @objc func chooseIvAction() {
        if selectedIndex.contains(indexPath) {
            delegate?.didTapChooseIV(in: self)
            chooseIv.image = UIImage(systemName: "circle")
            if let index = selectedIndex.firstIndex(of: indexPath) {
                selectedIndex.remove(at: index)
            }
        } else {
            delegate?.didTapChooseIV(in: self)
            chooseIv.image = UIImage(systemName: "checkmark.circle.fill")
            selectedIndex.append(indexPath)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
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
    
    func configData(model: FilterDistrictModel) {
        nameLabel.text = model.name
    }
    
    func setSelectedState(_ selected: Bool) {
        UIView.animate(withDuration: 0.2) {
            if selected {
                self.chooseIv.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                self.chooseIv.image = UIImage(systemName: "circle")
            }
        }
    }
}
