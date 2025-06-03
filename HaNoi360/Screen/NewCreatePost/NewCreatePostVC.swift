//
//  NewCreatePostVC.swift
//  HaNoi360
//
//  Created by Tuấn on 25/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CoreLocation

class NewCreatePostVC: BaseVC {
    let viewModel = NewCreatePostVM()
    lazy var scrollView = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor,
                                                             showsVerticalScrollIndicator: true)
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back,
                                                                                               title: "Thêm bài viết",
                                                                                               delegate: self)
    lazy var avatarIV = {
        let iv = ImageViewFactory.createImageView(image: UIImage(named: "placeholderImage"), contentMode: .scaleAspectFill, radius: 20)
        iv.backgroundColor = .waitingImageColor
        return iv
    }()
    
    lazy var titleTf = {
        let tf = TextFieldFactory.createTextField(placeholder: "Tiêu đề bài viết", rounded: 8)
        tf.imageLeftView(image: .location, placeholder: "", padding: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), imageSize: CGSize(width: 16, height: 16))
        tf.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        return tf
    }()
    
    lazy var tagBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "tag"), title: "   Thêm thẻ", tinColor: .primaryColor, font: .regular14)
        btn.backgroundColor = .textFiledColor
        btn.layer.cornerRadius = 8
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.numberOfLines = 1
        btn.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return btn
    }()
    
    lazy var mapBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "mappin"), title: "  Thêm địa chỉ", tinColor: .primaryColor, font: .regular12)
        btn.backgroundColor = .textFiledColor
        btn.layer.cornerRadius = 8
        btn.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return btn
    }()
    
    lazy var tagAndMapSV = [tagBtn, mapBtn].hStack(10, distribution: .fillEqually)
    
    lazy var contentLb = LabelFactory.createLabel(text: "Nội dung bài viết", font: .medium14)
    
    lazy var contentTableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        tableView.register(HeadingCell.self, forCellReuseIdentifier: "HeadingCell")
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    var contentTableViewHeightConstraint: Constraint?
    
    lazy var createBlockNew = {
        let btn = ButtonFactory.createButton("Thêm khối mới", font: .regular16, rounded: true, height: 40)
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return btn
    }()
    
    lazy var createBtn = {
        let btn = ButtonFactory.createButton("Tạo bài viết", font: .medium14, bgColor: .lightGray)
        btn.isEnabled = false
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return btn
    }()
    
    var contentBlocks: [CreateBlockType] = []
    var categoryName: [String] = []
    
    override func setupUI() {
        view.addSubviews([navigationView, scrollView])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.addSubviews([avatarIV, titleTf, tagAndMapSV, contentLb, contentTableView, createBlockNew, createBtn])
        
        contentView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(createBtn.snp.bottom).offset(20)
        }
        
        avatarIV.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(110)
            make.width.equalTo(110)
        }
        
        titleTf.snp.makeConstraints { make in
            make.left.equalTo(avatarIV.snp.right).offset(4)
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().inset(4)
        }
        
        tagAndMapSV.snp.makeConstraints { make in
            make.top.equalTo(titleTf.snp.bottom).offset(16)
            make.left.equalTo(titleTf.snp.left)
            make.right.equalTo(titleTf.snp.right)
        }
        
        contentLb.snp.makeConstraints { make in
            make.top.equalTo(tagAndMapSV.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        contentTableView.snp.makeConstraints { make in
            make.top.equalTo(contentLb.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            self.contentTableViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        createBlockNew.snp.makeConstraints { make in
            make.top.equalTo(contentTableView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        createBtn.snp.makeConstraints { make in
            make.top.equalTo(createBlockNew.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    override func setupEvent() {
        let avatarIVTap = UITapGestureRecognizer(target: self, action: #selector(avatarIVAction))
        avatarIV.addGestureRecognizer(avatarIVTap)
        
        createBlockNew.rx.tap
            .subscribe(onNext: {
                let vc = CreateBlockVC()
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        titleTf.addTarget(self, action: #selector(titleTfAction(_:)), for: .editingChanged)
        
        tagBtn.rx.tap
            .subscribe(onNext: {
                let vc = AddCategoryVC()
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overCurrentContext
                if let categoryId = self.viewModel.categoryId.value {
                    vc.categoryId = categoryId
                    vc.categoryNames = self.categoryName
                }
                vc.delegate = self
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mapBtn.rx.tap
            .subscribe(onNext: {
                let vc = MapVC()
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                viewModel.avatarIV.asObservable(),
                viewModel.title.asObservable(),
                viewModel.categoryId.asObservable(),
                viewModel.coordinate.asObservable(),
                viewModel.idAddress.asObservable(),
                viewModel.contentBlocks.asObservable()
            )
            .map { avatar, title, category, coordinate, addressId, content in
                let hasContent = self.viewModel.isContentBlocksValid(content)
                
                return avatar != nil &&
                !(title?.isEmpty ?? true) &&
                !(category?.isEmpty ?? true) &&
                coordinate != nil &&
                !(addressId?.isEmpty ?? true) &&
                !content.isEmpty &&
                hasContent
            }
            .subscribe(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.createBtn.isEnabled = isValid
                self.createBtn.backgroundColor = isValid ? .primaryButtonColor : .lightGray
            })
            .disposed(by: disposeBag)
        
        createBtn.rx.tap
            .subscribe(onNext: {
                self.viewModel.createPost()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.isLoading.accept(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.isSuccess
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.resetForm()
                    Toast.showToast(message: "Thêm bài viết thành công", image: "toast_success")
                } else {
                    Toast.showToast(message: "Thêm bài viết thất bại", image: "toast_error")
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func avatarIVAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc func titleTfAction(_ textField: UITextField) {
        viewModel.title.accept(textField.text)
    }
    
    override func bindState() {
        viewModel.contentBlocks
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.contentTableView.reloadData()
                self.updateTableViewHeight()
            })
            .disposed(by: disposeBag)
        
    }
    
    func updateTableViewHeight() {
        contentTableView.layoutIfNeeded()
        contentTableViewHeightConstraint?.update(offset: contentTableView.contentSize.height + 56)
    }
    
    func resetForm() {
        titleTf.text = ""
        viewModel.title.accept("")
        
        avatarIV.image = UIImage(named: "placeholderImage")
        viewModel.avatarIV.accept(nil)
        
        viewModel.categoryId.accept([])
        tagBtn.setTitle("Thêm thẻ", for: .normal)
        
        viewModel.coordinate.accept(nil)
        viewModel.idAddress.accept(nil)
        mapBtn.setTitle("Thêm địa chỉ", for: .normal)
        
        viewModel.contentBlocks.accept([])
    }
    
}

extension NewCreatePostVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contentBlocks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let block = viewModel.contentBlocks.value[indexPath.row]
        
        switch block.type {
        case .heading:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeadingCell", for: indexPath) as? HeadingCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: block.text ?? "")
            cell.onTextChanged = { [weak self] updated in
                guard let self = self, let currentIndexPath = tableView.indexPath(for: cell) else { return }
                print(updated)
                var blocks = self.viewModel.contentBlocks.value
                blocks[currentIndexPath.row].text = updated
                self.viewModel.contentBlocks.accept(blocks)
            }
            return cell
            
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: block.text ?? "")
            cell.onTextChanged = { [weak self] updated in
                guard let self = self,
                      let currentIndexPath = tableView.indexPath(for: cell) else { return }
                print(updated)
                var blocks = self.viewModel.contentBlocks.value
                blocks[currentIndexPath.row].text = updated
                self.viewModel.contentBlocks.accept(blocks)
            }
            return cell
            
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: block.image ?? .placeholderImage2)
            cell.onImagePicked = { [weak self] newImage in
                guard let self = self,
                      let currentIndexPath = tableView.indexPath(for: cell) else { return }
                cell.iv.image = newImage
                var blocks = self.viewModel.contentBlocks.value
                blocks[currentIndexPath.row].image = newImage
                self.viewModel.contentBlocks.accept(blocks)
            }
            return cell
        }
    }
}

extension NewCreatePostVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var current = viewModel.contentBlocks.value
        let movedItem = current.remove(at: sourceIndexPath.row)
        current.insert(movedItem, at: destinationIndexPath.row)
        viewModel.contentBlocks.accept(current)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Xoá") { (_, _, completion) in
            var current = self.viewModel.contentBlocks.value
            current.remove(at: indexPath.row)
            self.viewModel.contentBlocks.accept(current)
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension NewCreatePostVC: CreateBlockDelegate {
    func didSelected(_ type: CreateBlockType) {
        let contentBlock = CreateBlock(type: type, text: "", image: nil)
        var contentBlocks = viewModel.contentBlocks.value
        contentBlocks.append(contentBlock)
        viewModel.contentBlocks.accept(contentBlocks)
    }
}

extension NewCreatePostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            avatarIV.image = image
            viewModel.avatarIV.accept(image)
            picker.dismiss(animated: true)
        }
    }
}

extension NewCreatePostVC: CategoryDelegate {
    func didSelected(categoryId: [String], categoryNames: [String]) {
        viewModel.categoryId.accept(categoryId)
        self.categoryName = categoryNames
        let joinedName = categoryNames.joined(separator: ", ")
        self.tagBtn.setTitle(joinedName, for: .normal)
    }
}

extension NewCreatePostVC: MapVCDelegate {
    func didMaped(district: String, coordinate: CLLocationCoordinate2D) {
        self.mapBtn.setTitle(district, for: .normal)
        viewModel.coordinate.accept(coordinate)
        viewModel.extractDistrictName(from: district)
    }
}

extension NewCreatePostVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}
