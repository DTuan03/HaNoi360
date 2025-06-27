//
//  MyProfileVC.swift
//  HaNoi360
//
//  Created by Tuấn on 28/5/25.
//

import RxSwift
import RxCocoa
import UIKit
import Segmentio
import SnapKit
import Kingfisher

enum MyProfileType {
    case guest
    case owner
}

class MyProfileVC: BaseVC {
    let widthScreen = UIScreen.main.bounds.width

    let viewModel = MyProfileVM()
    lazy var myProfileType: MyProfileType = .owner
    
    lazy var nameHeaderLb = LabelFactory.createLabel(text: viewModel.user.value?.name, font: .bold18, textColor: .primaryTextColor)
    lazy var backHeaderIv = ImageViewFactory.createImageView(image: UIImage(systemName: "chevron.backward"), tintColor: .primaryTextColor)
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBlackColor
        view.addSubviews([nameHeaderLb, backHeaderIv])
        
        nameHeaderLb.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.centerX.equalToSuperview()
        }
        
        backHeaderIv.snp.makeConstraints { make in
            make.centerY.equalTo(nameHeaderLb.snp.centerY)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(24)
        }
        return view
    }()
    
    lazy var scrollView = {
        let sv = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor, bounces: false)
        sv.delegate = self
        return sv
    }()
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    lazy var backIv = ImageViewFactory.createImageView(image: UIImage(systemName: "chevron.backward"), tintColor: .iconColor)
    
    lazy var nameLb = LabelFactory.createLabel(text: viewModel.user.value?.name, font: .bold18, textColor: .primaryTextColor)
    
    lazy var avatarIv = ImageViewFactory.createImageView(image: .test, contentMode: .scaleAspectFill, radius: 40)
    
    lazy var blogLbBuilder = LabelStackBuilder()
        .setFirstLabel(text: "34", textColor: .primaryTextColor, font: .extraBoldItalic13)
        .setSecondLabel(text: "account.posts".localized, font: .extraBoldItalic13)
    
    lazy var numberBlogsLb = blogLbBuilder.build(spacing: 4, alignment: .center)
    
    lazy var followersLbBuilder = LabelStackBuilder()
        .setFirstLabel(text: "240", textColor: .primaryTextColor, font: .extraBoldItalic13)
        .setSecondLabel(text: "account.followers".localized, font: .extraBoldItalic13)
    
    lazy var followersLb = followersLbBuilder.build(spacing: 4, alignment: .center)
    
    lazy var followingLbBuilder = LabelStackBuilder()
        .setFirstLabel(text: "456", textColor: .primaryTextColor, font: .extraBoldItalic13)
        .setSecondLabel(text: "account.following".localized, font: .extraBoldItalic13)
    
    lazy var followingLb = followingLbBuilder.build(spacing: 4, alignment: .center)
    
    lazy var descriptionLb = LabelFactory.createLabel(text: "Yêu du lịch, thích trải nghiệm", font: .regular16)
    
    lazy var editProfileBtn = {
        let btn = ButtonFactory.createButton("account.edit.profile".localized, font: .medium14, textColor: .white, bgColor: .primaryColor, rounded: false, height: 30)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return btn
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        let infoSv = [avatarIv, numberBlogsLb, followersLb, followingLb].hStack(4, alignment: .center, distribution: .equalSpacing)
        let stv = [nameLb, descriptionLb, editProfileBtn].vStack(8, alignment: .leading, distribution: .fill)
        view.addSubviews([backIv, infoSv, stv])
        avatarIv.snp.makeConstraints { make in
            make.height.width.equalTo(80)
        }
        backIv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(24)
        }
        
        infoSv.snp.makeConstraints { make in
            make.top.equalTo(backIv.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(10)
        }
        
        stv.snp.makeConstraints { make in
            make.top.equalTo(infoSv.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        return view
    }()
    
    lazy var lineView = UIViewFactory.createLineView(height: 8, bgColor: .lineViewColor /*UIColor(hex: "#F1F1F1")*/)
    
    lazy var segmentioView: Segmentio = {
        let segment = Segmentio()
        let content = [
            SegmentioItem(title: "account.timeline".localized, image: nil),
            SegmentioItem(title: "Album", image: nil),
            SegmentioItem(title: "Check-in", image: nil)
        ]
        
        segment.setup(
            content: content,
            style: .onlyLabel,
            options: SegmentioOptions(
                backgroundColor: .backgroundColor,
                scrollEnabled: false,
                indicatorOptions: SegmentioIndicatorOptions(
                    type: .bottom,
                    ratio: 1,
                    height: 3,
                    color: .clear
                ),
                horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(
                    type: .none
                ),
                verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(
                    ratio: 0.6,
                    color: .clear
                ),
                imageContentMode: .center,
                labelTextAlignment: .center,
                labelTextNumberOfLines: 1,
                segmentStates: SegmentioStates(
                    defaultState: SegmentioState(
                        backgroundColor: .backgroundColor,
                        titleFont: .regular14,
                        titleTextColor: .gray
                    ),
                    selectedState: SegmentioState(
                        backgroundColor: .backgroundColor,
                        titleFont: .bold14,
                        titleTextColor: .primaryColor
                    ),
                    highlightedState: SegmentioState(
                        backgroundColor: .backgroundColor,
                        titleFont: .regular14,
                        titleTextColor: .gray
                    )
                )
            )
        )
        segment.selectedSegmentioIndex = 0
        
        segment.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return segment
    }()
    
    lazy var actionButtons = ImageLabelBuilder()
    
    lazy var contentTbv = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(MyProfileCell.self, forCellReuseIdentifier: "MyProfileCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubviews([contentTbv])
        
        contentTbv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(360 * viewModel.blogsPost.value.count)
        }
        
        return view
    }()
    
    lazy var checkInClv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CheckInImageCell.self, forCellWithReuseIdentifier: "CheckInImageCell")
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.register(CheckInHeaderView.self,
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                             withReuseIdentifier: "CheckInHeaderView")
        return cv
    }()
    
    lazy var checkInBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubviews([checkInClv])
        
        checkInClv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(700)
            make.height.equalTo(400)
        }
        
        return view
    }()
    
    lazy var albumClv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 32
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(AlbumImageCell.self, forCellWithReuseIdentifier: "AlbumImageCell")
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        cv.backgroundColor = .backgroundColor

        return cv
    }()
    
    lazy var albumBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.addSubviews([albumClv])
        
        albumClv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(700)
        }
        
        return view
    }()
    
    lazy var lineViewBottom = UIViewFactory.overlayView()
    
    lazy var stv = [topView, lineView, segmentioView, actionButtons, bottomView, albumBottomView, checkInBottomView].vStack(2)
    
    lazy var emptyTbv = {
        let tv = TableViewFactory.createTableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .clear
        tv.setLottieBackground(
            name: "emptyBlog",
            title: "account.empty.title".localized,
            message: "account.empty.message".localized,
            topAnimation: -150,
            topStv: -180
        )
        return tv
    }()
    
    var isEmptyBlog: Bool = false
    var isEmptyCheckIn: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if myProfileType == .guest {
            self.viewModel.isFollowing.accept(viewModel.user.value?.followers?.contains { $0.followerId == self.userId } ?? false)
        }
    }
    
    override func setupUI() {
        showUI()
        view.addSubviews([scrollView, headerView])
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([stv, lineViewBottom, emptyTbv])
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        stv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        lineViewBottom.snp.makeConstraints { make in
            make.top.equalTo(stv.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        emptyTbv.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(400)
        }
        
        self.segmentioView.selectedSegmentioIndex = 0
        self.bottomView.isHidden = false
        self.checkInBottomView.isHidden = true
        self.albumBottomView.isHidden = true
    }
    
    func showUI() {
        switch myProfileType {
        case .guest:
            actionButtons.isHidden = true
        case .owner:
            actionButtons.isHidden = false
            editProfileBtn.setTitle("account.edit.profile".localized, for: .normal)
        }
    }
    
    override func bindState() {
        viewModel.blogsPost
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.blogLbBuilder.first.text = "\(value.count)"
                self.contentTbv.reloadData()
                self.viewModel.filterImageAlbum()
                self.isEmptyBlog = value.isEmpty
                self.emptyTbv.isHidden = !value.isEmpty
            })
            .disposed(by: disposeBag)
        
        viewModel.image
            .skip(1)
            .subscribe(onNext: { [weak self] image in
                self?.viewModel.uploadImage()
            })
            .disposed(by: disposeBag)
        
        viewModel.isUploaded
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.addImageCheckIn {
                    self?.viewModel.fetchAllCheckIn{}
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.isLoading.accept(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.isDelete
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if value {
                    Toast.showToast(message: "common.delete.success".localized, image: "toast_success")
                    self.viewModel.getPlaces(authorId: userId) {}
                } else {
                    Toast.showToast(message: "common.delete.faild".localized, image: "toast_error")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.checkIn
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.checkInClv.reloadData()
                self.segmentioView.selectedSegmentioIndex = 2
                self.bottomView.isHidden = true
                self.checkInBottomView.isHidden = false
                self.albumBottomView.isHidden = true
                self.checkInClv.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(6)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo((Int(self.widthScreen / 3 + 50) * (value?.count ?? 0)))
                }
                self.isEmptyCheckIn = ((value?.isEmpty) != nil)
                self.emptyTbv.isHidden = !(value?.isEmpty ?? true)
            })
            .disposed(by: disposeBag)
        
        viewModel.user
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.nameHeaderLb.text = value?.name
                self.nameLb.text = value?.name
                self.descriptionLb.text = value?.interest
                self.avatarIv.kf.setImage(with: URL(string: value?.avatarUrl ?? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"))
                self.followersLbBuilder.first.text = "\(value?.followers?.count ?? 0)"
                self.followingLbBuilder.first.text = "\(value?.following?.count ?? 0)"
            })
            .disposed(by: disposeBag)
        
        viewModel.allUrlImage
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.albumClv.reloadData()
                self.segmentioView.selectedSegmentioIndex = 1
                self.bottomView.isHidden = true
                self.checkInBottomView.isHidden = true
                self.albumBottomView.isHidden = false
                let number = (value.count + 2) / 3
                let height = Int(self.widthScreen / 3 + 10) * number
                self.albumClv.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(6)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(height)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isFollowing
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if self.myProfileType == .guest {
                    if viewModel.isFollowing.value {
                        editProfileBtn.setTitle("account.following.new".localized, for: .normal)
                    } else {
                        editProfileBtn.setTitle("account.follow".localized, for: .normal)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func setupEvent() {
        segmentioView.valueDidChange = { segmentio, index in
            print("Selected index: \(index)")
            switch index {
            case 0:
                self.bottomView.isHidden = false
                self.checkInBottomView.isHidden = true
                self.albumBottomView.isHidden = true
                self.emptyTbv.isHidden = !self.isEmptyBlog
            case 1:
                self.bottomView.isHidden = true
                self.checkInBottomView.isHidden = true
                self.albumBottomView.isHidden = false
                self.emptyTbv.isHidden = !self.isEmptyBlog
            case 2:
                self.bottomView.isHidden = true
                self.albumBottomView.isHidden = true
                self.checkInBottomView.isHidden = false
                self.viewModel.fetchAllCheckIn{}
                self.emptyTbv.isHidden = !self.isEmptyCheckIn
            default:
                self.bottomView.isHidden = false
                self.checkInBottomView.isHidden = true
            }
        }
        
        let backIvTap = UITapGestureRecognizer(target: self, action: #selector(backIvAction))
        backIv.addGestureRecognizer(backIvTap)
        
        let backHeaderIvTap = UITapGestureRecognizer(target: self, action: #selector(backHeaderIvAction))
        backHeaderIv.addGestureRecognizer(backHeaderIvTap)
        
        actionButtons.writePostButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(NewCreatePostVC(), animated: true)
            })
            .disposed(by: disposeBag)
        
        actionButtons.checkinButton.rx.tap
            .subscribe(onNext: {
                self.openCamera()
            })
            .disposed(by: disposeBag)
        
        editProfileBtn.rx.tap
            .subscribe(onNext: {
                switch self.myProfileType {
                case .guest:
                    if self.viewModel.isFollowing.value {
                        self.viewModel.unfollowUser(currentUserId: self.userId, targetUserId: (self.viewModel.user.value?.userId)!) {_ in
                            let numberFollowers = (self.viewModel.user.value?.followers?.count ?? 0) - 1
                            self.followersLbBuilder.first.text = "\(numberFollowers)"
                            self.viewModel.isFollowing.accept(false)
                        }
                    } else {
                        self.viewModel.followUser(currentUserId: self.userId, targetUserId: (self.viewModel.user.value?.userId)!) {
                            let numberFollowers = (self.viewModel.user.value?.followers?.count ?? 0) + 1
                            self.followersLbBuilder.first.text = "\(numberFollowers)"
                            self.viewModel.isFollowing.accept(true)
                        }
                    }
                case .owner:
                    let vc = ProfileVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func backIvAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backHeaderIvAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false // Hoặc true nếu muốn chỉnh sửa
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "account.noti".localized,
                                          message: "popup.camera.faild".localized,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    var isSegmentPinned = false
    
    var segmentOriginalY: CGFloat = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if segmentOriginalY == 0 {
            let segmentioFrameInView = segmentioView.convert(segmentioView.bounds, to: self.view)
            let actionButtonFrameInView = segmentioView.convert(actionButtons.bounds, to: self.view)
            segmentOriginalY = segmentioFrameInView.origin.y + actionButtonFrameInView.origin.y
        }
    }
}

extension MyProfileVC: UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maxOffset: CGFloat = 110
        let normalized = min(max(offsetY / maxOffset, 0), 1)
        self.headerView.backgroundColor = UIColor.whiteBlackColor.withAlphaComponent(normalized)
        self.nameHeaderLb.textColor = UIColor.primaryTextColor.withAlphaComponent(normalized)
        self.backHeaderIv.tintColor = UIColor.primaryTextColor.withAlphaComponent(normalized)
        let frameInView = segmentioView.convert(segmentioView.bounds, to: self.view)
        
        if frameInView.origin.y <= headerView.frame.height, !isSegmentPinned {
            isSegmentPinned = true
            pinSegment()
        } else if scrollView.contentOffset.y < (segmentOriginalY - headerView.frame.height), isSegmentPinned {
            isSegmentPinned = false
            unpinSegment()
        }
    }
    
    func pinSegment() {
        segmentioView.removeFromSuperview()
        actionButtons.removeFromSuperview()
        view.addSubviews([segmentioView, actionButtons])
        
        segmentioView.snp.remakeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        actionButtons.snp.remakeConstraints { make in
            make.top.equalTo(segmentioView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
    }
    
    func unpinSegment() {
        segmentioView.removeFromSuperview()
        actionButtons.removeFromSuperview()
        stv.insertArrangedSubview(segmentioView, at: 2)
        stv.insertArrangedSubview(actionButtons, at: 3)
        
        segmentioView.snp.remakeConstraints { make in
            make.height.equalTo(40)
        }
        
        actionButtons.snp.remakeConstraints { make in
            make.height.equalTo(35)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NewDetailVC()
        detailVC.viewModel.placeId.accept(viewModel.blogsPost.value[indexPath.row].blogId)
        isLoading.accept(true)
        detailVC.viewModel.isFavoritePlace {
            detailVC.viewModel.featchPlace() {
                detailVC.viewModel.featchReview() {
                    self.isLoading.accept(false)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
}

extension MyProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.blogsPost.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath) as? MyProfileCell else {
            return UITableViewCell()
        }
        switch myProfileType {
        case .guest:
            cell.deleteIv.isHidden = true
        case .owner:
            cell.deleteIv.isHidden = false
        }
        let model = viewModel.blogsPost.value[indexPath.row]
        cell.configData(model: model)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension MyProfileVC: MyProfileCellDelegate {
    func didDeleteBlog(cell: UITableViewCell) {
        guard let indexPath = contentTbv.indexPath(for: cell) else { return }
        let popupVC = PopupVC()
        popupVC.titleLabel.text = "popup.cf.delete".localized
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.onOk = {
            self.viewModel.deleteBlog(blogId: self.viewModel.blogsPost.value[indexPath.row].blogId!){}
        }
        self.present(popupVC, animated: true)
    }
}

extension MyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            print("Ảnh chụp được: \(image)")
            viewModel.image.accept(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MyProfileVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
            case checkInClv:
                return viewModel.checkIn.value?.count ?? 0
            case albumClv:
                return 1
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case checkInClv:
                return viewModel.checkIn.value?[section].url.count ?? 0
            case albumClv:
                return viewModel.allUrlImage.value.count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case checkInClv:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckInImageCell", for: indexPath) as? CheckInImageCell else {
                    return UICollectionViewCell()
                }
                
                let url = viewModel.checkIn.value?[indexPath.section].url[indexPath.row]
                cell.setImage(urlString: url)
                return cell
            case albumClv:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumImageCell", for: indexPath) as? AlbumImageCell else {
                return UICollectionViewCell()
            }
            
            let url = viewModel.allUrlImage.value[indexPath.row]
            cell.setImage(urlString: url)
            return cell
            default:
                return UICollectionViewCell()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
            case checkInClv:
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: "CheckInHeaderView",
                        for: indexPath) as! CheckInHeaderView
                    
                    let date = viewModel.checkIn.value?[indexPath.section].createAt ?? ""
                    header.titleLabel.text = date
                    return header
                }
            case albumClv:
                print("f")
            default:
                return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
}

extension MyProfileVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case checkInClv:
            let url = viewModel.checkIn.value?[indexPath.section].url[indexPath.row] ?? ""
            let vc = FullImageVC()
            vc.imageView.kf.setImage(with: URL(string: url))
            self.navigationController?.pushViewController(vc, animated: true)
            case albumClv:
            let url = viewModel.allUrlImage.value[indexPath.row]
            let vc = FullImageVC()
            vc.imageView.kf.setImage(with: URL(string: url))
            self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("loi")
        }
    }
}

extension MyProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView {
            case checkInClv:
                return CGSize(width: collectionView.frame.width, height: 30)
            case albumClv:
                return CGSize(width: 0, height: 0)
            default:
                return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case checkInClv:
                return CGSize(width: widthScreen / 3 - 40  , height: widthScreen / 3 + 20)
            case albumClv:
                return CGSize(width: widthScreen / 3 - 10, height: widthScreen / 3 - 10)
            default:
                return CGSize(width: 0, height: 0)
        }
    }
}

