//
//  AlbumCell.swift
//  HaNoi360
//
//  Created by Tuấn on 4/6/25.
//

import UIKit
import Kingfisher

class AlbumImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 0
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
