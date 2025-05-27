//
//  HeadingCell.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import SnapKit

class DetailHeadingCell: UITableViewCell {
    lazy var tf = {
        let tf = TextFieldFactory.createTextField(placeholder: "Nhập tiêu đề", font: .medium16, bgColor: .clear, rounded: 8)
//        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
//        tf.rightViewMode = .always
//        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
//        tf.leftViewMode = .always
        tf.isEnabled = false
        return tf
    }()
    
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
        
        tf.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        paddingView.snp.makeConstraints { make in
            make.top.equalTo(tf.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    func configure(with text: String) {
        tf.text = "     " + text
    }
}