class LabelStackBuilder {
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    
    func setFirstLabel(text: String, textColor: UIColor = .black, font: UIFont = .regular16) -> Self {
        firstLabel.text = text
        firstLabel.textColor = textColor
        firstLabel.font = font
        return self
    }
    
    func setSecondLabel(text: String, textColor: UIColor = .primaryTextColor, font: UIFont = .regular16) -> Self {
        secondLabel.text = text
        secondLabel.textColor = textColor
        secondLabel.font = font
        return self
    }
    
    func build(axis: NSLayoutConstraint.Axis = .vertical,
               spacing: CGFloat = 8,
               alignment: UIStackView.Alignment = .fill,
               distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return [firstLabel, secondLabel].vStack(spacing, alignment: alignment, distribution: distribution)
    }
    
    var first: UILabel {
        return firstLabel
    }
    
    var second: UILabel {
        return secondLabel
    }
}

class ImageLabelBuilder: UIView {
    lazy var topView = UIViewFactory.createLineView(height: 2, bgColor: .lineViewColor)
    
    lazy var bottomView = UIViewFactory.createLineView(height: 2, bgColor: .lineViewColor)
    
    lazy var writePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("account.write.articles".localized, for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .iconColor
        button.setTitleColor(.secondaryTextColor, for: .normal)
        button.titleLabel?.font = .medium14
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    lazy var checkinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check-in", for: .normal)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .iconColor
        button.setTitleColor(.secondaryTextColor, for: .normal)
        button.titleLabel?.font = .medium14
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lineViewColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .backgroundColor
        let stv = [writePostButton, checkinButton].hStack(distribution: .fillEqually)
        addSubviews([topView, stv, dividerView, bottomView])
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        stv.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().inset(2)
            make.width.equalTo(2)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(stv.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
