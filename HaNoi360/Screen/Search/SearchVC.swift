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
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "common.search".localized, delegate: self)
    
    lazy var searchTF = {
        let tf =  TextFieldFactory.createTextField(placeholder: "common.search".localized,
                                                   bgColor: .white)
        tf.imageLeftView(image: .search)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#D1D5DB").cgColor
        tf.returnKeyType = .search
        tf.backgroundColor = .textFiledColor
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
    
    lazy var recentSearcheLabel = LabelFactory.createLabel(text: "search.rcent".localized, font: .regular16, textColor: .labelSecondColor)
    
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTF.text = ""
        viewModel.getRecentSearch()
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
                    tableView.reloadData()
                } else {
                    tableView.clearBackground()
                    tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.keyWord
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                let vc = ResultVC()
                vc.previousVCName = .search

                self.viewModel.search { result in
                    switch result {
                    case .success(let blogs):
                        vc.viewModel.resultSearch.accept(blogs)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .failure(_):
                        vc.viewModel.resultSearch.accept([])
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell, let model = viewModel.recentSearch.value?[indexPath.section] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configData(model: model)
        cell.onDelete = {
            self.viewModel.deleteRecentSearch(searchId: model.searchId ?? "")
            self.viewModel.getRecentSearch()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.keyWord.accept(viewModel.recentSearch.value?[indexPath.section].textSearch)
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // an ban phim
        textField.resignFirstResponder()
        viewModel.keyWord.accept(textField.text)
        
        let model = SearchModel(searchId: UUID().uuidString, textSearch: textField.text ?? "")
        viewModel.saveSearch(for: model)

        return true
    }
}
