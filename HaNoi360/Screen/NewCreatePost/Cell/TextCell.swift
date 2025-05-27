//
//  TextCell.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import SnapKit

class TextCell: UITableViewCell, UITextViewDelegate {
    lazy var tv = TextViewFactory.createTextView(placeholder: "Nhập đoạn văn")
    
    lazy var paddingView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var onTextChanged: ((String) -> Void)?

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
        contentView.addSubviews([tv, paddingView])
        tv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        paddingView.snp.makeConstraints { make in
            make.top.equalTo(tv.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
            
            make.height.equalTo(8)
        }
        
        tv.delegate = self
    }
    
    func configure(with text: String) {
        tv.text = text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        onTextChanged?(textView.text)
    }
}
