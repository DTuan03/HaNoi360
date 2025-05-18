//
//  HomeVC.swift
//  HaNoi360
//
//  Created by Tuấn on 3/4/25.
//

import UIKit
import SnapKit
import RxSwift
import SkeletonView

class HomeVC: BaseVC {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let viewModel = HomeVM()
    lazy var scrollView = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor)
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithNotiButton(image: .noti,
                                                                                       delegate: self)
    
    lazy var titleLabel = LabelFactory.createLabel(text: "Bạn muốn khám phá \nđịa điểm nào",
                                                   font: .medium32,
                                                   highLighText: "khám phá",
                                                   highLightColor: .hightlightColor,
                                                   highLightFont: .medium32)
    
    lazy var searchTF = {
        let tf =  TextFieldFactory.createTextField(placeholder: "Tìm kiếm",
                                                   bgColor: .white)
        tf.imageLeftView(image: .search)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#D1D5DB").cgColor
        return tf
    }()
    
    lazy var overlayView = UIViewFactory.overlayView()
    
    lazy var filterBtn = {
        let btn = UIButton()
        btn.setImage(.filter, for: .normal)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(hex: "#D1D5DB").cgColor
        return btn
    }()
    
    lazy var nameDistrictCV = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 32
        layout.sectionInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(NameDistrictCell.self, forCellWithReuseIdentifier: "NameDistrictCell")
        cv.dataSource = self
        cv.delegate = self

        return cv
    }()
    
    lazy var placeCV = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(PlaceCell.self, forCellWithReuseIdentifier: "PlaceCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var categoryLabel = LabelFactory.createLabel(text: "Thể loại",
                                                      font: .medium18)
    
    lazy var categoryCV = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var tredingLabel = LabelFactory.createLabel(text: "Điểm đến thịnh hành",
                                                      font: .medium18)
    
    lazy var allLabel = LabelFactory.createLabel(text: "Tất cả",
                                                 font: .medium14,
                                                 textColor: .primaryColor)
    
    lazy var trendingCV = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(TrendingCell.self, forCellWithReuseIdentifier: "TrendingCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var addPlaceBtn = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "plus"), tinColor: .primaryColor)
        btn.backgroundColor = .backgroundColor
        btn.layer.cornerRadius = 30
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(hex: "#F3F4F6").cgColor
        return btn
    }()
    var selectedItemNameDistrictCV: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeCV.isSkeletonable = true
        view.isSkeletonable = true
        placeCV.showAnimatedGradientSkeleton()
    }
    
    override func setupUI() {
        view.addSubviews([scrollView, addPlaceBtn])
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
       
        contentView.addSubviews([navigationView, titleLabel, searchTF, overlayView, filterBtn, nameDistrictCV, placeCV, categoryLabel, categoryCV, tredingLabel, allLabel, trendingCV])
      
        navigationView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
  
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
  
        filterBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(46)
        }
        
        searchTF.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(filterBtn.snp.left).inset(-10)
            make.height.equalTo(46)
        }
        
        overlayView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(filterBtn.snp.left).inset(-10)
            make.height.equalTo(46)
        }
        
        nameDistrictCV.snp.makeConstraints { make in
            make.top.equalTo(searchTF.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(26)
        }
        
        placeCV.snp.makeConstraints { make in
            make.top.equalTo(nameDistrictCV.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(height * 0.39)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(placeCV.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        categoryCV.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(height * 0.123)
        }
        
        tredingLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCV.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        allLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCV.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        trendingCV.snp.makeConstraints { make in
            make.top.equalTo(tredingLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(width - 20)
            make.bottom.equalToSuperview().inset(10)
        }
        
        addPlaceBtn.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
        }
        
        addPlaceBtn.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
    
    override func setupEvent() {
        addPlaceBtn.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(AddPlaceVC(), animated: true)
            })
            .disposed(by: disposeBag)
        
        filterBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(FilterVC(), animated: true)
            })
            .disposed(by: disposeBag)
        
        let overlayViewTap = UITapGestureRecognizer(target: self, action: #selector(overlayViewAction))
        overlayView.addGestureRecognizer(overlayViewTap)
    }
    
    @objc func overlayViewAction() {
        let vc = SearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
                       
    override func bindState() {
        viewModel.itemsPlace
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else {return}
                self.placeCV.reloadData()
                self.placeCV.hideSkeleton(reloadDataAfter: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.itemsTrendingPlace
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else {return}
                self.trendingCV.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case nameDistrictCV:
            return viewModel.itemsNameDistrict.value.count
        case placeCV:
            return viewModel.itemsPlace.value.count
        case categoryCV:
            return viewModel.itemsCategory.value.count
        case trendingCV:
            return viewModel.itemsTrendingPlace.value.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case nameDistrictCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameDistrictCell", for: indexPath) as? NameDistrictCell else {
                return UICollectionViewCell()
            }
            let model = viewModel.itemsNameDistrict.value[indexPath.row]
            cell.configData(model: model, indexPath: indexPath, selectedItem: selectedItemNameDistrictCV)
            
            return cell
        case placeCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as? PlaceCell else {
                return UICollectionViewCell()
            }
            let model = viewModel.itemsPlace.value[indexPath.row]
            cell.configure(model: model)
            return cell
        case categoryCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            let model = viewModel.itemsCategory.value[indexPath.row]
            cell.configData(model: model)
            return cell
        case trendingCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as? TrendingCell else {
                return UICollectionViewCell()
            }
            let model = viewModel.itemsTrendingPlace.value[indexPath.row]
            cell.configData(model: model)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case nameDistrictCV:
            let oldIndex = selectedItemNameDistrictCV
            selectedItemNameDistrictCV = indexPath
            nameDistrictCV.reloadItems(at: [oldIndex, selectedItemNameDistrictCV])
            viewModel.getPlaces(idDistrict: viewModel.districts[indexPath.row].id)
        case placeCV:
            let detailVC = DetailVC()
            detailVC.viewModel.placeId.accept(viewModel.itemsPlace.value[indexPath.row].placeId)
            detailVC.viewModel.isFavoritePlace {
                detailVC.viewModel.featchPlace() {
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        case categoryCV:
            let vc = CategoryVC()
            vc.viewModel.initialIndex.accept(indexPath.row)
            vc.viewModel.categoryId.accept(viewModel.itemsCategory.value[indexPath.row].id)
            vc.viewModel.categoryImg.accept(viewModel.categories[indexPath.row].img ?? "")
            vc.viewModel.categoryTitle.accept(viewModel.categories[indexPath.row].name ?? "")
//            vc.viewModel.featchPlace()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let detailVC = DetailVC()
            detailVC.viewModel.placeId.accept(viewModel.itemsTrendingPlace.value[indexPath.row].placeId)
            detailVC.viewModel.isFavoritePlace {
                detailVC.viewModel.featchPlace() {
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case nameDistrictCV:
            let namePlace = viewModel.itemsNameDistrict.value[indexPath.row].name
            
            let label = UILabel()
            label.text = namePlace
            label.font = UIFont.medium16
            
            let maxWidth: CGFloat = collectionView.frame.width
            let labelSize = label.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
            
            let sizeForItem = CGSize(width: labelSize.width, height: 26)
            return sizeForItem
        case placeCV:
            return CGSize(width: width * 0.67, height: height * 0.39)
        case categoryCV:
            return CGSize(width: width * 0.192, height: height * 0.123)
        case trendingCV:
            let widthCV = (width - 60) / 2
            return CGSize(width: widthCV, height: widthCV)
        default:
            return CGSize()
        }
    }
}

extension HomeVC: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        switch skeletonView {
        case nameDistrictCV:
            return "NameDistrictCell"
        case placeCV:
            return "PlaceCell"
        case categoryCV:
            return "CategoryCell"
        case trendingCV:
            return "TrendingCell"
        default:
            return ""
        }
    }
}

extension HomeVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        print("noti")
    }
}
