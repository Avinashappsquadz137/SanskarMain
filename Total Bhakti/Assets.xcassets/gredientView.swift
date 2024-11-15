//
//  gredientView.swift
//  Poppn
//
//  Created by viru on 09/04/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class gredientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var thirdColor: UIColor = UIColor.clear {
          didSet {
              updateView()
          }
      }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer

        layer.colors = [firstColor, secondColor,thirdColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        }else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
            
        }
    }
}

@IBDesignable
class gredientView2: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var thirdColor: UIColor = UIColor.clear {
          didSet {
              updateView()
          }
      }
    @IBInspectable var fourColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var fiveColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer

        layer.colors = [firstColor, secondColor,thirdColor,fourColor,fiveColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        }else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
            
        }
    }
}



//MARK:- UIVIEW DESIGNABLE
extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
       var borderWidth: CGFloat {
           get {
               return layer.borderWidth
           }
           set {
               layer.borderWidth = newValue
           }
       }
    @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {

                layer.shadowRadius = newValue
            }
        }
        @IBInspectable
        var shadowOffset : CGSize{

            get{
                return layer.shadowOffset
            }set{

                layer.shadowOffset = newValue
            }
        }

        @IBInspectable
        var shadowColor : UIColor{
            get{
                return UIColor.init(cgColor: layer.shadowColor!)
            }
            set {
                layer.shadowColor = newValue.cgColor
            }
        }
        @IBInspectable
        var shadowOpacity : Float {

            get{
                return layer.shadowOpacity
            }
            set {

                layer.shadowOpacity = newValue

            }
        }
}

