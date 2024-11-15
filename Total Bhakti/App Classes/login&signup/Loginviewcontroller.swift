//
//  Loginviewcontroller.swift
//  Sanskar
//  Created by Sanskar IOS Dev on 25/11/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class Loginviewcontroller: UIViewController {
    
    
    @IBOutlet weak var mobileTxtf: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet var submit: UIButton!
    @IBOutlet var cancelbtn: UIButton!
    @IBOutlet var continuelbl : UILabel!
    
    var countryCode: String = ""
    var param1 : Parameters = [:]
    var withOutPin: Bool = true
    var continuewith = ""
    var mobiledata = [[String:Any]]()
    var mobiled = ""
    var isAPICalling: Bool = false
    var devicetokennew = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit.layer.cornerRadius = 10 
        continuelbl.isHidden = true
        table.delegate = self
        table.dataSource = self
        submit.isHidden = true
        mobileTxtf.delegate = self
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let param: Parameters = ["device_id": device_id]
        print(param)
        loginrecordapi(param)
    }
 
    func loginrecordapi(_ param : Parameters){
        
        self.uplaodData(APIManager.sharedInstance.KuserRecord , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    self.continuelbl.isHidden = false
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    self.mobiledata = data
                    print(self.mobiledata)
                   self.table.reloadData()
                }
            }
        }
    }
    

    func signInApi(_ param : Parameters){
 
        if withOutPin {
            param1.updateValue("1", forKey: "login_with_otp")
        }
        print(param1)
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let header:HTTPHeaders = ["Deviceid": device_id ?? ""]
        self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, param1, header: header) { [self] response in
            print(response as Any)
            if response != nil {
                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
                    if let result = response as? NSDictionary {
                        print(result)
                        let pin = (result["data"] as? NSDictionary ?? [:])["pin"] as? String ?? ""
                        print(pin)
                        //   currentUser = User.init(dictionary: result)
                        let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
//                        if !(self.mobileTxtf.text?.isEmpty)!{
//                           UserDefaults.standard.setValue(self.mobileTxtf.text, forKey: "mobileNoOrEmail")
//                        } else {
//                        }
                        UserDefaults.standard.setValue(jwt, forKey: "jwt")
                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
                        if mobileTxtf.text!.isEmpty {
                            vc.textfiledinput = self.mobiled
                            print(vc.textfiledinput)
                            UserDefaults.standard.setValue( self.mobiled, forKey: "mobileNoOrEmail")
                        } else {
                            vc.textfiledinput = self.mobileTxtf.text!
                            print(vc.textfiledinput)
                            UserDefaults.standard.setValue(self.mobileTxtf.text, forKey: "mobileNoOrEmail")
                        }

                        
                        vc.parameter = self.param1
                        vc.completionBlock = {() -> ()in
                        self.dismiss(animated: false, completion: nil)
                        }
                        self.mobileTxtf.text = ""
                        DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                        self.navigationController?.pushViewController(vc, animated: true)
                       
                    }
                }
                
            }
            
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        
               guard let text = mobileTxtf.text, !text.isEmpty else {
                          // Handle the case where the text field is empty
                          return
                      }

                      let firstCharacter = text.first!
               if firstCharacter.isNumber {
                          // The first character is a number
                          if text.allSatisfy({ $0 == "0" }) {
                              // All characters are zeros, consider it as not valid
                              print("Invalid input: All characters are zeros")
                              addAlert(appName, message: ALERTS.KPleaseEnterVaildallnumber, buttonTitle: ALERTS.kAlertOK)
                          } else if let number = Int(text) {
                              // Valid number, do something with it
                              submit.backgroundColor = UIColor.systemYellow

                              print("Valid number: \(number)")
                              let device_id = UserDefaults.standard.string(forKey: "device_id")
                              
                              deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? devicetokennew

                         
                                  param1 = ["mobile": mobileTxtf.text!, "login_type" : "0" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : "+91"]
                             
                              signInApi(param1)
                          } else {
                              // Invalid number
                              print("Invalid number")
                              addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
                          }
                      } else if firstCharacter.isLetter {
                          // The first character is an alphabet, perform email validation
                          if isValidEmail(testStr: text) {
                              // Valid email, do something with it
                              submit.backgroundColor = UIColor.systemYellow

                              print("Valid email: \(text)")
                              let device_id = UserDefaults.standard.string(forKey: "device_id")
                              
                              deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? devicetokennew

                         
                                  param1 = ["mobile": mobileTxtf.text!, "login_type" : "0" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : "91"]
                             
                              signInApi(param1)
                          } else {
                              // Invalid email
                              addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileOrEmail, buttonTitle: ALERTS.kAlertOK)
                          }
                      } else {
                          // Handle other cases as needed
                          print("Invalid input")
                      }
            }
           
    
    @IBAction func cancelbtn(_ sender: UIButton) {
        mobileTxtf.text = ""
    }
}

