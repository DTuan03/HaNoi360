//
//  CategoryVC.swift
//  HaNoi360
//
//  Created by Tuấn on 13/4/25.
//

import UIKit
import SnapKit

protocol CategoryDelegate: AnyObject {
    func didSelected(categoryId: [String], categoryNames: [String])
}

class AddCategoryVC: BaseVC {
    let viewModel = CategoryViewModel()
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
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
        tv.register(CategoryAddPlaceCell.self, forCellReuseIdentifier: "CategoryAddPlaceCell")
        tv.dataSource = self
        return tv
    }()
    
    lazy var categoryId: [String] = []
    lazy var categoryNames: [String] = []
    
    weak var delegate: CategoryDelegate?
  
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
                if self.categoryId.isEmpty {
                    print("show popUp")
                } else {
                    self.delegate?.didSelected(categoryId: self.categoryId, categoryNames: self.categoryNames)
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func handleSwipeDown() {
        dismiss(animated: true, completion: nil)
    }

}

extension AddCategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCategoies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryAddPlaceCell", for: indexPath) as? CategoryAddPlaceCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let model = viewModel.itemCategoies.value[indexPath.row]
        cell.configData(model: model)
        cell.delegate = self
        cell.idCategory = model.id
        let isSelected = categoryId.contains(cell.idCategory)
        cell.setSelectedState(isSelected)
        return cell
    }
}

extension AddCategoryVC: CategoryAddPlaceCellDelegate {
    func didTapChooseIV(in cell: CategoryAddPlaceCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let model = viewModel.itemCategoies.value[indexPath.row]
        if let item = categoryId.firstIndex(of: model.id ?? "") {
            categoryId.remove(at: item)
            categoryNames.remove(at: item)
        } else {
            categoryId.append(model.id ?? "")
            categoryNames.append(model.name ?? "")
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
