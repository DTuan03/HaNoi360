//
//  TabBarVC.swift
//  HaNoi360
//
//  Created by Tuấn on 4/4/25.
//

import UIKit
import SnapKit

class TabBarVC: BaseViewController {
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var tabBarView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.borderColor = UIColor(hex: "#F3F4F6").cgColor
        view.layer.borderWidth = 1
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let iv = ImageViewFactory.createImageView(image: .bg, contentMode: .scaleAspectFill)
        view.addSubview(iv)
        iv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var homeBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "house.fill"), tinColor: UIColor(hex: "#4B5563"))
    
    lazy var titleHomeLabel = LabelFactory.createLabel(text: "Trang chủ", font: .regular14, textColor: UIColor(hex: "#1F2937"))
    
    lazy var stvHome = [homeBtn, titleHomeLabel].vStack(alignment: .center, distribution: .fillEqually)
    
    lazy var calendarBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "calendar.badge.plus"), tinColor: UIColor(hex: "#4B5563"))
    
    lazy var titleCalendarLabel = LabelFactory.createLabel(text: "Lịch trình", font: .regular14, textColor: UIColor(hex: "#1F2937"))
    
    lazy var stvCalendar = [calendarBtn, titleCalendarLabel].vStack(alignment: .center, distribution: .fillEqually)
    
    lazy var favoriteBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "heart"), tinColor: UIColor(hex: "#4B5563"))
    
    lazy var titleFavoriteLabel = LabelFactory.createLabel(text: "Yêu thích", font: .regular14, textColor: UIColor(hex: "#1F2937"))
    
    lazy var stvFavorite = [favoriteBtn, titleFavoriteLabel].vStack(alignment: .center, distribution: .fillEqually)
    
    lazy var profileBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "person"), tinColor: UIColor(hex: "#4B5563"))
    
    lazy var titleSettingLabel = LabelFactory.createLabel(text: "Tài khoản", font: .regular14, textColor: UIColor(hex: "#1F2937"))
    
    lazy var stvProfile = [profileBtn, titleSettingLabel].vStack(alignment: .center, distribution: .fillEqually)
    
    lazy var stackView = [stvHome, stvCalendar, stvFavorite, stvProfile].hStack(distribution: .fillEqually)
    
    let homeVC = HomeVC()
    
    let calendarVC = CalendarVC()
    
    let favoriteVC = FavoriteVC()
    
    let profileVC = AccountVC()
        
    var currentVC: UIViewController = HomeVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchToVC(homeVC)
        updateButtonColors(selected: homeBtn)
    }
    
    override func setupUI() {
        view.addSubviews([containerView, tabBarView])
        tabBarView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(tabBarView.snp.top)
        }
        
        tabBarView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        homeBtn.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        calendarBtn.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        favoriteBtn.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        profileBtn.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
    }
    
    override func setupEvent() {
        homeBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.switchToVC(self.homeVC)
            self.updateButtonColors(selected: self.homeBtn)
        }.disposed(by: disposeBag)
        
        let stvHomeTap = UITapGestureRecognizer(target: self, action: #selector(stvHomeAction))
        stvHome.addGestureRecognizer(stvHomeTap)
        
        let stvCalendarTap = UITapGestureRecognizer(target: self, action: #selector(stvCalendarAction))
        stvCalendar.addGestureRecognizer(stvCalendarTap)
        
        let stvFavoriteTap = UITapGestureRecognizer(target: self, action: #selector(stvFavoriteAction))
        stvFavorite.addGestureRecognizer(stvFavoriteTap)
        
        let stvProfileTap = UITapGestureRecognizer(target: self, action: #selector(stvProfileAction))
        stvProfile.addGestureRecognizer(stvProfileTap)
        
        calendarBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.switchToVC(self.calendarVC)
            self.updateButtonColors(selected: self.calendarBtn)
        }.disposed(by: disposeBag)
        
        favoriteBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.switchToVC(self.favoriteVC)
            self.updateButtonColors(selected: self.favoriteBtn)
            calendarVC.viewModel.featchPlace()
        }.disposed(by: disposeBag)
        
        profileBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.switchToVC(self.profileVC)
            self.updateButtonColors(selected: self.profileBtn)
        }.disposed(by: disposeBag)
    }
    
    @objc func stvHomeAction() {
        switchToVC(self.homeVC)
        updateButtonColors(selected: self.homeBtn)
    }
    
    @objc func stvCalendarAction() {
        switchToVC(self.calendarVC)
        updateButtonColors(selected: self.calendarBtn)
    }
    
    @objc func stvFavoriteAction() {
        switchToVC(self.favoriteVC)
        updateButtonColors(selected: self.favoriteBtn)
        calendarVC.viewModel.featchPlace()
    }
    
    @objc func stvProfileAction() {
        switchToVC(self.profileVC)
        updateButtonColors(selected: self.profileBtn)
    }
    
    func switchToVC(_ vc: UIViewController) {
        currentVC.remove()
        add(vc, to: containerView)
        currentVC = vc
    }
    
    func updateButtonColors(selected: UIButton) {
        let buttons = [homeBtn, calendarBtn, favoriteBtn, profileBtn]
        let labels = [titleHomeLabel, titleCalendarLabel, titleFavoriteLabel, titleSettingLabel]
        for (index, button) in buttons.enumerated() {
            button.tintColor = (button == selected) ? UIColor(hex: "#FF3E00") : .black
            labels[index].textColor = (button == selected) ? UIColor(hex: "#FF3E00") : .black
            labels[index].font = (button == selected) ? .medium14 : .regular14
        }
    }
    
    func add(_ child: UIViewController, to container: UIView) {
        addChild(child)
        container.addSubview(child.view)
        child.view.frame = container.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParent: self)
    }
}

extension UIViewController {
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
