//
//  MyProfileCell.swift
//  HaNoi360
//
//  Created by Tuấn on 28/5/25.
//

import UIKit
import Kingfisher

class MyProfileCell: UITableViewCell {
    
    lazy var avatarIv = ImageViewFactory.createImageView(image: .test, contentMode: .scaleAspectFill, radius: 30)

    lazy var nameLb = LabelFactory.createLabel(text: "Đặng Anh Tuấn", font: .bold18, textColor: .black)

    lazy var timeLb = LabelFactory.createLabel(text: "4h", font: .regular16, textColor: UIColor(hex: "#808080"))
    
    lazy var infoSv = [avatarIv, [nameLb, timeLb].vStack(2)].hStack(6, alignment: .center)
    
    lazy var titleLb = LabelFactory.createLabel(text: "Kinh Nghiệm Du Lịch TP HCM Tự Túc Mới Nhất", font: .bold16)
    
    lazy var descriptionLb = LabelFactory.createLabel(text: "Sài Gòn là thành phố của những chuyển động, sự sôi nổi, sầm uất bậc nhất cả nước, đan xen một chút cổ kính, một chút châu Âu.", font: .regular14, numberOfLines: 2)
    
    lazy var avatarPlaceIv = ImageViewFactory.createImageView(image: UIImage(named: "placeholderImage2"), contentMode: .scaleAspectFit)
    
    lazy var lineView = UIViewFactory.createLineView(height: 3, bgColor: UIColor(hex: "#F1F1F1"))
    
    lazy var stv = [infoSv, titleLb, descriptionLb, avatarPlaceIv].vStack(6)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([stv, lineView])
        
        avatarIv.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        avatarPlaceIv.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.left.right.equalToSuperview()
        }
        
        stv.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(stv.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configData(model: BlogPost) {
        avatarIv.kf.setImage(with: URL(string: model.authorAvatar ?? ""))
        avatarPlaceIv.kf.setImage(with: URL(string: model.placeImage ?? ""))
        titleLb.text = model.title
        timeLb.text = model.createAt?.displayRelativeTime()
        if let firstDescription = model.contentBlocks.first(where: { $0.type.rawValue == "text"}) {
            descriptionLb.text = firstDescription.value
        }
    }
}
