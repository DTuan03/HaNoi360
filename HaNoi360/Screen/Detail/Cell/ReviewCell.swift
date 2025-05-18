//
//  ReviewCell.swift
//  HaNoi360
//
//  Created by Tuấn on 10/4/25.
//

import UIKit
import SnapKit

class ReviewCell: UITableViewCell {
    lazy var avatarIV = ImageViewFactory.createImageView(image: .test, contentMode: .scaleAspectFill, radius: 25)
    
    lazy var nameLabel = LabelFactory.createLabel(text: "Thinh Minh Lan", font: .medium16)
    
    lazy var sv1 = [avatarIV, nameLabel].hStack(8)
    
    lazy var reportIconIV = ImageViewFactory.createImageView(image: .ellipsisVertical)
    
    lazy var starReview = CosmosViewFactory.createCosmosView(updateOnTouch: false)

    lazy var contentReviewLabel = LabelFactory.createLabel(text: "We went to Rara Lake from our college as a tour. Initially, I was in doubt whether I should visit there or not as it's very far from Kathmandu. I eventually decided to visit Rara lake and believe me, it was the best experience of my lifetime. It took 3 days for us to reach there.", font: .regular14)
    
    lazy var sv = [sv1, starReview, contentReviewLabel].vStack(8)
    
    lazy var reportBtn = {
        let btn = ButtonFactory.createButton("Báo cáo", font: .regular14, textColor: .primaryTextColor, bgColor: .backgroundColor, rounded: false, height: 30)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 6
        btn.isHidden = true
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        let reportIconIVTap = UITapGestureRecognizer(target: self, action: #selector(reportIconIVAction))
        reportIconIV.addGestureRecognizer(reportIconIVTap)
        let reportBtnTap = UITapGestureRecognizer(target: self, action: #selector(reportBtnAction))
        self.addGestureRecognizer(reportBtnTap)
    }
    
    @objc func reportIconIVAction() {
        reportBtn.isHidden = false
    }
    
    @objc func reportBtnAction() {
        reportBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([sv, reportIconIV, reportBtn])
        avatarIV.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        sv.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
        }
        
        reportIconIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview()
        }
        
        reportBtn.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.top.equalTo(reportIconIV.snp.bottom)
            make.right.equalTo(reportIconIV.snp.left).inset(4)
        }
    }
}
