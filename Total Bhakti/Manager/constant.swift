//
//  constant.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation
import UIKit
import GoogleCast
import Alamofire
let reachability = Reachability()!
var noInternet = false

let storyBoard = UIStoryboard(name: "Main", bundle: nil)
let storyBoardNew = UIStoryboard(name: "NewScreenLive", bundle: nil)
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var currentUser : User!
                                                                                                                       

var isChangeScreen = false
var dataOFVideos : VideosData1!
var audioPlayed = Int()
var avPlayer: AVPlayer!
var bhajanSongArr = NSMutableArray()
let dateFormatterForWholeApp = DateFormatter()
let KTIMEFORMATE        = "MM-dd-yyyy HH:mm"
var deviceTokanStr   = String()
var goLive              = String()
let appName : String    = "Sanskar"
var bhajanData : Bhajan!
var home : TBHomeTabBar!
var FirebaseChannel = ""
let kCureencySymbol = "\u{20B9}" + " "
var AdStatus: Int?
var IsPremiumAct: Int?
var qrStatus : String?
var epgIos: String?
var isoStatus: String = ""
var casting: Bool = false
var epgLive: Bool = false
var watchedId = ""
var isDownloadSongPlay : Bool = false

var mediaInfo: GCKMediaInformation? {
    didSet {
        print("setMediaInfo: \(String(describing: mediaInfo))")
    }
}

private var castSession: GCKCastSession!

   
enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}


var comeFromHomeScreen    =  0
var isComeFrom            =  0
var isComeFromProfile     =  0
var allVideoHeaderName    =  0
var bhajanPage            =  0
var termsAndCondition     =  0
var isComeFromHomeScreenToBhajanList = false
var isComeFromHomeScreenToNewsList = false
var isComeFromHomeScreen  = false
var type = ""
var isComeFromHome            =  0
var videoType                 = 0
//date And time
let KYEARS     =    "years"
let KMONTHS    =    "months"
let KWEEKS     =    "weeks"
let KDAYS      =    "days"
let KMINUTES   =    "minutes"
let KSECONDS   =    "seconds"
let KHOURS     =    "hours"
var is_premium_active = ""
var universalType = ""
var kAds: Bool = false
var epgPlay : Bool = false
var prePlay: Bool = false
var iscoming = ""
var goingTo = ""
var roImg = ""
var goToRadio = ""
var prePum : String = ""
var liveTap: String = ""
var exact: Int = 0
let appColor =  UIColor(named: "NewColor")
struct AppConstant {
    static let KSCREENSIZE               =      UIScreen.main.bounds
    static let KTHEAMCOLORLIGHT          =      UIColor(red:0.27, green:0.57, blue:0.71, alpha:1.0)
    static let KTHEAMCOLORDARK           =      UIColor(red:0.18, green:0.44, blue:0.55, alpha:1.0)
    static let KFont                     =      "Ubuntu-Regular"
  
}

struct CONTROLLERNAMES {
    static let KVIEWCONTROLLER            =     "ViewController"
    static let KMOBILEVARIFICATION        =     "MobileVerificationVC"
    static let KNewMobileVC               =     "NewMobileVC"
    static let KTBOTPVC                   =     "TBOTPVC"
    static let KHOME                      =     "TBHomeVC"
    static let KSIDEMENU                  =     "TBSideMenuVC"
    static let KPROFILEVC                 =     "TBProfileVC"
    static let KALLVIDEOS                 =     "TBAllVideosVC"
    static let KTERMSANDCONDITIONVC       =     "TBTermsAndConditions"
    static let KGRURVC                    =     "TBGuruListViewController"
    static let KVIDEOPLAYER               =     "TBVideoPlayerVC"
    static let KVIDEOLISTVC               =     "TBVideoListVC"
    static let KNOTIFICATIONVC            =     "TBNotificationVC"
    static let KGRURDETAILVC              =     "TBGuruDetailVC"
    static let KNEWSVC                    =     "TBNewsVC"//
    static let KBHAJANVC                  =     "TBhajanVC"//
    static let KBHAJANLISTVC              =     "TBbhajanListVC"
    static let KNEWSDETAILSVC             =     "TBNewsDetailVC"
    static let KAUDIOPLAYERVC             =     "TBAudioPlayerVC"
    static let KCOMMENTVC                 =     "TBCommentVC"
    static let KSankitranVC               =     "TBSankitranVC"
    static let KCOMINGSOONVC              =     "TBComingSoonVC"
    static let KMYPLAYLISTVC              =     "TBMYPLAYLISTVC"
    static let KMYDOWNLOADS               =     "TBDownloadsVC"
    static let KLIVEPOOJA                 =     "LivepoojaViewController"
    static let KLIVEPOOJADETAIL           =     "livepoojadetailViewController"
    static let KPREIMIUMDETAIL            =     "newPreDetails"
    static let Kactiveprofile             =     "activeuserprofileViewController"
    static let KNewpremium                =     "Newpaymentvc"
    
