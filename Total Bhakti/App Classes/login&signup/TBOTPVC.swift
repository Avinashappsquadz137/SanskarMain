//
//  TBOTPVC.swift
//  Total Bhakti
//  Created by Prashant on 20/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import OTPFieldView


typealias vCB = () ->()
typealias vCB2 = () ->()
protocol otpDelegate{
    func dataStatus(_ Status: Bool)
}
protocol currentDataDelegate{
    func loginState(_ state: Bool)
}

class TBOTPVC: TBInternetViewController {
    
    //MARK:-IBOutlets.
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var verifyOtp: UIButton!
    var completionBlock:vCB?
    static let sharedInstance = TBOTPVC()
    //MARK:- Variables.
    var parameter : Parameters = [:]
    var withOut: Bool = false
    var email: Bool = false
    var dict : Parameters = [:]
    var resendOtpValue = 0
    var Cvc = MobileVerificationVC()
    var deleagte : otpDelegate? = nil
    var loginDelegate : currentDataDelegate? = nil
    var state: Bool = false
    var loginState: Bool = false
    var pin: String = ""
    var opt: String = ""
    var forgetPin: Bool = false
    var otpData: String = ""
    var clearTxt: Bool = false
    var pin1: String = ""
    var textfiledinput = ""
    
    //MARK:- LifeCycle Methode.
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pin1)
        print(textfiledinput)
     
        TBSharedPreference.sharedIntance.setLoginStatus(false)
                
        if isComeFrom == 1 || isComeFrom == 2 || isComeFrom == 3{
         //   getUserToken()
        }
        else{
            let label = self.view.viewWithTag(10) as? UILabel
            
            if email == false {
                label?.text = "We have sent you an OTP code on your " + textfiledinput
            }
            else{
                label?.text = "We have sent you an OTP code on your number"
            }
            setupOtpView()
            
        }
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // firstTF.becomeFirstResponder()
        if isComeFromProfile == 1 {
            let dict1 = dict as NSDictionary
            let otpFromResponse = String(describing: dict1.value(forKey: "otp") as! String)
            addAlert("Please Enter This OTP", message: otpFromResponse, buttonTitle: ALERTS.kAlertOK)
            //  isComeFromProfile = 0
        }else {
            
            // addAlert("Please Enter This OTP", message: (currentUser.result?.otp)!, buttonTitle: ALERTS.kAlertOK)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //set gradientOnBtn.
        let layer = gradientBackground()
        layer.frame = verifyOtp.bounds
        layer.cornerRadius = 5.0
        verifyOtp.clipsToBounds = true
        verifyOtp.layer.insertSublayer(layer, at: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deleagte?.dataStatus(state)
        loginDelegate?.loginState(loginState)
    }
    
    func setupOtpView(){
            self.otpTextFieldView.fieldsCount = 4
            self.otpTextFieldView.fieldBorderWidth = 2
            self.otpTextFieldView.defaultBorderColor = UIColor.black
            self.otpTextFieldView.filledBorderColor = UIColor.green
            self.otpTextFieldView.cursorColor = UIColor.black
            self.otpTextFieldView.displayType = .square
            self.otpTextFieldView.fieldSize = 40
            self.otpTextFieldView.separatorSpace = 8
            self.otpTextFieldView.shouldAllowIntermediateEditing = false
            self.otpTextFieldView.delegate = self
            self.otpTextFieldView.initializeUI()
        }
    
    @IBAction func backbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Loginviewcontroller") as! Loginviewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- ScreenBtn Actions.
    @IBAction func screenBtnActions (_ sender : UIButton) {
        if sender.tag == 10 {//backbtn.
            _ = navigationController?.popViewController(animated: true)
        }else if sender.tag == 20 {//verify otp.
            state = true
            loginState = true
            clearTxt = true
            checks()
        }else if sender.tag == 30 {//resendOtp
            clearTxt = true
            resendOtp()
        }
    }
    
    func checks() {
        if otpData.isEmpty {
            self.addAlert(appName, message: ALERTS.KPleaseEnterOTP, buttonTitle: ALERTS.kAlertOK)
        }else {
            if isComeFromProfile == 1 {
                let otp  = otpData
                var otpFromResponse = String()
                if resendOtpValue == 1 {
                    otpFromResponse = (currentUser.result?.otp)!
                }else {
                    let dict1 = dict as NSDictionary
                    otpFromResponse = String(describing: dict1.value(forKey: "otp")!)
                }
                if otp == otpFromResponse {
                    updateProfileApi()
                    resendOtpValue = 0
                }else {
                    self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
                DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
                VerifyOtp()
            }
        }
    }
    
    //MARK:- verifyOTP.
    func VerifyOtp() {
        
        
        var UDID = ""
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            UDID = uid
        }
        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
        var otp = ""
        if iscoming == "mobile"{
            otp = ""
            pin = UserDefaults.standard.value(forKey: "Pin") as? String ?? ""
            print(pin)
        }else{
            otp  = otpData
        }
        
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        var param: Parameters = [:]
        if goingTo == "reset"{
            param = ["mobile" : "\(UserDefaults.standard.value(forKey: "mobileNoOrEmail") ?? "")","otp" : "\(otp)","device_id": device_id ?? "","pin":pin,"forgot_pin":"1","device_token":deviceTokanStr]
        }else{
            param = ["mobile" : "\(UserDefaults.standard.value(forKey: "mobileNoOrEmail") ?? "")","otp" : "\(otp)","device_id": device_id ?? "","pin":pin,"device_token":deviceTokanStr]
        }
        
                self.uplaodData(APIManager.sharedInstance.KOTPAPI, param, { response in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            if let response = response as? NSDictionary {
                if response.value(forKey: "status") as? Bool == true {
                    print(response )
                    self.getUserToken()
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBHomeVC") as! TBHomeVC
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    if self.withOut {
//
//                    }else{
//                        if self.pin != "" {
//                            self.getUserToken()
//                        }else{
//                            let nav = self.storyboard?.instantiateViewController(withIdentifier: "setPinVc") as! setPinVc
//                            nav.delegate = self
//                            self.present(nav,animated: true,completion: nil)
//                        }
//                    }
//
                }
                else{
                    let message = response.value(forKey: "message") as? String
                    self.addAlert(appName, message: message ?? "", buttonTitle: ALERTS.kAlertOK)
                }
                
            }
            else{
                self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)
                
            }
        })
        //        }
    }
    
    func loginS(_ status: String) {
        if status != "" {
            pin = status
            otpData = ""
            otpTextFieldView.initializeUI()
            VerifyOtp()
        }
    }
    
    /*
     .setHeader("jwt",Utils.JWT)
     .setMultipartParameter("login_type",login_type)
     .setMultipartParameter("device_id",android_id);
     */
    //MARK:- Get user token.
    func getUserToken() {
        var UDID = ""
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            UDID = uid
        }
        let device_id = UserDefaults.standard.string(forKey: "device_id")

        var param1 : Parameters = ["device_id":device_id ?? "","login_type":"0"]

        if isComeFrom == 2{
            param1.updateValue("2", forKey: "login_type")
        }
        if isComeFrom == 1{
            param1.updateValue("1", forKey: "login_type")
        }
        if isComeFrom == 3{
            param1.updateValue("3", forKey: "login_type")
        }



        var apiString = String()

        apiString = APIManager.sharedInstance.KGETUSERTOKENAPI

        let jwt:HTTPHeaders = ["jwt":"\(UserDefaults.standard.value(forKey: "jwt") ?? "")", "mobile" : "\(UserDefaults.standard.value(forKey: "mobileNoOrEmail") ?? "")", "Deviceid":device_id ?? ""]

        self.uplaodDataHeader(apiString, param1, header: jwt) { response in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            if let response = response as? NSDictionary {
                print(response)
                let data = (response["data"] as? NSDictionary ?? [:])
                print(data)

                let userLoginRecords = data["user_login_record"] as? [[String: Any]]
                print(userLoginRecords)
                if currentUser.status! {
                    if response["status"] as! Int != 0{
                        self.otpData = ""
                        currentUser = User.init(dictionary: response)
                        TBSharedPreference.sharedIntance.setLoginStatus(true)


             //           if isComeFrom == 1 || isComeFrom == 2 || isComeFrom == 3{
                            TBSharedPreference.sharedIntance.setUserData(currentUser)
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "activeuserprofileViewController") as! activeuserprofileViewController
//                 //       self.navigationController?.pushViewController(vc, animated: true)
//                            self.present(vc, animated: true)
//                            TBSharedPreference.sharedIntance.setLoginStatus(true)
//                        if sesiondata != nil{
//                           // self.navigationToPremiumpage()
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//
//                    self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                        else if  sesasonid != nil {
//                            self.navigationToPremiumpage()
//                        }
                      //  else {
                            self.navigatToHomeScreen()
                      //  }
                //        }
//                        else{
//                            if goingTo == "reset" {
//                                TBSharedPreference.sharedIntance.setUserData(currentUser)
//                                self.navigatToHomeScreen()
//                            }else{
//                                guard let cb = self.completionBlock else {return}
//                                self.dismiss(animated: true, completion: {
//                                    TBSharedPreference.sharedIntance.setUserData(currentUser)
//
//
//                                    cb()
//                                })
//                            }
//
//                        }

                    }
                    else{
                        self.addAlert(appName, message: response["message"]as! String, buttonTitle: ALERTS.kAlertOK)
                    }
                }else {
                    self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
    }
    func updateProfileApi() {
        dict["otp_verification"] = "1"
        dict["otp"] = nil
        let url = APIManager.sharedInstance.KBASEURL + APIManager.sharedInstance.KOTPAPI
        
        DispatchQueue.main.async {
            loader.shareInstance.showLoading(self.view)
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in self.dict {
                if key == "profile_picture", let image = value as? UIImage {
                    let milliseconds = Int64(Date().timeIntervalSince1970 * 1000.0)
                    let filename = "\(milliseconds).png"
                    if let imageData = image.UIImagePNGRepresentation() {
                        multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: "image/png")
                    } else {
                        print("Failed to convert image to PNG data")
                    }
                } else if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else {
                    print("Unsupported value type for key: \(key)")
                }
            }
        }, to: url, method: .post)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }
            
            switch response.result {
            case .success(let jsonResponse):
                guard let resultDict = jsonResponse as? [String: Any] else {
                    print("Invalid response format")
                    return
                }
                
                let status = resultDict["status"] as? Bool ?? false
                let message = resultDict["message"] as? String ?? "Unknown error"
                
                if status {
                    currentUser = User(dictionary: resultDict as NSDictionary)
                    TBSharedPreference.sharedIntance.setUserData(currentUser)
                    isComeFromProfile = 0
                    
                    DispatchQueue.main.async {
                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KHOME)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.addAlert(appName, message: message, buttonTitle: ALERTS.kAlertOK)
                    }
                }
                
            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
