//
//  NewMobileVC.swift
//  Sanskar
//
//  Created by Warln on 13/06/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import CountryPickerView
import FBSDKCoreKit
import FacebookLogin
import AuthenticationServices

struct socialHidden: Decodable{
    let data : socialList
}

struct socialList: Decodable{
    let is_google: String
    let is_facebook: String
}

class NewMobileVC: UIViewController, otpDelegate, ASAuthorizationControllerDelegate {

    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var termsAndPolicyLbl: FRHyperLabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var socialBtn: UIButton!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var countryScreen: UIView!
    @IBOutlet weak var submitBtnOpt: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var orView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var emailtext: UITextField!
    
    var countryCode: String = ""
    var param1 : Parameters = [:]
    var withOutPin: Bool = true
    var record: [[String:Any]] = []
//    var completionHandler: ((Bool) -> Void)?
//    var UDID: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        logindetail()
//        tableview.delegate = self
//        tableview.dataSource = self
        
        mobileTxt.delegate = self
        countryPicker.delegate = self
        countryPicker.showPhoneCodeInView = true
        countryPicker.hostViewController = self
        setup()
//        policySetup()
//        hideSocial()
        stackView.isHidden = true
       //  orView.isHidden = false
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = gradientBackground()
        let layer1 = gradientBackground()
        layer.frame = submitBtn.bounds
        layer.cornerRadius = 5
        submitBtn.clipsToBounds = true
        submitBtn.layer.insertSublayer(layer, at: 0)
//        layer1.frame = submitBtnOpt.bounds
        layer1.cornerRadius = 5
//        submitBtnOpt.clipsToBounds = true
 //       submitBtnOpt.layer.insertSublayer(layer1, at: 0)
        
    }
    
    func setup() {
        let iso = UserDefaults.standard.value(forKey: "iso") as? String
        if iso == "IN" {
            countryScreen.isHidden = false
            countryCode = "+91"
        }else{
            countryScreen.isHidden = true
            countryCode = countryPicker.selectedCountry.phoneCode
        }
    }
    
    func policySetup() {
        termsAndPolicyLbl.numberOfLines = 0
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
        
        
    }
    
    //MARK: - Button Pressed Functionality
    @IBAction func submitBtnPressed(_ sender: UIButton ) {
        if !(mobileTxt.text?.isEmpty)! {
            if (mobileTxt.text!.count < 10) || (mobileTxt.text!.count > 10 ){
                addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
            } else {
                view.endEditing(true)
                DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
                signInApi()
                
            }
        } else if !(emailtext.text?.isEmpty)! {
            if isValidEmail(testStr: emailtext.text!){
                
                view.endEditing(true)
                DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
                signInApi()
            } else {
                addAlert(appName, message: ALERTS.KEmailVerify, buttonTitle: ALERTS.kAlertOK)
            }
        } else {
            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileOrEmail, buttonTitle: ALERTS.kAlertOK)
        }
//            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
//        }
//        else if !isValidPhone(value: mobileTxt.text!) {
//            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
//        }
//        else{
//            view.endEditing(true)
//            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
//            signInApi()
//  //      }
        
    }
    
//    @IBAction func submitOtpBtn(_sender: UIButton ) {
//        withOutPin = true
//        if (mobileTxt.text?.isEmpty)! || (mobileTxt.text!.count < 10) || (mobileTxt.text!.count > 10 ) {
//            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
//        }
//        else if !isValidPhone(value: mobileTxt.text!) {
//            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
//        }
//        else{
//            view.endEditing(true)
//            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
//            signInApi()
//        }
//    }
    
