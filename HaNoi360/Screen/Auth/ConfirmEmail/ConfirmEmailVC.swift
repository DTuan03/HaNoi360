//
//  ConfirmEmailVC.swift
//  HaNoi360
//
//  Created by Tuấn on 4/4/25.
//

import UIKit
import SnapKit
import RxSwift

class ConfirmEmailVC: BaseViewController {
    var nameUser: String?
    lazy var titleLabel = LabelFactory.createLabel(text: "Xác thực email được gửi cho bạn !",
                                                   font: .bold24,
                                                   textAlignment: .center)
    
    lazy var descriptionLabel = LabelFactory.createLabel(text: "Nếu đã xác thực hãy nhấn nút xác nhận bên dưới.",
                                                         font: .regular16,
                                                         textColor: .secondaryTextColor,
                                                         textAlignment: .center)
    
    lazy var confirmBtn = ButtonFactory.createButton("Tôi đã xác thực")
    
    let viewModel = ConfirmEmailViewModel()
    
    override func setupUI() {
        view.addSubviews([titleLabel, descriptionLabel, confirmBtn])
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    override func setupEvent() {
        confirmBtn.rx.tap
            .subscribe(onNext: {
                self.viewModel.confirm(name: self.nameUser ?? "")
            })
            .disposed(by: disposeBag)
        
        viewModel.isConfirm
            .subscribe(onNext: { isConfirm in
                if isConfirm {
                    self.navigationController?.pushViewController(SignInVC(), animated: true)
                } else {
                    Toast.showToast(message: "Hãy thử lại !", image: "toast_error")
                }
            })
            .disposed(by: disposeBag)
    }
}