    static let KGOLIVEVC                  =     "TBGoLiveViewController"
    static let KTABBARVC                  =     "TBHomeTabBar"
    static let KCHANNELTABLECLASS         =     "TBchannelTableView"
    static let KTBLIVECLASS               =     "TBLiveViewController"
    static let ChannelListVC              =     "TBChannelListVC"
    static let KPremiumDetailVC           =     "TBPremiumDetailVc"
    static let KTrendingBhajanVC          =     "TBTrendingBhajanVc"
    static let KTBCouponScreenVC          =     "TBCouponScreenVC"
    static let KTBCouponListVC            =     "TBCouponListVC"
    static let wallpaperVc                =     "GuruWallpaperVC"
    static let KPROFILECONTROLLER         =     "activeuserprofileViewController"
    static let Kloginvc                   =     "newloginpage"
    static let KLiveDarshanViewController =     "LiveDarshanViewController"
    
}

struct VpnChecker {

    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]

    static func isVpnActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
            let allKeys = keys.allKeys as? [String] else { return false }

        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
                where key.starts(with: protocolId) {
                // I use start(with:), so I can cover also `ipsec4`, `ppp0`, `utun0` etc...
                return true
            }
        }
        return false
    }
}


struct KEYS {
    static let KClinetId       : String   =     "606223139744-2nedd2kvv8bg16mtujb3l7pvf6tf0gp8.apps.googleusercontent.com"
    static let KCELL           : String   =     "KCELL"
    static let KCELL1          : String   =     "KCELL1"
    static let KCELL2          : String   =     "KCELL2"
    static let KCELL3          : String   =     "KCELL3"
    static let KROTATIONKEY    : String   =     "orientation"
}

struct ALERTS {
    static let kAlertOK                   =    "OK"
    static let kAlertCancel               =    "CANCEL"
    static let kAlertNo                   =    "NO"
    static let kAlertYes                  =    "YES"
    static let KAGREE                     =    "Agree"
    static let KDISAGREE                  =    "Disagree"
    static let KDone                      =    "Done"
    static let KERROR                     =    "ERROR"
    static let KSUCCESS                   =    "SUCCESS"
    
    static let KFirstString               =    "By signing up with Sanskar, you agree to our Terms & Privacy Policy"
    static let KSecondString              =    "Terms & Privacy Policy"
    static let KPleaseEnterMobileNumber   =    "Please enter your mobile number."
    static let kNoInterNetConnection      =    "Unable to connect to internet"
//    static let KSOMETHINGWRONG            =    "Something went worng, please try after some time."
    static let KCountryCode               =    "Country code cannot be empty."
    static let KOTPDoesnotVArify          =    "OTP does not verify."
    static let KPleaseEnterOTP            =    "Please enter vaild OTP."
    static let KLogout                    =    "Do you really want to logout?"
    static let KEmailVerify               =    "Please enter vaild email."
    static let KLoaderMessage             =    "Please wait.."
    static let KProfileUpdate             =    "Profile updated successfully."
    static let KADDEDINPLAYLIST           =     "Added to playlist"
    static let KPleaseEnterVaildMbileNumber =     "Please enter valid mobile number."
    static let KPleaseEnterVaildallnumber  =     "Please enter valid mobile number."
    static let KPleaseEnterVaildMbileOrEmail =     "Please enter valid mobile number / Email."
    static let KPleaseSelectOption        =     "Please select any plan"
    static let KSubscribe                 = "Please subscribe us to watch this video"
    static let KCouponEmpty               = "Please enter coupon code"
    static let kAlert                     =    "Alert"

}

