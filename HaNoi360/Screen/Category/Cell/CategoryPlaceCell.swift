//
//  CategoryPlaceCell.swift
//  HaNoi360
//
//  Created by Tuấn on 30/4/25.
//

import UIKit
import SnapKit

class CategoryPlaceCell: UITableViewCell {
    lazy var containerView = {
        let view = UIView()
        return view
    }()
        
    lazy var placeIV = ImageViewFactory.createImageView(image: .test, contentMode: .scaleAspectFill, radius: 12)
    
    lazy var namePlaceLabel = LabelFactory.createLabel(text: "Ho Tay", font: .medium16, textColor: .primaryTextColor)
    
    lazy var addressLabel = LabelFactory.createLabel(text: "Ho Tay, Ha Noi", font: .light14, textColor: .secondaryTextColor)
    
    lazy var starIconIV = ImageViewFactory.createImageView(image: .star)
    
    lazy var favoriteIconIV = ImageViewFactory.createImageView(image: UIImage(systemName: "heart"), tintColor: .white)
    
    lazy var avgStarLabel = LabelFactory.createLabel(text: "4.0", font: .regular16)
    
    lazy var starAndAvgStarSV = [starIconIV, avgStarLabel].hStack(6, alignment: .center)
    
    lazy var stackView = [addressLabel, starAndAvgStarSV].vStack(4)
    
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
        
        containerView.addSubviews([placeIV, namePlaceLabel, stackView])
        placeIV.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(110)
        }
        
        namePlaceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(placeIV.snp.right).offset(24)
            make.right.equalToSuperview().inset(8)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(namePlaceLabel.snp.bottom).offset(8)
            make.left.equalTo(placeIV.snp.right).offset(24)
            make.right.equalToSuperview().inset(8)
        }
        
        placeIV.addSubview(favoriteIconIV)
        favoriteIconIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(8)
            make.height.width.equalTo(24)
        }
    }
    
    func configData(model: DetailModel) {
        placeIV.kf.setImage(with: URL(string: model.placeImage ?? ""))
        namePlaceLabel.text = model.name
        addressLabel.text = model.address
        avgStarLabel.text = String(model.avgRating ?? 0)
    }
}
