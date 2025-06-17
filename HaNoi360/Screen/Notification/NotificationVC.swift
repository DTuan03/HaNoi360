//
//  NotificationVC.swift
//  HaNoi360
//
//  Created by Tuấn on 14/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NotificationVC: BaseVC {
    let viewModel = NotificationVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Thông báo", delegate: self)
    
    lazy var notiTable = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.register(NotiCell.self, forCellReuseIdentifier: "NotiCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func setupUI() {
        view.addSubviews([navigationView, notiTable])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        notiTable.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    override func bindState() {
        viewModel.noti
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.notiTable.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension NotificationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.noti.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as? NotiCell else {
            return UITableViewCell()
        }
        let model = viewModel.noti.value[indexPath.section]
        cell.selectionStyle = .none
        cell.configDate(model: model)
        
        return cell
    }
}

extension NotificationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.noti.value[indexPath.section]
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.updateIsRead(notiId: model.notificationId!)
        }
        let vc = DetailNotiVC()
        vc.viewModel.getDetailNoti(notiId: model.notificationId!) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        var temp = viewModel.noti.value
        temp[indexPath.section].isRead = true
        self.viewModel.noti.accept(temp)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}

extension NotificationVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}
