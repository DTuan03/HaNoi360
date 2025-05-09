//
//  MapDetailVC.swift
//  HaNoi360
//
//  Created by Tuấn on 2/5/25.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

class MapDetailVC: BaseViewController {
    var placeLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var namePlace: String?
    var address: String?
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.userTrackingMode = .followWithHeading
        mv.showsUserLocation = true
        return mv
    }()
    
    //Lay vi tri hien tai
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
        let tf = TextFieldFactory.createTextField(placeholder: "Nhập địa điểm xuất phát", bgColor: .white)
        tf.imageLeftViewMapVC(image: UIImage(named: "search")!)
        tf.delegate = self
        tf.returnKeyType = .search
        tf.imageDeleteRightView(image: UIImage(systemName: "multiply"))
        return tf
    }()
    
    lazy var resultContainerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.isHidden = false
        return view
    }()
    
    lazy var pullDownView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 3
        return v
    }()
    
    lazy var namePlaceLabel = LabelFactory.createLabel(text: "Khoảng cách: 0 km", font: .medium20, numberOfLines: 2)
        
    lazy var closeBtn = ButtonFactory.createImageButton(withImage: UIImage(systemName: "multiply"), tinColor: .white)
    
    lazy var chooseBtn = ButtonFactory.createButton("   Chỉ đường   ", font: .medium14, rounded: true)
    
    weak var delegate: MapVCDelegate?
        
    var coordinateSearch: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
                
        let region = MKCoordinateRegion(center: placeLocation, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: false)
        
        addPinAtCoordinate(placeLocation, title: namePlace, subtitle: address)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let pointA = locationManager.location?.coordinate else { return }
        let pointB = placeLocation
        
        showRoute(from: pointA, to: pointB)
        locationManager.stopUpdatingLocation()
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
            make.right.equalToSuperview().inset(58)
            make.height.equalTo(40)
        }
        
        resultContainerView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
        
        let stv = [namePlaceLabel, chooseBtn].vStack(8)
        
        resultContainerView.addSubviews([pullDownView, stv, closeBtn])
        
        pullDownView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(40)
            make.height.equalTo(6)
            make.centerX.equalToSuperview()
        }
        
        stv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(8)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalToSuperview().inset(48)
        }
        
        closeBtn.layer.cornerRadius = 20
        closeBtn.backgroundColor = .lightGray
        closeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(8)
            make.height.width.equalTo(40)
        }
    
        chooseBtn.isHidden = true
    }
    
    override func setupEvent() {
        backBtn.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        closeBtn.rx.tap
            .subscribe(onNext: {
                self.resultContainerView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        chooseBtn.rx.tap
            .subscribe(onNext: {
                guard let pointA = self.coordinateSearch else { return }
                self.chooseBtn.isHidden = true
                self.namePlaceLabel.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(24)
                    make.left.equalToSuperview().offset(16)
                    make.width.equalToSuperview().multipliedBy(0.8)
                    make.bottom.equalToSuperview().inset(48)
                }
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.showRoute(from: pointA, to: self.placeLocation)
            })
            .disposed(by: disposeBag)
    }
    
    func showRoute(from sourceCoord: CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoord)
        let destPlacemark = MKPlacemark(coordinate: destinationCoord)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destPlacemark)
        directionRequest.transportType = .automobile // hoặc .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                self.showAlert()
                return
            }
            
            let distanceInMeters = route.distance
            let expectedTravelTimeInSeconds = route.expectedTravelTime
            
            let distanceInKm = distanceInMeters / 1000.0
            let travelTimeInMinutes = expectedTravelTimeInSeconds / 60.0
            
            print("Khoảng cách: \(String(format: "%.2f", distanceInKm)) km")
            
            self.namePlaceLabel.text = ("Khoảng cách: \(String(format: "%.2f", distanceInKm)) km")
            
            // Vẽ route lên map
            self.mapView.addOverlay(route.polyline)
            
            // Zoom vừa khít route
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20),
                                           animated: true)
        }
    }

    
    func addPinAtCoordinate(_ coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    func searchLocationInHanoi(keyword: String) {
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let `self` = self, let mapItem = response?.mapItems.first else {
                self?.showAlert(title: "Chưa tìm thấy địa điểm nào", message: "Vui lòng tìm kiếm địa điểm khác.")
                return }
            let coordinate = mapItem.placemark.coordinate
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
                guard let placemark = placemarks?.first else { return }
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 900, longitudinalMeters: 900)
                self.mapView.setRegion(region, animated: true)
                self.showResultContainerView(placemark: placemark)
            }
        }
    }
    
    func showResultContainerView(placemark: CLPlacemark) {
        self.chooseBtn.isHidden = false
        self.resultContainerView.isHidden = false
        namePlaceLabel.text = placemark.name ?? "Chưa xác định"
        if let coordinate = placemark.location?.coordinate {
            self.coordinateSearch = coordinate
        }
    }
    
    func showAlert(title: String = "Không tìm thấy tuyến đường đi phù hợp", message: String = "Vui lòng chọn địa điểm xuất phát khác.") {
        self.resultContainerView.isHidden = true
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension MapDetailVC: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MapDetailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, !keyword.isEmpty {
            searchLocationInHanoi(keyword: keyword)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}


