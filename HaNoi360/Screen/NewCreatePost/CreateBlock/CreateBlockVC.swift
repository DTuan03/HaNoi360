//
//  CreateBlockVC.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol CreateBlockDelegate: AnyObject {
    func didSelected(_ type: CreateBlockType)
}

struct CreateBlockModel {
    let type: CreateBlockType
    let name: String
}

class CreateBlockVM {
    let createBlocks: [CreateBlockModel] = [
        CreateBlockModel(type: .heading(""), name: "Tiêu đề"),
        CreateBlockModel(type: .text(""), name: "Đoạn văn"),
        CreateBlockModel(type: .image(nil), name: "Ảnh")
    ]
    
    let itemBlock = BehaviorRelay<[CreateBlockModel]>(value: [])
    
    init() {
        itemBlock.accept(createBlocks)
    }
    
}

class CreateBlockVC: BaseVC {
    let viewModel = CreateBlockVM()
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
    
    lazy var addBtn = ButtonFactory.createButton("common.add".localized, font: .medium18, textColor: .primaryColor, bgColor: .clear)
    
    lazy var tableView = {
        let tv = TableViewFactory.createTableView()
        tv.register(CreateBlockCell.self, forCellReuseIdentifier: "CreateBlockCell")
        tv.dataSource = self
        return tv
    }()
    
    var blockType: CreateBlockType?
    var selectedIndexPath: IndexPath?
    
    weak var delegate: CreateBlockDelegate?
    
    override func setupUI() {
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.62)
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
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
                if let blockType = self.blockType {
                    self.delegate?.didSelected(blockType)
                    self.dismiss(animated: true)
                } else {
                    print("show popUp")
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func handleSwipeDown() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreateBlockVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemBlock.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateBlockCell", for: indexPath) as? CreateBlockCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let model = viewModel.itemBlock.value[indexPath.row]
        let isSelected = (indexPath == selectedIndexPath)
        cell.configData(model: model, isSelected: isSelected)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

extension CreateBlockVC: CreateBlockCellDelegate {
    func didTapChooseIV(indexPath: IndexPath?) {
        if selectedIndexPath == indexPath {
            blockType = nil
            selectedIndexPath = nil
        } else {
            if let indexPath = indexPath {
                let model = viewModel.itemBlock.value[indexPath.row]
                blockType = model.type
                selectedIndexPath = indexPath
            }
        }
        tableView.reloadData()
        print(blockType as Any)
    }
}
