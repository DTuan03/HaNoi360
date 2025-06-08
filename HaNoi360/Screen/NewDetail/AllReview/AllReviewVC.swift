//
//  AllReviewVC.swift
//  HaNoi360
//
//  Created by Tuấn on 6/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos
import SnapKit

class AllReviewVC: BaseVC {
    let viewModel = AllReviewVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Nhận xét", delegate: self)
    
    lazy var avgReviewLb = LabelFactory.createLabel(text: "4.8", font: .bold32, textColor: .black)
    
    lazy var avgReviewStv = {
        let totalLb = LabelFactory.createLabel(text: "/5", font: .medium24, textColor: .lightGray)
        let stv = [avgReviewLb, totalLb].hStack(alignment: .bottom, distribution: .fillEqually)
        return stv
    }()
    
    lazy var starReview = CosmosViewFactory.createCosmosView(starSize: 32)
    
    lazy var descripLb = LabelFactory.createLabel(text: "Dựa trên 1.91k lượt đánh giá", font: .regular14, textColor: .lightGray)
    
    lazy var sortLb = LabelFactory.createLabel(text: "Sắp xếp thep: Góp ý ⏷", font: .medium14, textColor: .black)
    
    lazy var reviewTableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        tableView.dataSource = self
        tableView.bounces = false
        
        return tableView
    }()
    
    override func setupUI() {
        sortLb.isHidden = true
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        view.addSubviews([avgReviewStv, starReview, descripLb, sortLb, reviewTableView])
        avgReviewStv.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }
        
        starReview.snp.makeConstraints { make in
            make.top.equalTo(avgReviewStv.snp.top)
            make.left.equalTo(avgReviewStv.snp.right).offset(8)
        }
        
        descripLb.snp.makeConstraints { make in
            make.top.equalTo(avgReviewStv.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        sortLb.snp.makeConstraints { make in
            make.top.equalTo(descripLb.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        reviewTableView.snp.makeConstraints { make in
            make.top.equalTo(sortLb.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.lessThanOrEqualTo(400)
        }
    }
    
    override func bindState() {
        viewModel.review
            .subscribe(onNext: { [weak self] review in
                guard let self = self else { return }
                self.reviewTableView.reloadData()
                self.reviewTableView.layoutIfNeeded()
                self.reviewTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.reviewTableView.contentSize.height)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension AllReviewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.review.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell, let model = viewModel.review.value?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configData(model: model)
        cell.delegate = self
        return cell
    }
}

extension AllReviewVC: ReviewCellDelegate {
    func didReport(cell: UITableViewCell) {
        guard let indexPath = reviewTableView.indexPath(for: cell),
              let reviewId = viewModel.review.value?[indexPath.row].reviewId else {
            return
        }
        
        let vm = NewDetailVM()
        vm.updateUserReportStatusForReview(reviewId: reviewId) {
            Toast.showToast(message: "Gửi báo cáo thành công", image: "toast_success")
            if let reviewCell = cell as? ReviewCell {
                reviewCell.reportBtn.isHidden = true
            }
        }
    }
}
extension AllReviewVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}
