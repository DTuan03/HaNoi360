//
//  CategoryVC.swift
//  HaNoi360
//
//  Created by Tuấn on 29/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import UPCarouselFlowLayout

class CategoryVC: BaseViewController {
    let viewModel = CategoryVM()
    
    lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView(frame: UIScreen.main.bounds)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    lazy var overlayView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return v
    }()
    
    lazy var scrollView = {
        let sv = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor)
        sv.delegate = self
        sv.backgroundColor = .clear
        return sv
    }()
    
    lazy var contentView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var backSearchButton = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "chevron.backward"), tinColor: .white)
        btn.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        return btn
    }()
        
    lazy var backTitleButton = {
        let btn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "chevron.backward"), tinColor: .black)
        btn.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        return btn
    }()
    
    lazy var searchTF = {
        let tf =  TextFieldFactory.createTextField(placeholder: "Tìm kiếm",
                                                   bgColor: .clear,
                                                   textColor: .white,
                                                   rounded: 21)
        tf.imageLeftView(image: UIImage(systemName: "magnifyingglass") ?? .search, tinColor: .white)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.white.cgColor
        tf.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        return tf
    }()
    
    lazy var filterBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "category.ic.filter"), for: .normal)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.snp.makeConstraints { make in
            make.height.width.equalTo(42)
        }
        return btn
    }()
    
    lazy var titleLabel = LabelFactory.createLabel(text: "Trải nghiệm", font: .medium18, textColor: .black, textAlignment: .center)
    
    lazy var searchStv = [backSearchButton, searchTF, filterBtn].hStack(10, distribution: .fill)
    
    lazy var titleStv = [backTitleButton, titleLabel].hStack(-10, distribution: .fillProportionally)
    
    lazy var lineView = {
        let v = UIViewFactory.createLineView()
        v.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return v
    }()
    
    lazy var subHeaderView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubviews([searchStv, titleStv, lineView])
        searchStv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleStv.isHidden = true
        titleStv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        lineView.isHidden = true
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(10)
        }
        return view
    }()
    
    lazy var headerView = {
        let view = UIView()
        view.backgroundColor = .clear
    
        return view
    }()
    
    lazy var categoryCV = {
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: 30)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCarouseCell.self, forCellWithReuseIdentifier: "CategoryCarouseCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var tableView = {
        let tb = TableViewFactory.createTableView()
        tb.separatorStyle = .none
        tb.register(CategoryPlaceCell.self, forCellReuseIdentifier: "CategoryPlaceCell")
        tb.dataSource = self
        tb.isScrollEnabled = false
        return tb
    }()
    
    lazy var backgroundView = {
        let v = UIView()
        self.view.addSubview(v)
        v.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return v
    }
    
    override func viewDidAppear(_ animated: Bool) {
        categoryCV.scrollToItem(at: IndexPath(item: viewModel.initialIndex.value, section: 0),
                                at: .centeredHorizontally,
                                animated: true)
    }
    
    override func setupUI() {
        view.addSubviews([scrollView, headerView, subHeaderView])
        subHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(42)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(110)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        contentView.addSubviews([categoryCV, containerView])
        
        categoryCV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(categoryCV.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(600)
        }
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(8)
            make.right.bottom.equalToSuperview()
        }
        
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(350)
        }

        view.insertSubview(overlayView, aboveSubview: backgroundImageView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundImageView)
        }
    }
    
    override func bindState() {
        viewModel.placesForCategory
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
                
                let itemCount = self.viewModel.placesForCategory.value?.count ?? 0
                let newHeight = CGFloat(itemCount) * 145
                self.tableView.snp.updateConstraints { make in
                    make.height.equalTo(newHeight)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.categoryId
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.viewModel.featchPlace()
            })
            .disposed(by: disposeBag)
        
        viewModel.categoryImg
            .subscribe(onNext: { [weak self] imgName in
                guard let self = self else { return }
                self.backgroundImageView.image = UIImage(named: imgName)
            })
            .disposed(by: disposeBag)
        
        viewModel.categoryTitle
            .subscribe(onNext: { [weak self] title in
                guard let `self` = self else { return }
                self.titleLabel.text = title
            })
            .disposed(by: disposeBag)
    }
    
    override func setupEvent() {
        backTitleButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        backSearchButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension CategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCategory.value.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCarouseCell", for: indexPath) as? CategoryCarouseCell else { return UICollectionViewCell() }
        let model = viewModel.itemsCategory.value[indexPath.row]
        cell.configData(model: model)
        return cell
    }
}

extension CategoryVC: UICollectionViewDelegate {
}

extension CategoryVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == categoryCV {
            guard let collectionView = scrollView as? UICollectionView else { return }
            
            let center = view.convert(collectionView.center, to: collectionView)
            
            if let indexPath = collectionView.indexPathForItem(at: center) {
                for cell in collectionView.visibleCells {
                    guard let myCell = cell as? CategoryCarouseCell else { continue }
                    
                    let cellIndexPath = collectionView.indexPath(for: myCell)
                    myCell.updateFontWeight(isCenter: cellIndexPath == indexPath)
                }
                
                let selectedCategory = viewModel.itemsCategory.value[indexPath.row].id
                viewModel.categoryId.accept(selectedCategory)
                
                let selectedCategoryImg = viewModel.categories[indexPath.row].img ?? ""
                viewModel.categoryImg.accept(selectedCategoryImg)
                
                let selectedCategoryTitle = viewModel.categories[indexPath.row].name ?? ""
                viewModel.categoryTitle.accept(selectedCategoryTitle)
            }
            
        } else if scrollView == self.scrollView {
            let offsetY = scrollView.contentOffset.y
            let maxOffset: CGFloat = 200

            let alpha = min(max(offsetY / maxOffset, 0), 1)

            headerView.backgroundColor = UIColor.white.withAlphaComponent(alpha)

            let maxCornerRadius: CGFloat = 24
            containerView.layer.cornerRadius = maxCornerRadius * (1 - alpha)
            
            if offsetY > 10 {
                searchStv.isHidden = true
                titleStv.isHidden = false
                lineView.isHidden = false
            } else {
                titleStv.isHidden = true
                searchStv.isHidden = false
                lineView.isHidden = true
            }
        }
    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.placesForCategory.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryPlaceCell", for: indexPath) as? CategoryPlaceCell, let model = viewModel.placesForCategory.value?[indexPath.row] else { return UITableViewCell() }
        cell.configData(model: model)
        cell.selectionStyle = .none
        return cell
    }
}