//    @IBAction func socailButtonPressed(_ sender: UIButton ) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailController") as! EmailController
//        vc.completionHandler = { [weak self] result in
//            if result {
//                DispatchQueue.main.async {
//                    self?.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    @IBAction func backBtnPressed(_ sender: UIButton ) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func socailBtnPressed(_ sender: UIButton ) {
//        switch sender.tag {
//        case 25:
//            let loginManager = LoginManager()
//            loginManager.logOut()
//            loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: { result in
//                switch result {
//                case .failed(let error) :
//                    print(error.localizedDescription)
//                case .cancelled:
//                    print("cancelled")
//                case .success(let grantedPermissions, _, let userInfo):
//                    print(userInfo.tokenString)
//                    print(grantedPermissions.map { "\($0)"}.joined(separator: " "))
//                    self.getDataFromFacebook()
//                }
//            })
//        case 26:
//            GIDSignIn.sharedInstance().signOut()
//            GIDSignIn.sharedInstance().clientID = KEYS.KClinetId
//            GIDSignIn.sharedInstance().delegate = self
//            GIDSignIn.sharedInstance().uiDelegate = self
//            GIDSignIn.sharedInstance().signIn()
//            isComeFrom = 2
//        case 27:
//            signInWithApple()
//        default:
//            break
//        }
//
//    }
    
    //MARK: - Sign API
    
    func logindetail(){
        param1 = [ "device_id": "c1cf7b8477cf34ab"]
        self.uplaodData(APIManager.sharedInstance.KuserRecord , param1) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    self.record = data
                    
                }
            }
        }
    }
    
    func signInApi(){
        
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        
        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"

        if !(mobileTxt.text?.isEmpty)! {
            param1 = ["mobile": mobileTxt.text!, "login_type" : "0" , "login_with":"1","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : countryCode]
            
        } else if !(mobileTxt.text?.isEmpty)!  {
            param1 = ["mobile": emailtext.text!, "login_type" : "0" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : "91"]
           
        }
        else {
            param1 = ["mobile": emailtext.text!, "login_type" : "0" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr, "country_code" : "91"]
           
        }
        if withOutPin {
            param1.updateValue("1", forKey: "login_with_otp")
        }
        print(param1)
        
        
        let header:HTTPHeaders = ["Deviceid": device_id ?? ""]
        self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, param1, header: header) { response in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if response != nil {
                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
                    if let result = response as? NSDictionary {
                        print(result)
                        let pin = (result["data"] as? NSDictionary ?? [:])["pin"] as? String ?? ""
                        print(pin)
//                        currentUser = User.init(dictionary: result)
                        let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
                        if !(self.mobileTxt.text?.isEmpty)!{
                            UserDefaults.standard.setValue(self.mobileTxt.text, forKey: "mobileNoOrEmail")
                        } else {
                            UserDefaults.standard.setValue(self.emailtext.text, forKey: "mobileNoOrEmail")
                        }
                        
                      
                        UserDefaults.standard.setValue(jwt, forKey: "jwt")
                        if !self.withOutPin {
                            if  pin == "0" {
                                if currentUser.status! {
                                    if isComeFrom == 2 || isComeFrom == 1{
                                   //     TBOTPVC.sharedInstance.getUserToken()
                                    }
                                    else{
                                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
                                        vc.parameter = self.param1
                                        
                                        vc.deleagte = self
                                        vc.completionBlock = {() -> ()in
                                            self.dismiss(animated: false, completion: nil)
                                        }
                                        
                                        self.navigationController?.pushViewController(vc, animated: true)
     
                                    }
                                }else {
                                    self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                                }
                            }
                            else{
//                                let nav = self.storyboard?.instantiateViewController(withIdentifier: "enterPinVc") as! enterPinVc
//                                goingTo = "enter"
//                                nav.delegate = self
//                                self.present(nav, animated: true, completion: nil)
                            }
                        }else{
                            if currentUser.status! {
                                if isComeFrom == 2 || isComeFrom == 1{
                                //    TBOTPVC.sharedInstance.getUserToken()
                                }
                                else{
                                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
                                    vc.parameter = self.param1
                                    vc.pin1 = pin
                                    if !(self.mobileTxt.text?.isEmpty)! {
                                        vc.email = true
                                    } else {
                                        vc.email = false
                                    }
                                    
                                    vc.deleagte = self
                                    vc.withOut = self.withOutPin
                                    vc.completionBlock = {() -> ()in
                                        self.dismiss(animated: false, completion: nil)
                                    }
                                    
                                    self.navigationController?.pushViewController(vc, animated: true)
 
                                }
                            }else {
                                self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                            }
                        }

                    }
                    
                } else {
                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
        

    }
    
    func dataStatus(_ Status: Bool) {
        if Status == true {
//            completionHandler?(true)
            self.navigationController?.popViewController(animated: false)
        }
    }
    
//    func signInWithApple(){
//        if #available(iOS 13.0, *) {
//            let appleIdProvider = ASAuthorizationAppleIDProvider()
//            let request = appleIdProvider.createRequest()
//            request.requestedScopes = [.email,.fullName]
//            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//            authorizationController.delegate = self
//            authorizationController.presentationContextProvider = self
//            authorizationController.performRequests()
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    
    func getStatus(state: Bool) {
        if state == true {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
//func hideSocial() {
//
//    var dict = Dictionary<String,Any>()
//    dict["device_type"] = "2"
//    dict["current_version"] = "\(UIApplication.release)"
//    DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
//    HttpHelper.apiCallWithout(postData: dict as NSDictionary,
//                              url: APIManager.sharedInstance.KSocialHidden,
//                              identifire: "") { result, response, error, data in
//        DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
//        if let Json = data,(response?["status"] as? Bool == true), response != nil {
//            let decoder = JSONDecoder()
//            do{
//                let safeData = try decoder.decode(socialHidden.self, from: Json)
//                DispatchQueue.main.async {
//                    if safeData.data.is_google == "2"{
//                        self.stackView.isHidden = false
//                        self.orView.isHidden = false
//                    }else{
//                        self.stackView.isHidden = true
//                        self.orView.isHidden = true
//                    }
//                }
//
//            }catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//}
//
//
//}
//MARK: - Socail Api Hit
//func signInApiSocial(params:Parameters){
//    let device_id = UserDefaults.standard.string(forKey: "device_id") ?? ""
//    let header:HTTPHeaders = ["Deviceid": device_id]
//    self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, params, header:header) { response in
//        DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
//        print(response as Any)
//        if response != nil {
//            if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
//                if let result = response as? NSDictionary {
//                    print(result)
//
//                    currentUser = User.init(dictionary: result)
//                    if currentUser.status! {
//                        self.navigationController?.popViewController(animated: false)
//                        TBSharedPreference.sharedIntance.setUserData(currentUser)
//
//                        let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
//                        UserDefaults.standard.setValue(jwt, forKey: "jwt")
//
//                        TBOTPVC.sharedInstance.getUserToken()
//                    }else {
//                        self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
//                    }
//                }
//
//            } else {
//                self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
//            }
//        }
//    }
////        self.uplaodData(APIManager.sharedInstance.KLOGINAPI, params) { response in
////            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
////            print(response as Any)
////            if response != nil {
////                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
////                    if let result = response as? NSDictionary {
////                        print(result)
////
////                        currentUser = User.init(dictionary: result)
////                        if currentUser.status! {
////                            self.navigationController?.popViewController(animated: false)
////                            TBSharedPreference.sharedIntance.setUserData(currentUser)
////
////                            let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
////                            UserDefaults.standard.setValue(jwt, forKey: "jwt")
////
////                            TBOTPVC.sharedInstance.getUserToken()
////                        }else {
////                            self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
////                        }
////                    }
////
////                } else {
////                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
////                }
////            }
////        }
//}




//MARK: - CountryPickerViewDelegate

extension NewMobileVC: CountryPickerViewDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(countryPicker.selectedCountry.phoneCode)
        countryCode = country.phoneCode
    }
    
}

//MARK: - UITextFieldDelegate {
extension NewMobileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        let maxLength = 10
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}

extension NewMobileVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "userrecordcell", for: indexPath) as! userrecordcell
        let mobile = (record[indexPath.row]["mobile"] as? String ?? "")
        cell.label.text = mobile
        return cell
    }
}



