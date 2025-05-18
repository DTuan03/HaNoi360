//
//  FilterDistrictVC.swift
//  HaNoi360
//
//  Created by Tuấn on 4/5/25.
//

import UIKit
import SnapKit

protocol FilterDistrictDelegate: AnyObject {
    func didSelected(districtsId: [String], districtsName: [String])
}

class FilterDistrictVC: BaseVC, FilterDistrictCellDelegate {
    let viewModel = FilterDistrictVM()
//    var
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
    
    lazy var districtsId: [String] = []
    lazy var districtsName: [String] = []
    
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
                if self.districtsId.isEmpty {
                    print("show popUp")
                } else {
                    self.delegate?.didSelected(districtsId: self.districtsId, districtsName: self.districtsName)
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func handleSwipeDown() {
        dismiss(animated: true, completion: nil)
    }
    
    override func bindState() {
        viewModel.itemDistricts
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
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
        cell.idDistrict = model.id
        let isSelected = districtsId.contains(cell.idDistrict)
        cell.setSelectedState(isSelected)
        return cell
    }
}

extension FilterDistrictVC {
    func didTapChooseIV(in cell: FilterDistrictCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let model = viewModel.itemDistricts.value[indexPath.row]
        if let item = districtsId.firstIndex(of: model.id) {
            districtsId.remove(at: item)
            districtsName.remove(at: item)
        } else {
            districtsId.append(model.id)
            districtsName.append(model.name)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension FilterDistrictVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.itemDistricts.accept(viewModel.districts)
        } else {
            let keyword = searchText.lowercased()
            let fitered = viewModel.districts.filter { $0.name.lowercased().contains(keyword) }
            viewModel.itemDistricts.accept(fitered)
        }
    }
}
