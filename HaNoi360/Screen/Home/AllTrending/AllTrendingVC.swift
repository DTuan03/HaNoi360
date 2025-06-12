//
//  AllTrendingVC.swift
//  HaNoi360
//
//  Created by Tuấn on 3/6/25.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import RxSwift
import RxCocoa
import Kingfisher

class AllTrendingVC: BaseVC {
    let viewModel = AllTrendingVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back, title: "Thịnh hành", delegate: self)
    
    lazy var clv = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2  // số cột
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let clv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        clv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        clv.dataSource = self
        clv.delegate = self
        clv.backgroundColor = .backgroundColor
        clv.register(TrendingCell.self, forCellWithReuseIdentifier: "TrendingCell")
        
        return clv
    }()
    
    override func setupUI() {
        view.addSubviews([navigationView, clv])
        navigationView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        clv.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func bindState() {
        viewModel.itemsTrendingPlace
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.clv.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension AllTrendingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsTrendingPlace.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as? TrendingCell else {
            return UICollectionViewCell()
        }
        
        cell.image.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let model = viewModel.itemsTrendingPlace.value[indexPath.row]
        cell.configData(model: model)

        return cell
    }
}

extension AllTrendingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = NewDetailVC()
        detailVC.viewModel.placeId.accept(viewModel.itemsTrendingPlace.value[indexPath.row].placeId)
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

extension AllTrendingVC: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 60) / 2
        let height = width * 1.618
        
        return indexPath.item % 2 == 0 ? CGSize(width: width, height: height) : CGSize(width: width, height: height * 0.8)
    }
}

extension AllTrendingVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        self.navigationController?.popViewController(animated: true)
    }
}


class AllTrendingCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(named name: String) {
        imageView.kf.setImage(with: URL(string: name))
    }
}
