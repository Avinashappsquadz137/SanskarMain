//
//  usersuggestionlogin.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 12/07/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//


import UIKit
class usersuggestionlogin: UIViewController {
    
    @IBOutlet weak var userlogintable: UITableView!
    @IBOutlet weak var usercontinuelbl: UILabel!
    @IBOutlet weak var proccedbtn: UIButton!
   // @IBOutlet weak var norecordlbl:UILabel!
    
    var mobiledata = [[String: Any]]()
    var mobile = ""
    var selectedIndex: Int = 0  // Start with zero index selected
    var devicetokennew = String()
    var withOutPin: Bool = true
    var param1 : Parameters = [:]
    var selectedMobile = ""
    let backdata = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // norecordlbl.isHidden = true
        proccedbtn.layer.cornerRadius = 20
        userlogintable.tableFooterView = UIView(frame: .zero)
        userlogintable.delegate = self
        userlogintable.dataSource = self
        usercontinuelbl.isHidden = true
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let param: Parameters = ["device_id": device_id]
        print(param)
        loginuserrecordapi(param)
    }
    
    func loginuserrecordapi(_ param: Parameters) {
        self.uplaodData(APIManager.sharedInstance.KuserRecord, param) { (response) in
            DispatchQueue.main.async { loader.shareInstance.hideLoading() }
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    self.usercontinuelbl.isHidden = false
                    let data = (JSON["data"] as? [[String: Any]] ?? [[:]])
                    print(data)
                    self.mobiledata = data
                    print(self.mobiledata)
                    self.userlogintable.reloadData()
                }
                else {
                    //self.norecordlbl.isHidden = false
                 //   self.proccedbtn.isHidden = true
                }
            }
        }
    }
    
    @IBAction func proccedbtnaction(_ sender: UIButton) {
        sendSelectedCellDetails()
    }
    
    @IBAction func Loginnewnumberbtb(_ sender: UIButton) {
        dismiss(animated: true) {
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
    func sendSelectedCellDetails() {
        guard selectedIndex < mobiledata.count else {
            print("Invalid selection")
            return
        }
         let id = UserDefaults.standard.string(forKey: "devicet")
  
        self.selectedMobile = mobiledata[selectedIndex]["mobile"] as? String ?? ""
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let defaultId = "123456789"
        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? id ?? defaultId
        param1 = ["mobile": selectedMobile, "login_type" : "0" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : "+91"]
        print(param1)
        
        signInApi(param1, mobile: selectedMobile)
    }
    
    func signInApi(_ param: Parameters, mobile: String) {
        print(param)
        DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let header: HTTPHeaders = ["Deviceid": device_id ?? ""]
        
        self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, param, header: header) { [self] response in
            print(response as Any)
            
            if let responseDict = response as? NSDictionary {
                if let status = responseDict.value(forKey: "status") as? Bool, status == true {
                    if let result = responseDict as? NSDictionary {
                        print(result)
                        let pin = (result["data"] as? NSDictionary ?? [:])["pin"] as? String ?? ""
                        print(pin)
                        if let jwt = (result["data"] as? NSDictionary)?["jwt"] as? String {
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
                                    vc.textfiledinput = self.selectedMobile
                                    print(vc.textfiledinput)
                                    vc.backvalue = backdata
                                    UserDefaults.standard.setValue(self.selectedMobile, forKey: "mobileNoOrEmail")
                                    vc.parameter = self.param1
                                    vc.completionBlock = { () -> () in
                                        self.dismiss(animated: false, completion: nil)
                                    }
                                    
                                    DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading() })
                                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                                }
                            }
                        } else {
                            print("JWT token not found")
                        }
                    }
                } else {
                    AlertController.alert(message: responseDict["message"] as? String ?? "")
                }
            } else {
                print("Response is not a dictionary")
            }
        }
    }

}

extension usersuggestionlogin: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mobiledata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newloginrecordcell", for: indexPath) as! newloginrecordcell
        
        mobile = mobiledata[indexPath.row]["mobile"] as? String ?? ""
        let daysremainStr = mobiledata[indexPath.row]["day_remains"] as? String ?? ""
        let daysremain = Int(daysremainStr) ?? 0
        
        if indexPath.row == selectedIndex {
            cell.activemsg.image = UIImage(named: "radio_active")
            cell.userimageview.tintColor = UIColor.green
        } else {
            cell.activemsg.image = nil
        }
        cell.usernamelbl.text = mobile
        
        if daysremain != 0 {
            cell.userimageview.image = UIImage(named: "tatacrown")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
