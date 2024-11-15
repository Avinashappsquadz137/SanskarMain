//
//  RoundCorners.swift
//  eMedicozEducator
//
//  Created by DAMS on 19/01/21.
//  Copyright © 2021 DAMS DELHI. All rights reserved.
//

import UIKit
//
//@IBDesignable
//
//class RoundUIView: UIView {
//
//    @IBInspectable var borderColor: UIColor = UIColor.white {
//        didSet {
//            self.layer.borderColor = borderColor.cgColor
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat = 2.0 {
//        didSet {
//            self.layer.borderWidth = borderWidth
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet {
//            self.layer.cornerRadius = cornerRadius
//        }
//    }
//
//}
@IBDesignable

class RoundUIView: UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }

    @IBInspectable var cornerRadiues: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
}


@IBDesignable
class RoundUIButton: UIButton {
    // MARK: - Properties
    @IBInspectable var cornerRadiuses: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColors: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOffsetHeight: CGFloat = 1.8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOpacitys: Float = 0.30 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowRadiuses: CGFloat = 3.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var shadowLayer: CAShapeLayer = CAShapeLayer() {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: shadowOffsetWidth,
                                          height: shadowOffsetHeight)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

extension UIView {
    /// Add Shadow to your view
    /// - Parameters:
    ///   - shadowColor: Shadow Color
    ///   - shadowOffset: Offsets
    ///   - shadowOpacity: Opacity
    ///   - shadowRadius: Radius
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor, shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0), shadowOpacity: Float = 0.4, shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
    }
}
