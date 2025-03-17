//
//  newotpvc.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 12/07/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//
import UIKit
import Alamofire

typealias vCB1 = () ->()

// Define OTPDelegate protocol
protocol OTPDelegate: AnyObject {
    func didChangeValidity(isValid: Bool)
}

class OTPTextField: UITextField {
    weak var nextTextField: OTPTextField?
    weak var previousTextField: OTPTextField?
}

class OTPStackView: UIStackView {

    // Customise the OTPField here
    let numberOfFields = 4
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false

    // Colors
    let inactiveFieldBorderColor = UIColor(white: 1, alpha: 0.3)
    let textBackgroundColor = UIColor(white: 1, alpha: 0.5)
    let activeFieldBorderColor = UIColor.green
    var remainingStrStack: [String] = []

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        addOTPFields()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }

    // Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 20
    }

    // Adding each OTPfield to stack view
    private final func addOTPFields() {
        for index in 0..<numberOfFields {
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            // Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            // Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
        textFieldsCollection[0].becomeFirstResponder()
    }

    // Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField) {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        textField.backgroundColor = textBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: "Kefa", size: 40)
        textField.textColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.textContentType = .oneTimeCode
    }

    // Checks if all the OTPfields are filled
    private final func checkForValidity() {
        for fields in textFieldsCollection {
            if (fields.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "") {
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }

    // Gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection {
            OTP += textField.text ?? ""
        }
        return OTP
    }

    // Set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor) {
        for textField in textFieldsCollection {
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }

    // Autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap { String($0) }
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }
}

// MARK: - TextField Handling
extension OTPStackView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor)
            showsWarningColor = false
        }
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
    }

    // Switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0 && string == "") {
                return false
            } else if (range.length == 0) {
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                } else {
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
}

class newotpvc: UIViewController {
    @IBOutlet weak var otpContainerView: UIView!
    @IBOutlet weak var textlbl: UILabel!
    @IBOutlet weak var resendotpbtn: UIButton!
    @IBOutlet weak var timerlbl: UILabel!

    let otpStackView = OTPStackView()
    var countdownTimer: Timer?
    var remainingTime = 30
    var parameter: Parameters = [:]
    var completionBlock: vCB1?
    var textfiledinput = ""
    var otpData: String = ""
    var resendOtpValue = 0
    var dict: Parameters = [:]
    var pin: String = ""
    var backvalue = Int()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print(backvalue)
        textlbl.text = "We have sent you an OTP code on your " + textfiledinput
        resendotpbtn.isEnabled = false // Disable button after resend is clicked
        resendotpbtn.alpha = 0.5
        otpContainerView.addSubview(otpStackView)
        otpStackView.delegate = self

        // Setup constraints for otpStackView
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor),
            otpStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor),
            otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor)
        ])

        // Initial UI setup
        startTimer()
    }

    deinit {
        countdownTimer?.invalidate()
    }

    func startTimer() {
        remainingTime = 30
        updateTimerLabel()
        resendotpbtn.isEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateTimerLabel()
        } else {
            countdownTimer?.invalidate()
            timerlbl.text = ""
            resendotpbtn.isEnabled = true
            resendotpbtn.alpha = 1.0 // Make button fully visible and clickable
        }
    }

    func updateTimerLabel() {
        if remainingTime > 0 {
            timerlbl.text = "Resend OTP in \(remainingTime) sec"
        } else {
            timerlbl.text = ""
        }
    }
    
    
    
    
    @IBAction func backbutton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

            }
    
    

    @IBAction func resendotpbutton(_ sender: UIButton) {
        resendOtp()
        
    }
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
    
    func checks() {
        if otpData.isEmpty {
            self.addAlert(appName, message: ALERTS.KPleaseEnterOTP, buttonTitle: ALERTS.kAlertOK)
        } else {
            if isComeFromProfile == 1 {
                let otp = otpData
                var otpFromResponse = String()
                if resendOtpValue == 1 {
                    otpFromResponse = (currentUser.result?.otp)!
                } else {
                    let dict1 = dict as NSDictionary
                    otpFromResponse = String(describing: dict1.value(forKey: "otp")!)
                }
                if otp == otpFromResponse {
                    updateProfileApi()
                    resendOtpValue = 0
                } else {
                    self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)
                }
            } else {
                DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                VerifyOtp()
            }
        }
    }

    func VerifyOtp() {
        var UDID = ""
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            UDID = uid
        }
        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
        var otp = otpData
        if iscoming == "mobile" {
            otp = ""
            pin = UserDefaults.standard.value(forKey: "Pin") as? String ?? ""
            print(pin)
        }
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        var param: Parameters = [:]
        if goingTo == "reset" {
            param = ["mobile": "\(UserDefaults.standard.value(forKey: "mobileNoOrEmail") ?? "")", "otp": "\(otp)", "device_id": device_id ?? "", "pin": pin, "forgot_pin": "1", "device_token": deviceTokanStr]
        } else {
            param = ["mobile": "\(UserDefaults.standard.value(forKey: "mobileNoOrEmail") ?? "")", "otp": "\(otp)", "device_id": device_id ?? "", "pin": pin, "device_token": deviceTokanStr]
        }
        print(param)
        self.uplaodData(APIManager.sharedInstance.KOTPAPI, param) { response in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading() })
            if let response = response as? NSDictionary {
                if response.value(forKey: "status") as? Bool == true {
                    self.view.endEditing(true)
                    self.getUserToken()
                } else {
                    let message = response.value(forKey: "message") as? String
                    self.addAlert(appName, message: message ?? "", buttonTitle: ALERTS.kAlertOK)
                }
            } else {
                self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
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
                            TBSharedPreference.sharedIntance.setUserData(currentUser)
//                            self.navigatToHomeScreen()
                        self.dismiss(animated: true, completion: nil)
   
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
                    
                    if let imageData = UIImagePNGRepresentation(image) {
                        let milliseconds = Int64(Date().timeIntervalSince1970 * 1000.0)
                        let filename = "\(milliseconds).png"
                        multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: "image/png")
                    }

                } else if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: url, method: .post, headers: nil)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }

            switch response.result {
            case .success(let value):
                print("Response JSON: \(value)")

                guard let json = value as? [String: Any] else {
                    print("Invalid response format")
                    return
                }

                let currentUser = User(dictionary: json as NSDictionary)
                if let status = json["status"] as? Bool, status {
                    TBSharedPreference.sharedIntance.setUserData(currentUser!)
                    isComeFromProfile = 0

                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KHOME)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if let currentUser = currentUser, let message = currentUser.message {
                        self.addAlert(appName, message: message, buttonTitle: ALERTS.kAlertOK)
                    }
                }

            case .failure(let error):
                print("Upload Failed: \(error.localizedDescription)")

                if let urlError = error.asAFError?.underlyingError as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        self.addAlert(appName, message: ALERTS.kNoInterNetConnection, buttonTitle: ALERTS.kAlertOK)
                    case .timedOut:
                        self.addAlert(appName, message: "Request timed out. Please try again.", buttonTitle: ALERTS.kAlertOK)
                    default:
                        break
                    }
                }
            }
        }
    }

}
extension newotpvc: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        if isValid {
            otpData = otpStackView.getOTP()
            checks()
        }
    }
}
