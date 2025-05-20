//
//  PopupCalendarVC.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import UIKit
import SnapKit

class PopupCalendarVC: UIViewController {
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPopupColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    let titleLabel = LabelFactory.createLabel(text: "Thêm địa điểm vào lịch trình ?",
                                              font: .bold20,
                                              textColor: .primaryTextColor,
                                              textAlignment: .center)
    
    let messageLabel = LabelFactory.createLabel(font: .regular16,
                                                textColor: .secondaryTextColor,
                                                textAlignment: .center)
    
    let okBtn = ButtonFactory.createButton("Tiếp tục",
                                           font: .medium16,
                                           textColor: .textButtonColor,
                                           bgColor: .primaryButtonColor,
                                           height: 40)
    
    let cancelBtn = {
        let btn = ButtonFactory.createButton("Huỷ",
                                             font: .medium16,
                                             textColor: .primaryColor,
                                             bgColor: .white,
                                             height: 40)
        btn.layer.borderColor = UIColor(hex: "#F97316").cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    lazy var stv = [cancelBtn, okBtn].hStack(10, distribution: .fillEqually)
    
    var onOk: (() -> Void)?
    
    var onCancel: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#cbcbcd", alpha: 0.5)
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(48)
        }
        
        containerView.addSubviews([titleLabel, messageLabel, stv])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(32)
        }
        
        stv.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func setupEvent() {
        okBtn.addTarget(self, action: #selector(okBtnAction), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
    }
    
    @objc func okBtnAction() {
        self.dismiss(animated: true)
        self.onOk?()
    }
    
    @objc func cancelBtnAction() {
        self.onCancel?()
        self.dismiss(animated: false)
    }
    
    func configure(onOk: @escaping () -> Void) {
        self.onOk = onOk
    }
}
