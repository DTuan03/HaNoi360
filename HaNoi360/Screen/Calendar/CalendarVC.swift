//
//  CalendarVC.swift
//  HaNoi360
//
//  Created by Tuấn on 4/4/25.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarVC: BaseVC {
    let viewModel = CalendarVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithTitleOnly(title: "Lịch trình dự kiến")
    
    lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scope = .week // hiển thị theo tuần
        calendar.locale = Locale(identifier: "vi_VN")
        calendar.headerHeight = 0 // ẩn tháng
        
        calendar.appearance.weekdayTextColor = UIColor.gray
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleTodayColor = .primaryColor
        calendar.appearance.selectionColor = .primaryColor
        calendar.appearance.titleSelectionColor = UIColor.white
        calendar.weekdayHeight = 30
        
        calendar.appearance.borderRadius = 1.0
        calendar.appearance.weekdayFont = .medium16 // Font chữ thứ
        calendar.appearance.titleFont = .medium16 // Font chữ ngày
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // Ẩn mờ khi vuốt tháng
        
        calendar.select(Date())
        
        return calendar
    }()
    
    lazy var selectedDateLabel = LabelFactory.createLabel(text : selectedDate, font: .medium16, textColor: .black)
    
    lazy var currentDateLabel = LabelFactory.createLabel(text: "Hôm nay", font: .regular16, textColor: .primaryColor)
    
    var selectedDate: String = ""
    let dateFormatter = DateFormatter()
    var placesForSelectedDate: [Calendar]? = []
    
    lazy var titleCalendarLabel = LabelFactory.createLabel(text: "Địa điểm dự kiến đi",
                                                           font: .medium18,
                                                           textColor: .primaryTextColor)
    
    lazy var calendarTableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.separatorStyle = .none
        tableView.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = CalendarHelper.shared.format(date: Date())
        selectedDateLabel.text = selectedDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.date.accept(Date().toString())
    }
    
    override func setupUI() {
        view.addSubviews([navigationView, containerView, titleCalendarLabel, calendarTableView])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(128)
        }
        
        containerView.addSubviews([selectedDateLabel, currentDateLabel, calendar])
        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        currentDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
                
        calendar.snp.makeConstraints { make in
            make.top.equalTo(currentDateLabel.snp.bottom).offset(8)
            make.right.left.equalToSuperview().inset(8)
//            make.bottom.equalToSuperview().offset(16)
            make.height.equalToSuperview().multipliedBy(2)
        }
        
        titleCalendarLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        calendarTableView.snp.makeConstraints { make in
            make.top.equalTo(titleCalendarLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    override func setupEvent() {
        calendar.delegate = self
        
        let currentDateTap = UITapGestureRecognizer(target: self, action: #selector(scrollCurrentDate))
        currentDateLabel.addGestureRecognizer(currentDateTap)
    }
    
    @objc func scrollCurrentDate() {
        selectedDate = CalendarHelper.shared.format(date: Date())
        selectedDateLabel.text = selectedDate
        calendar.setCurrentPage(Date(), animated: true)
        calendar.select(Date())
        viewModel.date.accept(Date().toString())
    }
    
    override func bindState() {
        viewModel.date
            .subscribe(onNext: { _ in
                self.viewModel.featchPlace()
            })
            .disposed(by: disposeBag)
        
        viewModel.placeCalendar
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if value?.isEmpty ?? true {
                    self.calendarTableView.setLottieBackground(
                        name: "emptyCalendar",
                        title: "Bạn đang rảnh rỗi ?",
                        message: "Bạn đã sẵn sàng cho chuyến phiêu lưu tiếp theo chưa ?",
                        topAnimation: 0,
                        topStv: -110
                    )
                } else {
                    self.calendarTableView.clearBackground()
                }
                self.calendarTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = CalendarHelper.shared.format(date: date)
        selectedDateLabel.text = selectedDate
        viewModel.date.accept(date.toString())
        viewModel.featchPlace()
    }
}

extension CalendarVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.placeCalendar.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as? CalendarCell, let model = viewModel.placeCalendar.value?[indexPath.section] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configDate(model: model)
        
        return cell
    }
}

extension CalendarVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, handler in
            print("Hiển thị popup xác nhận xoá cho hàng \(indexPath.section)")
            handler(true)
        }
        let deleteImage = UIImage(named: "trash") // ảnh có icon + background bo tròn
        deleteAction.image = deleteImage
        deleteAction.backgroundColor = .backgroundTableViewCellColor // hoặc tùy chỉnh
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}
