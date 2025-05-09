//
//  CalendarCell.swift
//  HaNoi360
//
//  Created by Tuấn on 7/4/25.
//

import UIKit
import SnapKit
import Kingfisher

class CalendarCell: UITableViewCell {
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .tableViewCellColor
//        view.layer.cornerRadius = 8
        return view
    }()
        
    lazy var placeIV = ImageViewFactory.createImageView(image: .intro1, radius: 8)
    
    lazy var iconIV = ImageViewFactory.createImageView(image: UIImage(systemName: "calendar"), tintColor: .secondaryTextColor)
    
    lazy var calendarLabel = LabelFactory.createLabel(text: "07 tháng 4 2025", font: .regular12, textColor: .secondaryTextColor)
    
    lazy var firstSV = [iconIV, calendarLabel].hStack(4)
    
    lazy var namePlaceLabel = LabelFactory.createLabel(text: "Ho Tay", font: .medium14, textColor: .primaryTextColor)
    
    lazy var addressLabel = LabelFactory.createLabel(text: "Ho Tay, Ha Noi", font: .light12, textColor: .secondaryTextColor)
    
    lazy var stackView = [namePlaceLabel, addressLabel].vStack(4)
    
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
        
        containerView.addSubviews([placeIV, firstSV, stackView])
        placeIV.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        firstSV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalTo(placeIV.snp.right).offset(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(firstSV.snp.bottom).offset(8)
            make.left.equalTo(placeIV.snp.right).offset(24)
        }
    }
    
    func configDate(model: AddCalendarModel) {
        placeIV.kf.setImage(with: URL(string: model.placeImage))
        calendarLabel.text = model.createAt.toString()
        namePlaceLabel.text = model.name
        addressLabel.text = model.address
    }
}
