 
//
//  AppDelegate.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import CoreData
import GoogleCast
import Firebase
import Crashlytics
import Fabric
import MMPlayerView
import FirebaseDatabase
import FirebaseMessaging
import FirebaseDynamicLinks
import FirebaseCore
//import IQKeyboardMsanager
import GoogleMobileAds
let kPrefPreloadTime = "preload_time_sec"
protocol shortCutDelegate:class {
    func shortCutIndex(index:Int)
}
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate, FIRMessagingDelegate {

    var key_id = ""
    var vlcScreenRotate = false
    var window: UIWindow?
    var firebaseBoolRemove = false
    static let instance = AppDelegate()
//    let kReceiverAppID = "46B46220"
    let kDebugLoggingEnabled = true
    var FirebaseForegroundBool : Bool!
    var isHome: Bool = false
    //    var ref = FIRDatabase.database().reference()
    var ref = FIRDatabaseQuery()
    var videoList : [videosResult] = []
    weak var delegate:shortCutDelegate?
    var selectedIndex:Int?
    var kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
    let kDebugLoggingEnable = true
    var orientationLock = UIInterfaceOrientationMask.all
    var fcToken: String?
    var castControlBarsEnabled: Bool {
        set(enabled) {
            if let castContainerVC = self.window?.rootViewController as? GCKUICastContainerViewController {
                castContainerVC.miniMediaControlsItemEnabled = enabled
            } else {
                print("GCKUICastContainerViewController is not correctly configured")
            }
        }
        get {
            if let castContainerVC = self.window?.rootViewController as? GCKUICastContainerViewController {
                return castContainerVC.miniMediaControlsItemEnabled
            } else {
                print("GCKUICastContainerViewController is not correctly configured")
                return false
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.isStatusBarHidden = false
        
        MusicPlayerManager.shared.playAudioBackground()
        
        FIRApp.configure()
        Fabric.sharedSDK().debug = true
        Crashlytics.sharedInstance().debugMode = true
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })

            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
        }
        application.registerForRemoteNotifications()
        IQKeyboardManager.shared.enable = false
        tokenRefreshNotification()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        application.beginReceivingRemoteControlEvents()
        let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        GCKCastContext.setSharedInstanceWith(options)
        GCKLogger.sharedInstance().delegate = self
        Thread.sleep(forTimeInterval: 2)
        // Enable logger.
//        GCKLogger.sharedInstance().delegate = self
        
        
        func logMessage(_ message: String,
                        at level: GCKLoggerLevel,
                        fromFunction function: String,
                        location: String) {
          if (kDebugLoggingEnabled) {
            print(function + " - " + message)
          }
        }
        self.CallAPI([:],url:APIManager.sharedInstance.get_version )
        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let splashvc = splashviewcontroller()
                        self.window?.rootViewController = splashvc
                        self.window?.makeKeyAndVisible()
    //    UIViewController().navigatToHomeScreen()
        UIApplication.shared.statusBarStyle = .default
        //        if let status = TBSharedPreference.sharedIntance.getLoginStatue() {
        //            if status {
        //                UIViewController().navigatToHomeScreen()
        //            }
        //
        //            UIApplication.shared.statusBarStyle = .default
        //        }
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let error as NSError
        {
            print(error)
        }
        
        return true
    }
   
    func application(_ application: UIApplication,
         performActionFor shortcutItem: UIApplicationShortcutItem,
         completionHandler: (Bool) -> Void) {

        completionHandler(handleShortcut(shortcutItem: shortcutItem))
    }
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
       // let shortcutType = shortcutItem.type
       
        if shortcutItem.localizedTitle == "Live TV"{
            delegate?.shortCutIndex(index: 1)
            self.selectedIndex = 1
            return true
        }else if shortcutItem.localizedTitle == "Bhajan"{
            delegate?.shortCutIndex(index: 2)
            self.selectedIndex = 2
            return true
        }else if shortcutItem.localizedTitle == "News"{
            delegate?.shortCutIndex(index: 3)
            self.selectedIndex = 3
        }
        return false
    }
    
   @objc func selectedShortCutIndex(){
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL{
            print("Incoming URL is \(incomingURL)")

        }
        guard let url = userActivity.webpageURL else {return false}
        print("url:::",url.absoluteString)

        var param : Parameters
        print(url)

        if let key = url.absoluteString.split(separator: "?").last.map(String.init) {
            // Check if the split result is not nil
            print(key)
            key_id = key

            if key.contains("id=") {
                // Extracting the value after "id="
                if let range = key.range(of: "id=") {
                    let value = key[range.upperBound...]
                    print("Extracted value:", value) // Print the extracted value
                    UserDefaults.standard.set(String(value), forKey: "shortdataKey")
                } else {
                    print("Invalid key format")
                }
            } else if key.count == 8 {
                
                UserDefaults.standard.set(key_id, forKey: "keyAccess")
            } else if key.count == 1 {
                UserDefaults.standard.set(key_id, forKey: "holidataKey")
            } else {
                print("Invalid key length")
            }

            UserDefaults.standard.synchronize()

            print(UserDefaults.standard.object(forKey: "shortdataKey"))
            print(UserDefaults.standard.object(forKey: "keyAccess"))

        } else {
            print("URL components do not have the expected structure")
        }

//        print(url)
//               print(url.absoluteString.components(separatedBy: "="))
//               let key = url.absoluteString.components(separatedBy: "=")
//               print(key[1]) //[1]
//               key_id = key[1]
//               UserDefaults.standard.set(key_id, forKey: "keyAccess")
//                           UserDefaults.standard.synchronize()
//
//               print(UserDefaults.standard.object(forKey: "keyAccess"))
           
              
        param = ["user_id": "163", "media_id":"", "data_type":""]
        
        if url.absoluteString.contains("/video"){
            print("Video:::::::::::")
            
            if let range = url.absoluteString.range(of: "/video/") {
                let media_id = url.absoluteString[range.upperBound...]
                print(media_id)
                universalType = "1"
                param.updateValue(media_id, forKey:"media_id")
                param.updateValue("1", forKey: "data_type")
            }
        }
        
        else if url.absoluteString.contains("/bhajan"){
            print("bhajan:::::::::::")
            if let range = url.absoluteString.range(of: "/bhajan/") {
                let media_id = url.absoluteString[range.upperBound...]
                print(media_id)
                universalType = "2"
                param.updateValue(media_id, forKey:"media_id")
                param.updateValue("2", forKey: "data_type")
            }
            
        }
        else if url.absoluteString.contains("/news"){
            print("news:::::::::::")
            if let range = url.absoluteString.range(of: "/news/") {
                let media_id = url.absoluteString[range.upperBound...]
                print(media_id)
                universalType = "3"
                param.updateValue(media_id, forKey:"media_id")
                param.updateValue("3", forKey: "data_type")
            }
            

        }else if url.absoluteString.contains("/?source=Dishtv&user_id="){
            print("hello")
        }
    
        UserDefaults.standard.setValue(param, forKey: "universalParam")
        UIViewController().navigatToHomeScreen()

        return true
    }
