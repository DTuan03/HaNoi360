//
//  FavoriteCell.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit
import Kingfisher

class FavoriteCell: UITableViewCell {
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .tableViewCellColor
//        view.layer.cornerRadius = 8
        return view
    }()
        
    lazy var placeIV = ImageViewFactory.createImageView(image: .intro1, radius: 8)
    
    lazy var namePlaceLabel = LabelFactory.createLabel(text: "Ho Tay", font: .medium14, textColor: .primaryTextColor, numberOfLines: 1)
    
    lazy var addressLabel = LabelFactory.createLabel(text: "Ho Tay, Ha Noi", font: .light12, textColor: .secondaryTextColor, numberOfLines: 1)
    
    lazy var starIconIV = ImageViewFactory.createImageView(image: .star)
    
    lazy var favoriteIconIV = ImageViewFactory.createImageView(image: UIImage(systemName: "heart.circle.fill"), tintColor: UIColor(hex: "#EF4444"))
    
    lazy var avgStarLabel = LabelFactory.createLabel(text: "4.0", font: .regular14)
    
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
        
        containerView.addSubviews([placeIV, namePlaceLabel, stackView, favoriteIconIV])
        placeIV.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        namePlaceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(placeIV.snp.right).offset(24)
            make.right.equalToSuperview().inset(48)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(namePlaceLabel.snp.bottom).offset(8)
            make.left.equalTo(placeIV.snp.right).offset(24)
            make.right.equalToSuperview().inset(48)
        }
        
        favoriteIconIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(24)
        }
    }
    
    func configData(model: FavoriteModel) {
        placeIV.kf.setImage(with: URL(string: model.placeImage ?? ""))
        namePlaceLabel.text = model.name
        addressLabel.text = model.address
        avgStarLabel.text = String(model.avgRating ?? 0)
    }
}
