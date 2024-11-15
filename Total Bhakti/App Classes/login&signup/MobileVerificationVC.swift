//
//  MobileVerificationVC.swift
//  Total Bhakti
//
//  Created by Prashant on 09/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import CountryPickerView

class MobileVerificationVC: TBInternetViewController ,CountryPickerViewDelegate, otpDelegate{

    //MARK:- UIOutlets.
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var termsAndPolicyLbl: FRHyperLabel!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var countryCodeImageView: UIImageView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryCodePicker: CountryPickerView!
    @IBOutlet weak var countryScreen: UIView!
    var socialBool = false
    static let sharedInstance = MobileVerificationVC()
    
    //MARK:- variables.
    let country = MICountryPicker()
    let countryData = CountryPickerView()
    let bundle = "assets.bundle/"
    var phone_code : String = "+91"
    var param1 : Parameters = [:]
    var socialData : Parameters = [:]
    var UDID: String!
    //MARK:- LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        if socialBool == true{
        //            signInApi()
        //        }
        //
        //        else{
        
        mobileNumberTF.delegate = self
        countryCodePicker.delegate = self
        // here set link type string .
        termsAndPolicyLbl.numberOfLines = 0;
        let string = ALERTS.KFirstString
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                          NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        termsAndPolicyLbl.attributedText = NSAttributedString(string: string, attributes: attributes)
        let handler  = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTERMSANDCONDITIONVC)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let KSecondString = ALERTS.KSecondString
        let attribute = [NSAttributedStringKey.foregroundColor: UIColor.blue,
                         NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        termsAndPolicyLbl.setLinkForSubstring(KSecondString, withAttribute: attribute, andLinkHandler: handler)
        
        //            countryCodeImageView.image = UIImage(named: bundle + "in.png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        countryCodePicker.showCountryCodeInView = false
        //        }
        
        updateCountry()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if iscoming == "otpScreen"{
            self.navigationController?.popViewController(animated: false)
        }
        
    }
    
    func updateCountry() {
        let iso = UserDefaults.standard.value(forKey: "iso") as? String
        if iso == "IN" {
            countryScreen.isHidden = false
            mobileNumberTF.placeholder = "Mobile Number"
            countryCodeLbl.text = "+91"
        }else{
            countryScreen.isHidden = true
            mobileNumberTF.placeholder = "Enter Email Id"
        }
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        mobileNumberTF.text = ""
        self.countryCodeLbl.text = country.phoneCode
        if country.phoneCode == "+91"{
            print("name::\(country.name)--phoneCode::\((country.phoneCode))")
            mobileNumberTF.placeholder = "Mobile Number"
            mobileNumberTF.resignFirstResponder()
            mobileNumberTF.keyboardType = .numberPad
            mobileNumberTF.becomeFirstResponder()
            
        }
        else{
            print("name::\(country.name)--phoneCode::\((country.phoneCode))")
            mobileNumberTF.placeholder = "Enter Email Id"
            mobileNumberTF.resignFirstResponder()
            mobileNumberTF.keyboardType = .emailAddress
            mobileNumberTF.becomeFirstResponder()
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //set gradient.
        let layer = gradientBackground()
        layer.frame = sendOtpBtn.bounds
        layer.cornerRadius = 5
        sendOtpBtn.clipsToBounds = true
        sendOtpBtn.layer.insertSublayer(layer, at: 0)
    }
    
    //MARK:- mobileVerification Check.
    func ckecks() {
        if countryCodeLbl.text == "+91"{
            if (mobileNumberTF.text?.isEmpty)! || (mobileNumberTF.text!.count < 10) || (mobileNumberTF.text!.count > 10){
                addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
            }
            
            else if !isValidPhone(value: mobileNumberTF.text!) {
                addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
            }else if (countryCodeLbl.text?.isEmpty)! {
                addAlert(appName, message: ALERTS.KCountryCode, buttonTitle: ALERTS.kAlertOK)
            }else {
                self.view.endEditing(true)
                DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
                signInApi()
            }
        }
        else{
            if mobileNumberTF.text == "" || !isValidEmail(testStr: mobileNumberTF.text!) {
                addAlert(appName, message: ALERTS.KEmailVerify, buttonTitle: ALERTS.kAlertOK)
            }
            else{
                UserDefaults.standard.set("emailaddress", forKey: "emailaddress")
                DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
                signInApi()
            }
        }
        //        else if !isValidPhone(value: mobileNumberTF.text!) {
        //            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
        //        }else if (countryCodeLbl.text?.isEmpty)! {
        //            addAlert(appName, message: ALERTS.KCountryCode, buttonTitle: ALERTS.kAlertOK)
        //        }else {
        //            self.view.endEditing(true)
        //        }
    }
    func dataStatus(_ Status: Bool) {
        if Status == true {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    //MARK:- ScreenBtn Actions.
    @IBAction func screenBtnAction (_ sender : UIButton) {
        if sender.tag == 10 {//CountryCode.
            let picker = MICountryPicker { (name, code) -> () in
                print(code)
            }
            
            // delegate
            picker.delegate = self
            // Display calling codes
            picker.showCallingCodes = true
            // or closure
            picker.didSelectCountryWithCallingCodeClosure = { name, code, dialCode in
            }
            // self.present(picker, animated: true, completion: nil)
            navigationController?.pushViewController(picker, animated: true)
            
        }else  if sender.tag == 20  {//sendOtp
            ckecks()
            
        }else if sender.tag == 30 {
            
        }else if sender.tag == 40 {//back
            if iscoming == "musicPlayer"{
                self.dismiss(animated: true, completion: nil)
            }else{
                _ = navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func getStatus(state: Bool) {
        if state == true {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func removeMobile() {
        self.navigationController?.popViewController(animated: false)
    }
    //MARK:- signInApi.
    func signInApi(){
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            self.UDID = uid
            UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
        }
        
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
        if  isComeFrom == 0 {//normalgetStated
            
            if countryCodeLbl.text == "+91"{//Mobile No
                param1 = ["mobile": mobileNumberTF.text!, "login_type" : "0" , "login_with":"1","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : countryCodeLbl.text!]
                
            }
            else{// Email ID
                param1 = ["mobile": mobileNumberTF.text!, "login_type" : "0" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : countryCodeLbl.text!]
                
            }
        }else if isComeFrom == 2 {//Google
            
            param1 = ["mobile":socialData["email"] ?? "", "login_type" : "2" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr,"social_token":socialData["gmail_id"] ?? ""]
            
        }else if isComeFrom == 1 {//Facebook
            //            param1.updateValue(mobileNumberTF.text!, forKey: "mobile")
            //            param1.updateValue("1", forKey: "login_type")
            //            param1.updateValue(countryCodeLbl.text!, forKey: "country_code")
            
            
            param1 = ["mobile": socialData["email"] ?? "", "login_type" : "1" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "social_token" : socialData["fb_id"] ?? ""]
            
        }

        let header:HTTPHeaders = ["Deviceid": device_id ?? ""]
        self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, param1, header: header) { response in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if response != nil {
                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
                    if let result = response as? NSDictionary {
                        print(result)
                        let pin = (result["data"] as? NSDictionary ?? [:])["pin"] as? String ?? ""                        //                        currentUser = User.init(dictionary: result)
                        let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
                        UserDefaults.standard.setValue(self.mobileNumberTF.text, forKey: "mobileNoOrEmail")
                        UserDefaults.standard.setValue(jwt, forKey: "jwt")
                        if  pin == "0" {
                            if currentUser.status! {
                                //                            TBSharedPreference.sharedIntance.setUserData(currentUser)
                                //                            self.navigationController?.popViewController(animated: false)
                                if isComeFrom == 2 || isComeFrom == 1{
                                    self.socialData = [:]
                                //    TBOTPVC.sharedInstance.getUserToken()
                                }
                                else{
                                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
                                    vc.parameter = self.param1
                                    vc.deleagte = self
                                    vc.completionBlock = {() -> ()in
                                        self.dismiss(animated: false, completion: nil)
                                    }
                                    
                                    self.present(vc,animated: true,completion: nil)
                                    //                                self.performSegue(withIdentifier: "otpVc", sender: self)
                                    
                                    
                                }
                            }else {
                                self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                            }
                        }
                        else{
//                            let nav = self.storyboard?.instantiateViewController(withIdentifier: "enterPinVc") as! enterPinVc
//                            goingTo = "enter"
//                            nav.delegate = self
//                            self.present(nav, animated: true, completion: nil)
                        }

                    }
                    
                } else {
                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
        
//        self.uplaodData(APIManager.sharedInstance.KLOGINAPI, param1) { response in
//            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
//            print(response as Any)
//            if response != nil {
//                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
//                    if let result = response as? NSDictionary {
//                        print(result)
//                        let pin = (result["data"] as? NSDictionary ?? [:])["pin"] as? String ?? ""                        //                        currentUser = User.init(dictionary: result)
//                        let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
//                        UserDefaults.standard.setValue(self.mobileNumberTF.text, forKey: "mobileNoOrEmail")
//                        UserDefaults.standard.setValue(jwt, forKey: "jwt")
//                        if  pin == "0" {
//                            if currentUser.status! {
//                                //                            TBSharedPreference.sharedIntance.setUserData(currentUser)
//                                //                            self.navigationController?.popViewController(animated: false)
//                                if isComeFrom == 2 || isComeFrom == 1{
//                                    self.socialData = [:]
//                                    TBOTPVC.sharedInstance.getUserToken()
//                                }
//                                else{
//                                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
//                                    vc.parameter = self.param1
//                                    vc.deleagte = self
//                                    vc.completionBlock = {() -> ()in
//                                        self.dismiss(animated: false, completion: nil)
//                                    }
//                                    
//                                    self.present(vc,animated: true,completion: nil)
//                                    //                                self.performSegue(withIdentifier: "otpVc", sender: self)
//                                    
//                                    
//                                }
//                            }else {
//                                self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
//                            }
//                        }
//                        else{
//                            let nav = self.storyboard?.instantiateViewController(withIdentifier: "enterPinVc") as! enterPinVc
//                            goingTo = "enter"
//                            nav.delegate = self
//                            self.present(nav, animated: true, completion: nil)
//                        }
//
//                    }
//                    
//                } else {
//                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
//                }
//            }
//        }
    }
    
    
}


// MARK:- country code.
extension MobileVerificationVC : MICountryPickerDelegate {
    func countryPicker(picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        picker.dismiss(animated: true, completion: nil)
    }
    func countryPicker(picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        picker.dismiss(animated: true, completion: nil)
        phone_code = dialCode
        self.countryCodeLbl.text = phone_code
        countryCodeImageView.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        
    }
}
//MARK:- textField Delegates.
extension MobileVerificationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 100 {
            textField.resignFirstResponder()
        }else {
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == mobileNumberTF {
            if countryCodeLbl.text == "+91"{
                let currentCharacterCount = textField.text?.characters.count ?? 0
                if (range.length + range.location > currentCharacterCount){
                    return false
                }
                let newLength = currentCharacterCount + string.characters.count - range.length
                return newLength <= 10
                
            }
            else{
                return true
            }
        }
        return false
    }
}
