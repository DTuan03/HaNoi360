//
//  PlaceCell.swift
//  HaNoi360
//
//  Created by Tuấn on 3/4/25.
//

import UIKit
import Kingfisher
import SkeletonView

class PlaceCell: UICollectionViewCell {
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#F3F4F6").cgColor
        return view
    }()
    
    lazy var imageView = ImageViewFactory.createImageView(contentMode: .scaleAspectFill,
                                                          radius: 8)
    
    lazy var nameLabel = LabelFactory.createLabel(font: .bold20,
                                                  numberOfLines: 1)
    
    lazy var addressLabel = LabelFactory.createLabel(font: .light16,
                                                     numberOfLines: 1)
    
    lazy var nameAndAddressSV = [nameLabel, addressLabel].vStack(4)
    
    lazy var starIv = ImageViewFactory.createImageView()
    
    lazy var avgReviewLabel = LabelFactory.createLabel(font: .regular16)
    
    lazy var starAndAvgReviewSV = [starIv, avgReviewLabel].hStack(6)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        
        containerView.isSkeletonable = true
        containerView.clipsToBounds = true
        
        imageView.isSkeletonable = true
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        nameLabel.isSkeletonable = true
        nameLabel.linesCornerRadius = 4
        
        addressLabel.isSkeletonable = true
        addressLabel.linesCornerRadius = 4
        
        avgReviewLabel.isSkeletonable = true
        avgReviewLabel.linesCornerRadius = 4
        
        starIv.isSkeletonable = true
        starIv.layer.cornerRadius = 6
        starIv.clipsToBounds = true
        
        nameAndAddressSV.isSkeletonable = true
        starAndAvgReviewSV.isSkeletonable = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(1)
        }
        containerView.addSubviews([imageView, nameAndAddressSV, starAndAvgReviewSV])
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(containerView.snp.height).multipliedBy(0.72)
        }
        
        nameAndAddressSV.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        starAndAvgReviewSV.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    func configure(model: PlaceModel) {
        imageView.kf.setImage(with: URL(string: model.placeImage))
        starIv.image = .star
        nameLabel.text = model.name
        addressLabel.text = model.address
        avgReviewLabel.text = String(model.avgRating)
    }
}
