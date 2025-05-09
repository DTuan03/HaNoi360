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
        return view
    }()
    
    lazy var pullDownView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 3
        return v
    }()
    
    lazy var addBtn = ButtonFactory.createButton("Thêm", font: .medium18, textColor: .primaryColor, bgColor: .clear)
    
    lazy var tableView = {
        let tv = TableViewFactory.createTableView()
        tv.register(FilterDistrictCell.self, forCellReuseIdentifier: "FilterDistrictCell")
        tv.dataSource = self
        return tv
    }()
    
    lazy var categories: [String] = []
    
    weak var delegate: FilterDistrictDelegate?
  
    override func setupUI() {
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.62)
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        containerView.addSubviews([pullDownView, tableView, addBtn])
        
        pullDownView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(6)
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addBtn.snp.bottom).offset(16)
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
                if self.categories.isEmpty {
                    print("show popUp")
                } else {
                    self.delegate?.didSelected(self.categories)
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

extension FilterDistrictVC: FilterDistrictDelegate {
    func didSelected(_ data: [String]) {
        
    }
    
    func didTapChooseIV(in cell: FilterDistrictCell) {
        let model = viewModel.itemDistricts.value[cell.indexPath.row]
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
        } else {
            selectedIndexPaths.insert(indexPath)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