//                if let err = encodingError as? URLError, err.code == .notConnectedToInternet || err.code == .timedOut {
//                    self.addAlert(appName , message: ALERTS.kNoInterNetConnection, buttonTitle: ALERTS.kAlertOK)
//                } 
            }
        }
    }

    //MARK:- resendOtp.
    func resendOtp() {
        var param1 : Parameters = [:]
        
        var apiString = String()
        if isComeFromProfile == 1 {
            apiString = APIManager.sharedInstance.KUPDATEUSER
            param1 = dict
        }else {
            apiString = APIManager.sharedInstance.KResendOTPAPI
            //            var param1 : Parameters = ["mobile":"\(UserDefaults.standard.value(forKey: "mobileNoOrEmail") ?? "")"]
            
            param1 = ["mobile":"\(UserDefaults.standard.value(forKey: "mobileNoOrEmail") ?? "")","device_id":UIDevice.current.identifierForVendor?.uuidString ?? ""]
        }
        
        self.uplaodData(apiString, param1) { response in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            if let response = response as? NSDictionary {
                print(response)
                currentUser = User.init(dictionary: response)
                if currentUser.status! {
                    TBSharedPreference.sharedIntance.setUserData(currentUser)
                    self.resendOtpValue = 1
                    //self.addAlert("Please Enter This OTP", message: (currentUser.result?.otp)!, buttonTitle: ALERTS.kAlertOK)
                    self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                }else {
                    self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
    }
    
}

//MARK: - UITextField Delegates.
extension TBOTPVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        otpData = otpString
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}
