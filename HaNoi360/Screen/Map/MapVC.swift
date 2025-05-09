//
//  MapVC.swift
//  HaNoi360
//
//  Created by Tuấn on 13/4/25.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

protocol MapVCDelegate: AnyObject {
    func didMaped(district: String, coordinate: CLLocationCoordinate2D)
}

class MapVC: BaseViewController {
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.showsUserLocation = true // Hiển thị vị trí người dùng
        return mv
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    lazy var backBtn = {
        let btn = ButtonFactory.createImageButton(withImage: .back, radius: 20)
        btn.backgroundColor = .white
        return btn
    }()
    
    lazy var searchTF = {
        let tf = TextFieldFactory.createTextField(placeholder: "Nhập địa điểm", bgColor: .white)
        tf.imageLeftViewMapVC(image: UIImage(named: "search")!)
        tf.delegate = self
        tf.returnKeyType = .search
        return tf
    }()
    
    lazy var resultContainerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.isHidden = true
        return view
    }()
    
    lazy var pullDownView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 3
        return v
    }()
    
    lazy var namePlaceLabel = LabelFactory.createLabel(font: .medium20)
    
    lazy var addressLabel = LabelFactory.createLabel(font: .regular16)
    
    lazy var deleteBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "multiply"), tinColor: .white)
    
    lazy var chooseBtn = ButtonFactory.createButton("   Chọn địa điểm   ", font: .medium14, rounded: true)
    
    weak var delegate: MapVCDelegate?
    
    var district: String = ""
    
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        let hanoiCenter = CLLocationCoordinate2D(latitude: 21.028511, longitude: 105.804817)
        let region = MKCoordinateRegion(center: hanoiCenter, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: false)
    }
    
    @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        mapView.removeAnnotations(mapView.annotations)
        addPinAtCoordinate(coordinate, title: "Đã chọn")
        getAddressFromCoordinate(coordinate)
    }
    
    override func setupUI() {
        view.addSubviews([mapView, backBtn, searchTF, resultContainerView])
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(40)
        }
        
        searchTF.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.left.equalTo(backBtn.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        resultContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        resultContainerView.addSubviews([pullDownView, namePlaceLabel, addressLabel, deleteBtn, chooseBtn])
        
        pullDownView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(40)
            make.height.equalTo(6)
            make.centerX.equalToSuperview()
        }
        
        namePlaceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(namePlaceLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
        deleteBtn.layer.cornerRadius = 20
        deleteBtn.backgroundColor = .lightGray
        deleteBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(8)
            make.height.width.equalTo(40)
        }
        
        chooseBtn.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(48)
            make.height.equalTo(40)
        }
        
    }
    
    override func setupEvent() {
        backBtn.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        deleteBtn.rx.tap
            .subscribe(onNext: {
                self.resultContainerView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        chooseBtn.rx.tap
            .subscribe(onNext: {
                self.delegate?.didMaped(district: self.district, coordinate: self.coordinate!)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func addPinAtCoordinate(_ coordinate: CLLocationCoordinate2D, title: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    func getAddressFromCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                if self.checkCiTy(placemark: placemark) {
                    self.showResultContainerView(placemark: placemark)
                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    func searchLocationInHanoi(keyword: String) {
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        
        let hanoiCenter = CLLocationCoordinate2D(latitude: 21.028511, longitude: 105.804817)
        let hanoiRegion = MKCoordinateRegion(center: hanoiCenter, latitudinalMeters: 50000, longitudinalMeters: 50000)
        request.region = hanoiRegion
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self, let mapItem = response?.mapItems.first else { return }
            let coordinate = mapItem.placemark.coordinate
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
                guard let placemark = placemarks?.first else { return }
                if self.checkCiTy(placemark: placemark) {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = mapItem.name
                    self.mapView.addAnnotation(annotation)
                    
                    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    self.mapView.setRegion(region, animated: true)
                    self.showResultContainerView(placemark: placemark)
                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    func showResultContainerView(placemark: CLPlacemark) {
        self.resultContainerView.isHidden = false
        namePlaceLabel.text = placemark.name ?? "Chưa xác định"
        if let coordinate = placemark.location?.coordinate {
//            self.addressLabel.text = "Toạ độ: (\(coordinate.latitude), \(coordinate.longitude)"
            self.coordinate = coordinate
        }
        addressLabel.text = "\(placemark.subAdministrativeArea ?? "Chưa xác định")"
        if let district = placemark.subAdministrativeArea {
            self.district = district
        }
    }
    
    func checkCiTy(placemark: CLPlacemark) -> Bool {
        if placemark.administrativeArea == "Thành Phố Hà Nội" {
            return true
        } else {
            return false
        }
    }
    
    func showAlert() {
        self.resultContainerView.isHidden = true
        let alert = UIAlertController(title: "Không hợp lệ", message: "Vui lòng chọn địa điểm trong Hà Nội.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension MapVC: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MapVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, !keyword.isEmpty {
            searchLocationInHanoi(keyword: keyword)
        }
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func imageLeftViewMapVC(image: UIImage, placeholder: String = "") {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 56))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 12, y: 16, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFill
        paddingView.addSubview(imageView)
        
        self.leftView = paddingView
        self.leftViewMode = .always
        self.keyboardType = .default
        if placeholder == "passWord" {
            self.isSecureTextEntry = true
        }
    }
}
