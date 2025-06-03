//
//  ProfileVC.swift
//  HaNoi360
//
//  Created by Tuấn on 8/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileVC: BaseVC {
    let viewModel = ProfileVM()
    lazy var navigationView = NavigationViewFactory.createNavigationViewWithBackButtonAndTitle(image: .back,
                                                                                               title: "Hồ sơ",
                                                                                               delegate: self)
    lazy var tableView = {
        let tableView = TableViewFactory.createTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 70
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.dataSource = self
        return tableView
    }()
    
    let titles: [String] = ["Tên của bạn", "Email", "Điện thoại", "Sở thích", "Ngày sinh", "Địa chỉ"]
    
    lazy var saveBtn = ButtonFactory.createButton("Lưu",
                                                  font: .bold16,
                                                  textColor: .textButtonColor)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.featchUser()
    }
    
    override func setupUI() {
        view.addSubviews([navigationView, tableView/*, saveBtn*/])
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(70 * 6)
        }
        
//        saveBtn.snp.makeConstraints { make in
//            make.top.equalTo(tableView.snp.bottom).offset(32)
//            make.left.right.equalToSuperview().inset(40)
//        }
    }
    
    override func bindState() {
        viewModel.user
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell, let model = viewModel.user.value else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configData(title: titles[indexPath.row], index: indexPath.row, model: model)
        cell.editLabel.isHidden = indexPath.row == 1 ? true : false
        cell.delegate = self
        return cell
    }
    
}

extension ProfileVC: NavigationViewDelegate {
    func didTapButton(in view: UIView) {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileVC: ProfileCellDelegate {
    func didTapEdit(in cell: ProfileCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let placeholder: [String] = ["Nhập họ tên", "", "Nhập số điện thoại", "Sở thích của bạn là gì?", "Ngày sinh", "Bạn đang ở đâu?"]
        let field: [String] = ["name", "", "phone", "interest", "date", "address"]
        let vc = PopupProfile()
        vc.titleLb.text = titles[indexPath.row]
        vc.textField.placeholder = placeholder[indexPath.row]
        vc.valueOld = cell.valueLabel.text
        vc.onData = {
            self.viewModel.featchUser()
            self.tableView.reloadData()
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        vc.index = indexPath.row
        vc.field = field[indexPath.row]
        if indexPath.row == 4 {
            vc.textField.isHidden = true
        } else {
            vc.picker.isHidden = true
        }
        self.present(vc, animated: true)
    }
}

class PopupProfile: BaseVC, UITextFieldDelegate {
    let viewModel = ProfileVM()
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPopupColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var closeBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "multiply"))
    
    lazy var titleLb = LabelFactory.createLabel(text: "Ten cua ban", font: .medium16)
    
    let lineView = UIViewFactory.createLineView()
    
    lazy var textField = {
        let tf = TextFieldFactory.createTextField(placeholder: "ho ten", font: .regular14, bgColor: .white, rounded: 8)
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.returnKeyType = .done
        tf.delegate = self
        return tf
    }()
    
    lazy var picker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "vi_VN")
        return datePicker
    }()
    
    lazy var stv = [textField, picker].vStack()
    
    lazy var saveBtn = ButtonFactory.createButton("Lưu",
                                                  font: .bold16,
                                                  textColor: .textButtonColor)
    
    var index: Int?
    var field: String?
    var valueOld: String?
    var onData: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        if index == 2 {
            textField.keyboardType = .numberPad
        }
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor(hex: "#cbcbcd", alpha: 0.5)
        view.addSubview(containerView)
        
        if index == 4 {
            picker.date = valueOld?.toDate() ?? Date()
        } else {
            textField.text = valueOld
        }
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubviews([closeBtn, titleLb, lineView, stv, saveBtn])
        
        closeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(8)
            make.height.width.equalTo(24)
        }
        
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(closeBtn.snp.top)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        stv.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.right.left.equalToSuperview().inset(16)
        }
        
        picker.snp.makeConstraints { make in
            
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(stv.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(32)
        }
        textField.imageLeftView(image: UIImage(systemName: "pencil.line") ?? .back)
    }
    
    override func setupEvent() {
        closeBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        saveBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if index == 4 {
                    if self.picker.date < Date() {
                        self.viewModel.updateProfile(field: self.field ?? "", value: self.picker.date.toString()) {
                            self.onData?()
                            self.dismiss(animated: true)
                        }
                    } else {
                        Toast.showToast(message: "Ngày không phù hợp", image: "error")
                    }
                } else {
                    if self.valueOld != self.textField.text {
                        self.viewModel.updateProfile(field: self.field ?? "", value: self.textField.text ?? "") {
                            self.onData?()
                            self.dismiss(animated: true)
                        }
                    } else {
                        Toast.showToast(message: "Chưa thay đổi thông tin", image: "error")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func bindState() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.isLoading.accept(value)
            })
            .disposed(by: disposeBag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
