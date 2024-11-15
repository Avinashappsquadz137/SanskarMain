//
//  TBPremiumPaymentVC.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 29/01/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class TBPremiumPaymentVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var planBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var blurBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var bottomAmountView: UIView!
    @IBOutlet weak var amountAndMobileLbl: UILabel!
    @IBOutlet weak var nextAndSigninBtn: UIButton!
    @IBOutlet weak var loginwithothernumberbtn: UIButton!
    
    @IBOutlet weak var amountWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var radioImg1: UIImageView!
    @IBOutlet weak var radioImg2: UIImageView!
    @IBOutlet weak var radioImg3: UIImageView!
    @IBOutlet weak var popupTF: UITextField!
    var selected = ""
    var paymentData : [paymentModel] = []
    var paymentModelData : paymentModel?
    var userId : String = ""
    var selectedIndex : Int?
    var currcenyData = [Any]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var planLbl: UILabel!
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let premium_is = UserDefaults.standard.string(forKey: "is_premium")
        print(premium_is)
//        if premium_is  == 0{
//            self.loginwithothernumberbtn.isHidden = false
//        }
//        else{
//            self.loginwithothernumberbtn.isHidden = true
//        }
        initializer()
        
        // Do any additional setup after loading the view.
    }
           
    func initializer(){
        
        let param : Parameters = ["user_id": currentUser.result?.id ?? ""]
        getPaymentPlanApi(param)
         
         planBtn.cornerRadius = planBtn.frame.size.height/2
         planLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
         payBtn.cornerRadius = payBtn.frame.size.height/2
         payBtn.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
         payBtn.borderWidth = 2
         
         watchBtn.cornerRadius = watchBtn.frame.size.height/2
         watchBtn.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
         watchBtn.borderWidth = 2
         
         
         planBtn.clipsToBounds = true
         payBtn.clipsToBounds = true
         watchBtn.clipsToBounds = true
         
//         blurBtn.isHidden = true
//         bottomView.roundCorners([.topLeft, .topRight], radius: 30)
//         bottomView.isHidden = true
         
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //bottomAmountView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 9, scale: true)
    }
   
    @IBAction func blurBtn(_ sender:UIButton) {
        blurBtn.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 1.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
        }, completion: { (completed) in
            self.bottomView.isHidden = true
            
        })
    }
    
    //MARK:- Api Method.
    func getPaymentPlanApi(_ param : Parameters){

        let jwt:HTTPHeaders = ["jwt":"\(UserDefaults.standard.value(forKey: "jwt") ?? "")"]
  //      DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodData1(APIManager.sharedInstance.KPaymentPlanApi, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})

            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Bool == true {
                    self.currcenyData.append(JSON["data"] as? [Any] ?? [])
                    let data = JSON.ArrayofDict("data")
                    
                    _ = data.filter({ (dict) -> Bool in
                         
                        self.paymentData.append(paymentModel(dict: dict))
//                        let list = dict.ArrayofDict("")
//                        if list.count == 0{
//
//                        }else{
//                            self.premiumData.append(seeMoreModel(dict: dict))
//                        }
//                        let premium_is = UserDefaults.standard.string(forKey: "is_premium")
//                        print(premium_is)
//                        
//                        if premium_is == 0{
//                            self.loginwithothernumberbtn.isHidden = false
//                        }
//                        else{
//                            self.loginwithothernumberbtn.isHidden = true
//                        }
                        
                        return true
                    })
                    self.tableView.reloadData()
                }else {
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
            }
        }
    }

    @IBAction func proceedBtn(_ sender:UIButton) {

        if selected != ""{
            if currentUser.result!.id! == "163"{
                UserDefaults.standard.setValue(1, forKey: "isComeFromPaymemt")
                let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                if sms == "1"{
                    let record = UserDefaults.standard.integer(forKey: "recorddata")
                        print(record)

                        if record == 1 {
                        self.dismiss(animated: true) {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "usersuggestionlogin") as! usersuggestionlogin
                            if #available(iOS 15.0, *) {
                                if let sheet = vc.sheetPresentationController {
                                    var customDetent: UISheetPresentationController.Detent?
                                    if #available(iOS 16.0, *) {
                                        customDetent = UISheetPresentationController.Detent.custom { context in
                                            return 450 // Replace with your desired height
                                        }
                                        sheet.detents = [customDetent!]
                                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                                    }
                                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                                    sheet.prefersGrabberVisible = true
                                    sheet.preferredCornerRadius = 24
                                }
                            }
                            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                        }
                    }
                    else {
                        self.dismiss(animated: true) {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "newloginpage") as! newloginpage
                            if #available(iOS 15.0, *) {
                                if let sheet = vc.sheetPresentationController {
                                    var customDetent: UISheetPresentationController.Detent?
                                    if #available(iOS 16.0, *) {
                                        customDetent = UISheetPresentationController.Detent.custom { context in
                                            return 450 // Replace with your desired height
                                        }
                                        sheet.detents = [customDetent!]
                                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                                    }
                                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                                    sheet.prefersGrabberVisible = true
                                    sheet.preferredCornerRadius = 24
                                }
                            }
                            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                        }
                    }
                }else{
                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }else{
                for i in 0...paymentData.count - 1{
                    if paymentData[i].is_Selected == true{
                        self.paymentModelData = paymentData[i]
                    }
                }
                if iscoming == "FromScan" {
                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBCouponScreenVC) as! TBCouponScreenVC
                    vc.paymentData = self.paymentModelData
                    vc.userID = userId
                    vc.qrscan = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBCouponScreenVC) as! TBCouponScreenVC
                    vc.paymentData = self.paymentModelData
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
        }
        else{
            self.addAlert(ALERTS.KERROR, message: ALERTS.KPleaseSelectOption, buttonTitle: ALERTS.kAlertOK)
        }
    }
    
    
    
    @IBAction func menuBtn(_ sender:UIButton) {
        self.completionHandler?(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addCategory() {
        if #available(iOS 13.0, *) {
            let popoverContent = self.storyboard?.instantiateViewController(identifier: "TBPaymentPopover") as! TBPaymentPopover
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController
            popoverContent.preferredContentSize = CGSize(width: 500,height: 100)
            popover?.delegate = self
            popover?.sourceView = self.view
            popover?.sourceRect = CGRect(x: 100,y: 100,width: 0,height: 0)
            
            self.present(nav, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
        //            self.storyboard.instantiateViewControllerWithIdentifier("NewCategory") as UIViewController
        
    }
    @IBAction func nextAndSigninBtn(_ sender:UIButton) {
        
        addCategory()
        
        //        amountWidthConstraints.constant = 190
        //        DispatchQueue.main.async {
        //            self.bottomAmountView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 9, scale: true)
        //        }
        //        amountAndMobileLbl.text = "Mobile No: 8299478098"
        //        nextAndSigninBtn.setTitle("Sign In", for: .normal)
    }
    
    @IBAction func signinBtn(_ sender:UIButton) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 40, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension TBPremiumPaymentVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20.0
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentData.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row;
        selected = "selected"
        tableView.reloadData()
    }
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath)
        
        let radioImg = cell.viewWithTag(1) as? UIImageView
        let planLbl = cell.viewWithTag(2) as? UILabel
        let amountLbl = cell.viewWithTag(3) as? UILabel

        planLbl?.text = paymentData[indexPath.row].plan_name
        
        
        
        let adskey = UserDefaults.standard.value(forKey: "iosads") as? String ?? ""
        if adskey == "1"{
            if paymentData[indexPath.row].currency == "INR"{
                
                amountLbl?.text = "\(kCureencySymbol)\(paymentData[indexPath.row].amount ?? "")"
            }else{
                amountLbl?.text = "$ \(paymentData[indexPath.row].amount ?? "")"
            }
        }
        else {
            if paymentData[indexPath.row].currency == "INR"{
                
                amountLbl?.text = "\(kCureencySymbol)\(paymentData[indexPath.row].ios_amount ?? "")"
            }else{
                amountLbl?.text = "$ \(paymentData[indexPath.row].ios_amount ?? "")"
            }
        }
     
        if(indexPath.row == selectedIndex)
        {
            paymentData[indexPath.row].is_Selected = true
//            cell.accessoryType = .checkmark
            radioImg?.image = UIImage(named: "radio_active-1")
        }
        else
        {
            paymentData[indexPath.row].is_Selected = false
//            cell.accessoryType = .none
            radioImg?.image = UIImage(named: "radio_inactive")

        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
