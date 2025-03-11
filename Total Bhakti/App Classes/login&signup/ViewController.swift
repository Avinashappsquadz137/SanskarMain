//
//  ViewController.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin
import AuthenticationServices

class ViewController: TBInternetViewController {
    var param1 : Parameters = [:]
    //MARK:- UIOutLets.
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var UDID: String!
    static private(set) var currentInstance: ViewController?

    @IBOutlet weak var orView: UIView!
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var socialStack: UIStackView!
    //MARK:- Variables.
    var textArr = [String]()
    var thisWidth:CGFloat = 0

    //MARK:- Lycle Cycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        orView.isHidden = true
        socialStack.isHidden = true
        self.faceBookBtn.isHidden = true
        self.googleBtn.isHidden = false
        self.appleBtn.isHidden = false
        let param = ["device_type":"2","current_version": "\(UIApplication.release)"]
        DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view)})
        CallSOCIALAPI(param, url: APIManager.sharedInstance.KSocialHidden)
        
        pageControl.hidesForSinglePage = true
        shadowEffect(button: faceBookBtn)
        shadowEffect(button: googleBtn)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        textArr = ["With the blessings of Indian Gurus and Saints, sanskar has ventured into a new concept of bringing all Spiritual thoughts.","We are displaying videos as well as audio contents in a more user-friendly format  to reach people 24/7 from all over the world","All are invited to share their spiritual experiences by using Videos, Images and even Audio as well"]
        faceBookBtn.layer.cornerRadius = faceBookBtn.frame.size.height / 2
        googleBtn.layer.cornerRadius = googleBtn.frame.size.height / 2
        
    }

    func CallSOCIALAPI(_ param: [String: Any], url: String) {
        let fullURL = APIManager.sharedInstance.KBASEURL + url

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                print("key::::::\(key)----value:::::\(value)")

                if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else if let dataValue = value as? Data {
                    multipartFormData.append(dataValue, withName: key)
                } else {
                    print("Unsupported value type for key: \(key)")
                }
            }
        }, to: fullURL, method: .post)
        .responseJSON { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }

            switch response.result {
            case .success(let jsonResponse):
                guard let resultDict = jsonResponse as? [String: Any],
                      let data = resultDict["data"] as? [String: Any] else {
                    print("Invalid response format")
                    return
                }

                let isApple = data["is_apple"] as? String ?? "0"
                let isFacebook = data["is_facebook"] as? String ?? "0"
                let isGoogle = data["is_google"] as? String ?? "0"
                let iso = data["iso"] as? String ?? ""

                DispatchQueue.main.async {
                    isoStatus = iso
                    UserDefaults.standard.set(iso, forKey: "iso")

                    self.appleBtn.isHidden = (isApple == "1")
                    self.faceBookBtn.isHidden = (isFacebook == "1")
                    self.googleBtn.isHidden = (isGoogle == "1")
                    self.orView.isHidden = !(isApple == "1" || isFacebook == "1" || isGoogle == "1")
                }

            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
                if let urlError = error as? URLError {
                    DispatchQueue.main.async {
                        if urlError.code == .notConnectedToInternet {
                            AlertController.alert(title: ALERTS.kNoInterNetConnection)
                        } else if urlError.code == .timedOut {
                            AlertController.alert(title: "Connection timeout")
                        } else if urlError.code == .networkConnectionLost {
                            AlertController.alert(title: "Network Connection Lost")
                        }
                    }
                }
            }
        }
    }

    func reloadData() {
        self.orView.setNeedsDisplay()
//        self.orView.setNeedsDisplay()
       }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = gradientBackground()
        layer.frame = getStartedBtn.bounds
        getStartedBtn.clipsToBounds = true
        getStartedBtn.layer.insertSublayer(layer, at: 0)
    }
  
    //ShadowEffect.
    func shadowEffect (button : UIButton) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 1
    }
    
    
    //MARK:- Screen BtnActions.
    @IBAction func screenBtnAction(_ sender : UIButton) {
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        if sender.tag == 10 {//getStarted
          //  let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
        //  navigationController?.pushViewController(vc, animated: true)
            isComeFrom = 0

            
             signInApi()
   //
            
        }else if sender.tag == 20 {//faceBookBtn.
            let loginManager = LoginManager()
              loginManager.logOut()
            loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: { result in
                switch result {
                case .failed(let error) :
                    print(error.localizedDescription)
                case .cancelled:
                    print("cancelled")
                case .success(let grantedPermissions, _, let userInfo):
                    print(userInfo.tokenString)
                    print(grantedPermissions.map { "\($0)"}.joined(separator: " "))
                    getDataFromFacebook()
                    
                }
            })
        }else if sender.tag == 30 {//GoogleSignIn.
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance().clientID = KEYS.KClinetId
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            isComeFrom = 2
   //         navigationTohomepage()
            
        }else if sender.tag == 40 {//AppleSignIn.
            signInWithApple()
        }
        


        func getDataFromFacebook () {
            if(AccessToken.current != nil){
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: {
                    (connection, result, error) -> Void in
                    if (error == nil){
                        var email = String()
                        let fbData = result as! Parameters
                             print(result!)
                            print(fbData)
                        if ((fbData["email"] as? String) != nil) {
                            email = fbData["email"] as! String
                        }
                      
                        let name = fbData["name"] as! String
                        let id = fbData["id"] as! String
                        var profileImage = String()
                        if let imageURL = ((fbData["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                           profileImage = imageURL
                            
                        }
                        let fbParameter: Parameters = ["fb_id": id ,"username": name ,"email": email,"profile_picture" : profileImage]
//                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION) as! MobileVerificationVC
//                        vc.socialData = fbParameter
                        isComeFrom = 1
//                        vc.socialBool = true
                        
                        if let uid = UIDevice.current.identifierForVendor?.uuidString {
                            print(uid)
                            self.UDID = uid
                            UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
                        }
                        deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
                        let device_id = UserDefaults.standard.string(forKey: "device_id")

                        let param1 = ["mobile": fbParameter["email"] ?? "", "login_type" : "1" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id, "device_token":deviceTokanStr, "social_token" : fbParameter["fb_id"] ?? "","username":fbParameter["username"] ?? "","profile_picture": fbParameter["profile_picture"] ?? ""]
                        self.signInApiSocial(params: param1)
                       
//                        self.navigationController?.pushViewController(vc, animated: true)
                       
                    }
                })
            }
        }
        DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
    }
    
    func signInWithApple(){
        if #available(iOS 13.0, *) {
            let appleIdProvider = ASAuthorizationAppleIDProvider()
            let request = appleIdProvider.createRequest()
            request.requestedScopes = [.email,.fullName]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()

        } else {
            // Fallback on earlier versions
        }
    }
    //MARK:- ScrollViewDelegte For PageControl Current Page.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}
