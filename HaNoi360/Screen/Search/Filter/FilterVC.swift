//
//  FilterVC.swift
//  HaNoi360
//
//  Created by Tuấn on 3/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import TTRangeSlider

class FilterVC: BaseViewController {
    let viewModel = FilterVM()
    
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Lọc", delegate: self)
    
    lazy var categoryLabel = LabelFactory.createLabel(text: "Thể loại", font: .medium18)
    
    lazy var categoryCV = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        cv.dataSource = self
        cv.delegate = self

        return cv
    }()
    
    lazy var ratingLabel = LabelFactory.createLabel(text: "Đánh giá", font: .medium18)
    
    lazy var rangeRating = {
        let rangeSlider = TTRangeSlider()
        rangeSlider.delegate = self
        
        rangeSlider.minValue = 1
        rangeSlider.maxValue = 5
        rangeSlider.selectedMinimum = 2
        rangeSlider.selectedMaximum = 4
        rangeSlider.minLabelColour = .black
        rangeSlider.maxLabelColour = .black
        rangeSlider.minLabelFont = .regular14
        rangeSlider.maxLabelFont = .regular14
        rangeSlider.handleImage = UIImage(named: "thumb")
        rangeSlider.tintColorBetweenHandles = UIColor(hex: "#F97316")
        rangeSlider.tintColor = UIColor(hex: "#FED7AA")
        rangeSlider.handleDiameter = 20
        rangeSlider.lineHeight = 3
        rangeSlider.step = 0.1
        rangeSlider.selectedHandleDiameterMultiplier = 1
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        
        rangeSlider.numberFormatterOverride = formatter
        return rangeSlider
    }()
    
    lazy var districtLabel = LabelFactory.createLabel(text: "Quận/Huyện", font: .medium18)
    
    lazy var districtTF = {
        let tf =  TextFieldFactory.createTextField(placeholder: "Chọn Quận/Huyện",
                                                   bgColor: .white)
        tf.imageLeftView(image: .location)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 46))
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 8, y: 19, width: 8, height: 8)
        imageView.contentMode = .scaleAspectFill
        paddingView.addSubview(imageView)
        
        tf.rightView = paddingView
        tf.rightViewMode = .always
        tf.keyboardType = .default
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#D1D5DB").cgColor
        return tf
    }()
    
    lazy var overlayView = UIViewFactory.overlayView()
    
    var selectedCategory: [String] = []
    var selectedIndexPath: Set<IndexPath> = [IndexPath(row: 0, section: 0)]
    
    override func setupUI() {
        
        view.addSubviews([navigationView, categoryLabel, categoryCV, ratingLabel, rangeRating, districtLabel, districtTF, overlayView])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(20)
        }
        
        categoryCV.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(42 + 16 + 42 + 16 + 42)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCV.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(20)
        }
        
        rangeRating.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(8)
        }
        
        districtLabel.snp.makeConstraints { make in
            make.top.equalTo(rangeRating.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(20)
        }
        
        districtTF.snp.makeConstraints { make in
            make.top.equalTo(districtLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
        
        overlayView.snp.makeConstraints { make in
            make.top.equalTo(districtLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
    }
    
    override func setupEvent() {
        let overlayViewTap = UITapGestureRecognizer(target: self, action: #selector(overlayViewAction))
        overlayView.addGestureRecognizer(overlayViewTap)
    }
    
    @objc func overlayViewAction() {
        let vc = FilterDistrictVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
//        vc.delegate = self
        self.present(vc, animated: true)
    }
    
   
}

extension FilterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCategory.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell else { return UICollectionViewCell() }
        let model = viewModel.itemsCategory.value[indexPath.row]
        if selectedIndexPath.contains(indexPath) {
            cell.configData(model: model, isSelected: true)
        } else {
            cell.configData(model: model, isSelected: false)
        }
        return cell
    }
}

extension FilterVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.categories[indexPath.row]
        if indexPath == IndexPath(row: 0, section: 0) {
            selectedIndexPath = []
            selectedIndexPath = [IndexPath(row: 0, section: 0)]
            collectionView.reloadData()
        } else {
            selectedIndexPath.remove(IndexPath(row: 0, section: 0))
            if selectedIndexPath.contains(indexPath) {
                selectedIndexPath.remove(indexPath)
            } else {
                selectedIndexPath.insert(indexPath)
            }
            collectionView.reloadData()
        }
    }
}

extension FilterVC: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        print("Giá trị: \(selectedMinimum) - \(selectedMaximum)")
    }
}

extension FilterVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}