//    //MARK:- UpdateLiveUser
//    func updateLiveUserApi(_ param : Parameters) {
//        self.uplaodData1(APIManager.sharedInstance.KUpdateLiveUsers , param) { (response) in
//
//            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
//            print(response as Any)
//
//            if let JSON = response as? NSDictionary {
//                print(JSON)
//                if JSON.value(forKey: "status") as? Bool == true {
//
//                    UserDefaults.standard.setValue(self.current_channel_id, forKey: "last_channel_id")
//                    let param: Parameters = ["channel_id":self.current_channel_id ?? ""]
//                    self.liveUserCountApi(param)
//
//                }
//                else{
//
//                }
//            }
//            else{
//                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
//            }
//        }
//    }
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        
    }
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        
    }
    

    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (window?.isKind(of: MMLandscapeWindow.self))! {
            return self.orientationLock
        } else {
            return self.orientationLock
        }
//        return self.orientationLock
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else { return }
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
    
    
    func tokenRefreshNotification() {
        let fcmDeviceToken = FIRInstanceID.instanceID().token()
        // TODO: Send token to server
        print(fcmDeviceToken as Any)
        fcToken = fcmDeviceToken
//        deviceTokanStr = fcmDeviceToken ?? ""
//        UserDefaults.standard.setValue(deviceTokanStr, forKey: "device_tokken")
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        FIRInstanceID.instanceID().token() = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        if token.isEmpty{
            UserDefaults.standard.set("123456789", forKey: "device_tokken")
//            idenity.kDeviceToken = token
        }else{
            UserDefaults.standard.set(token, forKey: "device_tokken")
//            idenity.kDeviceToken = token
        }
       
        
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print("device token \(deviceTokenString)")
//        if deviceTokenString.isEmpty == true {
//            print(deviceTokanStr)
//            UserDefaults.standard.setValue(deviceTokanStr, forKey: "device_tokken")
//        }else {
//            deviceTokanStr = deviceTokenString
//            UserDefaults.standard.setValue(deviceTokenString, forKey: "device_tokken")
//        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        deviceTokanString = "1234567890"
//        print("i am not available in simulator \(error)")
//        UserDefaults.standard.setValue("1234567890", forKey: "device_tokken")
        
    }
    
    //Called if unable to register for APNS.
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoInBG"), object: nil)
//        CoverA.instance.removeCurrentLiveUserToOffline()
//        CoverA.instance.removeLiveUserApi()
        //  NotificationCenter.default.post(name: NSNotification.Name(rawValue : "appInBG"), object: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.setValue(true, forKey: "FirebaseForegroundBool")