//MARK:- UIColection View DataSource Methods.
extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL, for: indexPath) as! mainViewCollcetionCell
        cell.lbl.text = textArr[indexPath.row]
        
        return cell
    }
    
    
}

//MARK:- UIColection View Delegates Methods.
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat((140*AppConstant.KSCREENSIZE.height)/647)
        let size = CGSize(width: AppConstant.KSCREENSIZE.width-40, height: 140)
        return size
    }
}

//MARK:- GoogleSignIN Delegtes Methods.
extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            debugPrint(user.authentication.clientID)
            
            let userid = user.userID // For client-side use only!
            _ = user.authentication.idToken //Safe to send to the server
            let fullName = user.profile.name
            let email = user.profile.email
            let imageURL = user.profile.imageURL(withDimension: 250)
            let gmailData: Parameters = ["gmail_id": userid! as String,"username":fullName! as String,"email":email! as String ,"password" : ""]
            print("gmailData::::",gmailData)
//            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION) as! MobileVerificationVC
//            vc.socialData = gmailData
//            vc.socialBool = true
            isComeFrom = 2
//            MobileVerificationVC.sharedInstance.signInApi()
//            navigationController?.pushViewController(vc, animated: false)
            
            
            if let uid = UIDevice.current.identifierForVendor?.uuidString {
                print(uid)
                self.UDID = uid
                UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
                
            }
            
            let device_id = UserDefaults.standard.string(forKey: "device_id")
            deviceTokanStr = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"

            let  param1 = ["mobile":gmailData["email"] ?? "", "login_type" : "2" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr,"social_token":gmailData["gmail_id"] ?? "", "username":fullName ?? "","profile_picture": "\(imageURL!)"]
            
            signInApiSocial(params: param1)
            
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
}

extension ViewController{

