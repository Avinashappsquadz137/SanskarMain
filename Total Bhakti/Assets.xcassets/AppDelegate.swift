
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
//import IQKeyboardManagerSwift
import Alamofire

let kPrefPreloadTime = "preload_time_sec"


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {
    var vlcScreenRotate = false
    var window: UIWindow?
    
    let kReceiverAppID = "46B46220"
    let kDebugLoggingEnabled = true
    
    var isHome: Bool = false
    
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
        
//        IQKeyboardManager.shared.enable = true
        CallAPI([:],url:APIManager.sharedInstance.get_version )
        
        
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
            
        }
        
        
        MusicPlayerManager.shared.playAudioBackground()
        
        FIRApp.configure()
        Fabric.sharedSDK().debug = true
        Crashlytics.sharedInstance().debugMode = true
        
        
//        IQKeyboardManager.shared.enable = false
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        application.beginReceivingRemoteControlEvents()
        let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        GCKCastContext.setSharedInstanceWith(options)
        // Enable logger.
        GCKLogger.sharedInstance().delegate = self
        
        registerForPushNotifications()
        
        
        if let status = TBSharedPreference.sharedIntance.getLoginStatue() {
            if status {
                UIViewController().navigatToHomeScreen()
            }
            
            UIApplication.shared.statusBarStyle = .default
        }
        
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
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (window?.isKind(of: MMLandscapeWindow.self))! {
            return .portrait
        } else {
            return .portrait
        }
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
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        if deviceTokenString.isEmpty == true {
            deviceTokanString = "12345"
            UserDefaults.standard.setValue("1234567890", forKey: "device_tokken")
        }else {
            deviceTokanString = deviceTokenString
            UserDefaults.standard.setValue(deviceTokenString, forKey: "device_tokken")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        deviceTokanString = "1234567890"
        print("i am not available in simulator \(error)")
        UserDefaults.standard.setValue("1234567890", forKey: "device_tokken")
        
    }
    
    //Called if unable to register for APNS.
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoInBG"), object: nil)
        //  NotificationCenter.default.post(name: NSNotification.Name(rawValue : "appInBG"), object: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        UserDefaults.standard.removeObject(forKey: "notification_type")
        UserDefaults.standard.removeObject(forKey: "SideMneuIndexValue")
        UserDefaults.standard.removeObject(forKey: "channelIndex") 
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) {
            return true
        }else if SDKApplicationDelegate.shared.application(app ,  open:url , options:options){
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
        
        let notification_type = json!["type"] as? String ?? ""
        
        UserDefaults.standard.set(notification_type, forKey: "notification_type")
        
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
                            
                            let is_hardUpdate = data!.validatedValue("is_hard_update_ios")
                            let AvailableVersion  = data!.validatedValue("ios")
                            let CurrentVersion = Bundle.main.appVersionShort ?? ""
                            if is_hardUpdate == "1"{
                                if CurrentVersion != AvailableVersion{
                                    AlertController.alert(title: "Sanskar", message: "Available in a new version , you are using an old version", buttons: ["Not Now","Update"]) { (action, index) in
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




struct UserModel{
    static var device_tokken : String{
        return UserDefaults.standard.value(forKey: "device_tokken") as? String ?? "1234567890"
    }
}










