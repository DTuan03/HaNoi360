//
//  CategoryCell.swift
//  HaNoi360
//
//  Created by Tuấn on 13/4/25.
//

import UIKit
import SnapKit

protocol CategoryAddPlaceCellDelegate: AnyObject {
    func didTapChooseIV(indexPath: IndexPath, isSelectedIndex: Bool)
}

class CategoryAddPlaceCell: UITableViewCell {
    lazy var nameLabel = LabelFactory.createLabel(text: "Ẩm thực", font: .medium18)
    
    lazy var chooseIv = ImageViewFactory.createImageView(image: UIImage(systemName: "circle"), tintColor: .primaryColor, contentMode: .scaleAspectFill)
    
    weak var delegate: CategoryAddPlaceCellDelegate?
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
            delegate?.didTapChooseIV(indexPath: indexPath, isSelectedIndex: true)
            chooseIv.image = UIImage(systemName: "circle")
            if let index = selectedIndex.firstIndex(of: indexPath) {
                selectedIndex.remove(at: index)
            }
        } else {
            delegate?.didTapChooseIV(indexPath: indexPath, isSelectedIndex: false)
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
    
    func configData(model: CategoryModel) {
        nameLabel.text = model.name
    }
}