extension UIViewController {
    func gradientBackground() -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        let leftColor = UIColor(red:236.0/255.0, green:90.0/255.0, blue:110.0/255.0, alpha:1.0)
        let rightColor = UIColor(red:244.0/255.0, green:154.0/255.0, blue:24.0/255.0, alpha:1.0)
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidPhone(value: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: value)
    }
    
    func addAlert(_ title : String , message : String , buttonTitle : String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func getDate(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
//        return dateFormatter.date(from: "2015-04-01T11:42:00") // replace Date String
        return dateFormatter.date(from: date)
    }
    
    func getNewDate(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
//        return dateFormatter.date(from: "2015-04-01T11:42:00") // replace Date String
        return dateFormatter.date(from: date)
    }
    
    //MARK:- NoDataFound.
    func noDataLabelCall(controllerType: UIViewController, tableReference: Any) -> UILabel {
        let noDataLbl = UILabel(frame: CGRect(x: AppConstant.KSCREENSIZE.width/2, y: AppConstant.KSCREENSIZE.height/2, width: 300, height: 50))
        noDataLbl.font = UIFont(name: AppConstant.KFont, size: 30.0)
        noDataLbl.text = "No data found"
        noDataLbl.center = CGPoint(x: AppConstant.KSCREENSIZE.width/2, y: AppConstant.KSCREENSIZE.height/2)
        noDataLbl.textAlignment = .center
        noDataLbl.textColor = UIColor.lightGray
        controllerType.view.addSubview(noDataLbl)
        noDataLbl.isHidden = true
        return noDataLbl
    }
    
    func exactTime() -> Int{
        let localISOFormatter = ISO8601DateFormatter()
        localISOFormatter.timeZone = TimeZone(identifier: "IST")
        // Printing a Date
        let date = Date()
        let currentdate = localISOFormatter.string(from: date)
        let cutdate = currentdate.subString(from: 11, to: 19)
        print(localISOFormatter.string(from: date))
        // Parsing a string timestamp representing a date
        let newTime = cutdate.secondFromString
        return Int(newTime)
    }
    
    //MARK:- NoDataFound with diffrent height.
    func noDataLabelCall1(controllerType: UIViewController, tableReference: Any) -> UILabel {
        let noDataLbl = UILabel(frame: CGRect(x: AppConstant.KSCREENSIZE.width/2, y: AppConstant.KSCREENSIZE.height/2 + 250, width: 300, height: 60))
        noDataLbl.font = UIFont(name: AppConstant.KFont, size: 45.0)
        noDataLbl.text = "No data found"
        noDataLbl.center = CGPoint(x: AppConstant.KSCREENSIZE.width/2, y: AppConstant.KSCREENSIZE.height/2 + 150)
        noDataLbl.textAlignment = .center
        noDataLbl.textColor = UIColor.lightGray
        controllerType.view.addSubview(noDataLbl)
        noDataLbl.isHidden = true
        return noDataLbl
    }
    
    //MARK:- check if url is vaild or not.
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
                
            }
        }
        return false
    }
    
    func uplaodData(_ url: String, _ param: [String: Any], _ success: @escaping (_ response: Any?) -> ()) {
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
                if let statusCode = response.response?.statusCode, statusCode == APIManager.sharedInstance.KHTTPSUCCESS {
                    success(jsonResponse)
                } else {
                    success(nil)
                }
                
            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
                if let urlError = error as? URLError,
                   urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                    print("No internet connection or request timed out.")
                }
                success(nil)
            }
        }
    }

    func uplaodDataHeader(_ url: String, _ param: [String: Any], header: HTTPHeaders, _ success: @escaping (_ response: Any?) -> ()) {
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
        }, to: fullURL, method: .post, headers: header)
        .responseJSON { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }
            
            switch response.result {
            case .success(let jsonResponse):
                if let statusCode = response.response?.statusCode, statusCode == APIManager.sharedInstance.KHTTPSUCCESS {
                    success(jsonResponse)
                } else {
                    success(nil)
                }
                
            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
                if let urlError = error as? URLError,
                   urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                    DispatchQueue.main.async {
                        loader.shareInstance.hideLoading()
                        // self.addAlert(ALERTS.KERROR, message: ALERTS.kNoInterNetConnection, buttonTitle: ALERTS.kAlertOK)
                    }
                }
                success(nil)
            }
        }
    }



    func uplaodData1(_ url: String, _ param: Parameters, _ success: @escaping (_ response: Any?) -> ()) {
        let fullURL = APIManager.sharedInstance.KBASEURL + url

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                print("key:::\(key), value:::::\(value)")
                
                if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: fullURL, method: .post, headers: nil)
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

                guard let responseDict = value as? [String: Any] else {
                    print("Invalid response format")
                    success(nil)
                    return
                }
                
                success(responseDict)

            case .failure(let error):
                print("Upload Failed: \(error.localizedDescription)")

                if let urlError = error.asAFError?.underlyingError as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        print("No Internet Connection")
                    case .timedOut:
                        print("Request Timed Out")
                    default:
                        break
                    }
                }
                
                success(nil)
            }
        }
    }

    
    func uplaodData2(_ url: String, _ param: [String: Any], _ success: @escaping (_ response: Any?) -> ()) {
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                print("key:::\(key), value:::::\(value)")

                if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else {
                    print("Unsupported value type for key: \(key)")
                }
            }
        }, to: url, method: .post)
        .responseJSON { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }

            switch response.result {
            case .success(let jsonResponse):
                if let statusCode = response.response?.statusCode, statusCode == APIManager.sharedInstance.KHTTPSUCCESS {
                    success(jsonResponse)
                } else {
                    success(nil)
                }

            case .failure(let error):
                print("Upload failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        if urlError.code == .notConnectedToInternet {
                            print("No internet connection")
                        } else if urlError.code == .timedOut {
                            print("Connection timed out")
                        }
                    }
                    success(nil)
                }
            }
        }
    }

    //MARK:- recentViewHit.
    func recentViewHit(_ param : Parameters) {
       // loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.KRECENTVIEWAPI, param) { (response) in
          //  DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Int == 1 {
//                    if let result = JSON.value(forKey: "data") as? NSArray {
//                        print(result)
//                    }
                }else {
                  //  self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
             //   self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    func navigatToHomeScreen() {
        
        let status = TBSharedPreference.sharedIntance.getLoginStatue() ?? false
        if status {
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "TBHomeTabBar") as! TBHomeTabBar
            let leftViewController = storyboard.instantiateViewController(withIdentifier: "TBSideMenuVC") as! TBSideMenuVC
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            
            nvc.isNavigationBarHidden = true
            nvc.navigationBar.isHidden = true
            SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width - 50
            SlideMenuOptions.hideStatusBar = true
            let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
            slideMenuController.delegate = leftViewController as SlideMenuControllerDelegate
            let nav = UINavigationController(rootViewController: slideMenuController)
            
            nav.isNavigationBarHidden = true
            nav.navigationBar.isHidden = true
            
            appdelegate.window!.rootViewController = nav
            appdelegate.window!.makeKeyAndVisible()
            
            
        }else{
            let nav = UINavigationController()
            nav.isNavigationBarHidden = true
            let loginScreen = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KVIEWCONTROLLER)
            nav.viewControllers = [loginScreen]
            appDelegate.window?.rootViewController = nav
            appDelegate.window?.makeKeyAndVisible()
            nav.isNavigationBarHidden = true
            nav.navigationController?.navigationBar.isHidden = true
            
        }
    }
    
    

