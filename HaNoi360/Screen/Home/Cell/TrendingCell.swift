//
//  TrendingCell.swift
//  HaNoi360
//
//  Created by Tuấn on 3/4/25.
//

import UIKit
import SnapKit
import Kingfisher

class TrendingCell: UICollectionViewCell {
    lazy var image = ImageViewFactory.createImageView(image: .intro2,
                                                      contentMode: .scaleAspectFill,
                                                      radius: 8)
    lazy var view = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.6)
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var nameLabel = LabelFactory.createLabel(text: "Ẩm thực",
                                                   font: .medium16,
                                                  textColor: UIColor(hex: "#FFF7ED"),
                                                  numberOfLines: 1)
    
    lazy var starIv = ImageViewFactory.createImageView(image: .star)
    
    lazy var avgReviewLabel = LabelFactory.createLabel(text: "0.0",
                                                       font: .regular12,
                                                       textColor:  .white)
    
    lazy var stackView = [starIv, avgReviewLabel].hStack(6)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([image, view])
        image.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(image.snp.width)
        }
        
        view.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        
        view.addSubviews([nameLabel ,stackView])
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(48)
        }
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
        }
    }
    
    func configData(model: PlaceModel) {
        image.kf.setImage(with: URL(string: model.placeImage))
        nameLabel.text = model.name
        avgReviewLabel.text = String(model.avgRating)
    }
}
