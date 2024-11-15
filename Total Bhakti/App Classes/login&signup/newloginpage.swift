//
//  setPinVc.swift
//  Sanskar
//
//  Created by Warln on 24/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import OTPFieldView


class newloginpage: UIViewController {
    
    @IBOutlet weak var mobilemailtxt:UITextField!
    @IBOutlet weak var getotpbtn:UIButton!
    
    var param1 : Parameters = [:]
    var withOutPin: Bool = true
    var isAPICalling: Bool = false
    var devicetokennew = String()
    var mobiled = ""
    var backdata = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobilemailtxt.becomeFirstResponder()
        mobilemailtxt.becomeFirstResponder()
        mobilemailtxt.layer.borderColor = UIColor.white.cgColor
        mobilemailtxt.layer.cornerRadius = 5
        getotpbtn.layer.cornerRadius = 20
        
    }
    
    @IBAction func getotpaction(_ sender: UIButton) {
        guard let text = mobilemailtxt.text, !text.isEmpty else {
            // Handle the case where the text field is empty
            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileOrEmail, buttonTitle: ALERTS.kAlertOK)
            return
        }
        
        let firstCharacter = text.first!
        
        if firstCharacter.isNumber {
            // The first character is a number, validate mobile number
            if text.allSatisfy({ $0 == "0" }) {
                // All characters are zeros, consider it as not valid
                addAlert(appName, message: ALERTS.KPleaseEnterVaildallnumber, buttonTitle: ALERTS.kAlertOK)
            } else if isValidPhoneNumber(text) {
                // Valid mobile number
                let id = UserDefaults.standard.string(forKey: "devicet")
                let device_id = UserDefaults.standard.string(forKey: "device_id")
                let defaultId = "123456789"
                let deviceTokenStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? id ?? defaultId
                
                let param1: [String: Any] = [
                    "mobile": text,
                    "login_type": "0",
                    "login_with": "2",
                    "device_type": "2",
                    "device_model": "\(UIDevice().type)",
                    "device_id": device_id ?? "",
                    "device_token": deviceTokenStr,
                    "country_code": "+91"
                ]
                print(param1)
                signInApi(param1)
            } else {
                // Invalid mobile number
                addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
            }
        } else if firstCharacter.isLetter {
            // The first character is an alphabet, perform email validation
            if isValidEmail1(testStr: text) {
                let id = UserDefaults.standard.string(forKey: "devicet")
                let device_id = UserDefaults.standard.string(forKey: "device_id")
                let defaultId = "123456789"
                let deviceTokenStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? id ?? defaultId
                
                let param1: [String: Any] = [
                    "mobile": text,
                    "login_type": "0",
                    "login_with": "2",
                    "device_type": "2",
                    "device_model": "\(UIDevice().type)",
                    "device_id": device_id ?? "",
                    "device_token": deviceTokenStr,
                    "country_code": "+91"
                ]
                print(param1)
                signInApi(param1)
            } else {
                // Invalid email
                addAlert(appName, message: ALERTS.KEmailVerify, buttonTitle: ALERTS.kAlertOK)
            }
        } else {
            // Handle other cases as needed
            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileOrEmail, buttonTitle: ALERTS.kAlertOK)
        }
        
    }
    // Function to validate email
    func isValidEmail1(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // Function to validate mobile number
    func isValidPhoneNumber(_ mobile: String) -> Bool {
        let mobileRegEx = "^[0-9]{10}$"
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return mobileTest.evaluate(with: mobile)
    }
    
    
    func signInApi(_ param1: Parameters) {
       
        print(param1)
        DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let header: HTTPHeaders = ["Deviceid": device_id ?? ""]
        self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, param1, header: header) { [self] response in
            print(response as Any)
            if response != nil {
                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
                    if let result = response as? NSDictionary {
                        print(result)
                        let pin = (result["data"] as? NSDictionary ?? [:])["pin"] as? String ?? ""
                        print(pin)
                        let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
                        UserDefaults.standard.setValue(jwt, forKey: "jwt")
                        
                        dismiss(animated: true) {
                            let vc = storyBoard.instantiateViewController(withIdentifier: "newotpvc") as! newotpvc
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
                            if mobilemailtxt.text!.isEmpty {
                                vc.textfiledinput = self.mobiled
                                print(vc.textfiledinput)
                                vc.backvalue = backdata
                                print(vc.backvalue)
                                UserDefaults.standard.setValue(self.mobiled, forKey: "mobileNoOrEmail")
                            } else {
                                vc.textfiledinput = self.mobilemailtxt.text!
                                print(vc.textfiledinput)
                                print(backdata)
                                vc.backvalue = backdata
                                print(vc.backvalue)
                                UserDefaults.standard.setValue(self.mobilemailtxt.text, forKey: "mobileNoOrEmail")
                            }
                            
                            vc.parameter = self.param1
                            vc.completionBlock = { () -> () in
                                self.dismiss(animated: false, completion: nil)
                            }
                            self.mobilemailtxt.text = ""
                            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading() })
                            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func notnowaction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension newloginpage: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        let isNumeric = currentText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        let isAlphanumeric = currentText.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil

//        if isNumeric {
//            submit.isHidden = currentText.count <= 8
//        //    cancelbtn.isHidden = (currentText.count != 0) || false
//            return currentText.count <= 10
//        } else {
//            let currentText = textField.text ?? ""
//                    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//                    submit.isHidden = !newText.lowercased().contains("@")
//                    return newText.count <= 50
//        }
        return false
    }
      }
