//
//  NewDetailVC.swift
//  HaNoi360
//
//  Created by Tuấn on 24/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class NewDetailVC: BaseVC {
    let viewModel = NewDetailVM()
    
    lazy var favoriteIV = ImageViewFactory.createImageView(image: UIImage(systemName: "heart"),
                                                           tintColor: UIColor(hex: "#666666"))
    
    lazy var countFavoriteLb = LabelFactory.createLabel(text: "1k", font: .regular16, textColor: UIColor(hex: "#666666"))
    
    lazy var favoriteSv = [favoriteIV, countFavoriteLb].hStack(4, alignment: .center)
    
    lazy var commentIV = ImageViewFactory.createImageView(image: UIImage(systemName: "pencil.and.list.clipboard"),
                                                          tintColor: UIColor(hex: "#666666"))
    
    lazy var countCommentLb = LabelFactory.createLabel(text: "100", font: .regular16, textColor: UIColor(hex: "#666666"))
    
    lazy var commentSv = [commentIV, countCommentLb].hStack(4, alignment: .center)
    
    lazy var shareIV = ImageViewFactory.createImageView(image: UIImage(systemName: "square.and.arrow.up"),
                                                        tintColor: UIColor(hex: "#666666"))
    
    lazy var mapIV = ImageViewFactory.createImageView(image: UIImage(systemName: "map"),
                                                           tintColor: UIColor(hex: "#666666"))
    
    lazy var calendarIV = ImageViewFactory.createImageView(image: UIImage(systemName: "calendar"),
                                                           tintColor: UIColor(hex: "#666666"))
    
    lazy var tabBarSv = [favoriteSv, commentSv, shareIV, mapIV, calendarIV].hStack(8, alignment: .center, distribution: .fillEqually)
    
    lazy var tabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubviews([tabBarSv])
        favoriteIV.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        commentIV.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        calendarIV.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        mapIV.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        shareIV.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        tabBarSv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        return view
    }()
    
    lazy var scrollView = {
        let sv = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor, showsVerticalScrollIndicator: true, bounces: false)
        return sv
    }()
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    lazy var backIv = ImageViewFactory.createImageView(image: .back)
    
    lazy var nameAuthor = LabelFactory.createLabel(text: viewModel.place.value?.authorName, font: .bold16, textColor: .primaryTextColor, numberOfLines: 1)
    
    lazy var avatarAuthor: UIImageView = {
        let iv = ImageViewFactory.createImageView(contentMode: .scaleAspectFill, radius: 25)
        iv.kf.setImage(with: URL(string: viewModel.place.value?.authorAvatar ?? ""))
        iv.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        return iv
    }()
    
    lazy var locationIv = ImageViewFactory.createImageView(image: .location)
    
    lazy var locationLb = LabelFactory.createLabel(text: viewModel.place.value?.address, font: .medium14, textColor: UIColor(hex: "#808080"), numberOfLines: 1)
    
//    lazy var locationSv = [locationIv, locationLb].hStack(4, distribution: .fill)
    
    lazy var infoSv = [avatarAuthor, [nameAuthor, locationLb].vStack(2, distribution: .fill)].hStack(12, alignment: .center, distribution: .fill)
    
    lazy var handleSv = [favoriteIV, calendarIV].hStack(16, distribution: .fillProportionally)
    
    lazy var containerView = {
        locationIv.backgroundColor = .red
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubviews([backIv, infoSv/*, handleSv*/])
        backIv.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(4)
            make.width.equalTo(50)
        }
        
        infoSv.snp.makeConstraints { make in
            make.left.equalTo(backIv.snp.right).offset(8)
            make.top.bottom.right.equalToSuperview()
//            make.right.equalTo(handleSv.snp.left).inset(4)
        }
        
