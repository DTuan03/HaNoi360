//
//  NewCeateScheduleVC.swift
//  HaNoi360
//
//  Created by Tuấn on 29/5/25.
//

import FSCalendar
import UIKit
import RxSwift
import RxCocoa
import SnapKit

extension String {
    static func formatVietnameseDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEE, dd 'thg' M"
        return formatter.string(from: date)
    }
    
    static func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "'tháng' M 'năm' yyyy"
        return formatter.string(from: date)
    }
}

class NewCreateScheduleVC: BaseVC {
    let viewModel = NewCreateScheduleVM()
    lazy var chooseDateLabel = LabelFactory.createLabel(text: "Chọn ngày", font: .medium16)
    
    lazy var dateLabel = LabelFactory.createLabel(text: String.formatVietnameseDate(Date()), font: .regular32)
    
    lazy var lineView = UIViewFactory.createLineView(height: 2)
    
    lazy var pencilIv = ImageViewFactory.createImageView(image: UIImage(systemName: "pencil"), tintColor: .iconColor)
    
    lazy var selectedDateLabel = LabelFactory.createLabel(font: .medium18, textColor: .primaryTextColor.withAlphaComponent(0.8))
    
    lazy var monthLabel = LabelFactory.createLabel(text: String.formatMonth(Date()), font: .medium14, textColor: .secondaryTextColor)
    
    lazy var monthSv = {
        let downIv = ImageViewFactory.createImageView(image: UIImage(systemName: "arrowtriangle.down.fill"), tintColor: .secondaryTextColor)
        downIv.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(12)
        }
        let sv = [monthLabel, downIv].hStack(2)
        
        return sv
    }()
    
    lazy var backBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "chevron.left"), tinColor: .primaryTextColor.withAlphaComponent(0.8))
    
    lazy var nextBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "chevron.right"), tinColor: .primaryTextColor.withAlphaComponent(0.8))
    
    lazy var stvBtn = [backBtn, nextBtn].hStack(40)
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scope = .month
        calendar.locale = Locale(identifier: "vi_VN")
        calendar.headerHeight = 0
        calendar.firstWeekday = 2
        calendar.appearance.weekdayTextColor = .secondaryTextColor
        calendar.appearance.titleDefaultColor = .primaryTextColor
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .orange
        calendar.appearance.selectionColor = .orange
        calendar.appearance.titleSelectionColor = .primaryTextColor
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
    
    var selectDate: ((Date) -> Void)?
    var fromDate: Date?
    var toDate: Date = Date()
    
    lazy var cancelLabel = LabelFactory.createLabel(text: "Huỷ", font: .regular16, textColor: .orange)
    
    lazy var okLabel = LabelFactory.createLabel(text: "OK", font: .regular16, textColor: .orange)
    
    lazy var svCancelOk = [cancelLabel, okLabel].hStack(40)
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 20
        view.addSubviews([chooseDateLabel, dateLabel, pencilIv, lineView, monthSv, stvBtn, calendar, svCancelOk])
        
        chooseDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(chooseDateLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(24)
        }
        
        pencilIv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
            make.height.width.equalTo(36)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        monthSv.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
        }
        
        stvBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(stvBtn.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        svCancelOk.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(24)
        }
        
        return view
    }()
    
    var selectedDate: String = ""
    
    override func setupUI() {
        selectedDate = CalendarHelper.shared.format(date: Date())
        selectedDateLabel.text = selectedDate
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.62)
        view.addSubview(containerView)
        
        calendar.select(fromDate)
        
        dateLabel.text = String.formatVietnameseDate(calendar.selectedDate ?? Date())
        monthLabel.text = String.formatMonth(calendar.selectedDate ?? Date())
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func showToDate() {
        if let fromDate = fromDate, !isSelectableDate(Date(), from: fromDate) {
            calendar.select(Calendar.current.date(byAdding: .day, value: 30, to: fromDate))
        } else {
            calendar.select(toDate)
        }
    }
    
    override func setupEvent() {
        backBtn.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let current = self.calendar.currentPage
                if let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: current) {
                    self.calendar.setCurrentPage(prevMonth, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let current = self.calendar.currentPage
                if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: current) {
                    self.calendar.setCurrentPage(nextMonth, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        let cancelLabelTap = UITapGestureRecognizer(target: self, action: #selector(cancelLabelAction))
        cancelLabel.addGestureRecognizer(cancelLabelTap)
        
        let okLabelTap = UITapGestureRecognizer(target: self, action: #selector(okLabelAction))
        okLabel.addGestureRecognizer(okLabelTap)
    }
    
    @objc func cancelLabelAction() {
        self.dismiss(animated: true)
    }
    
    @objc func okLabelAction() {
        self.viewModel.isCalendarPlace()
    }
    
    override func bindState() {
        viewModel.isAddPlace
            .subscribe(onNext: { isAddPlace in
                if isAddPlace {
                    let popupVC = PopupCalendarVC()
                    let choosedDates: [String] = self.viewModel.choosedDatePlaceCurrent.value ?? []
                    
                    let futureDates: [String] = choosedDates.compactMap {
                        guard let date = $0.toDate(), date > Date() else { return nil }
                        return date.toString()
                    }
                    
                    let dateList = futureDates.joined(separator: ", ") // nối thành 1 chuỗi
                    
                    if dateList.isEmpty {
                        popupVC.messageLabel.text = "Bạn có chắc chắn muốn thêm địa điểm này ?"
                    } else {
                        popupVC.messageLabel.text = "Bạn đã thêm địa điểm này vào ngày \(dateList)"
                    }
                                        
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
        
        viewModel.eventDates
            .subscribe(onNext: {_ in
                self.calendar.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func isSelectableDate(_ date: Date, from fromDate: Date?) -> Bool {
        guard let fromDate = fromDate else {
            return date <= Date()
        }
        
        let range = Calendar.current.dateComponents([.day], from: fromDate, to: Date()).day ?? 0
        let isAfterFromDate = date >= fromDate
        if range <= 30 {
            let isBeforeNow = date <= Date()
            return isAfterFromDate && isBeforeNow
            
        } else {
            if let maxDate = Calendar.current.date(byAdding: .day, value: 30, to: fromDate) {
                let isBeforeNow = date <= maxDate
                return isAfterFromDate && isBeforeNow
                
            }
        }
        
        return false
    }
    
}

extension NewCreateScheduleVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.eventDates.value.contains { Calendar.current.isDate($0, inSameDayAs: date) } ? 1 : 0
    }
}

extension NewCreateScheduleVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateLabel.text = String.formatVietnameseDate(date)
        monthLabel.text = String.formatMonth(date)
        viewModel.date.accept(date.toString())
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthLabel.text = String.formatMonth(calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Calendar.current.startOfDay(for: Date()) // lấy ngày hôm nay (00:00)
        let selectedDay = Calendar.current.startOfDay(for: date) // lấy ngày đang xét
        
        return selectedDay >= today // chỉ cho chọn ngày hôm nay trở đi
    }
}

extension NewCreateScheduleVC: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: date)
        
        if selectedDay < today {
            return .lightGray
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if viewModel.eventDates.value.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
            return [.primaryColor] // màu của dấu chấm
        }
        return nil
    }
}
