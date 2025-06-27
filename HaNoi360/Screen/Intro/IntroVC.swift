//
//  IntroVC.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class IntroVC: BaseVC {
    lazy var scrollView = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor,
                                                             showsHorizontalScrollIndicator: true,
                                                             bounces: false)
    lazy var pageControl = {
        let pc = CustomPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        return pc
    }()
    
    lazy var nextButton = ButtonFactory.createButton("intro.next".localized,
                                                     font: .bold18)
    
    var introModel: [IntroModel] = [
        IntroModel(title: "intro.title.0".localized,
                   highLight: "intro.highlight.0".localized,
                   description: "intro.description.0".localized,
                   image: "intro1",
                   numberPageControl: 0),
        
        IntroModel(title: "intro.title.1".localized,
                   highLight: "intro.highlight.1".localized,
                   description: "intro.description.1".localized,
                   image: "intro2",
                   numberPageControl: 1),
        
        IntroModel(title: "intro.title.2".localized,
                   highLight: "intro.highlight.2".localized,
                   description: "intro.description.2".localized,
                   image: "intro3",
                   numberPageControl: 2)
    ]
    
    override func setupUI() {
        view.addSubviews([nextButton,scrollView, pageControl])
        
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(48)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        addContentToScrollView()
    }
    
    override func setupEvent() {
        nextButton.rx.tap
            .subscribe(onNext: {
                var contentOffset = self.scrollView.contentOffset
                
                if contentOffset.x <= self.scrollView.frame.size.width {
                    contentOffset.x = contentOffset.x + UIScreen.main.bounds.width
                    self.pageControl.currentPage = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width) + 1
                    self.scrollView.setContentOffset(CGPoint(x: contentOffset.x, y: 0), animated: true)
                } else {
                    let signUpVC = SignUpVC()
                    self.navigationController?.pushViewController(signUpVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func addContentToScrollView() {
        scrollView.frame.size.width = UIScreen.main.bounds.width
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: scrollView.frame.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        scrollView.isScrollEnabled = false
        
        for (index, item) in introModel.enumerated() {
            let contentView = UIView()
//            contentView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(scrollView.frame.width * CGFloat(index))
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
            
            lazy var image = ImageViewFactory.createImageView(image: UIImage(named: item.image),
                                                              contentMode: .scaleToFill)
            
            lazy var title = LabelFactory.createLabel(text: item.title,
                                                      font: .bold32,
                                                      textColor: .primaryTextColor,
                                                      textAlignment: .center,
                                                      highLighText: item.highLight,
                                                      highLightFont: .bold32)
            
            lazy var description = LabelFactory.createLabel(text: item.description,
                                                            font: .medium16,
                                                            textColor: .secondaryTextColor,
                                                            textAlignment: .center)
            contentView.addSubviews([image, title, description])
            image.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.6)
            }
            
            title.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalTo(image.snp.bottom).offset(30)
            }
            
            description.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalTo(title.snp.bottom).offset(20)
            }
        }
    }
}
