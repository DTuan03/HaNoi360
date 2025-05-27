//
//  ImageCell.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import SnapKit
import Kingfisher

class DetailImageCell: UITableViewCell {
    lazy var iv = ImageViewFactory.createImageView(image: UIImage(named: "placeholderImage2"), contentMode: .scaleAspectFit)
    
    lazy var paddingView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([iv, paddingView])
        iv.layer.cornerRadius = 4
        iv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        paddingView.snp.makeConstraints { make in
            make.top.equalTo(iv.snp.bottom)
            make.bottom.equalToSuperview()
            make.right.left.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    func configure(with image: String) {
        iv.kf.setImage(with: URL(string: image))
    }
}
