//
//  TBCouponListVC.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 18/03/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

protocol selectedCoupon {
    func dataPass(couponModel: couponListModel?)
}
class TBCouponListVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var planBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var promoField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    var couponListArray: [couponListModel] = []
    var delegate : selectedCoupon?
    var couponString: String?
    override func viewDidLoad() {
    super.viewDidLoad()
        
        initializer()
    }
    
    func initializer(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        planBtn.cornerRadius = planBtn.frame.size.height/2
        payBtn.cornerRadius = payBtn.frame.size.height/2
        
        watchBtn.cornerRadius = watchBtn.frame.size.height/2
        watchBtn.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        watchBtn.borderWidth = 2
        
        submitBtn.layer.cornerRadius = 10
        submitBtn.clipsToBounds = true
        
        planBtn.clipsToBounds = true
        payBtn.clipsToBounds = true
        watchBtn.clipsToBounds = true
        
        
        tableView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 10, opacity: 0.35, layerRadius: 10)
        
        let params:Parameters = ["user_id":currentUser.result?.id ?? ""]
        couponListApi(params)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = gradientBackground()
        layer.frame = submitBtn.bounds
        submitBtn.clipsToBounds = true
        submitBtn.layer.insertSublayer(layer, at: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        return true;
    }
    @objc func applyCouponBtn(){
        print("Apply Coupon")
        if ((couponString?.isEmpty) != nil){
            
            let params:Parameters = ["user_id":currentUser.result?.id ?? "","promocode": couponString! ]
            applyPromocodeApi(params)

        }
        else{
            addAlert(ALERTS.kAlert, message: ALERTS.KCouponEmpty, buttonTitle:ALERTS.kAlertOK)
        }
    }
    @objc func valueChanged(_ textField: UITextField){
        print("textField:::",textField.text ?? "")
        couponString = textField.text
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton ) {
        if promoField.text == nil {
            addAlert(ALERTS.kAlert, message: ALERTS.KCouponEmpty, buttonTitle:ALERTS.kAlertOK)
        }else{
            let params:Parameters = ["user_id":currentUser.result?.id ?? "","promocode": promoField.text! ]
            applyPromocodeApi(params)
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Promo code Api Method.
    func applyPromocodeApi(_ param : Parameters){
        
        self.uplaodData1(APIManager.sharedInstance.KPromoCodeValidate, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                
                self.promoField.text?.removeAll()
                if JSON.value(forKey: "status") as? Bool == true {
                    let data = ((JSON as? NSDictionary)?["data"] as? NSDictionary)
                                        
//                    _ = data?.filter({ (dict) -> Bool in
//                        
//                        self.couponListArray.append(couponListModel(dict: dict))
//                        
//                        return true
//                    })
                    self.tableView.reloadData()
                }else {
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
            }
        }
    }
    //MARK:- Api Method.
    func couponListApi(_ param : Parameters){
        
        self.uplaodData1(APIManager.sharedInstance.KCouponListApi, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                
                if JSON.value(forKey: "status") as? Bool == true {
                    let data = JSON.ArrayofDict("data")
                    
                    _ = data.filter({ (dict) -> Bool in
                        
                        self.couponListArray.append(couponListModel(dict: dict))
                        
                        return true
                    })
                    self.tableView.reloadData()
                }else {
                    
//                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    self.noDataLbl.text = "Sorry! No Coupoun here..."
                    
                }
            }else {
            }
            self.tableView.reloadData()
        }
    }
    
}

extension TBCouponListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if couponListArray.count != 0{
            return couponListArray.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            return 70
//        }
//        else if indexPath.row == 1{
//            return 70
//        }
//        else{
//            return 70
//
//        }
        return 70
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponcell", for: indexPath)
        let couponNameLbl = cell.viewWithTag(2) as? UILabel
        let couponValueLbl = cell.viewWithTag(3) as? UILabel
        
        let couponArray = couponListArray[indexPath.row ]
        couponNameLbl?.text = couponArray.coupon_tilte
        
        if couponArray.coupon_type == "2"{ //Percentile
            couponValueLbl?.text = "\(couponArray.coupon_value ?? "")% off"
        }
        else{
            couponValueLbl?.text = "FLAT \(couponArray.coupon_value ?? "") off"
        }
        
        
        cell.selectionStyle = .none
        return cell
        
//        if indexPath.row == 0{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "dummyCell1", for: indexPath)
//            cell.selectionStyle = .none
//            return cell
//        }
//        else if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "dummyCell", for: indexPath)
//            let couponTxtField = cell.viewWithTag(20) as? UITextField
//            let applyBtn = cell.viewWithTag(21) as? UIButton
//
//            couponTxtField?.delegate = self
//            couponTxtField?.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
//            couponTxtField?.tag = indexPath.row
//            applyBtn?.addTarget(self, action: #selector(applyCouponBtn), for: UIControlEvents.touchUpInside)
//            cell.selectionStyle = .none
//            return cell
//        }
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "couponcell", for: indexPath)
//            let couponNameLbl = cell.viewWithTag(2) as? UILabel
//            let couponValueLbl = cell.viewWithTag(3) as? UILabel
//
//            let couponArray = couponListArray[indexPath.row - 2]
//            couponNameLbl?.text = couponArray.coupon_tilte
//
//            if couponArray.coupon_type == "2"{ //Percentile
//                couponValueLbl?.text = "\(couponArray.coupon_value ?? "")% off"
//            }
//            else{
//                couponValueLbl?.text = "FLAT \(couponArray.coupon_value ?? "") off"
//            }
//
//
//            cell.selectionStyle = .none
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let couponArray = couponListArray[indexPath.row - 2]
        
        delegate?.dataPass(couponModel: couponArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float,layerRadius:CGFloat ) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = layerRadius
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