//        handleSv.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.right.equalToSuperview().inset(8)
//        }
        return view
    }()
    
    lazy var categoryClv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        cv.dataSource = self
                cv.delegate = self
        return cv
    }()
    
    lazy var titleLb = LabelFactory.createLabel(text: viewModel.place.value?.title, font: .bold22)
    
    lazy var createAtLb = LabelFactory.createLabel(text: viewModel.place.value?.createAt?.toString(format: "'Ngày' dd 'tháng' MM 'năm' yyyy"), font: .extraBoldItalic14, textColor: UIColor(hex: "#666666"))
    
    lazy var infoPost = [titleLb, createAtLb].vStack(4)
    
    lazy var contentTbv = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(DetailHeadingCell.self, forCellReuseIdentifier: "DetailHeadingCell")
        tableView.register(DetailTextCell.self, forCellReuseIdentifier: "DetailTextCell")
        tableView.register(DetailImageCell.self, forCellReuseIdentifier: "DetailImageCell")
        tableView.dataSource = self
        return tableView
    }()
        
    lazy var writeReviewLabel = LabelFactory.createLabel(text: "Viết nhận xét", font: .medium20)
    
    lazy var avatarUser = ImageViewFactory.createImageView(image: .test,
                                                           contentMode: .scaleAspectFill,
                                                           radius: 25)
    
    lazy var reviewTextView = {
        let tv = TextViewFactory.createTextView(text: "",
                                                font: .regular14,
                                                cornerRadius: 10,
                                                borderColor: .lightGray,
                                                borderWidth: 1,
                                                placeholder: "Viết nhận xét")
        tv.delegate = self
        return tv
    }()
    
    lazy var starReview = CosmosViewFactory.createCosmosView()
    
    lazy var rangeReviewLabel = LabelFactory.createLabel(text: "0/250", font: .regular16, textColor: .lightGray)
    
    lazy var sendReviewBtn = {
        let btn = ButtonFactory.createButton("Gửi", rounded: false, height: 38)
        btn.layer.cornerRadius = 16
        btn.isEnabled = false
        btn.backgroundColor = .lightGray
        return btn
    }()
    
    lazy var reviewLabel = LabelFactory.createLabel(text: "Nhận xét", font: .medium20)
    
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.bounces = false

        return tableView
    }()
    
    lazy var moreLabel = LabelFactory.createLabel(text: "Nhiều hơn", font: .medium14, textColor: .primaryColor)
    
    override func setupUI() {
        view.addSubviews([scrollView, tabBarView])
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tabBarView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([containerView, categoryClv, infoPost, contentTbv, writeReviewLabel, avatarUser, reviewTextView, starReview, rangeReviewLabel, sendReviewBtn, reviewLabel, tableView, moreLabel])
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        categoryClv.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
        infoPost.snp.makeConstraints { make in
            make.top.equalTo(categoryClv.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentTbv.snp.makeConstraints { make in
            make.top.equalTo(infoPost.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(4)
            make.height.equalTo(1)
//            make.bottom.equalToSuperview()
        }
        
        writeReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTbv.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        avatarUser.snp.makeConstraints { make in
            make.top.equalTo(writeReviewLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(32)
            make.height.width.equalTo(50)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(writeReviewLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(avatarUser.snp.right).offset(50)
            make.height.equalTo(100)
        }
        
        starReview.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(8)
            make.left.equalTo(reviewTextView.snp.left)
        }
        
        rangeReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(20)
        }
                
        sendReviewBtn.snp.makeConstraints { make in
            make.top.equalTo(rangeReviewLabel.snp.bottom).offset(16)
            make.width.equalTo(80)
            make.right.equalToSuperview().inset(24)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(sendReviewBtn.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        moreLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTbv.snp.updateConstraints { make in
            make.height.equalTo(contentTbv.contentSize.height)
        }
    }
    
    override func bindState() {
        viewModel.categoryHastag
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.categoryClv.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.countReview
            .subscribe(onNext: { [weak self] count in
                guard let `self` = self else {return}
                self.rangeReviewLabel.text = "\(count)/250"
            })
            .disposed(by: disposeBag)
        
        viewModel.contentReview
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if !value.isEmpty {
                    self.sendReviewBtn.isEnabled = true
                    self.sendReviewBtn.backgroundColor = .primaryButtonColor
                } else {
                    self.sendReviewBtn.isEnabled = false
                    self.sendReviewBtn.backgroundColor = .lightGray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isReview
            .subscribe(onNext: { [weak self] isReview in
                guard let self = self else { return }
                if isReview {
                    Toast.showToast(message: "Đánh giá thành công", image: "toast_success")
                    self.reviewTextView.text = ""
                    self.starReview.rating = 1
                    self.viewModel.featchReview()
                    self.sendReviewBtn.isEnabled = false
                    self.sendReviewBtn.backgroundColor = .lightGray
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.viewModel.checkContentReview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    

}

extension NewDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryHastag.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
        
        let label = LabelFactory.createLabel(font: .bold12, textColor: UIColor(hex: "#666666"), numberOfLines: 1)
        label.text = viewModel.categoryHastag.value[indexPath.row]
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        return cell
    }
}

extension NewDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = viewModel.categoryHastag.value[indexPath.row]
        label.font = UIFont.bold12
        
        let maxWidth: CGFloat = collectionView.frame.width
        let labelSize = label.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        let sizeForItem = CGSize(width: labelSize.width + 5, height: 36)
        return sizeForItem
    }
}

extension NewDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.place.value?.contentBlocks.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let block = viewModel.place.value?.contentBlocks[indexPath.row]
        
        switch block?.type {
        case .heading:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeadingCell", for: indexPath) as? DetailHeadingCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: block?.value ?? "")
            
            return cell
            
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTextCell", for: indexPath) as? DetailTextCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: block?.value ?? "")
           
            return cell
            
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailImageCell", for: indexPath) as? DetailImageCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: block?.value ?? "placeholderImage2")
            
            return cell
        case .none:
            return UITableViewCell()
        }
    }
}

extension NewDetailVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        self.viewModel.contentReview.accept(updatedText)
        return updatedText.count <= 250
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.countReview.accept(textView.text.count)
    }
}

