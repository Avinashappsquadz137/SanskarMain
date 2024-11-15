//
//  IosAlertView.swift
//  Sanskar
//
//  Created by Warln on 03/03/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

enum AnimationType{
    case scale
    case rotate
    case bounceUp
    case zoomIn
}

class IosAlertView: UIViewController {
    
    var userAction:((_ callback: Bool) -> Void)? = nil
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var postiveBtn: UIButton!

    
    var backgroundColor: UIColor = appColor!
    var backgroundOpacity: CGFloat = 0.8
    var animationType: AnimationType = .bounceUp
    
    var titleMessage: String = ""
    var message: String = ""
    var btnTitlePositive: String = ""
    var btnTitleNegative: String = ""
    
    convenience init(title: String, message: String, animationType: AnimationType = .scale) {
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
    }
    deinit {
        print("Dallocated iOSAlertView from memory")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor.withAlphaComponent(backgroundOpacity)
        self.view.alpha = 0
        setup()
    }
    
    func setup() {
        
        alertView.layer.cornerRadius = 10
        alertView.clipsToBounds = true
        titleLbl.text = self.titleMessage
        let image = UserDefaults.standard.value(forKey: "img") as? String
        alertImg.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
    }
    
    
    private func startAnimating(type: AnimationType) {
        
        switch type {
        case .rotate:
            alertView.transform = CGAffineTransform(rotationAngle: 1.5)
        case .bounceUp:
            let screenHeight = UIScreen.main.bounds.height/2 + alertView.frame.height/2
            alertView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .zoomIn:
            alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        default:
            alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            print("use new animation ")
        }
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 1
            self.alertView.transform = .identity

           
        }, completion: {(n)in
            
        })
        
    }
    
    func showAlert(title: String, message: String,ButtonTitle:[String] = ["Yes","Cancel"], animationType: AnimationType, action: ((_ value: Bool) -> Void)? = nil) {
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.titleMessage = title
        self.message = message
        userAction = action
        btnTitlePositive = ButtonTitle[0]
        self.animationType = animationType
        guard let viewController = Utils.topViewController()else{return}
        viewController.present(self, animated: true, completion: nil)
        
    }
    
    @IBAction func postiveAction(_ sender: Any) {
        
        closeWithAnimation()
        dismiss(animated: true, completion: {
            if self.userAction != nil{
                self.userAction!(true)
            }
        })
    }
    
    @IBAction func negativeAction(_ sender: Any) {
        
        closeWithAnimation()

        dismiss(animated: true, completion: {
            if self.userAction != nil{
                self.userAction!(false)
            }
        })
    }
    
    
    func closeWithAnimation(){

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 0
            if self.animationType == .bounceUp{
                let screenHeight = (UIScreen.main.bounds.height/2 + self.alertView.frame.height/2)
                self.alertView.transform =  CGAffineTransform(translationX: 0, y: screenHeight)
            }else if self.animationType == .zoomIn{
                self.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }else{
                self.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
        }, completion: nil)
        
    }

}

var currentDate = Date()
var maxiMumDate = Date()
var minimumData = Date()
var isDisableFutureDate = false
var isMinimumDate = false

class Utils {
    
    static func dateString(date:Date,format:String) -> String {
       let calendar = Calendar.current
       let dateComponents = calendar.component(.day, from: date)
       let numberFormatter = NumberFormatter()
       numberFormatter.numberStyle = .ordinal
       let day = numberFormatter.string(from: dateComponents as NSNumber)
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = format
       return day! + dateFormatter.string(from: date)
    }
    
    static func differentbetWeenDate(previousDate:Date,nowDate:Date) -> String{
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year,.month]
        formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case

        let string = formatter.string(from: previousDate, to: nowDate)
        
        return string ?? ""
        
    }
    

    static func timeStampToString(str:String,format:String) -> String {
    
    if str == ""{
        return ""
    }
        let timestapm = TimeInterval(Double(str)!)
        let date = Date(timeIntervalSince1970: timestapm)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
        
    }
    
    
    static func timeStampToExpected(str:String,format:String) -> String {
    
    if str == ""{
        return ""
    }
        var date = Date()
        if str.count == 13{
            let timestapm = TimeInterval(Double(str)!/1000)
             date = Date(timeIntervalSince1970: timestapm)
        }else{
            let timestapm = TimeInterval(Double(str)!)
             date = Date(timeIntervalSince1970: timestapm)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
        
    }
    
    
    static func stringFromDate(date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: date)
        return dateStr
        
    }
    
    static func topViewController() -> UIViewController? {
        return topViewController(vc: UIApplication.shared.windows.last?.rootViewController)
    }
    
    private static func topViewController(vc:UIViewController?) -> UIViewController? {
        if let rootVC = vc {
            guard let presentedVC = rootVC.presentedViewController else {
                return rootVC
            }
            if let presentedNavVC = presentedVC as? UINavigationController {
                let lastVC = presentedNavVC.viewControllers.last
                return topViewController(vc: lastVC)
            }
            return topViewController(vc: presentedVC)
        }
        return nil
    }
    
    static func previousDate()-> [String]{
        let current = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        currentDate = current
        
         //ordinal date
       //  return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.dateString(date:current,format:" MMM , yyyy")]
        
        return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.stringFromDate(date: current, format: "dd MMM yyyy")]
    }
    
    static func nextDate() -> [String]{
        
        let current = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        currentDate = current
        
        //ordinal date
       //   return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.dateString(date:current,format:" MMM , yyyy")]
        
        return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.stringFromDate(date: current, format: "dd MMM yyyy")]
    }

}

