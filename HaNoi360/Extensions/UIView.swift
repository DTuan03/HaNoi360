//
//  UIView.swift
//  HaNoi360
//
//  Created by Tuấn on 27/3/25.
//
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func addSubviews(_ subviews: UIView...) {
        addSubviews(subviews)
    }
    
    func isVisible(in view: UIView?) -> Bool {
        guard let view = view else { return true }
        let viewport = view.convert(bounds, to: self)
        guard viewport.intersects(view.bounds) else {
            return false
        }
        
        return isVisible(in: view.superview)
    }
    
    @discardableResult
    func withBorder(width: CGFloat,
                    cornerRadius: CGFloat = 0,
                    color: UIColor? = .clear) -> Self {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
        layer.cornerRadius = cornerRadius
        return self
    }
    
    // MARK: - Utils
    func findFirstResponder() -> UIView? {
        guard !isFirstResponder else { return self }
        for view in subviews {
            let match = view.findFirstResponder()
            if match != nil {
                return match
            }
        }
        return nil
    }
    
    func dropShadow(color: UIColor,
                    opacity: Float = 1,
                    offSet: CGSize,
                    radius: CGFloat = 1,
                    scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
//    func whiteShadow() {
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.init(hexString: "000000", alpha: 0.2).cgColor
//        layer.shadowOpacity = 1
//        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        layer.shadowRadius = 4
//    }
    
    func imageFromView(scale: CGFloat) -> Data? {
        takeSnapshot(scale: scale)?.pngData()
    }
    
    func takeSnapshot(scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale * scale)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func pdfFromView(saveToDocumentsWithFileName fileName: String) -> URL? {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, bounds, nil)
        
        let rect = CGRect(origin: .zero,
                          size: UIScreen.main.bounds.size)
        
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext(),
              let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first else { return nil }
        layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        let fileUrl = documentsURL.appendingPathComponent("\(fileName).pdf")
        // swiftlint:disable force_try
        try! pdfData.write(to: fileUrl,
                           options: .atomic)
        return fileUrl
    }
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [5, 5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else { return nil }
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect(origin: .zero, size: size))
        guard let scaledImage = context?.makeImage() else { return nil }
        return UIImage(cgImage: scaledImage)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    @IBInspectable var tr_cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var tr_borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var tr_borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            } else {
                self.layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var tr_shadowBlur: CGFloat {
        get {
            return self.layer.shadowRadius * 2.0
        }
        set {
            self.layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable var tr_shadowColor: UIColor? {
        get {
            if let color = self.layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.shadowColor = color.cgColor
                self.layer.shadowOpacity = 1.0
            } else {
                self.layer.shadowColor = nil
                self.layer.shadowOpacity = 0.0
            }
        }
    }
}

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
