//
//  DetailVC.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit
import MapKit
import Cosmos
import Kingfisher

class DetailVC: BaseVC {
    let viewModel = DetailVM()
    
    lazy var safeAreaView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0)
        return view
    }()
    
    lazy var navigationView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0)
        return view
    }()
    
    func createRoundedIconContainer(borderColor: UIColor = UIColor(hex: "#F3F4F3")) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
//        view.layer.borderWidth = 1
//        view.layer.borderColor = borderColor.cgColor
        return view
    }
    
    lazy var backIV = ImageViewFactory.createImageView(image: .back)
    
    lazy var favoriteIV = ImageViewFactory.createImageView(image: UIImage(systemName: "heart"),
                                                           tintColor: .black)
    
    lazy var calendarIV = ImageViewFactory.createImageView(image: UIImage(systemName: "calendar"),
                                                           tintColor: .black)
    
    lazy var backView = createRoundedIconContainer()
    lazy var favoriteView = createRoundedIconContainer()
    lazy var calendarView = createRoundedIconContainer()
    
    lazy var mainScrollView = {
        let sv = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor, bounces: false)
        sv.delegate = self
        return sv
    }()
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    lazy var imageScrollView = {
        let sv = ScrollViewFactory.createScrollView(backgroundColor: .clear)
        sv.layer.cornerRadius = 16
        sv.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        sv.clipsToBounds = true

        return sv
    }()
    
    lazy var pageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 10
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .primaryColor
        pc.pageIndicatorTintColor = .white
        pc.hidesForSinglePage = true
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    var timer: Timer?
    var currentIndex = 0
    
    lazy var nameLabel = LabelFactory.createLabel(text: viewModel.place.value?.name,
                                                  font: .bold22,
                                                  numberOfLines: 2)
    
    lazy var addressLabel = LabelFactory.createLabel(text: viewModel.place.value?.address,
                                                     font: .regular16,
                                                     numberOfLines: 2)
    
    lazy var starIconIV = ImageViewFactory.createImageView(image: .star)
    
    lazy var avgReviewsLabel = LabelFactory.createLabel(text: String(viewModel.place.value?.avgRating ?? 0),
                                                        font: .regular16)
        
    lazy var totalReviewLabel = LabelFactory.createLabel(text: String(viewModel.place.value?.totalReviews ?? 0) + " Nhận xét",
                                                         font: .regular16)
    
    lazy var athorLabel = LabelFactory.createLabel(text: "bởi \(viewModel.place.value?.authorName ?? "chưa xác định")",
                                                   font: .regular16)
    
    lazy var starIconIVAndAvgLabelSV = [starIconIV, avgReviewsLabel].hStack(4, alignment: .center)
    
    lazy var starIconAvgAndTotalSV = [starIconIVAndAvgLabelSV, totalReviewLabel].hStack(-20, distribution: .equalCentering)
    
    lazy var sv1 = [starIconAvgAndTotalSV, athorLabel].vStack(5, alignment: .trailing)
    
    lazy var sv2 = [nameLabel, addressLabel].vStack(5)
    
    lazy var sv3 = [sv2, sv1].hStack(0, distribution: .fillEqually)
    
    lazy var aboutLabel = LabelFactory.createLabel(text: "Mô tả",
                                                   font: .medium20)
    
    lazy var detailAboutLabel = {
        let label = LabelFactory.createLabel(text: viewModel.place.value?.description, font: .regular16, numberOfLines: 5)
        label.lineBreakMode = .byTruncatingTail
        label.addReadMore(trailingText: " Đọc thêm", trailingFont: .bold16, trailingColor: UIColor(hex: "#0369A1"))
        return label
    }()
    
    lazy var mapLabel = LabelFactory.createLabel(text: "Bản đồ",
                                                 font: .medium20)
       
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 12
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        return map
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
        return btn
    }()
    
    lazy var reviewLabel = LabelFactory.createLabel(text: "Nhận xét", font: .medium20)
    
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var moreLabel = LabelFactory.createLabel(text: "Nhiều hơn", font: .medium14, textColor: .primaryColor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        setupMapView(latitude: CLLocationDegrees(viewModel.place.value?.coordinates.latitude ?? 0), longitude: CLLocationDegrees(viewModel.place.value?.coordinates.longitude ?? 0))
    }
    
    override func setupUI() {
        setupIcon(backIV, in: backView)
        setupIcon(favoriteIV, in: favoriteView)
        setupIcon(calendarIV, in: calendarView)
        
        view.addSubviews([mainScrollView, safeAreaView, navigationView, backView, favoriteView, calendarView])
        
        safeAreaView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        backView.snp.makeConstraints { make in
            make.centerY.equalTo(navigationView.snp.centerY).offset(-10)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(30)
        }
        
        calendarView.snp.makeConstraints { make in
            make.centerY.equalTo(navigationView.snp.centerY).offset(-10)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }
        
        favoriteView.snp.makeConstraints { make in
            make.centerY.equalTo(navigationView.snp.centerY).offset(-10)
            make.right.equalTo(calendarView.snp.left).inset(-20)
            make.width.height.equalTo(30)
        }
        
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainScrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-60)
            make.left.right.bottom.equalToSuperview()
            make.width.equalTo(mainScrollView.snp.width)
            make.height.equalTo(1800)
        }
        
        contentView.addSubviews([imageScrollView, pageControl, sv3, aboutLabel, detailAboutLabel, mapLabel, mapView, writeReviewLabel, avatarUser, reviewTextView, starReview, rangeReviewLabel, sendReviewBtn, reviewLabel, tableView, moreLabel])
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(450)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageScrollView.snp.bottom).inset(4)
        }
        pageControl.numberOfPages = viewModel.place.value?.subPlaceImage?.count ?? 0
        
        addContentToScrollView()
        
        sv3.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        aboutLabel.snp.makeConstraints { make in
            make.top.equalTo(sv3.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
        
        detailAboutLabel.snp.makeConstraints { make in
            make.top.equalTo(aboutLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mapLabel.snp.makeConstraints { make in
            make.top.equalTo(detailAboutLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(mapLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        writeReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
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
    
    func setupIcon(_ iconView: UIView, in container: UIView) {
        container.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func bindState() {
        viewModel.isFavorite
            .subscribe(onNext: { isFavorite in
                if isFavorite {
                    self.favoriteIV.image = UIImage(systemName: "heart.fill")
                    self.favoriteIV.tintColor = .red
                } else {
                    self.favoriteIV.image = UIImage(systemName: "heart")
                    self.favoriteIV.tintColor = .black
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isAddFavorite
            .subscribe(onNext: { isFavorite in
                if isFavorite {
                    Toast.showToast(message: "Yêu thích thành công", image: "toast_success")
                } else {
                    Toast.showToast(message: "Yêu thích thất bại", image: "toast_error")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isDeleteFavorite
            .subscribe(onNext: { isFavorite in
                if isFavorite {
                    Toast.showToast(message: "Đã bỏ yêu thích", image: "toast_success")
                } else {
                    Toast.showToast(message: "Bỏ yêu thích thất bại", image: "toast_error")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.countReview
            .subscribe(onNext: { [weak self] count in
                guard let `self` = self else {return}
                self.rangeReviewLabel.text = "\(count)/250"
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.isLoading.accept(value)
                self.isBgWhiteLoading.accept(value)
            })
            .disposed(by: disposeBag)
    }
    
    func setupMapView(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        // Add annotation (pin)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = viewModel.place.value?.name ?? "Địa điểm"
        mapView.addAnnotation(annotation)
    }
    
    override func setupEvent() {
        let backIVTap = UITapGestureRecognizer(target: self, action: #selector(backIVAction))
        backIV.addGestureRecognizer(backIVTap)
        
        let favoriteIVTap = UITapGestureRecognizer(target: self, action: #selector(favoriteIVAction))
        favoriteIV.addGestureRecognizer(favoriteIVTap)
        
        let calendarViewTap = UITapGestureRecognizer(target: self, action: #selector(calendarViewAction))
        calendarView.addGestureRecognizer(calendarViewTap)
        
        let mapViewTap = UITapGestureRecognizer(target: self, action: #selector(mapViewAction))
        mapView.addGestureRecognizer(mapViewTap)
    }
    
    @objc func backIVAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func favoriteIVAction() {
        if viewModel.isFavorite.value {
            viewModel.deleteFavorite()
        } else {
            viewModel.addFavorite()
        }
    }
    
    @objc func calendarViewAction() {
        let vc = AddCalendarVC()
        vc.viewModel.placeId.accept(self.viewModel.placeId.value ?? "")
        vc.viewModel.place.accept(self.viewModel.place.value)
        vc.viewModel.featchPlaceCalendar()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @objc func mapViewAction() {
        let vc = MapDetailVC()
        vc.placeLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(viewModel.place.value?.coordinates.latitude ?? 0), longitude: CLLocationDegrees(viewModel.place.value?.coordinates.longitude ?? 0))
        vc.namePlace = viewModel.place.value?.name
        vc.address = viewModel.place.value?.address
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addContentToScrollView() {
        imageScrollView.frame.size.width = UIScreen.main.bounds.width
        imageScrollView.contentSize = CGSize(width: imageScrollView.frame.width * CGFloat(viewModel.place.value?.subPlaceImage?.count ?? 0), height: imageScrollView.frame.height)
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.isPagingEnabled = true
        imageScrollView.isScrollEnabled = true

        if let subImage = viewModel.place.value?.subPlaceImage {
            for (index, item) in subImage.enumerated() {
                let contentView = UIView()
                imageScrollView.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(imageScrollView.frame.width * CGFloat(index))
                    make.top.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalToSuperview()
                }
                lazy var image = ImageViewFactory.createImageView(contentMode: .scaleToFill)
                image.kf.setImage(with: URL(string: item))
                contentView.addSubviews([image])
                image.snp.makeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    make.height.equalToSuperview()
                }
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextImage() {
        let nextIndex = currentIndex + 1
        if nextIndex < viewModel.place.value?.subPlaceImage?.count ?? 0 {
            currentIndex = nextIndex
            pageControl.currentPage = nextIndex
        } else {
            currentIndex = 0
            pageControl.currentPage = 0
        }
        
        let xOffset = CGFloat(currentIndex) * imageScrollView.frame.width
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
        }, completion: nil)
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension DetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension DetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            let offsetY = mainScrollView.contentOffset.y
            
            let maxOffset: CGFloat = mainScrollView.frame.height - navigationView.frame.height * 15
            
            let alpha = min(1, max(0, offsetY / maxOffset))
//            navigationView.alpha = alpha
            safeAreaView.backgroundColor = UIColor(hex: "#FFFFFF", alpha: alpha)
            navigationView.backgroundColor = UIColor(hex: "#FFFFFF", alpha: alpha)
        }
    }
}

extension DetailVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 250
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.countReview.accept(textView.text.count)
    }
}
