//
//  TBSideMenuVC.swift
//  Total Bhakti
//  Created by Prashant on 21/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.


import UIKit
var sideMenuType = Int()
class TBSideMenuVC: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var profileEmailLbl: UILabel!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables.
    var sideMenuArray  = [String]()
    var sideMenuImageArray  = [String]()
    var sideMenuActiveArray = [String]()
    var sideMenuData = NSMutableArray()
    var devicetokent = String()
    
    //MARK:- lifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        SlideMenuOptions.contentViewScale = 1
        
        
        NotificationCenter.default.addObserver(self, selector: #selector (updateSideMenuOnConditions), name: NSNotification.Name.init("updateSideMenu"), object: nil)
        
    }
    
    @IBAction func profileActionBtn(_ sender:UIButton){
        
        if currentUser.result?.id != "163"{
            
            slideMenuController()?.closeLeft()
            
            let vc : TBProfileVC = storyboard?.instantiateViewController(withIdentifier: "TBProfileVC") as! TBProfileVC
            vc.isPresent = true
          //  present(vc,animated: true,completion: nil)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            
            slideMenuController()?.closeLeft()
            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
            if sms == "1"{
                let record = UserDefaults.standard.integer(forKey: "recorddata")
                    print(record)

                    if record == 1 {
                    self.dismiss(animated: true) {
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "usersuggestionlogin") as! usersuggestionlogin
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
                else {
                    self.dismiss(animated: true) {
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
            }else{
//                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
            }
            
            
 
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentUser == nil {
            currentUser = User.init(dictionary: TBSharedPreference.sharedIntance.getUserData()!)
        }
        
        if currentUser != nil {
            profileNameLbl.text = "Welcome to sanskar"
            if currentUser.result?.id != "163"{
                if currentUser.result?.username != "" {
                    profileEmailLbl.text = currentUser.result?.username
                }
                else{
                    if currentUser.result?.email != "" {
                        profileEmailLbl.text = currentUser.result?.email
                    }
                    
                    else {
                        profileEmailLbl.text = currentUser.result?.mobile
                    }
                }
                
                
                if let profileUrl = currentUser.result!.profile_picture, profileUrl != ""{
                    profileImage.contentMode = .scaleAspectFill
                    profileImage.sd_setShowActivityIndicatorView(true)
                    profileImage.sd_setIndicatorStyle(.gray)
                    profileImage.sd_setImage(with: URL(string: profileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, placeholderImage: UIImage(named: "Profile_img"), options: .refreshCached, completed: nil)
                    
                } else{
                    
                }
                
                if currentUser.result?.go_live == "1" {
                    goLive = "1"
                }else {
                    goLive = "0"
                }
            }else{
                profileEmailLbl.text = "Enjoy bhajans"
            }
            
            updateSideMenuOnConditions()
        }
    }
    
    @objc func updateSideMenuOnConditions()  {
        if goLive == "1" {
            sideMenuData = NSMutableArray(array: [["name": "Home", "isSelected": false] , ["name": "Videos", "isSelected": false] , ["name": "Guru", "isSelected": false] ,["name": "Bhajan", "isSelected": false] , ["name": "News & Articles", "isSelected": false], ["name": "Go Live", "isSelected": false] , ["name": "My Playlist", "isSelected": false],["name": "My Downloads", "isSelected": false],["name": "Live Pooja", "isSelected": false], ["name": "Terms & Conditions", "isSelected": false] , ["name": "Privacy & Policy", "isSelected": false],["name": "Share", "isSelected": false]])
            sideMenuImageArray  = ["home_inactive","video_inactive","guru_inactive","bhajan_inactive","news_articles_inactive","golive_inactive","my_playlist_inactive","download","live_pooja_inactive","terms_condition_inactive","privacy_policy_inactive","share"]
            sideMenuActiveArray = ["home_active","video_active","guru_active","bhajan_active","news_articles_active","golive_active","my_playlist_active","download_audio","terms_condition_active","privacy_policy_active","share"]
        }else {
            sideMenuData = NSMutableArray(array: [["name": "Home", "isSelected": false] , ["name": "Videos", "isSelected": false] , ["name": "Guru", "isSelected": false] ,["name": "Bhajan", "isSelected": false] , ["name": "News & Articles", "isSelected": false], ["name": "My Playlist", "isSelected": false],["name": "my Downloads", "isSelected": false],["name": "Live Pooja", "isSelected": false],["name": "Terms & Conditions", "isSelected": false],["name": "Privacy & Policy", "isSelected": false],["name": "Share", "isSelected": false]])
            sideMenuImageArray  = ["home_inactive","video_inactive","guru_inactive","bhajan_inactive","news_articles_inactive","my_playlist_inactive","download_audio","live_pooja_inactive","terms_condition_inactive","privacy_policy_inactive","share"]
            sideMenuActiveArray = ["home_active","video_active","guru_active","bhajan_active","news_articles_active","my_playlist_active","download_audio", "terms_condition_active","privacy_policy_active","share"]
        }
        tableView.reloadData()
    }
    
    
    //MARK:- MoveToControllerFromSideMenu.
    func moveToNextScreenScreen(_ indentifier : String)  {
        let vc = storyBoard.instantiateViewController(withIdentifier: indentifier)
        
        
        if vc is TBHomeTabBar{

            let button = UIButton()
            button.tag = sideMenuType
            TBHomeTabBar.currentInstance?.TabBarActionButton(button)
            slideMenuController()?.closeLeft()
            vc.navigationController?.popViewController(animated: true)
           
        }else{
            
            (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
            slideMenuController()?.closeLeft()
        }
        return
        
//        if let nav = self.slideMenuController()?.navigationController {
//            
//            var didGet: Bool = false
//            
//            for controller in nav.viewControllers
//            {
//                if controller is TBHomeTabBar //&& vc is TBHomeTabBar
//                {
//                    
//                    if vc is TBbhajanListVC{
//                        didGet = true
//                        let button = UIButton()
//                        button.tag = sideMenuType
//                        (controller as! TBHomeTabBar).TabBarActionButton(button)
//                        nav.popToViewController(controller, animated: true)
//                    }else{
//                        (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
//                    }
////                    didGet = true
////                    let button = UIButton()
////                    button.tag = sideMenuType
////                    (controller as! TBHomeTabBar).TabBarActionButton(button)
////                    nav.popToViewController(controller, animated: true)
//                }
//            }
//            if let home = vc as? TBHomeTabBar {
//                if !didGet
//                {
//                    home.selectedIndex = sideMenuType
//                }
//            }
//            
//            if !didGet
//            {
//                (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
//                
//            }
//            
//            slideMenuController()?.closeLeft()
//        }
    }
    
    //MARK:- LogoutApi.
    func logoutApi() {
        
        var UDID = ""
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            UDID = uid
        }
        
        let device_id = UserDefaults.standard.string(forKey: "device_id")

        let param : Parameters = ["user_id" : currentUser.result?.id ?? "", "device_id": "\(device_id ?? "")"]

            
            self.uplaodData(APIManager.sharedInstance.KLOGOUTAPI, param, { response in
                DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                if let response = response as? NSDictionary {
    //                currentUser = User.init(dictionary: result)
    //                if currentUser.status! {
    //                       TBSharedPreference.sharedIntance.setUserData(currentUser)

                    if response.value(forKey: "status") as? Bool == true {
                        
                        self.devicetokent = UserDefaults.standard.value(forKey: "device_tokken") as! String
                        TBSharedPreference.sharedIntance.clearAllPreference()
                        
                        UserDefaults.standard.setValue(device_id, forKey: "device_id")

                        let vc = storyBoard.instantiateViewController(withIdentifier: "Loginviewcontroller") as! Loginviewcontroller
                        vc.devicetokennew = self.devicetokent
                       self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)

                    }
                }
            })
        }
}

//MARK:- UITableView DataSource Methods.
extension TBSideMenuVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuActiveArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sideMenuActiveArray.count == indexPath.row{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let notification_status = UserDefaults.standard.value(forKey: "notification_status") as? String ?? "0"
            
            
            let switchControl =  cell.contentView.viewWithTag(77) as? UISwitch
            switchControl?.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
            
            
            if notification_status == "0"{
                switchControl?.isOn = true
            }else{
                switchControl?.isOn = false
            }
            
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath)
        let dataToShow = sideMenuData[indexPath.row] as! NSDictionary
        let sideMenuImageView = cell.viewWithTag(100) as! UIImageView
        let sideMenuNameLbl = cell.viewWithTag(200) as! UILabel
        sideMenuNameLbl.text = dataToShow.value(forKey: "name") as? String
        if (dataToShow.value(forKey: "isSelected") as! Bool) {
            sideMenuImageView.image = UIImage(named : sideMenuActiveArray[indexPath.row])
            sideMenuNameLbl.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 1.0)
        } else {
            sideMenuImageView.image = UIImage(named: sideMenuImageArray[indexPath.row] )
            sideMenuNameLbl.textColor = UIColor.black
        }
        
        let index = UserDefaults.standard.value(forKey: "SideMneuIndexValue") as? Int ?? 0
        if indexPath.row == index{
            sideMenuImageView.image = UIImage(named : sideMenuActiveArray[indexPath.row])!.withRenderingMode(.alwaysTemplate)
            sideMenuNameLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            sideMenuImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if indexPath.row == sideMenuImageArray.count-1{
            sideMenuImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    @objc func didTapSwitch(_ sender:UISwitch){
        print("hello")
      
        if currentUser.result?.id != "163"{
            MuteNotificationApi()
        }
    }
    
    
}

//MARK:- UITableView Delegate Methods.
extension TBSideMenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == sideMenuActiveArray.count{
            return
        }
        
        UserDefaults.standard.setValue(indexPath.row, forKey: "SideMneuIndexValue")
        
        if indexPath.row == sideMenuActiveArray.count-1{
            termsAndCondition = 2
            moveToNextScreenScreen(CONTROLLERNAMES.KTERMSANDCONDITIONVC)
           
            
        }else{
            
            let cell = tableView.cellForRow(at: indexPath)!
            let sideMenuImageView = cell.viewWithTag(100) as! UIImageView
            let sideMenuNameLbl = cell.viewWithTag(200) as! UILabel
            let dataToShow = sideMenuData[indexPath.row] as! NSDictionary
            let status = dataToShow.value(forKey: "isSelected") as! Bool
            let dict = NSMutableDictionary()
            dict.addEntries(from: dataToShow as! [AnyHashable : Any])
            
            if !status {
                sideMenuImageView.image = UIImage(named : sideMenuActiveArray[indexPath.row])
                sideMenuNameLbl.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 1.0)
                dict.setValue(true, forKey: "isSelected")
                
            }
            
            sideMenuData.replaceObject(at: indexPath.row, with: dict)
            for index in 0..<sideMenuData.count {
                if index != indexPath.row {
                    let actualDict = sideMenuData[index] as! NSDictionary
                    if (actualDict.value(forKey: "isSelected") as! Bool) {
                        let temp = NSMutableDictionary()
                        temp.addEntries(from: actualDict as! [AnyHashable : Any])
                        temp.setValue(false, forKey: "isSelected")
                        sideMenuData.replaceObject(at: index, with: temp)
                        tableView.reloadData()
                    }
                }
            }
            if status == false {
                if goLive == "1" {
                    switch indexPath.row {
                    case 0://home
                        sideMenuType = 0
                        moveToNextScreenScreen(CONTROLLERNAMES.KTABBARVC)
                    case 1://videos
                        sideMenuType = 1
                        NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
                        moveToNextScreenScreen(CONTROLLERNAMES.KTABBARVC)
                    case 2://Guru
                        sideMenuType = 4
                        bhajanPage = 2
                        moveToNextScreenScreen(CONTROLLERNAMES.KTABBARVC)
                    case 3://bhajan
                        sideMenuType = 3
                        moveToNextScreenScreen(CONTROLLERNAMES.KTABBARVC)
                    case 4://news
                        // sideMenuType = 4
                        moveToNextScreenScreen(CONTROLLERNAMES.KNEWSVC)
                    case 5://goLive
                        moveToNextScreenScreen(CONTROLLERNAMES.KGOLIVEVC)
                    case 6://MyPlaylist
                        moveToNextScreenScreen(CONTROLLERNAMES.KMYPLAYLISTVC)
                    case 7://termsAndCondition
                        termsAndCondition = 1
                        moveToNextScreenScreen(CONTROLLERNAMES.KTERMSANDCONDITIONVC)
                    case 8://PrivateAndPolicy
                        termsAndCondition = 2
                        moveToNextScreenScreen(CONTROLLERNAMES.KTERMSANDCONDITIONVC)
                    case 9:
                        let alert =  UIAlertController(title: appName, message: ALERTS.KLogout, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: ALERTS.kAlertYes, style: .default, handler: { (action: UIAlertAction!) in
                             
                            DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                            self.logoutApi()
                        }))
                        alert.addAction(UIAlertAction(title: ALERTS.kAlertNo, style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                    default:
                        break
                    }
                }else {
                    switch indexPath.row {
                    case 0://home
                        sideMenuType = 0
                        moveToNextScreenScreen(CONTROLLERNAMES.KTABBARVC)
                    case 1://video
                        sideMenuType = 1
                        NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
                        
                        moveToNextScreenScreen(CONTROLLERNAMES.KTABBARVC)
                    case 2://Guru
                        bhajanPage = 2
                        moveToNextScreenScreen(CONTROLLERNAMES.KGRURVC)
                    case 3://bhajan
                        sideMenuType = 3
                        moveToNextScreenScreen(CONTROLLERNAMES.KBHAJANVC)
                    case 4://news
                        sideMenuType = 4
                        moveToNextScreenScreen(CONTROLLERNAMES.KTABBARVC)
                    case 5://MyPlaylist
                        moveToNextScreenScreen(CONTROLLERNAMES.KMYPLAYLISTVC)
                    case 6://My Downloads
                        moveToNextScreenScreen(CONTROLLERNAMES.KMYDOWNLOADS)
                    case 7://Live pooja
                        moveToNextScreenScreen(CONTROLLERNAMES.KLIVEPOOJA)
                    case 8: //termsAndCondition
                        termsAndCondition = 1
                        moveToNextScreenScreen(CONTROLLERNAMES.KTERMSANDCONDITIONVC)
                    case 9://PrivateAndPolicy
                        termsAndCondition = 2
                        moveToNextScreenScreen(CONTROLLERNAMES.KTERMSANDCONDITIONVC)
                    case 10:
                        let alert =  UIAlertController(title: appName, message: ALERTS.KLogout, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: ALERTS.kAlertYes, style: .default, handler: { (action: UIAlertAction!) in

                            DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                            self.logoutApi()
                        }))
                        alert.addAction(UIAlertAction(title: ALERTS.kAlertNo, style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                    default:
                        break
                    }
                }
            }else {
                slideMenuController()?.closeLeft()
                
            }
            
        }
    }
    
}

extension TBSideMenuVC{
    //MARK:- call Api.
    func MuteNotificationApi(){
        
        
        var notification_status = UserDefaults.standard.value(forKey: "notification_status") as? String ?? "0"
        
        if notification_status == "0"{
            notification_status = "1"
        }else{
            notification_status = "0"
        }
       
        let param : Parameters = ["user_id" : currentUser.result!.id!,"notification_status":notification_status]
        self.uplaodData(APIManager.sharedInstance.notification_mute, param) { (response) in
            
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    let data = JSON["data"] as? NSDictionary
                    
                    let notification_status = "\(data!["notification_status"]!)"
                    UserDefaults.standard.setValue(notification_status, forKey: "notification_status")
                    
                    self.tableView.reloadData()
                   
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}
extension TBSideMenuVC : SlideMenuControllerDelegate {

func leftWillOpen() {
// print("SlideMenuControllerDelegate: leftWillOpen")
}
func leftDidOpen() {
//print("SlideMenuControllerDelegate: leftDidOpen")
}
func leftWillClose() {
//print("SlideMenuControllerDelegate: leftWillClose")

}
func leftDidClose() {
// print("SlideMenuControllerDelegate: leftDidClose")

}

func rightWillOpen() {
// print("SlideMenuControllerDelegate: rightWillOpen")
}
func rightDidOpen() {
//print("SlideMenuControllerDelegate: rightDidOpen")
}
func rightWillClose() {
//print("SlideMenuControllerDelegate: rightWillClose")
}
func rightDidClose() {
//print("SlideMenuControllerDelegate: rightDidClose")
}
}