    //MARK:- signInApi.
    func signInApiSocial(params:Parameters){
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            self.UDID = uid
        }
//        if isComeFrom == 2 {//Google
//
//            param1 = ["mobile":socialData["email"] ?? "", "login_type" : "2" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": self.UDID ?? "", "device_token":UserModel.device_tokken,"social_token":socialData["gmail_id"] ?? ""]
//
//        }
//        if isComeFrom == 1 {//Facebook
//            //            param1.updateValue(mobileNumberTF.text!, forKey: "mobile")
//            //            param1.updateValue("1", forKey: "login_type")
//            //            param1.updateValue(countryCodeLbl.text!, forKey: "country_code")
//
//
//            param1 = ["mobile": socialData["email"] ?? "", "login_type" : "1" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": self.UDID ?? "", "device_token":UserModel.device_tokken, "social_token" : socialData["fb_id"] ?? ""]
//
//        }
        let device_id = UserDefaults.standard.string(forKey: "device_id") ?? ""
        let header:HTTPHeaders = ["Deviceid": device_id]
        self.uplaodDataHeader(APIManager.sharedInstance.KLOGINAPI, params, header: header) { response in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if response != nil {
                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
                    if let result = response as? NSDictionary {
                        print(result)
                        
                        currentUser = User.init(dictionary: result)
                        if currentUser.status! {
                            self.navigationController?.popViewController(animated: false)
                            TBSharedPreference.sharedIntance.setUserData(currentUser)
                            
                            let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
                            UserDefaults.standard.setValue(jwt, forKey: "jwt")
                            
//                            if isComeFrom == 2 || isComeFrom == 1{
//                                self.socialData = [:]
                        //        TBOTPVC.sharedInstance.getUserToken()
//                            }
//                            else{
//                                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
//                                vc.parameter = self.param1
//
//                                vc.completionBlock = {() -> ()in
//                                    self.navigationController?.popViewController(animated: true)
//                                }
//
//                                self.present(vc,animated: true,completion: nil)
//
//
//                            }
                        }else {
                            self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                        }
                    }
                    
                } else {
                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
        
//        self.uplaodData(APIManager.sharedInstance.KLOGINAPI, params) { response in
//            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
//            print(response as Any)
//            if response != nil {
//                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
//                    if let result = response as? NSDictionary {
//                        print(result)
//                        
//                        currentUser = User.init(dictionary: result)
//                        if currentUser.status! {
//                            self.navigationController?.popViewController(animated: false)
//                            TBSharedPreference.sharedIntance.setUserData(currentUser)
//                            
//                            let jwt = ((result["data"] as! NSDictionary)["jwt"] as! String)
//                            UserDefaults.standard.setValue(jwt, forKey: "jwt")
//                            
////                            if isComeFrom == 2 || isComeFrom == 1{
////                                self.socialData = [:]
//                                TBOTPVC.sharedInstance.getUserToken()
////                            }
////                            else{
////                                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
////                                vc.parameter = self.param1
////
////                                vc.completionBlock = {() -> ()in
////                                    self.navigationController?.popViewController(animated: true)
////                                }
////
////                                self.present(vc,animated: true,completion: nil)
////
////
////                            }
//                        }else {
//                            self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
//                        }
//                    }
//                    
//                } else {
//                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
//                }
//            }
//        }
    }
//    
//    
    
    
//MARK:- signInApi.
func signInApi(){

//    param1 = ["mobile": "9811792554", "login_type" : "0" , "country_code" : "+91"]

    if let uid = UIDevice.current.identifierForVendor?.uuidString {
        print(uid)
        self.UDID = uid
        print(self.UDID)
    }

    param1 = ["mobile": "9811792554"]

    self.uplaodData(APIManager.sharedInstance.KGUESTLOGINAPI, param1) { response in
        DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
        print(response as Any)
        if response != nil {
            if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
                if let result = response as? NSDictionary {
                    print(result)

                    currentUser = User.init(dictionary: result)
                    if currentUser.status! {
                       TBSharedPreference.sharedIntance.setUserData(currentUser)
//                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
//                        vc.parameter = self.param1
//                        self.navigationController?.pushViewController(vc, animated: true)

                        self.VerifyOtp()

                    }else {
                        self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                    }
                }

            } else {
                self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}
}

extension ViewController{
//MARK:- verifyOTP.
func VerifyOtp() {
    let otp  = "0000"
    
    if let uid = UIDevice.current.identifierForVendor?.uuidString {
        print(uid)
        self.UDID = uid
        UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
    }
    
    let device_id = UserDefaults.standard.string(forKey: "device_id")

    let param : Parameters = ["mobile" : "9811792554","otp_verification" : "\(otp)", "device_id":device_id]

        
        self.uplaodData(APIManager.sharedInstance.KOTPAPI, param, { response in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            if let response = response as? NSDictionary {
//                currentUser = User.init(dictionary: result)
//                if currentUser.status! {
//                       TBSharedPreference.sharedIntance.setUserData(currentUser)

                if response.value(forKey: "status") as? Bool == true {
                    TBSharedPreference.sharedIntance.setLoginStatus(true)
//                    
//                    let vc =  storyBoard.instantiateViewController(withIdentifier: "Loginviewcontroller") as! Loginviewcontroller
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    self.navigationTohomepage()
                }
                else{
                    self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)

                }
            }
        })
    }
}

@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerDelegate{
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        AlertController.alert(title: error.localizedDescription)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            print(credentials.user)
            print(credentials.fullName?.familyName)
            print(credentials.fullName?.givenName)
            print(credentials.email)
            
            let name = "\(credentials.fullName?.givenName ?? "") \((credentials.fullName?.familyName ?? ""))"
            
            if let uid = UIDevice.current.identifierForVendor?.uuidString {
                print(uid)
                self.UDID = uid
                UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
            }
            
            let device_id = UserDefaults.standard.string(forKey: "device_id")

            isComeFrom = 3
            let  param1: Parameters = ["mobile":credentials.email ?? "", "login_type" : "3" , "login_with":"2","device_type":"2", "device_model":"\(UIDevice().type)","device_id": device_id ?? "", "device_token":deviceTokanStr,"social_token":credentials.user, "username":name ]
            
            signInApiSocial(params: param1)
        case let credentials as ASPasswordCredential:
            print(credentials.password)

        default:
            AlertController.alert(title: "Error local")
        }
    }
}

@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}

