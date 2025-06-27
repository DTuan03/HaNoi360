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
import Kingfisher

enum NewCreateBlogType {
    case edit
    case create
}

class NewCreatePostVC: BaseVC {
    let viewModel = NewCreatePostVM()
    var newCreateBlogType: NewCreateBlogType = .create
    lazy var titleNavigation: String? = "create.add.post".localized
    lazy var scrollView = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor,
                                                             showsVerticalScrollIndicator: true)
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back,
                                                                                               title: titleNavigation,
                                                                                               delegate: self)
    lazy var avatarIV = {
        let iv = ImageViewFactory.createImageView(image: UIImage(named: "placeholderImage"), contentMode: .scaleAspectFill, radius: 20)
        iv.backgroundColor = .waitingImageColor
        return iv
    }()
    
    lazy var titleTf = {
        let tf = TextFieldFactory.createTextField(placeholder: "post.title".localized, rounded: 8)
        tf.imageLeftView(image: UIImage(systemName: "mappin.and.ellipse.circle")!, placeholder: "", padding: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), imageSize: CGSize(width: 16, height: 16))
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        return tf
    }()
    
    lazy var tagBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "tag"), title: "create.add.tag".localized, tinColor: .primaryColor, font: .regular14)
        btn.backgroundColor = .textFiledColor
        btn.layer.cornerRadius = 8
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.numberOfLines = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return btn
    }()
    
    lazy var mapBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "mappin"), title: "create.add.address".localized, tinColor: .primaryColor, font: .regular12)
        btn.backgroundColor = .textFiledColor
        btn.layer.cornerRadius = 8
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return btn
    }()
    
    lazy var tagAndMapSV = [tagBtn, mapBtn].hStack(10, distribution: .fillEqually)
    
    lazy var contentLb = LabelFactory.createLabel(text: "create.post.content".localized, font: .medium14)
    
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
        let btn = ButtonFactory.createButton("create.add.new.block".localized, font: .regular16, rounded: true, height: 40)
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
        
        switch newCreateBlogType {
        case .edit:
            createBtn.setTitle("create.edit.post".localized, for: .normal)
        case .create:
            createBtn.setTitle("create.add.post".localized, for: .normal)
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
                    switch newCreateBlogType {
                    case .edit:
                        Toast.showToast(message: "toast.edit.success".localized, image: "toast_success")
                    case .create:
                        Toast.showToast(message: "toast.add.success".localized, image: "toast_success")
                    }
                } else {
                    switch newCreateBlogType {
                    case .edit:
                        Toast.showToast(message: "toast.edit.faild".localized, image: "toast_error")
                    case .create:
                        Toast.showToast(message: "toast.add.faild".localized, image: "toast_error")
                    }
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
        
        viewModel.blog
            .subscribe(onNext: { [weak self] value in
                guard let self = self, let value = value else { return }
                self.viewModel.blogId = value.blogId!
                self.viewModel.title.accept(value.title)
                self.titleTf.text = value.title
                self.viewModel.avatarUrl.accept(value.avatarBlog)
                if let urlString = value.avatarBlog, let url = URL(string: urlString) {
                    self.avatarIV.kf.setImage(with: url) { result in
                        switch result {
                        case .success(let imageResult):
                            self.viewModel.avatarIV.accept(imageResult.image)
                        case .failure:
                            self.avatarIV.image = UIImage(named: "placeholderImage")
                            self.viewModel.avatarIV.accept(nil)
                        }
                    }
                }
                self.viewModel.idAddress.accept(value.districId)
                self.mapBtn.setTitle(value.address, for: .normal)
                self.viewModel.coordinate.accept(CLLocationCoordinate2D(latitude: value.coordinates.latitude, longitude: value.coordinates.longitude))
                self.viewModel.categoryId.accept(value.category)
                let categoryNames = value.category!.compactMap { id in
                    self.viewModel.categories.first(where: { $0.id == id })?.name
                }
                let joinedName = categoryNames.joined(separator: ", ")
                self.tagBtn.setTitle(joinedName, for: .normal)
                convertBlocks(contentBlocks: value.contentBlocks) { createBlocks in
                    self.viewModel.contentBlocks.accept(createBlocks)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.contentBlocks
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.contentTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func convertBlocks(
        contentBlocks: [ContentBlock],
        completion: @escaping ([CreateBlock]) -> Void
    ) {
        let group = DispatchGroup()
        var result = [CreateBlock]()
        let resultQueue = DispatchQueue(label: "convertBlocks.result.queue") // bảo vệ result

        for block in contentBlocks {
            switch block.type {
            case .heading:
                let text = block.value ?? ""
                let createBlock = CreateBlock(type: .heading(text), text: text, image: nil)
                resultQueue.async {
                    result.append(createBlock)
                }

            case .text:
                let text = block.value ?? ""
                let createBlock = CreateBlock(type: .text(text), text: text, image: nil)
                resultQueue.async {
                    result.append(createBlock)
                }

            case .image:
                group.enter()
                if let urlString = block.value, let url = URL(string: urlString) {
                    KingfisherManager.shared.retrieveImage(with: url) { resultKF in
                        defer { group.leave() }
                        let createBlock: CreateBlock
                        switch resultKF {
                        case .success(let imageResult):
                            createBlock = CreateBlock(type: .image(imageResult.image), text: nil, image: imageResult.image)
                        case .failure:
                            createBlock = CreateBlock(type: .image(nil), text: nil, image: nil)
                        }
                        resultQueue.async {
                            result.append(createBlock)
                        }
                    }
                } else {
                    let createBlock = CreateBlock(type: .image(nil), text: nil, image: nil)
                    resultQueue.async {
                        result.append(createBlock)
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            resultQueue.async {
                let safeResult = result // snapshot result tránh race
                DispatchQueue.main.async {
                    completion(safeResult)
                }
            }
        }
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
        tagBtn.setTitle("create.add.tag".localized, for: .normal)
        
        viewModel.coordinate.accept(nil)
        viewModel.idAddress.accept(nil)
        mapBtn.setTitle("create.add.address".localized, for: .normal)
        
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
