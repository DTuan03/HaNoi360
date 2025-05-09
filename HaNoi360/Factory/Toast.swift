//
//  Toast.swift
//  HaNoi360
//
//  Created by Tuấn on 20/4/25.
//
import UIKit
import SnapKit

class Toast {
    static func showToast(message: String?, image: String?) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        let toastView = UIView()
        toastView.backgroundColor = .white
        toastView.layer.cornerRadius = 12
        toastView.clipsToBounds  = true
        toastView.alpha = 0
        window.addSubview(toastView)

        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(window.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.greaterThanOrEqualToSuperview().offset(16)
        }

        let imageView = UIImageView()
        imageView.image = UIImage(named: image ?? "toast_success")
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }

        let label = UILabel()
        label.text = message ?? ""
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .top
        stackView.distribution = .fill

        toastView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        UIView.animate(withDuration: 0.5, animations: {
            toastView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseIn, animations: {
                toastView.alpha = 0.0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        })
    }
}
