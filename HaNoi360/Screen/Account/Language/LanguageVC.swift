//
//  LanguageVC.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

class LanguageVC: BaseVC {
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "account.langugae.interface".localized, delegate: self)
    
    lazy var languageLb = LabelFactory.createLabel(text: "account.language".localized, font: .medium16, textColor: .primaryTextColor)
    
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
    
    lazy var themeLb = LabelFactory.createLabel(text: "account.interface".localized, font: .medium16, textColor: .primaryTextColor)
    
    lazy var darkModeLb = LabelFactory.createLabel(text: "account.darkMode".localized, font: .regular16, textColor: .primaryTextColor)
    
    lazy var themeSwitch = createSwitch()
    
    private func createSwitch() -> UISwitch {
        let themeSwitch = UISwitch()
        if let savedStyle = UserDefaults.standard.value(forKey: "darkModeEnabled") as? Int {
            themeSwitch.isOn = (savedStyle == UIUserInterfaceStyle.dark.rawValue)
        } else {
            themeSwitch.isOn = false
        }
        themeSwitch.onTintColor = UIColor(hex: "#FF7B00")
        themeSwitch.thumbTintColor = .white
        themeSwitch.addTarget(self, action: #selector(darkModeChanged(_:)), for: .valueChanged)
        return themeSwitch
    }

    override func setupUI() {
        view.addSubviews([navigationView, themeLb, darkModeLb, themeSwitch, languageLb, languageTableView])
        
        navigationView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        themeLb.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        darkModeLb.snp.makeConstraints { make in
            make.top.equalTo(themeLb.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(20)
        }
        
        themeSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(darkModeLb.snp.centerY)
            make.right.equalToSuperview().inset(16)
        }
        
        languageLb.snp.makeConstraints { make in
            make.top.equalTo(themeSwitch.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
        }
        
        languageTableView.snp.makeConstraints { make in
            make.top.equalTo(languageLb.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func darkModeChanged(_ sender: UISwitch) {
        let newStyle: UIUserInterfaceStyle = sender.isOn ? .dark : .light
        
        view.window?.overrideUserInterfaceStyle = newStyle
        UserDefaults.standard.set(newStyle.rawValue, forKey: "darkModeEnabled")
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
        let langCode: String
        switch indexPath.row {
        case 0: langCode = "vi"
        case 1: langCode = "en"
        default: langCode = "vi"
        }
        UserDefaults.standard.set(langCode, forKey: "appLanguage")
        UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
        UserDefaults.standard.set(indexPath.row, forKey: "language")
        UserDefaults.standard.synchronize()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UINavigationController(rootViewController: TabBarVC())
            window.makeKeyAndVisible()
        }
        tableView.reloadData()
    }
}
extension LanguageVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
