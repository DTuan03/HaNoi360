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

class IntroVC: BaseViewController {
    lazy var scrollView = ScrollViewFactory.createScrollView(backgroundColor: .backgroundColor,
                                                             showsHorizontalScrollIndicator: true,
                                                             bounces: false)
    lazy var pageControl = {
        let pc = CustomPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        return pc
    }()
    
    lazy var nextButton = ButtonFactory.createButton("TIẾP THEO",
                                                     font: .bold18)
    
    var introModel: [IntroModel] = [
        IntroModel(title: "Công việc lấp đầy túi bạn, phiêu lưu lấp đầy tâm hồn.",
                   highLight: "phiêu lưu",
                   description: "Du lịch Hà Nội là một hành trình tuyệt vời để mở rộng tầm hiểu biết và mang lại những trải nghiệm mới mẻ, vừa thú vị vừa bổ ích.",
                   image: "intro1",
                   numberPageControl: 0),
        
        IntroModel(title: "Sống cuộc đời không lý do, du lịch Hà Nội không hối tiếc.",
                   highLight: "du lịch",
                   description: "Hà Nội là điểm đến lý tưởng với nhiều địa danh nổi tiếng, mỗi chuyến đi đều mang lại cảm giác mới mẻ và không bao giờ khiến bạn phải tiếc nuối.",
                   image: "intro2",
                   numberPageControl: 1),
        
        IntroModel(title: "Hà Nội trong tầm tay. \n Du lịch là sống trọn vẹn.",
                   highLight: "trọn vẹn.",
                   description: "Khám phá thiên nhiên, gặp gỡ con người mới, và trải nghiệm văn hóa đặc sắc - Hà Nội là nơi hiện thực hóa những ước mơ phiêu lưu đó.",
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
