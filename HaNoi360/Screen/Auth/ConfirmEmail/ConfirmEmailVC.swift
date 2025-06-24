//
//  ConfirmEmailVC.swift
//  HaNoi360
//
//  Created by Tuấn on 4/4/25.
//

import UIKit
import SnapKit
import RxSwift

class ConfirmEmailVC: BaseVC {
    var nameUser: String 
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonOnly(delegate: self)
    lazy var titleLabel = LabelFactory.createLabel(text: "Xác thực email được gửi cho bạn !",
                                                   font: .bold24,
                                                   textAlignment: .center)
    
    lazy var descriptionLabel = LabelFactory.createLabel(text: "Nếu đã xác thực hãy nhấn nút xác nhận bên dưới.",
                                                         font: .regular16,
                                                         textColor: .secondaryTextColor,
                                                         textAlignment: .center)
    
    lazy var confirmBtn = ButtonFactory.createButton("Tôi đã xác thực")
    
    let viewModel = ConfirmEmailViewModel()
    
    init(nameUser: String) {
        self.nameUser = nameUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        view.addSubviews([navigationView, titleLabel, descriptionLabel, confirmBtn])
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(16)
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
                self.viewModel.confirm(name: self.nameUser ?? "k")
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

extension ConfirmEmailVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}
