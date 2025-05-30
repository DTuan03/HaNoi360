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

enum MyProfileType {
    case guest
    case owner
}

class MyProfileVC: BaseVC {
    let viewModel = MyProfileVM()
    lazy var myProfileType: MyProfileType = .owner
    
    lazy var nameHeaderLb = LabelFactory.createLabel(text: "Đặng Anh Tuấn", font: .bold18, textColor: UIColor(hex: "#000000", alpha: 1))
    lazy var backHeaderIv = ImageViewFactory.createImageView(image: UIImage(systemName: "chevron.backward"), tintColor: UIColor(hex: "#000000", alpha: 1))

    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1)
        view.addSubviews([nameHeaderLb, backHeaderIv])
        
        nameHeaderLb.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.centerX.equalToSuperview()
        }
        
        backHeaderIv.snp.makeConstraints { make in
            make.centerY.equalTo(nameHeaderLb.snp.centerY)
            make.left.equalToSuperview().offset(10)
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
    
    lazy var backIv = ImageViewFactory.createImageView(image: UIImage(systemName: "chevron.backward"), tintColor: .black)
    
    lazy var nameLb = LabelFactory.createLabel(text: "Đặng Anh Tuấn", font: .bold18, textColor: .black)
    
    lazy var avatarIv = ImageViewFactory.createImageView(image: .test, contentMode: .scaleAspectFill, radius: 40)
    
    lazy var blogLbBuilder = LabelStackBuilder()
        .setFirstLabel(text: "34", textColor: .black, font: .extraBoldItalic13)
        .setSecondLabel(text: "Bài viết", font: .extraBoldItalic13)

    lazy var numberBlogsLb = blogLbBuilder.build(spacing: 4, alignment: .center)

    lazy var followersLbBuilder = LabelStackBuilder()
        .setFirstLabel(text: "240", textColor: .black, font: .extraBoldItalic13)
        .setSecondLabel(text: "người theo dõi", font: .extraBoldItalic13)

    lazy var followersLb = followersLbBuilder.build(spacing: 4, alignment: .center)
    
    lazy var followingLbBuilder = LabelStackBuilder()
        .setFirstLabel(text: "456", textColor: .black, font: .extraBoldItalic13)
        .setSecondLabel(text: "đang theo dõi", font: .extraBoldItalic13)

    lazy var followingLb = followingLbBuilder.build(spacing: 4, alignment: .center)
    
    lazy var descriptionLb = LabelFactory.createLabel(text: "Yêu du lịch, thích trải nghiệm", font: .regular16)
    
    lazy var editProfileBtn = {
        let btn = ButtonFactory.createButton("Chỉnh sửa trang cá nhân", font: .medium14, textColor: .white, bgColor: .primaryColor, rounded: false, height: 30)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return btn
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let infoSv = [avatarIv, numberBlogsLb, followersLb, followingLb].hStack(4, alignment: .center, distribution: .equalSpacing)
        let stv = [nameLb, descriptionLb, editProfileBtn].vStack(8, alignment: .leading, distribution: .fill)
        view.addSubviews([backIv, infoSv, stv])
        avatarIv.snp.makeConstraints { make in
            make.height.width.equalTo(80)
        }
        backIv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(10)
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
    
    lazy var lineView = UIViewFactory.createLineView(height: 8, bgColor: UIColor(hex: "#F1F1F1"))
    
    lazy var segmentioView: Segmentio = {
        let segment = Segmentio()
        let content = [
            SegmentioItem(title: "Dòng thời gian", image: nil),
            SegmentioItem(title: "Album", image: nil),
            SegmentioItem(title: "Check-in", image: nil)
        ]
        
        segment.setup(
            content: content,
            style: .onlyLabel,
            options: SegmentioOptions(
                backgroundColor: .white,
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
                        backgroundColor: .white,
                        titleFont: .regular14,
                        titleTextColor: .gray
                    ),
                    selectedState: SegmentioState(
                        backgroundColor: .white,
                        titleFont: .bold14,
                        titleTextColor: .primaryColor
                    ),
                    highlightedState: SegmentioState(
                        backgroundColor: .white,
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
        view.backgroundColor = .white
        
        view.addSubviews([contentTbv])
//        actionButtons.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(35)
//        }
        
        contentTbv.snp.makeConstraints { make in
//            make.top.equalTo(actionButtons.snp.bottom).offset(6)
            make.top.equalToSuperview().offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(350 * viewModel.itemsPlace.value.count)
        }
        
        return view
    }()
    
    lazy var lineViewBottom = UIViewFactory.overlayView()
    
    lazy var stv = [topView, lineView, segmentioView, actionButtons, bottomView].vStack(2)
    
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
        
        contentView.addSubviews([stv, lineViewBottom])
        
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
    }
    
    func showUI() {
        switch myProfileType {
        case .guest:
            actionButtons.isHidden = true
            editProfileBtn.setTitle("Theo dõi", for: .normal)
        case .owner:
            actionButtons.isHidden = false
            editProfileBtn.setTitle("Chỉnh sửa trang cá nhân", for: .normal)
        }
    }
    
    override func bindState() {
        viewModel.itemsPlace
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.blogLbBuilder.first.text = "\(value.count)"
                self.contentTbv.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func setupEvent() {
        segmentioView.valueDidChange = { segmentio, index in
            print("Selected index: \(index)")
            // Xử lý khi chuyển tab
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
    }
    
    @objc func backIvAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backHeaderIvAction() {
        self.navigationController?.popViewController(animated: true)
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
        self.headerView.backgroundColor = UIColor(hex: "#FFFFFF", alpha: normalized)
        self.nameHeaderLb.textColor = UIColor(hex: "#000000", alpha: normalized)
        self.backHeaderIv.tintColor = UIColor(hex: "#000000", alpha: normalized)
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
    
    
}

extension MyProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsPlace.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath) as? MyProfileCell else {
            return UITableViewCell()
        }
        let model = viewModel.itemsPlace.value[indexPath.row]
        cell.configData(model: model)
        cell.selectionStyle = .none
        return cell
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
    
    func setSecondLabel(text: String, textColor: UIColor = .black, font: UIFont = .regular16) -> Self {
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
    lazy var topView = UIViewFactory.createLineView(height: 2, bgColor: UIColor(hex: "#F1F1F1"))
    
    lazy var bottomView = UIViewFactory.createLineView(height: 2, bgColor: UIColor(hex: "#F1F1F1"))
    
    lazy var writePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Viết bài", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .gray
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .medium14
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    lazy var checkinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check-in", for: .normal)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .gray
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .medium14
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F1F1F1")
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
        self.backgroundColor = .white
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
