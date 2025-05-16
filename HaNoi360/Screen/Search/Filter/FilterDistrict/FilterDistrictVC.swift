//
//  FilterDistrictVC.swift
//  HaNoi360
//
//  Created by Tuấn on 4/5/25.
//

import UIKit
import SnapKit

protocol FilterDistrictDelegate: AnyObject {
    func didSelected(_ data: [String])
}

class FilterDistrictVC: BaseViewController, FilterDistrictCellDelegate {
    let viewModel = FilterDistrictVM()
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        
        return view
    }()
    
    lazy var pullDownView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 3
        return v
    }()
    
    lazy var addBtn = ButtonFactory.createButton("Thêm", font: .medium18, textColor: .primaryColor, bgColor: .clear)
    
    let searchBarV: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Tìm kiếm địa điểm..."
        return sb
    }()

    lazy var tableView = {
        let tv = TableViewFactory.createTableView()
        tv.register(FilterDistrictCell.self, forCellReuseIdentifier: "FilterDistrictCell")
        tv.dataSource = self
        return tv
    }()
    
    lazy var districts: [String] = []
    
    weak var delegate: FilterDistrictDelegate?
    
    override func setupUI() {
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.62)
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        containerView.addSubviews([pullDownView, tableView, addBtn, searchBarV])
        
        pullDownView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(6)
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(24)
        }
        
        searchBarV.delegate = self
        searchBarV.snp.makeConstraints { make in
            make.top.equalTo(addBtn.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBarV.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    override func setupEvent() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        addBtn.rx.tap
            .subscribe(onNext: {
                if self.districts.isEmpty {
                    print("show popUp")
                } else {
                    self.delegate?.didSelected(self.districts)
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func handleSwipeDown() {
        dismiss(animated: true, completion: nil)
    }
    var selectedIndexPaths: Set<IndexPath> = []
    
    
}

extension FilterDistrictVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemDistricts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterDistrictCell", for: indexPath) as? FilterDistrictCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let model = viewModel.itemDistricts.value[indexPath.row]
        cell.configData(model: model)
        cell.delegate = self
        cell.indexPath = indexPath
        let isSelected = selectedIndexPaths.contains(indexPath)
        cell.setSelectedState(isSelected)
        return cell
    }
}

extension FilterDistrictVC {
    func didTapChooseIV(in cell: FilterDistrictCell) {
        let model = viewModel.itemDistricts.value[cell.indexPath.row]
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
            if let item = districts.firstIndex(of: model.id) {
                districts.remove(at: item)
            }
        } else {
            selectedIndexPaths.insert(indexPath)
            districts.append(model.id)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension FilterDistrictVC: UISearchBarDelegate {
    
}
