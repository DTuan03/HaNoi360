//
//  AddCalendar.swift
//  HaNoi360
//
//  Created by Tuấn on 12/4/25.
//

import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxCocoa

class AddCalendarVC: BaseViewController {
    let viewModel = AddCalendarVM()
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    lazy var pullDownView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 3
        return v
    }()
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scope = .month
        calendar.locale = Locale(identifier: "vi_VN")
        calendar.headerHeight = 0
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .primaryColor
        calendar.appearance.selectionColor = .primaryColor
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.borderRadius = 1.0
        calendar.appearance.headerTitleFont = .medium18
        calendar.appearance.weekdayFont = .medium16
        calendar.appearance.titleFont = .medium16
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.select(Date())
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    lazy var titleLabel = LabelFactory.createLabel(text: "Chọn thời gian dự định đi",
                                                   font: .medium18)
    
    lazy var closeBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "xmark"), tinColor: UIColor(hex: "#000000", alpha: 0.8))
    
    lazy var lineView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.3)
        return view
    }()
    
    lazy var selectedDateLabel = LabelFactory.createLabel(font: .medium18, textColor: UIColor(hex: "#000000", alpha: 0.8))
    
    lazy var addBtn = ButtonFactory.createButton("Thêm", font: .medium16)
    
    lazy var backBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "chevron.left"), tinColor: UIColor(hex: "#000000", alpha: 0.8))
    
    lazy var nextBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "chevron.right"), tinColor: UIColor(hex: "#000000", alpha: 0.8))
    
    lazy var stvBtn = [backBtn, nextBtn].hStack(16)
    
    var selectedDate: String = ""
    
    lazy var addLabel = LabelFactory.createLabel(text: "Thêm", font: .medium18, textColor: .primaryColor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = CalendarHelper.shared.format(date: Date())
        selectedDateLabel.text = selectedDate
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.62)
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.58)
        }
        
        containerView.addSubviews([pullDownView, titleLabel, lineView, closeBtn, selectedDateLabel, calendar, addBtn, stvBtn])
        
        pullDownView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(6)
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pullDownView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(pullDownView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
        }
        
        stvBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(16)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        addBtn.layer.cornerRadius = 24
        addBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
    }
    
    override func setupEvent() {
        closeBtn.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        backBtn.rx.tap
            .subscribe(onNext: {
                let currentPage = self.calendar.currentPage
                guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentPage) else { return }
                self.calendar.setCurrentPage(previousMonth, animated: true)
            })
            .disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .subscribe(onNext: {
                let currentPage = self.calendar.currentPage
                guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentPage) else { return }
                self.calendar.setCurrentPage(nextMonth, animated: true)
            })
            .disposed(by: disposeBag)
        
        addBtn.rx.tap
            .subscribe(onNext: {
                self.viewModel.isCalendarPlace()
            })
            .disposed(by: disposeBag)
        
        viewModel.isAddPlace
            .subscribe(onNext: { isAddPlace in
                if isAddPlace {
                    let popupVC = PopupCalendarVC()
                    let choosedDates: [String] = self.viewModel.choosedDatePlaceCurrent.value ?? []
                    let formattedDates = choosedDates.map { $0 } // chuyển từng Date thành String
                    let dateList = formattedDates.joined(separator: ", ") // nối thành 1 chuỗi
                    
                    popupVC.messageLabel.text = "Bạn đã thêm địa điểm này vào ngày \(dateList)"
                    
                    popupVC.onOk = {
                        self.viewModel.isAddPlaceContinue.accept(true)
                    }
                    
                    popupVC.onCancel = {
                        self.viewModel.isAddPlaceContinue.accept(false)
                    }
                    
                    popupVC.modalTransitionStyle = .crossDissolve
                    popupVC.modalPresentationStyle = .overCurrentContext
                    self.present(popupVC, animated: true)
                } else {
                    self.viewModel.isAddPlaceContinue.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isAddPlaceContinue
            .subscribe(onNext: { isAddPlaceContinue in
                if isAddPlaceContinue {
                    self.vm.isLoading.accept(true)
                    self.viewModel.addPlaceCalendar()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isSuccess
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    Toast.showToast(message: "Thêm lịch trình thành công", image: "toast_success")
                    self.dismiss(animated: true)
                } else {
                    Toast.showToast(message: "Thêm lịch trình thất bại", image: "toast_error")
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func bindState() {
        viewModel.eventDates
            .subscribe(onNext: {_ in 
                self.calendar.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
}

extension AddCalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = CalendarHelper.shared.format(date: date)
        selectedDateLabel.text = selectedDate
        viewModel.date.accept(date.toString())
     }
}

extension AddCalendarVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.eventDates.value.contains { Calendar.current.isDate($0, inSameDayAs: date) } ? 1 : 0
    }
}

extension AddCalendarVC: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if viewModel.eventDates.value.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
            return [.primaryColor] // màu của dấu chấm
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: date)
        
        if selectedDay < today {
            return .lightGray
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Calendar.current.startOfDay(for: Date()) // lấy ngày hôm nay (00:00)
        let selectedDay = Calendar.current.startOfDay(for: date) // lấy ngày đang xét
        
        return selectedDay >= today // chỉ cho chọn ngày hôm nay trở đi
    }
}