//MARK: - UITextFieldDelegate {
extension Loginviewcontroller: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        let isNumeric = currentText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        let isAlphanumeric = currentText.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil

        if isNumeric {
            submit.isHidden = currentText.count <= 8
        //    cancelbtn.isHidden = (currentText.count != 0) || false
            return currentText.count <= 10
        } else {
            let currentText = textField.text ?? ""
                    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
                    submit.isHidden = !newText.lowercased().contains("@")
                    return newText.count <= 50
        }
        return false
    }
      }
extension Loginviewcontroller : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mobiledata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "loginrecordcell", for: indexPath) as! loginrecordcell
        mobiled = mobiledata[indexPath.row]["mobile"] as? String ?? ""
        let daysremain = mobiledata[indexPath.row]["day_remains"] as? String ?? ""
        if let daysRemainInt = Int(daysremain) {
            if daysRemainInt > 0 {
                print("daysremain is \(daysRemainInt), setting crown image with orange tint")
                if #available(iOS 13.0, *) {
                    cell.crownimg.image = UIImage(named:"tatacrown")
                } else {
                    // Fallback on earlier versions
                    // Provide an alternative image or handle as needed
                }
                cell.crownimg.tintColor = UIColor.systemOrange
            } else if daysRemainInt == 0 {
                print("daysremain is \(daysRemainInt), setting person image with black tint")
                if #available(iOS 13.0, *) {
                    cell.crownimg.image = UIImage(systemName: "person.fill")
                } else {
                    // Fallback on earlier versions
                    // Provide an alternative image or handle as needed
                }
                cell.crownimg.tintColor = UIColor.black
            } else {
                print("daysremain is \(daysRemainInt), setting person image with black tint")
                if #available(iOS 13.0, *) {
                    cell.crownimg.image = UIImage(systemName: "person.fill")
                } else {
                    // Fallback on earlier versions
                    // Provide an alternative image or handle as needed
                }
                cell.crownimg.tintColor = UIColor.black
            }
        } else {
            // Handle the case where daysremain is not a valid integer string
            print("daysremain is not a valid integer: \(daysremain)")
            if #available(iOS 13.0, *) {
                cell.crownimg.image = UIImage(systemName: "person.fill")
            } else {
                // Fallback on earlier versions
                // Provide an alternative image or handle as needed
            }
            cell.crownimg.tintColor = UIColor.gray // You can set a default color here
        }

            cell.daysremainlbl.text = daysremain + " " + "days remains"
            cell.mobilelbl.text = mobiled
            
            return cell
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let device_id = UserDefaults.standard.string(forKey: "device_id")
            
            deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? devicetokennew
            
            //        if !(self.mobiled.isEmpty){
            //            UserDefaults.standard.setValue(self.mobiled, forKey: "mobileNoOrEmail")
            //        } else  {
            //
            //        }
            mobiled = mobiledata[indexPath.row]["mobile"] as? String ?? ""
            UserDefaults.standard.setValue(self.mobiled, forKey: "mobileNoOrEmail")
            
            param1 = ["mobile": mobiled, "login_type" : "0" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : "91"]
            signInApi(param1)
        }
        
    }

