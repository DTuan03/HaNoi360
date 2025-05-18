//
//  ProfileVC.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

class ProfileVC: BaseVC {
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back,
                                                                                               title: "Hồ sơ",
                                                                                               delegate: self)
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 64
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.dataSource = self
        return tableView
    }()
    
    let titles: [String] = ["Họ tên", "Email", "Điện thoại", "Ngày sinh", "Địa chỉ"]
    
    lazy var saveBtn = ButtonFactory.createButton("Lưu",
                                                  font: .bold16,
                                                  textColor: .textButtonColor)

    override func setupUI() {
        view.addSubviews([navigationView, tableView, saveBtn])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(64 * 5)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(40)
        }
    }
}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configData(title: titles[indexPath.row])
        return cell
    }
    
}

extension ProfileVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
