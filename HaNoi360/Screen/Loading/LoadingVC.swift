//
//  Loading.swift
//  HaNoi360
//
//  Created by Tuấn on 18/4/25.
//

import UIKit
import SnapKit

class LoadingVC: BaseViewController {
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#EEEEEE")
        v.layer.cornerRadius = 15
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        return v
    }()

    lazy var logoIV = ImageViewFactory.createImageView(image: .logo, radius: 10)
    
    private let arcLayer = CAShapeLayer()
    
    override func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(30)
        }
        containerView.addSubview(logoIV)
        logoIV.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        setupArc()
        startRotating()
        startPulsingLogo()
    }
    
    private func setupArc() {
        let radius: CGFloat = 15
        let center = view.center
        
        // Vẽ 1/3 hình tròn (tầm 120 độ)
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = startAngle + CGFloat(Double.pi * 2 * (1.0 / 8.0)) // 120 độ
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        arcLayer.path = path.cgPath
        arcLayer.strokeColor = UIColor.primaryColor.cgColor
        arcLayer.lineWidth = 3
        arcLayer.lineCap = .round
        containerView.layer.addSublayer(arcLayer)
    }
    
    private func startRotating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 2.0 // thời gian quay, giam di quay nhanh hơn
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        
        // Tạo container để xoay quanh ảnh
        let rotationLayer = CALayer()
        rotationLayer.frame = view.bounds
        view.layer.addSublayer(rotationLayer)
        rotationLayer.addSublayer(arcLayer)
        rotationLayer.add(rotation, forKey: "rotateAnimation")
    }
    
    private func startPulsingLogo() {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.5
        pulse.toValue = 1.2
        pulse.duration = 1
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        logoIV.layer.add(pulse, forKey: "pulse")
    }
}
//import SkeletonView
//
//class LoadingVC: UIViewController {
//
//    let avatarImageView: UIImageView = {
//        let img = UIImageView()
//        img.isSkeletonable = true
//        img.layer.cornerRadius = 40
//        img.clipsToBounds = true
//        return img
//    }()
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.isSkeletonable = true
//        label.text = "Loading..."
//        label.font = .boldSystemFont(ofSize: 20)
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        view.isSkeletonable = true
//        view.addSubview(avatarImageView)
//        view.addSubview(nameLabel)
//
//        // Layout đơn giản
//        avatarImageView.frame = CGRect(x: 40, y: 100, width: 80, height: 80)
//        nameLabel.frame = CGRect(x: 40, y: 190, width: 200, height: 30)
//
//        // Hiển thị skeleton
//        view.showAnimatedGradientSkeleton()
//
//        // Giả lập delay API
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.view.hideSkeleton()
//            self.avatarImageView.image = UIImage(named: "test")
//            self.nameLabel.text = "Nguyễn Văn A"
//        }
//    }
//}