//        CoverA.instance.firebaseBool = true
//        CoverA.instance.appforegroundAddLiveUser()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //        self.removeLiveUser()
//        CoverA.instance.removeCurrentLiveUserToOffline()
        CoverA.instance.removeLiveUserApi()

        UserDefaults.standard.removeObject(forKey: "notification_type")
        UserDefaults.standard.removeObject(forKey: "SideMneuIndexValue")
        UserDefaults.standard.removeObject(forKey: "channelIndex")
        UserDefaults.standard.removeObject(forKey: "channelName")

//        let last_channel_id = UserDefaults.standard.string(forKey: "last_channel_id")
        UserDefaults.standard.removeObject(forKey: "last_channel_id")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) {
            return true
        }else if ApplicationDelegate.shared.application(app ,  open:url , options:options){
            return true
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge, .alert, .sound])
        //                   let userInfo = notification.request.content.userInfo
        //                   print(userInfo)
        //                   UIApplication.shared.applicationIconBadgeNumber = (userInfo["aps"] as! NSDictionary).value(forKey: "badge") as! Int
        //
        //        print("Handle push from foreground")
        //        // custom code to handle push while app is in the foreground
        //        print("\(notification.request.content.userInfo)")
        //        let dict = (userInfo["aps"] as? NSDictionary)?.value(forKey: "json") as? NSDictionary
        //        if let goLiveAction = dict?.value(forKey: "go_live") as? String {
        //            goLive = goLiveAction
        //              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSideMenu"), object: nil)
        //        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        let userInfo = response.notification.request.content.userInfo
        UIApplication.shared.applicationIconBadgeNumber = (userInfo["aps"] as! NSDictionary).value(forKey: "badge") as! Int
        
        let json = (userInfo["aps"] as? NSDictionary)?.value(forKey: "json") as? NSDictionary
        let title = response.notification.request.content.title
        let notification_type = json!["type"] as? String ?? ""
        
        UserDefaults.standard.set(notification_type, forKey: "notification_type")
        UserDefaults.standard.set(title, forKey: "noteTitle")
        UserDefaults.standard.set("Yes", forKey: "fromPush")
        completionHandler()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name:"CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func CallAPI(_ param : Parameters, url:String){
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, to: APIManager.sharedInstance.KBASEURL+url, method: .get, headers: nil,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                    if let responseData = response.response {
                        switch responseData.statusCode {
                        case APIManager.sharedInstance.KHTTPSUCCESS:
                            guard let result = response.result.value else {
                                return
                            }
                            print(result)
                            
                            let dict = result as? Dictionary<String,Any>
                            let data = dict?["data"] as? Dictionary<String,Any>
                            //                            UserDefaults.standard.setValue("0", forKey: "is_premium_active")
                            is_premium_active = "1"
                            let is_hardUpdate = data!.validatedValue("is_hard_update_ios")
                            UserDefaults.standard.set(data!.validatedValue("aws_sms_ios"), forKey: "sms")
                            let AvailableVersion  = data!.validatedValue("ios")
                            let CurrentVersion = UIApplication.release
                            if is_hardUpdate == "1"{
                                if CurrentVersion < AvailableVersion{
                                    AlertController.alert(title: "Sanskar", message: "Available in a new version , you are using an old version", buttons: ["Not Now","Update"]//buttons: ["Update"] //
                                    ) { (action, index) in
                                        if index != 0{
                                            let urlStr = "itms-apps://itunes.apple.com/app/apple-store/id1497508487?mt=8"
                                            if #available(iOS 10.0, *) {
                                                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                                            } else {
                                                UIApplication.shared.openURL(URL(string: urlStr)!)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        default:
                            break
                        }
                    }
                    
                    if let err = response.result.error as? URLError {
                        if err.code == .notConnectedToInternet{
                            AlertController.alert(title: ALERTS.kNoInterNetConnection)
                        }
                        else if err.code == .timedOut{
                            // AlertController.alert(title: "Connection time out")
                        }else if err.code == .networkConnectionLost{
                            // AlertController.alert(title: "Network Connection Lost")
                        }
                    } else {
                        // AlertController.alert(title: ALERTS.kNoInterNetConnection)
                    }
                }
                
            case .failure(let encodingError):
                DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                // AlertController.alert(title: ALERTS.KSOMETHINGWRONG)
                print("error:\(encodingError)")
            }
        })
        
    }
}