//    func navigatToHomeScreen() {
//        if let nav = appDelegate.window?.rootViewController as? UINavigationController {
//            let homeScreen = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTABBARVC) as! TBHomeTabBar
//
//            let menuScreen = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KSIDEMENU) as! TBSideMenuVC
//            nav.viewControllers = [homeScreen]
//            let slideMenuController = SlideMenuController(mainViewController: nav, leftMenuViewController: menuScreen)
//            appDelegate.window?.rootViewController = slideMenuController
//            appDelegate.window?.makeKeyAndVisible()
//            var width = CGFloat()
//            if AppConstant.KSCREENSIZE.width == 375 {
//                width = 285.0
//            }else if AppConstant.KSCREENSIZE.width == 320.0 {
//                width = 260.0
//            }else if AppConstant.KSCREENSIZE.width == 414.0 {
//                width = 305.0
//            }
//            slideMenuController.changeLeftViewWidth(width)
//            UIApplication.shared.isStatusBarHidden = false
//            self.navigationController?.navigationBar.isHidden = false
//        }
//    }
    
    func navigationTohomepage () {
        let status = TBSharedPreference.sharedIntance.getLoginStatue() ?? true
        if status {
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "TBHomeTabBar") as! TBHomeTabBar
            let leftViewController = storyboard.instantiateViewController(withIdentifier: "TBSideMenuVC") as! TBSideMenuVC
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            
            nvc.isNavigationBarHidden = true
            nvc.navigationBar.isHidden = true
            SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width - 50
            SlideMenuOptions.hideStatusBar = true
            let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
            slideMenuController.delegate = leftViewController as SlideMenuControllerDelegate
            let nav = UINavigationController(rootViewController: slideMenuController)
            
            nav.isNavigationBarHidden = true
            nav.navigationBar.isHidden = true
            
            appdelegate.window!.rootViewController = nav
            appdelegate.window!.makeKeyAndVisible()
            
            
        }
    }
    
    func navigationToLoginScreen () {
        let nav = UINavigationController()
        nav.isNavigationBarHidden  = true
        let loginScreen = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KVIEWCONTROLLER)
        nav.viewControllers = [loginScreen]
        appDelegate.window?.rootViewController = nav
        appDelegate.window?.makeKeyAndVisible()
//        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false

    }
    func navigationToPremiumpage() {
        let nav = UINavigationController()
        nav.isNavigationBarHidden  = true
        let loginScreen = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
        nav.viewControllers = [loginScreen]
        appDelegate.window?.rootViewController = nav
        appDelegate.window?.makeKeyAndVisible()
//        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false

    }
    func navigationToLogincontroller () {
        let nav = UINavigationController()
        nav.isNavigationBarHidden  = true
        let loginScreen = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.Kloginvc)
        nav.viewControllers = [loginScreen]
        appDelegate.window?.rootViewController = nav
        appDelegate.window?.makeKeyAndVisible()
//        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false

    }
    func navigationToshorts () {
        let nav = UINavigationController()
        nav.isNavigationBarHidden  = true
        let loginScreen = storyBoard.instantiateViewController(withIdentifier: "TBshortsVC") as! TBshortsVC
      //  nav.viewControllers = [loginScreen]
        appDelegate.window?.rootViewController = nav
        appDelegate.window?.makeKeyAndVisible()
//        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false

    }



    func shadowEffectOnImageView(_ imageView : UIImageView)  {
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 1.0
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowOpacity = 0.5
    }
    
 
}



//MARK:- ImageResizing.
extension UIImage {
    func resizeToWidth(_ width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

//MARK:- Shadow Effect .
extension UIView {
    func dropShadow(_ scale: Bool = true) {
        self.layer.cornerRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.8, height: 0.5)
        self.layer.shadowRadius = 2
    }
   }
extension UIView {
    func dropShadowWithColor() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = false
       // self.layer.shadowColor = UIColor.black.cgColor
       // self.layer.shadowOpacity = 0.2
      //  self.layer.shadowOffset = CGSize(width: 0.8, height: 0.5)
      //  self.layer.shadowRadius = 2
    }
}

