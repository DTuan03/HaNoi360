//
//  LanguageVC.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

class LanguageVC: BaseViewController {
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Ngôn ngữ", delegate: self)
    
    lazy var languageTableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 64
        tableView.register(LanguageCell.self, forCellReuseIdentifier: "LanguageCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    var row: Int?
    
    override func setupUI() {
        view.addSubviews([navigationView, languageTableView])
        
        navigationView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        languageTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}

extension LanguageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        if UserDefaults.standard.object(forKey: "language") != nil {
            row = UserDefaults.standard.integer(forKey: "language")
        } else {
            row = UserDefaults.standard.integer(forKey: "language_system")
        }
        
        let isChecked = (indexPath.row == row)
        
        cell.selectionStyle = .none
        cell.configData(title: languageData[indexPath.row], isChecked: isChecked)
        
        return cell
    }
}

extension LanguageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "language")
        languageTableView.reloadData()
    }
}
extension LanguageVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
