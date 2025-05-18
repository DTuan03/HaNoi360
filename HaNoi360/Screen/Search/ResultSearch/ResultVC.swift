//
//  ResultVC.swift
//  HaNoi360
//
//  Created by Tuấn on 17/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum previousVCType {
    case search
    case filter
}

class ResultVC: BaseViewController {
    let viewModel = ResultVM()
    
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Kết quả tìm kiếm", delegate: self)
    
    var previousVCName: previousVCType = .search
    
    lazy var filterClv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FilterCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var recentSearcheLabel = LabelFactory.createLabel(text: "0 Kết quả phù hợp", font: .regular16, textColor: UIColor(hex: "#374151"))
    
    lazy var stv = [filterClv, recentSearcheLabel].vStack(24)
    
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
        view.addSubviews([navigationView, stv, tableView])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        stv.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        filterClv.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearcheLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        showFilterClv()
    }
    
    func showFilterClv() {
        switch previousVCName {
        case .search:
            filterClv.isHidden = true
        case .filter:
            filterClv.isHidden = false
        }
    }
    
    override func bindState() {
        viewModel.keyWord
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                print(value ?? "Khong co")
            })
            .disposed(by: disposeBag)
        
        viewModel.resultSearch
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if let v = value, v.count != 0 {
                    self.recentSearcheLabel.text = "\(v.count) Kết quả phù hợp"
                } else {
                    //hien thi backgroundview cua tableview khong co item
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.categoryFilter
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.filterClv.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ResultVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ResultVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.resultSearch.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell, let model = viewModel.resultSearch.value?[indexPath.section] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configData(model: model)
        return cell
    }
}

extension ResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}

extension ResultVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryFilter.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath)
        // Xoá subviews cũ (tránh lặp nếu scroll)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor(hex: "#6B7280").cgColor
        view.layer.borderWidth = 1
        
        let label = LabelFactory.createLabel(text: "Am thuc", font: .regular12, numberOfLines: 1)
        let closeIv = ImageViewFactory.createImageView(image: UIImage(systemName: "multiply"), tintColor: UIColor(hex: "#111827"), contentMode: .scaleAspectFill)
        
        let stv = [label, closeIv].hStack(2, alignment: .center)
        view.addSubviews([stv])
        stv.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(8)
        }
        
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        let model = viewModel.categoryFilter.value[indexPath.row]
        label.text = model
        return cell
    }
}

extension ResultVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let namePlace = viewModel.categoryFilter.value[indexPath.row]
        
        let label = UILabel()
        label.text = namePlace
        label.font = UIFont.regular14
        
        let maxWidth: CGFloat = collectionView.frame.width
        let labelSize = label.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        let sizeForItem = CGSize(width: labelSize.width + 30, height: 36)
        return sizeForItem
    }
}
