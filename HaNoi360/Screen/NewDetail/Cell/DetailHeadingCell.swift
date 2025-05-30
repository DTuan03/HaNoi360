//
//  HeadingCell.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import SnapKit

class DetailHeadingCell: UITableViewCell {
//    lazy var tf = {
//        let tf = TextFieldFactory.createTextField(placeholder: "Nhập tiêu đề", font: .medium16, bgColor: .clear, rounded: 8)
//        tf.isEnabled = false
//        return tf
//    }()
    
    lazy var tf = TextViewFactory.createTextView(font: .medium16, textAlignment: .justified, backgroundColor: .clear, borderWidth: 0, placeholder: "Nhập đoạn văn")
    
    lazy var paddingView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([tf, paddingView])
        tf.isScrollEnabled = false
        tf.isUserInteractionEnabled = false
        tf.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
//        paddingView.snp.makeConstraints { make in
//            make.top.equalTo(tf.snp.bottom)
//            make.right.left.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.height.equalTo(8)
//        }
    }
    
    func configure(with text: String, count: Int) {
        tf.text = "\(count). " + text
    }
}
