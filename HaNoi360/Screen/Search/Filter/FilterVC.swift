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
    
    override func setupUI() {
        view.addSubviews([navigationView, categoryLabel, categoryCV, ratingLabel, rangeRating])
        
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
    }
    
    override func setupEvent() {

    }
    
   
}

extension FilterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCategory.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell else { return UICollectionViewCell() }
        let model = viewModel.itemsCategory.value[indexPath.row]
        cell.configData(model: model)
        return cell
    }
}

extension FilterVC: UICollectionViewDelegate {
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