func shadow (_ cell : UICollectionViewCell) {
    cell.contentView.layer.cornerRadius = 10.0
    cell.contentView.layer.borderWidth = 1.0
    cell.contentView.layer.borderColor = UIColor.clear.cgColor
    cell.contentView.layer.masksToBounds = true
    
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 0.25
    cell.layer.masksToBounds = false
    cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
  
}

extension UILabel {
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedStringKey.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedStringKey.font: moreTextFont, NSAttributedStringKey.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedStringKey.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedStringKey : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedStringKey : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

extension Date {
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date)) \(KYEARS)"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date)) \(KMONTHS)"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date)) \(KWEEKS)"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date)) \(KDAYS)"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date)) \(KHOURS)"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date)) \(KMINUTES)" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) \(KSECONDS)" }
        return ""
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? "    "
    }
}
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970*1000)
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? "     "
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension UIViewController : GCKRequestDelegate{
    
    func playSelectedVideo(seletedData : videosResult)
    {
        let metadata = GCKMediaMetadata()
        metadata.setString(seletedData.video_title!.html2String, forKey: kGCKMetadataKeyTitle)
        metadata.setString(seletedData.video_desc!.html2String,
                           forKey: kGCKMetadataKeySubtitle)
        metadata.addImage(GCKImage(url: URL(string: seletedData.thumbnail_url!)!,
                                   width: 480,
                                   height: 360))
        
        
        var url = URL.init(string: seletedData.video_url!)
 
        guard let mediaURL = url else {
            print("invalid mediaURL")
            return
        }
        let mediaInformation : GCKMediaInformation?
        
        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaURL)
        mediaInfoBuilder.streamType = GCKMediaStreamType.none;
        mediaInfoBuilder.contentType = "video/m3u8"
        mediaInfoBuilder.contentID  = seletedData.video_url
        mediaInfoBuilder.metadata = metadata
        mediaInformation = mediaInfoBuilder.build()
        
        guard let mediaInfo = mediaInformation else {
            print("invalid mediaInformation")
            return
        }
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let request = remoteMediaClient.loadMedia(mediaInfo)
            request.delegate = self
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
        }
        else
        {
            NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil, userInfo: ["sucess" : seletedData])
        }
        
        
        
    }
    
    
   
    func playSelectedAudio(seletedData : Bhajan)
    {
        isPlayList = false
        let metadata = GCKMediaMetadata()
        metadata.setString(seletedData.artist_name!.html2String, forKey: kGCKMetadataKeyTitle)
        metadata.setString(seletedData.description!.html2String,
                           forKey: kGCKMetadataKeySubtitle)
        metadata.addImage(GCKImage(url: URL(string: seletedData.image!)!,
                                   width: 480,
                                   height: 360))
        
        
        let url = URL.init(string: seletedData.media_file!)
        guard let mediaURL = url else {
            print("invalid mediaURL")
            return
        }
        let mediaInformation : GCKMediaInformation?
        
        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaURL)
        mediaInfoBuilder.streamType = GCKMediaStreamType.none;
        mediaInfoBuilder.contentType = "Audio/mp3"
        mediaInfoBuilder.contentID  = seletedData.media_file
        mediaInfoBuilder.metadata = metadata
        mediaInformation = mediaInfoBuilder.build()
        
        guard let mediaInfo = mediaInformation else {
            print("invalid mediaInformation")
            return
        }
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let request = remoteMediaClient.loadMedia(mediaInfo)
            request.delegate = self
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()

        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openAudioPlayerView"), object: nil, userInfo: ["sucess" : seletedData])
        }
        
    }
    
    func playRadio(seletedData : Channel)
    {
        isPlayList = false
        let metadata = GCKMediaMetadata()
        metadata.setString(seletedData.name!, forKey: kGCKMetadataKeyTitle)
        metadata.setString(seletedData.description!.html2String,
                           forKey: kGCKMetadataKeySubtitle)
        metadata.addImage(GCKImage(url: URL(string: seletedData.image!)!,
                                   width: 480,
                                   height: 360))
        
        
        let url = URL.init(string: seletedData.channel_url!)
        guard let mediaURL = url else {
            print("invalid mediaURL")
            return
        }
        let mediaInformation : GCKMediaInformation?
        
        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaURL)
        mediaInfoBuilder.streamType = GCKMediaStreamType.live;
        mediaInfoBuilder.contentType = "Audio/mp3"
        mediaInfoBuilder.contentID  = seletedData.channel_url
        mediaInfoBuilder.metadata = metadata
        mediaInformation = mediaInfoBuilder.build()
        
        guard let mediaInfo = mediaInformation else {
            print("invalid mediaInformation")
            return
        }
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let request = remoteMediaClient.loadMedia(mediaInfo)
            request.delegate = self
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
            
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
            
        }
        
    }
    
    
    
    

    func playSelectedLiveTV(seletedData : Channel)
    {

        if seletedData.id! == "19"{
            FirebaseChannel = "sanskarTV"
        }
        else if seletedData.id! == "Sanskar UK"{
            FirebaseChannel = "sanskarUK"
        }
        else if seletedData.id! == "26"{
            FirebaseChannel = "sanskarUSA"
        }
        else if seletedData.id! == "23"{
            FirebaseChannel = "SanskarWebTV"
        }
        else if seletedData.id! == "20"{
            FirebaseChannel = "satsangTV"
        }
        else if seletedData.id! == "24"{
            FirebaseChannel = "satsangWebTV"
        }
        else if seletedData.id! == "22"{
            FirebaseChannel = "SubhCinemaTV"
        }
        else if seletedData.id! == "27"{
            FirebaseChannel = "SanskarTvRadio"
        }
        else {
            FirebaseChannel = "shubhTV"
        }
   
       NotificationCenter.default.post(name: Notification.Name("ObserveNewChannel"), object: nil)

        let metadata = GCKMediaMetadata()
        metadata.setString(seletedData.name!.html2String, forKey: kGCKMetadataKeyTitle)
        metadata.setString(seletedData.name!.html2String,
                           forKey: kGCKMetadataKeySubtitle)
        metadata.addImage(GCKImage(url: URL(string: seletedData.image!)!,
                                   width: 480,
                                   height: 360))
        
        
        let url = URL.init(string: seletedData.channel_url!)
        guard let mediaURL = url else {
            print("invalid mediaURL")
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)

        let mediaInformation : GCKMediaInformation?
        
        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaURL)
        mediaInfoBuilder.streamType = GCKMediaStreamType.none;
        mediaInfoBuilder.contentType = "video/m3u8"
        mediaInfoBuilder.contentID  = seletedData.channel_url
        mediaInfoBuilder.metadata = metadata
        mediaInformation = mediaInfoBuilder.build()
        
        guard let mediaInfo = mediaInformation else {
            print("invalid mediaInformation")
            return
        }
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let request = remoteMediaClient.loadMedia(mediaInfo)
            request.delegate = self
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
            
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
            
            NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "open"), object: nil, userInfo: ["sucess" : seletedData])
        }
        
    }
}
extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second" :
                "\(second)" + " " + "seconds ago"
        } else {
            return "just now"
        }
        
    }
}
public enum Model : String {

//Simulator
case simulator     = "simulator/sandbox",

//iPod
iPod1              = "iPod 1",
iPod2              = "iPod 2",
iPod3              = "iPod 3",
iPod4              = "iPod 4",
iPod5              = "iPod 5",
iPod6              = "iPod 6",
iPod7              = "iPod 7",

//iPad
iPad2              = "iPad 2",
iPad3              = "iPad 3",
iPad4              = "iPad 4",
iPadAir            = "iPad Air ",
iPadAir2           = "iPad Air 2",
iPadAir3           = "iPad Air 3",
iPadAir4           = "iPad Air 4",
iPad5              = "iPad 5", //iPad 2017
iPad6              = "iPad 6", //iPad 2018
iPad7              = "iPad 7", //iPad 2019
iPad8              = "iPad 8", //iPad 2020

//iPad Mini
iPadMini           = "iPad Mini",
iPadMini2          = "iPad Mini 2",
iPadMini3          = "iPad Mini 3",
iPadMini4          = "iPad Mini 4",
iPadMini5          = "iPad Mini 5",

//iPad Pro
iPadPro9_7         = "iPad Pro 9.7\"",
iPadPro10_5        = "iPad Pro 10.5\"",
iPadPro11          = "iPad Pro 11\"",
iPadPro2_11        = "iPad Pro 11\" 2nd gen",
iPadPro12_9        = "iPad Pro 12.9\"",
iPadPro2_12_9      = "iPad Pro 2 12.9\"",
iPadPro3_12_9      = "iPad Pro 3 12.9\"",
iPadPro4_12_9      = "iPad Pro 4 12.9\"",

//iPhone
iPhone4            = "iPhone 4",
iPhone4S           = "iPhone 4S",
iPhone5            = "iPhone 5",
iPhone5S           = "iPhone 5S",
iPhone5C           = "iPhone 5C",
iPhone6            = "iPhone 6",
iPhone6Plus        = "iPhone 6 Plus",
iPhone6S           = "iPhone 6S",
iPhone6SPlus       = "iPhone 6S Plus",
iPhoneSE           = "iPhone SE",
iPhone7            = "iPhone 7",
iPhone7Plus        = "iPhone 7 Plus",
iPhone8            = "iPhone 8",
iPhone8Plus        = "iPhone 8 Plus",
iPhoneX            = "iPhone X",
iPhoneXS           = "iPhone XS",
iPhoneXSMax        = "iPhone XS Max",
iPhoneXR           = "iPhone XR",
iPhone11           = "iPhone 11",
iPhone11Pro        = "iPhone 11 Pro",
iPhone11ProMax     = "iPhone 11 Pro Max",
iPhoneSE2          = "iPhone SE 2nd gen",
iPhone12Mini       = "iPhone 12 Mini",
iPhone12           = "iPhone 12",
iPhone12Pro        = "iPhone 12 Pro",
iPhone12ProMax     = "iPhone 12 Pro Max",
iPhone13Mini       = "iPhone 13 Mini",
iPhone13           = "iPhone 13",
iPhone13Pro        = "iPhone 13 Pro",
iPhone13ProMax     = "iPhone 13 Pro Max",
iPhone14Plus       = "iPhone 14 Plus",
iPhone14           = "iPhone 14",
iPhone14Pro        = "iPhone 14 Pro",
iPhone14ProMax     = "iPhone 14 Pro Max",
iPhone15Plus       = "iPhone 15 Plus",
iPhone15           = "iPhone 15",
iPhone15Pro        = "iPhone 15 Pro",
iPhone15ProMax     = "iPhone 15 Pro Max",
     

// Apple Watch
AppleWatch1         = "Apple Watch 1gen",
AppleWatchS1        = "Apple Watch Series 1",
AppleWatchS2        = "Apple Watch Series 2",
AppleWatchS3        = "Apple Watch Series 3",
AppleWatchS4        = "Apple Watch Series 4",
AppleWatchS5        = "Apple Watch Series 5",
AppleWatchSE        = "Apple Watch Special Edition",
AppleWatchS6        = "Apple Watch Series 6",

//Apple TV
AppleTV1           = "Apple TV 1gen",
AppleTV2           = "Apple TV 2gen",
AppleTV3           = "Apple TV 3gen",
AppleTV4           = "Apple TV 4gen",
AppleTV_4K         = "Apple TV 4K",

unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {

var type: Model {
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            ptr in String.init(validatingUTF8: ptr)
        }
    }

