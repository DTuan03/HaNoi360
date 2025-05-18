//
//  ProfileVC.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit
import FirebaseAuth

class AccountVC: BaseVC {
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithTitleOnly(title: "Tài khoản")
    
    lazy var avatarIV = ImageViewFactory.createImageView(image: .test,
                                                         contentMode: .scaleAspectFill,
                                                         radius: 60)
    
    lazy var editIconIV = ImageViewFactory.createImageView(image: .edit)
    
    lazy var nameLabel = LabelFactory.createLabel(text: "Minh Lan",
                                                  font: .medium20,
                                                  textAlignment: .center)
    
    lazy var emailLabel = LabelFactory.createLabel(text: "lantm@gmail.com",
                                                   font: .regular14,
                                                   textColor: .secondaryTextColor,
                                                   textAlignment: .center)
    
    lazy var stackView = [nameLabel, emailLabel].vStack(4)
    
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 16
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(hex: "#F3F4F6").cgColor
        tableView.register(AccountCell.self, forCellReuseIdentifier: "AccountCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    override func setupUI() {
        view.addSubviews([navigationView, avatarIV, editIconIV, stackView, tableView])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        avatarIV.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        editIconIV.snp.makeConstraints { make in
            make.center.equalTo(avatarIV.snp.center).offset(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(290)
        }
    }
}

extension AccountVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as? AccountCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let accountModel = accountData[indexPath.row]
        cell.configData(accountModel: accountModel)
        return cell
    }
}

extension AccountVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(ProfileVC(), animated: true)
        case 1:
            let forgotPasswordVC = ForgotPasswordVC()
            forgotPasswordVC.titleForgotPasswordVC = "Đổi mật khẩu"
            navigationController?.pushViewController(forgotPasswordVC, animated: true)
        case 2:
            print("Thong bao")
        case 3:
            navigationController?.pushViewController(LanguageVC(), animated: true)
        case 4:
            navigationController?.pushViewController(SignInVC(), animated: true)
            do {
                try Auth.auth().signOut()
                print("Đăng xuất thành công")
            } catch let signOutError as NSError {
                print("Lỗi khi đăng xuất: %@", signOutError)
            }
        default:
            return
        }
    }
}
