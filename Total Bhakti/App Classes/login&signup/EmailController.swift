
//  EmailController.swift
//  Sanskar
//
//  Created by Warln on 13/06/22.
//  Copyright © 2022 MAC MINI. All rights reserved.


import UIKit
//
//class EmailController: UIViewController{
//    
//    @IBOutlet var mobileemailtext: UITextField!
//    @IBOutlet var canceldatabtn: UIButton!
//    
//    @IBOutlet weak var submitbtn: UIButton!
//    
//    var countryCode: String = ""
//    var param1 : Parameters = [:]
//    var withOutPin: Bool = true
//    var continuewith = ""
//    var isAPICalling: Bool = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        submitbtn.isHidden = true
//        
//        mobileemailtext.delegate = self
//      
//  
//    }
//    func signInothernumberApi(_ param : Parameters){
// 
//        if withOutPin {
//            param1.updateValue("1", forKey: "login_with_otp")
//        }
//       
//        print(param1)
//        let device_id = UserDefaults.standard.string(forKey: "device_id")
//        let header:HTTPHeaders = ["Deviceid": device_id ?? ""]
//        self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, param1, header: header) { response in
//            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
//            
//            print(response as Any)
//            if response != nil {
//                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
//                    if let result = response as? NSDictionary {
//                        print(result)
//                        let pin = (result["data"] as? NSDictionary ?? [:])["pin"] as? String ?? ""
//                        print(pin)
//                        //                        currentUser = User.init(dictionary: result)
//                        let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
//                        if !(self.mobileemailtext.text?.isEmpty)!{
//                            UserDefaults.standard.setValue(self.mobileemailtext.text, forKey: "mobileNoOrEmail")
//                        } else {
//                           
//                        }
//                    
//                        UserDefaults.standard.setValue(jwt, forKey: "jwt")
//                        let vc = storyBoard.instantiateViewController(withIdentifier: "setPinVc") as! setPinVc
////                        vc.parameter = self.param1
//                        vc.completionBlock = {() -> ()in
//                        self.dismiss(animated: false, completion: nil)
//                        }
//                        self.mobileemailtext.text = ""
//                        self.navigationController?.pushViewController(vc, animated: true)
//                        DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
//                    }
//                }
//                
//            }
//            
//        }
//    }
//    
//    @IBAction func submitbtn(_ sender: UIButton) {
//        guard !isAPICalling, let text = mobileemailtext.text, !text.isEmpty else {
//                    return
//                }
//                
//                // Check whether it's a valid email or number
//                let firstCharacter = text.first!
//                if firstCharacter.isNumber {
//                    if text.allSatisfy({ $0 == "0" }) {
//                        print("Invalid input: All characters are zeros")
//                        addAlert(appName, message: ALERTS.KPleaseEnterVaildallnumber, buttonTitle: ALERTS.kAlertOK)
//                        return
//                    } else if let number = Int(text) {
//                        print("Valid number: \(number)")
//                        let device_id = UserDefaults.standard.string(forKey: "device_id")
//                        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
//                        param1 = ["mobile": mobileemailtext.text!, "login_type": "0", "login_with": "2", "device_type": "2", "device_model": "\(UIDevice().type)", "device_id": device_id ?? "", "device_token": deviceTokanStr, "country_code": "+91"]
//                        signInothernumberApi(param1)
//                    } else {
//                        print("Invalid number")
//                        addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
//                    }
//                } else if firstCharacter.isLetter {
//                    if isValidEmail(testStr: text) {
//                        print("Valid email: \(text)")
//                        let device_id = UserDefaults.standard.string(forKey: "device_id")
//                        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
//                        param1 = ["mobile": mobileemailtext.text!, "login_type": "0", "login_with": "2", "device_type": "2", "device_model": "\(UIDevice().type)", "device_id": device_id ?? "", "device_token": deviceTokanStr, "country_code": "91"]
//                        signInothernumberApi(param1)
//                    } else {
//                        print("Invalid email")
//                        addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileOrEmail, buttonTitle: ALERTS.kAlertOK)
//                    }
//                } else {
//                    // Handle other cases as needed
//                    print("Invalid input")
//                }
//                
//                // Set the flag to indicate that the API is in progress
//                isAPICalling = true
//        
//    }
//    
//    
//    @IBAction func canceldatabtn(_ sender: UIButton) {
//        mobileemailtext.text = ""
//    }
//    
//    
//    
//}
//extension EmailController: UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        textField.text = ""
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//        let isNumeric = currentText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
//        let isAlphanumeric = currentText.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
//
//        if isNumeric {
//            submitbtn.isHidden = currentText.count <= 9
//            
//        //    cancelbtn.isHidden = (currentText.count != 0) || false
//            return currentText.count <= 10
//        } else {
//            let currentText = textField.text ?? ""
//                    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//            submitbtn.isHidden = !newText.lowercased().contains("@")
//                    return newText.count <= 50
//        }
//        return false
//    }
//
//      }
