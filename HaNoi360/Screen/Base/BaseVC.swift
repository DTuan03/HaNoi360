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

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
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
    }
    
    func setupUI() {
    }
    
    func setupEvent() {
    }
    
    func setupData() {
    }
    
    func bindState() {
        vm.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                let vc = LoadingVC()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            } else {
                self.dismiss(animated: true)
            }
        })
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
}