    let modelMap : [String: Model] = [

        //Simulator
        "i386"      : .simulator,
        "x86_64"    : .simulator,

        //iPod
        "iPod1,1"   : .iPod1,
        "iPod2,1"   : .iPod2,
        "iPod3,1"   : .iPod3,
        "iPod4,1"   : .iPod4,
        "iPod5,1"   : .iPod5,
        "iPod7,1"   : .iPod6,
        "iPod9,1"   : .iPod7,

        //iPad
        "iPad2,1"   : .iPad2,
        "iPad2,2"   : .iPad2,
        "iPad2,3"   : .iPad2,
        "iPad2,4"   : .iPad2,
        "iPad3,1"   : .iPad3,
        "iPad3,2"   : .iPad3,
        "iPad3,3"   : .iPad3,
        "iPad3,4"   : .iPad4,
        "iPad3,5"   : .iPad4,
        "iPad3,6"   : .iPad4,
        "iPad6,11"  : .iPad5, //iPad 2017
        "iPad6,12"  : .iPad5,
        "iPad7,5"   : .iPad6, //iPad 2018
        "iPad7,6"   : .iPad6,
        "iPad7,11"  : .iPad7, //iPad 2019
        "iPad7,12"  : .iPad7,
        "iPad11,6"  : .iPad8, //iPad 2020
        "iPad11,7"  : .iPad8,

        //iPad Mini
        "iPad2,5"   : .iPadMini,
        "iPad2,6"   : .iPadMini,
        "iPad2,7"   : .iPadMini,
        "iPad4,4"   : .iPadMini2,
        "iPad4,5"   : .iPadMini2,
        "iPad4,6"   : .iPadMini2,
        "iPad4,7"   : .iPadMini3,
        "iPad4,8"   : .iPadMini3,
        "iPad4,9"   : .iPadMini3,
        "iPad5,1"   : .iPadMini4,
        "iPad5,2"   : .iPadMini4,
        "iPad11,1"  : .iPadMini5,
        "iPad11,2"  : .iPadMini5,

        //iPad Pro
        "iPad6,3"   : .iPadPro9_7,
        "iPad6,4"   : .iPadPro9_7,
        "iPad7,3"   : .iPadPro10_5,
        "iPad7,4"   : .iPadPro10_5,
        "iPad6,7"   : .iPadPro12_9,
        "iPad6,8"   : .iPadPro12_9,
        "iPad7,1"   : .iPadPro2_12_9,
        "iPad7,2"   : .iPadPro2_12_9,
        "iPad8,1"   : .iPadPro11,
        "iPad8,2"   : .iPadPro11,
        "iPad8,3"   : .iPadPro11,
        "iPad8,4"   : .iPadPro11,
        "iPad8,9"   : .iPadPro2_11,
        "iPad8,10"  : .iPadPro2_11,
        "iPad8,5"   : .iPadPro3_12_9,
        "iPad8,6"   : .iPadPro3_12_9,
        "iPad8,7"   : .iPadPro3_12_9,
        "iPad8,8"   : .iPadPro3_12_9,
        "iPad8,11"  : .iPadPro4_12_9,
        "iPad8,12"  : .iPadPro4_12_9,

        //iPad Air
        "iPad4,1"   : .iPadAir,
        "iPad4,2"   : .iPadAir,
        "iPad4,3"   : .iPadAir,
        "iPad5,3"   : .iPadAir2,
        "iPad5,4"   : .iPadAir2,
        "iPad11,3"  : .iPadAir3,
        "iPad11,4"  : .iPadAir3,
        "iPad13,1"  : .iPadAir4,
        "iPad13,2"  : .iPadAir4,
        

        //iPhone
        "iPhone3,1" : .iPhone4,
        "iPhone3,2" : .iPhone4,
        "iPhone3,3" : .iPhone4,
        "iPhone4s,1" : .iPhone4S,
        "iPhone5,1" : .iPhone5,
        "iPhone5,2" : .iPhone5,
        "iPhone5,3" : .iPhone5C,
        "iPhone5,4" : .iPhone5C,
        "iPhone6,1" : .iPhone5S,
        "iPhone6,2" : .iPhone5S,
        "iPhone7,1" : .iPhone6Plus,
        "iPhone7,2" : .iPhone6,
        "iPhone8,1" : .iPhone6S,
        "iPhone8,2" : .iPhone6SPlus,
        "iPhone8,4" : .iPhoneSE,
        "iPhone9,1" : .iPhone7,
        "iPhone9,3" : .iPhone7,
        "iPhone9,2" : .iPhone7Plus,
        "iPhone9,4" : .iPhone7Plus,
        "iPhone10,1" : .iPhone8,
        "iPhone10,4" : .iPhone8,
        "iPhone10,2" : .iPhone8Plus,
        "iPhone10,5" : .iPhone8Plus,
        "iPhone10,3" : .iPhoneX,
        "iPhone10,6" : .iPhoneX,
        "iPhone11,2" : .iPhoneXS,
        "iPhone11,4" : .iPhoneXSMax,
        "iPhone11,6" : .iPhoneXSMax,
        "iPhone11,8" : .iPhoneXR,
        "iPhone12,1" : .iPhone11,
        "iPhone12,3" : .iPhone11Pro,
        "iPhone12,5" : .iPhone11ProMax,
        "iPhone12,8" : .iPhoneSE2,
        "iPhone13,1" : .iPhone12Mini,
        "iPhone13,2" : .iPhone12,
        "iPhone13,3" : .iPhone12Pro,
        "iPhone13,4" : .iPhone12ProMax,
        "iPhone14,1" : .iPhone13Mini,
        "iPhone14,2" : .iPhone13,
        "iPhone14,3" : .iPhone13Pro,
        "iPhone14,4" : .iPhone13ProMax,
        "iPhone15,1" : .iPhone14Plus,
        "iPhone15,2" : .iPhone11,
        "iPhone15,3" : .iPhone14Pro,
        "iPhone15,4" : .iPhone14ProMax,
        "iPhone16,1" : .iPhone15Plus,
        "iPhone16,2" : .iPhone15,
        "iPhone16,3" : .iPhone15Pro,
        "iPhone16,4" : .iPhone15ProMax,
        
        
        // Apple Watch
        "Watch1,1" : .AppleWatch1,
        "Watch1,2" : .AppleWatch1,
        "Watch2,6" : .AppleWatchS1,
        "Watch2,7" : .AppleWatchS1,
        "Watch2,3" : .AppleWatchS2,
        "Watch2,4" : .AppleWatchS2,
        "Watch3,1" : .AppleWatchS3,
        "Watch3,2" : .AppleWatchS3,
        "Watch3,3" : .AppleWatchS3,
        "Watch3,4" : .AppleWatchS3,
        "Watch4,1" : .AppleWatchS4,
        "Watch4,2" : .AppleWatchS4,
        "Watch4,3" : .AppleWatchS4,
        "Watch4,4" : .AppleWatchS4,
        "Watch5,1" : .AppleWatchS5,
        "Watch5,2" : .AppleWatchS5,
        "Watch5,3" : .AppleWatchS5,
        "Watch5,4" : .AppleWatchS5,
        "Watch5,9" : .AppleWatchSE,
        "Watch5,10" : .AppleWatchSE,
        "Watch5,11" : .AppleWatchSE,
        "Watch5,12" : .AppleWatchSE,
        "Watch6,1" : .AppleWatchS6,
        "Watch6,2" : .AppleWatchS6,
        "Watch6,3" : .AppleWatchS6,
        "Watch6,4" : .AppleWatchS6,

        //Apple TV
        "AppleTV1,1" : .AppleTV1,
        "AppleTV2,1" : .AppleTV2,
        "AppleTV3,1" : .AppleTV3,
        "AppleTV3,2" : .AppleTV3,
        "AppleTV5,3" : .AppleTV4,
        "AppleTV6,2" : .AppleTV_4K
    ]

    if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
        if model == .simulator {
            if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                    return simModel
                }
            }
        }
        return model
    }
    return Model.unrecognized
  }
}

extension String{

    var integer: Int {
        return Int(self) ?? 0
    }

    var secondFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        let seconds = components[2].integer
        return Int((hours * 60 * 60) + (minutes * 60) + seconds)
    }
    
    var timeFromString: Int {
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        return Int((hours * 60 * 60) + (minutes * 60) )
    }
}


public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}


