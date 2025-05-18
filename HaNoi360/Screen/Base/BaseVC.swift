//
//  BaseVC.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseVC: UIViewController {
    var disposeBag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isBgWhiteLoading = BehaviorRelay<Bool>(value: false)
    private let loadingView = LoadingView()
    var vm = BaseVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        self.navigationController?.isNavigationBarHidden = true
        addDismissKeyboard()
        bindState()
        setupUI()
        setupEvent()
        setupData()
        setupLoadingView()
        bindLoading()
    }
    
    private func setupLoadingView() {
      loadingView.isHidden = true
      view.addSubview(loadingView)
      loadingView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
    
    func setupUI() {
    }
    
    func setupEvent() {
    }
    
    func setupData() {
    }
    
    func bindState() {
    }
    
    private func bindLoading() {
      isLoading
        .distinctUntilChanged()
        .observe(on: MainScheduler.instance)
        .bind { [weak self] loading in
          loading ? self?.loadingView.startAnimating() : self?.loadingView.stopAnimating()
        }
        .disposed(by: disposeBag)
      
      isBgWhiteLoading
        .distinctUntilChanged()
        .observe(on: MainScheduler.instance)
        .bind { [weak self] loading in
          self?.loadingView.backgroundColor = loading ? .white : .clear
        }
        .disposed(by: disposeBag)
    }
    
    func addDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[\(String(describing: type(of: self)))] appeared")
    }
}
