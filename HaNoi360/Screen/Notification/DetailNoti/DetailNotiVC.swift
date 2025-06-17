//
//  DetailNotiVC.swift
//  HaNoi360
//
//  Created by Tuấn on 15/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailNotiVC: BaseVC {
    let viewModel = DetailNotiVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Chi tiết thông báo", delegate: self)
    
    lazy var iconIV = ImageViewFactory.createImageView(image: UIImage(systemName: "calendar"), tintColor: .secondaryTextColor)
    
    lazy var timeLb = LabelFactory.createLabel(text: "07 tháng 4 2025", font: .regular12, textColor: .secondaryTextColor)
    
    lazy var firstSV = [iconIV, timeLb].hStack(4)
    
    lazy var titleLb = LabelFactory.createLabel(text: "Ho Tay", font: .medium16, textColor: .primaryTextColor, numberOfLines: 0)
    
    lazy var contentReviewLb = LabelFactory.createLabel(text: "Ho Tay", font: .medium14, textColor: .primaryTextColor, numberOfLines: 0)
    
    lazy var contentLb = LabelFactory.createLabel(text: "Ho Tay, Ha Noi", font: .light14, textColor: .secondaryTextColor, numberOfLines: 0)
    
    override func setupUI() {
        view.addSubviews([navigationView, firstSV, titleLb, contentReviewLb, contentLb])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        firstSV.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.equalToSuperview().offset(20)
        }
        
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(firstSV.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentReviewLb.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentLb.snp.makeConstraints { make in
            make.top.equalTo(contentReviewLb.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    override func bindState() {
        viewModel.noti
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.titleLb.text = "Thông báo"
                self.timeLb.text = value?.createdAt!.toString()
                self.contentReviewLb.text = "Nội dung nhận xét: \(value?.reviewContent ?? "")"
                self.contentLb.text = value?.message
            })
            .disposed(by: disposeBag)
    }
}

extension DetailNotiVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}