extension AppDelegate: GCKLoggerDelegate {
    
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print("Message from Chromecast = \(message) = \(location)")
        
    }
    
}

extension AVPlayer{
    
    // This works great if the phone call is declined
    func resumeAudioFromInterruption() {
        UserDefaults.standard.removeObject(forKey: "wasInterrupted")
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            print("AVAudioSession is Active")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        //thisFunctionPlaysMyAudio()
    }
    
}

//extension AppDelegate{
//    func removeLiveUser(){
//                firebaseBoolRemove = true
//                var liveUser = 0
//
//                let lastChannel = UserDefaults.standard.string(forKey: "channelName")
//                if lastChannel != "" && lastChannel != nil{
//                    self.ref.child("live_users_channel").child(lastChannel ?? "").observeSingleEvent(of: .value) { (snapshot) in
//
//                        if snapshot.exists(){
//                           print(snapshot)
//
//                            if let snapDict = snapshot.value as? Int {
//                                liveUser = snapDict
//                            print("Remove live data::",liveUser)
//                                liveUser = liveUser - 1
//                                self.ref.child("live_users_channel").child(lastChannel ?? "").setValue((liveUser))
//
//
//                           }
//
//                       }
////                    if self.firebaseBoolRemove == true{
////
//////                                if lastChannel != FirebaseChannel{
////                            print("Live count = \(liveUser) for channgel \(lastChannel ?? "")")
////                        if liveUser > 0{
////
////                            self.liveUser_lbl.text = "\(liveUser)"
////                            liveUser = 0
////                        UserDefaults.standard.removeObject(forKey: "channelName")
////                        self.firebaseBoolRemove = false
////                            self.postRemovalUpdate()
////                    }
//////                            }
////                    }
//                   }
//                } else {
//                }
//
//    }
//}


struct UserModel{
    static var device_tokken : String{
        return UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
    }
}
extension AppDelegate{
    
//    //MARK:- signInApi.
//    func universalLinkApi(_ param : Parameters){
//
//        Alamofire.upload((APIManager.sharedInstance.KUniversalLinkApi, param), to: <#T##URLConvertible#>, method: .post, headers: nil)
//        Alamofire.uplaod(APIManager.sharedInstance.KUniversalLinkApi, param) { response in
//            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
//            print(response as Any)
//            if response != nil {
//                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
//                    if let result = response as? NSDictionary {
//                        print(result)
//
//                    }
//
//                } else {
//                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
//                }
//            }
//        }
//    }
    
    func universalLinkApi(_ param : Parameters, url:String){

        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                print("key::\(key),,value::\(value)")
                print("url::",url)
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, to: APIManager.sharedInstance.KBASEURL+url, method: .post, headers: nil,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                    if let responseData = response.response {
                        switch responseData.statusCode {
                        case APIManager.sharedInstance.KHTTPSUCCESS:
                            guard let result = response.result.value else {
                                return
                            }
                            print(result)

                            switch universalType {
                            case "1":
                                print("Video switch::::")
                                    

                                if let JSON = result as? NSDictionary {
                                    print(JSON)
                                    

                                    let data = JSON["data"] as? NSDictionary
//                                        JSON.ArrayofDict("data")

                                    self.videoList.append(videosResult(dictionary: data!)!)
                                    let post = self.videoList[0]
                                    
                                  

                                    UIViewController().navigatToHomeScreen()
//                                    TBHomeVC.instance.postData = post
                                }
                            case "2":
                                print("Bhajan switch::::")
                            case "3":
                                print("News switch::::")
                            default:
                                break
                            }
                        default:
                            break
                        }
                    }

                    if let err = response.result.error as? URLError {
                        if err.code == .notConnectedToInternet{
                            AlertController.alert(title: ALERTS.kNoInterNetConnection)
                        }
                        else if err.code == .timedOut{
                            // AlertController.alert(title: "Connection time out")
                        }else if err.code == .networkConnectionLost{
                            // AlertController.alert(title: "Network Connection Lost")
                        }
                    } else {
                        // AlertController.alert(title: ALERTS.kNoInterNetConnection)
                    }
                }

            case .failure(let encodingError):
                DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                // AlertController.alert(title: ALERTS.KSOMETHINGWRONG)
                print("error:\(encodingError)")
            }
        })

    }
}









