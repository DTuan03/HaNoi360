//
//  SearchVC.swift
//  HaNoi360
//
//  Created by Tuấn on 3/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchVC: BaseVC {
    let viewModel = SeachVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Tìm kiếm", delegate: self)
    
    lazy var searchTF = {
        let tf =  TextFieldFactory.createTextField(placeholder: "Tìm kiếm",
                                                   bgColor: .white)
        tf.imageLeftView(image: .search)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#D1D5DB").cgColor
        tf.returnKeyType = .search
        tf.delegate = self
        return tf
    }()
    
    lazy var filterBtn = {
        let btn = UIButton()
        btn.setImage(.filter, for: .normal)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(hex: "#D1D5DB").cgColor
        return btn
    }()
    
    lazy var recentSearcheLabel = LabelFactory.createLabel(text: "Tìm kiếm gần đây", font: .regular16, textColor: UIColor(hex: "#374151"))
    
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func setupUI() {
        view.addSubviews([navigationView, searchTF, filterBtn, recentSearcheLabel, tableView])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        searchTF.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(filterBtn.snp.left).inset(-10)
            make.height.equalTo(46)
        }
        
        filterBtn.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(46)
        }
        
        recentSearcheLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTF.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearcheLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    override func setupEvent() {
        filterBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = FilterVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func bindState() {
        viewModel.recentSearch
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                let isValue = value?.isEmpty ?? true
                if isValue {
                    tableView.setLottieBackground(name: "emptyRecentSearch", title: "Chưa có tìm kiếm nào", message: "Bắt đầu khám phá và tìm kiếm nhiều hơn nhé")
                } else {
                    tableView.clearBackground()
                    tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SearchVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension SearchVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.recentSearch.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell, let model = viewModel.recentSearch.value?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configData(model: model)
        return cell
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // an ban phim
        textField.resignFirstResponder()
        
        let vc = ResultVC()
        vc.viewModel.keyWord.accept(textField.text)
        vc.previousVCName = .search
        self.navigationController?.pushViewController(vc, animated: true)
        return true
    }
}
