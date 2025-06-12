//
//  CheckInImageCell.swift
//  HaNoi360
//
//  Created by Tuấn on 4/6/25.
//
import UIKit
import Kingfisher

class CheckInImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func setImage(urlString: String?) {
        if let urlStr = urlString, let url = URL(string: urlStr) {
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CheckInHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .primaryTextColor
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
