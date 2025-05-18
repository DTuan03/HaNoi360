//
//  PopupVC.swift
//  HaNoi360
//
//  Created by Tuấn on 30/3/25.
//

import UIKit
import SnapKit

class PopupVC: UIViewController {
    //    var popupImage: String?
    //    var popupTitle: String?
    //    var popupMessgae: String?
    //    
    //    init(popupImage: String? = nil, popupTitle: String? = nil, popupMessgae: String? = nil) {
    //        self.popupImage = popupImage
    //        self.popupTitle = popupTitle
    //        self.popupMessgae = popupMessgae
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPopupColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    let titleLabel = LabelFactory.createLabel(text: "Xoá khỏi mục yêu thích?",
                                              font: .bold18,
                                              textColor: .primaryTextColor)
    
    let messageLabel = LabelFactory.createLabel(text: "Bạn có chắc chắn muốn xóa địa điểm này?",
                                                font: .regular16,
                                                textColor: .secondaryTextColor,
                                                textAlignment: .center)
    
    let okBtn = ButtonFactory.createButton("Xoá",
                                           font: .medium16,
                                           textColor: .textButtonColor,
                                           bgColor: .primaryButtonColor,
                                           height: 42)
    
    let cancelBtn = {
        let btn = ButtonFactory.createButton("Huỷ",
                                             font: .medium16,
                                             textColor: .primaryColor,
                                             bgColor: .white,
                                             height: 42)
        btn.layer.borderColor = UIColor(hex: "#F97316").cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
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
        
        containerView.addSubviews([titleLabel, messageLabel, okBtn, cancelBtn])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(32)
        }
        
        okBtn.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(okBtn.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func setupEvent() {
        okBtn.addTarget(self, action: #selector(okBtnAction), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
    }
    
    @objc func okBtnAction() {
        self.onOk?()
        self.dismiss(animated: false)
    }
    
    @objc func cancelBtnAction() {
        self.onCancel?()
        self.dismiss(animated: false)
    }
    
    func configure(onOk: @escaping () -> Void) {
        self.onOk = onOk
    }
}
