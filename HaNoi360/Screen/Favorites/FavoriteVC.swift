//
//  FavoriteVC.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit

class FavoriteVC: BaseVC {
    let viewModel = FavoriteVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithTitleOnly(title: "Địa điểm yêu thích")
    
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.featchPlace()
    }
    
    override func setupUI() {
        view.addSubviews([navigationView, tableView])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    override func bindState() {
        viewModel.featchPlace()
        viewModel.placeFavorite
            .subscribe(onNext: { i in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension FavoriteVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.placeFavorite.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell, let model = viewModel.placeFavorite.value?[indexPath.section] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configData(model: model)
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        
        return cell
    }
}

extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, handler in
            let popupVC = PopupVC()
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: true)
            handler(true)
        }
        let deleteImage = UIImage(named: "trash")
        deleteAction.image = deleteImage
        deleteAction.backgroundColor = .backgroundTableViewCellColor
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
