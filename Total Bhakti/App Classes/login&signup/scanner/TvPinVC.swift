//
//  TvPinVC.swift
//  Sanskar
//
//  Created by Warln on 28/07/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import OTPFieldView

class TvPinVC: UIViewController {
    
    @IBOutlet weak var txtfield: OTPFieldView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var completionHandler: ((Bool) -> Void)?
    var arr: Parameters?
    var header: HTTPHeaders?
    var otpData: String = ""
    var data: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = gradientBackground()
        layer.frame = submitBtn.bounds
        submitBtn.clipsToBounds = true
        submitBtn.layer.insertSublayer(layer, at: 0)
    }
    
    func setupOtpView(){
            self.txtfield.fieldsCount = 4
            self.txtfield.fieldBorderWidth = 2
            self.txtfield.defaultBorderColor = UIColor.black
            self.txtfield.filledBorderColor = UIColor.red
            self.txtfield.cursorColor = UIColor.black
            self.txtfield.displayType = .underlinedBottom
            self.txtfield.fieldSize = 40
            self.txtfield.separatorSpace = 8
            self.txtfield.shouldAllowIntermediateEditing = false
            self.txtfield.delegate = self
            self.txtfield.initializeUI()
        }
    
    @IBAction func submitBtnPressed(_ sender: UIButton ) {
        hitTv()
    }
    
    func hitTv() {
        arr?.updateValue(otpData, forKey: "pin")
        let device_id = UserDefaults.standard.string(forKey: "device_id") ?? ""
        let jwt:HTTPHeaders = ["jwt":"\(UserDefaults.standard.value(forKey: "jwt") ?? "")","Deviceid": device_id]
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodDataHeader("user/qr_login/get_user_data", arr ?? [:] , header: jwt) { response in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            DispatchQueue.main.async {
                self.otpData = ""
                self.txtfield.initializeUI()
                if let json = response as? [String: Any] {
                    if json["status"] as? Bool == true {
                        AlertController.alert(message: json["message"] as? String ?? "")
                        self.navigationController?.popToRootViewController(animated: false)
                    }else{
                        AlertController.alert(message: json["message"] as? String ?? "")
                    }
                }
            }

        }
    }
    
    
}

//MARK: - UITextField Delegates.
extension TvPinVC: OTPFieldViewDelegate {
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