//extension EmailController {
//
//    func getDataFromFacebook () {
//        if(AccessToken.current != nil){
//            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: {
//                (connection, result, error) -> Void in
//                if (error == nil){
//                    var email = String()
//                    let fbData = result as! Parameters
//                    print(result!)
//                    print(fbData)
//                    if ((fbData["email"] as? String) != nil) {
//                        email = fbData["email"] as! String
//                    }
//
//                    let name = fbData["name"] as! String
//                    let id = fbData["id"] as! String
//                    var profileImage = String()
//                    if let imageURL = ((fbData["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
//                        profileImage = imageURL
//
//                    }
//                    let fbParameter: Parameters = ["fb_id": id ,"username": name ,"email": email,"profile_picture" : profileImage]
//                    isComeFrom = 1
//                    if let uid = UIDevice.current.identifierForVendor?.uuidString {
//                        print(uid)
//                        self.UDID = uid
//                        UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
//                    }
//                    deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
//                    let device_id = UserDefaults.standard.string(forKey: "device_id")
//
//                    let param1 = ["mobile": fbParameter["email"] ?? "", "login_type" : "1" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id!, "device_token":deviceTokanStr, "social_token" : fbParameter["fb_id"] ?? "","username":fbParameter["username"] ?? "","profile_picture": fbParameter["profile_picture"] ?? ""]
//                    self.signInApiSocial(params: param1)
//
//                }
//            })
//        }
//    }
//
//
////MARK: - Google Sign In
//extension NewMobileVC: GIDSignInDelegate, GIDSignInUIDelegate {
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if (error == nil) {
//            debugPrint(user.authentication.clientID)
//
//            let userid = user.userID // For client-side use only!
//            _ = user.authentication.idToken //Safe to send to the server
//            let fullName = user.profile.name
//            let email = user.profile.email
//            let imageURL = user.profile.imageURL(withDimension: 250)
//            let gmailData: Parameters = ["gmail_id": userid! as String,"username":fullName! as String,"email":email! as String ,"password" : ""]
//            print("gmailData::::",gmailData)
//            isComeFrom = 2
//            if let uid = UIDevice.current.identifierForVendor?.uuidString {
//                print(uid)
//                self.UDID = uid
//                UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
//            }
//            let device_id = UserDefaults.standard.string(forKey: "device_id")
//            deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
//
//            let  param1 = ["mobile":gmailData["email"] ?? "", "login_type" : "2" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr,"social_token":gmailData["gmail_id"] ?? "", "username":fullName ?? "","profile_picture": "\(imageURL!)"]
//            signInApiSocial(params: param1)
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
//}
//
////MARK: - Apple Login
//@available(iOS 13.0, *)
//extension EmailController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        AlertController.alert(title: error.localizedDescription)
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//
//        switch authorization.credential {
//        case let credentials as ASAuthorizationAppleIDCredential:
//            print(credentials.user)
//            print(credentials.fullName?.familyName)
//            print(credentials.fullName?.givenName)
//            print(credentials.email)
//
//            let name = "\(credentials.fullName?.givenName ?? "") \((credentials.fullName?.familyName ?? ""))"
//
//            if let uid = UIDevice.current.identifierForVendor?.uuidString {
//                print(uid)
//                self.UDID = uid
//                UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
//            }
//
//            let device_id = UserDefaults.standard.string(forKey: "device_id")
//
//            isComeFrom = 3
//            let  param1: Parameters = ["mobile":credentials.email ?? "", "login_type" : "3" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr,"social_token":credentials.user, "username":name ]
//
//            signInApiSocial(params: param1)
//        case let credentials as ASPasswordCredential:
//            print(credentials.password)
//
//        default:
//            AlertController.alert(title: "Error local")
//        }
//    }
//
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return view.window!
//    }
//}

