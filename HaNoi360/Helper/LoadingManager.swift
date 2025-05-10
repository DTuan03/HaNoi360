//
//  LoadingManager.swift
//  HaNoi360
//
//  Created by Tuấn on 10/5/25.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class LoadingManager {
    static let shared = LoadingManager()
    private var loadingView: LoadingView?
    let disposeBag = DisposeBag()
    
    private init() {}
    
    func bind(to isLoading: BehaviorRelay<Bool>, in view: UIView) {
        isLoading
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] show in
                guard let self = self else { return }
                show ? self.show(in: view) : self.hide()
            })
            .disposed(by: disposeBag)
    }
    
    private func show(in view: UIView) {
        guard loadingView == nil else { return }
        
        let lv = LoadingView()
        view.addSubview(lv)
        
        lv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lv.play()
        loadingView = lv
    }
    
    private func hide() {
        loadingView?.stop()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
