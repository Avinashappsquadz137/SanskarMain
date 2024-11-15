//
//  TBGuruDetailVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 15/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import ExpandableLabel

protocol TBGuruDetailVCDelegates {
    func updateValue(_ data : guruData )
}

class TBGuruDetailVC: TBInternetViewController {
    
    //MARK:-IBOutlets.
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var guruFollowMainView: UIView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var numberOfViewLbl: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var numberOfLikeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControlslider: UIPageControl!
    @IBOutlet weak var relatedVideoAudioView: UIView!
    @IBOutlet weak var relatedVideosBtn: UIButton!
    @IBOutlet weak var relatedAudiosBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var imagesBtn: UIButton!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var notifCountLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHolder: UIView!
    @IBOutlet weak var searchBTn: UIButton!
    @IBOutlet weak var  qrcode: UIButton!
    
    @IBOutlet weak var selectorView: gredientView!
    var pdfNameFromUrl = String()

    @IBOutlet weak var imageSectionBanner: NSLayoutConstraint!
    var imgUrlArray = [String]()
    //MARK:-variables.
    var previoueData : guruData!
    var isFav = ""
    var isLike = ""
    var likeBtnClicked = 0
    var totalLikes = Int()
    var textString = String()
    var relatedVideos = [videosResult]()
    var clickOnBtn = Int()
    var relatedAudios = [Bhajan]()
    var delegate : TBGuruDetailVCDelegates!
    var follersCount = String()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var isLoadingList : Bool = false
    var page_no = 1
    var Timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    var lastVideoId = String()
    var index = 0
    var menuMasterId = ""
    var authername = ""
//MARK:-lifeCycleMethods.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         let param : Parameters = ["user_id": currentUser.result!.id! , "guru_id" : previoueData.id!]
         page_no:1
         limit:10
         */
        let param : Parameters = ["user_id": currentUser.result!.id! , "guru_id" : previoueData.id!,  "page_no":"1", "limit":"40"]
//        let param : Parameters = ["user_id": "13256" , "guru_id" : "11",  "page_no":"1", "limit":"10"]

        imgThumbnailApi(param)
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        
        
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0
        
        
        setDataOnScreen()
        clickOnBtn = 0
        
        relatedVideosHit()
        relatedAudioHit()
        searchBarHolder.isHidden = true
        searchBarHolder.backgroundColor = .clear

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if qrStatus == "0"{
            if #available(iOS 13.0, *) {
                qrcode.setImage(UIImage(systemName: ""), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            //searchBTn.isHidden = true
        }else{
            //searchBTn.isHidden = false
            
        }
        
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        
        if avPlayer != nil
        {
            if avPlayer.timeControlStatus == .playing  {
                avPlayer.pause()
            }
        }
    }
  
    
    //MARK:- Topbar Button action.
   
    @IBAction func logoBtnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
  
    @IBAction func shareBtnAction (_ sender : UIButton) {
        let text = "https://sanskargroup.page.link/"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func notificationBtnAction (_ sender : UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuBtnAction (_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func barCodeBtnprssed(_ sender: UIButton){
        if qrStatus == "1"{
            if currentUser.result!.id! == "163"{
                let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                if sms == "1"{
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
                }else{
//                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannerControl") as! ScannerControl
                navigationController?.pushViewController(vc, animated: true)
            }

        }else{
            if sender.isTouchInside {
                searchBarHolder.isHidden = false
                searchBarHolder.backgroundColor = .white
            }
        }

        
    }
    
    @IBAction func searchBtnpressed(_ sender: UIButton){
        searchBarHolder.isHidden = false
        searchBarHolder.backgroundColor = .white
        
    }
    
    @IBAction func searchCancelBtn(_ sender: UIButton){
        
        searchBarHolder.isHidden = true
        searchBarHolder.backgroundColor = .clear
    }
    
    
    
    
    //MARK:- ScrollViewDelegte For PageControl Current Page.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            pageControlslider.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            
            if self.relatedVideos.count == 0 || self.relatedVideos.count < 10{
                return
            }
            
            self.tableView.tableFooterView?.isHidden = false
            self.isLoadingList = true
            spinner.startAnimating()
            
            let lastVideo = relatedVideos[relatedVideos.count-1]
            let lastVideoId = lastVideo.id
            self.lastVideoId = lastVideoId ?? (previoueData.id ?? "")
            page_no += 1
            let param : Parameters
            param  = ["user_id": currentUser.result?.id ?? "" ,"video_id" : post?.id ?? "","limit":"10", "page_no":"\(page_no)"]
            relatedVideosHit()

            //            if lastVideo.category != nil{
//            param  = ["user_id": currentUser.result?.id ?? "" ,"search_content" : "", "last_video_id" : lastVideoId ?? "" , "video_category" : lastVideo.category ?? "","limit":"10"]
            //            }
            //            else{
            //                param  = ["user_id": currentUser.result?.id ?? "" ,"search_content" : "", "last_video_id" : lastVideoId ?? "" , "video_category" : "","limit":"10"]
            //
            //            }
            
//            getVideosApi(param)
        }
    }
    
    func gradientOnBtn(_ button : UIButton)  {
        let layer = gradientBackground()
        layer.frame = headerView.bounds
        button.clipsToBounds = true
        button.layer.insertSublayer(layer, at: 0)
    }
    
    func borderForView(_ view : UIView)  {
        view.layer.cornerRadius = 17.0
        //  view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
    }
    
    //MARK:- ScreenBtn action.
    @IBAction func screenBtnAction (_ sender : UIButton) {
        switch sender.tag {
        case 10:
            self.delegate.updateValue(previoueData)
            _ = navigationController?.popViewController(animated: true)
        case 20: //Follow
            if currentUser.result!.id! == "163"{
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
//                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }else{
                if  isFav == "0" {
                    followGuruApi(APIManager.sharedInstance.KFOLLOWGURU)
                }else {
                    followGuruApi(APIManager.sharedInstance.KUNFOLLWGURUR)
                }
            }
        case 30://Share
            shareData()
        case 40://like
            
            if currentUser.result!.id! == "163"{
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
//                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }else{
                likeBtnClicked = 1
                if isLike == "0" {
                    followGuruApi(APIManager.sharedInstance.KLIKEGURU)
                }else {
                    followGuruApi(APIManager.sharedInstance.KUNLIKEGURU)
                }
            }
        case 50://relatedVideos
            clickOnBtn = 0
            selectorView.frame.origin.x = sender.frame.origin.x
            
            if relatedVideos.count != 0 {
                self.noDataFoundLbl.isHidden = true
            }else {
                self.noDataFoundLbl.isHidden = false
            }
            self.tableView.reloadData()
            
            relatedAudiosBtn.setTitleColor(UIColor.black, for: .normal)
            aboutBtn.setTitleColor(UIColor.black, for: .normal)
            imagesBtn.setTitleColor(UIColor.black, for: .normal)
            sender.setTitleColor(UIColor.white, for: .normal)
            
        case 60 ://relatedAudios
            
            clickOnBtn = 1
            
            selectorView.frame.origin.x = sender.frame.origin.x
            
            if relatedAudios.count != 0 {
                self.noDataFoundLbl.isHidden = true
            }else {
                self.noDataFoundLbl.isHidden = false
            }
            self.tableView.reloadData()
            
            relatedVideosBtn.setTitleColor(UIColor.black, for: .normal)
            aboutBtn.setTitleColor(UIColor.black, for: .normal)
            imagesBtn.setTitleColor(UIColor.black, for: .normal)
            sender.setTitleColor(UIColor.white, for: .normal)
            
        case 33://About
            
            self.noDataFoundLbl.isHidden = true
            clickOnBtn = 2
            selectorView.frame.origin.x = sender.frame.origin.x
            relatedVideosBtn.setTitleColor(UIColor.black, for: .normal)
            relatedAudiosBtn.setTitleColor(UIColor.black, for: .normal)
            imagesBtn.setTitleColor(UIColor.black, for: .normal)
            sender.setTitleColor(UIColor.white, for: .normal)
            self.tableView.reloadData()
            
        case 34://images
            
            self.noDataFoundLbl.isHidden = false
            clickOnBtn = 3
            selectorView.frame.origin.x = sender.frame.origin.x
            relatedVideosBtn.setTitleColor(UIColor.black, for: .normal)
            relatedAudiosBtn.setTitleColor(UIColor.black, for: .normal)
            aboutBtn.setTitleColor(UIColor.black, for: .normal)
            sender.setTitleColor(UIColor.white, for: .normal)
            self.tableView.reloadData()
            
        default:
            break
        }
    }
    
    //MARK:- relatedAudio Api.
    func relatedAudioHit()  {
        let param : Parameters = ["user_id": currentUser.result!.id! ,"guru_id": previoueData.id!, "limit": "40", "page_no": "1"]
        self.uplaodData(APIManager.sharedInstance.KGURURELETEDAUDIOAPI,param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                 print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        self.relatedAudios = Bhajan.modelsFromDictionaryArray(array: result)
                        self.tableView.reloadData()
                    }
                }else {
                }
            }else {
            }
        }
    }
    
    //MARK:- relatedVideos Api.
    func relatedVideosHit() {
        //let id = self.page_no > 1 ? self.lastVideoId : previoueData.id!
        let param : Parameters = ["user_id": currentUser.result!.id! ,"guru_id": previoueData.id!, "limit": "10", "page_no": "\(page_no)","device_type":"2","current_version": "\(UIApplication.release)"]
        self.uplaodData(APIManager.sharedInstance.KRELATEDVIDEOGURUAPI,param) { [self] (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                self.spinner.stopAnimating()
                
                if JSON.value(forKey: "status") as? Bool == true {
                    self.isLoadingList = false
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        self.relatedVideos = self.relatedVideos + videosResult.modelsFromDictionaryArray(array: result)
                        self.tableView.reloadData()
                    }
                    if self.relatedVideos.count == 0 {
                        self.tableView.isHidden = true
                        self.noDataFoundLbl.isHidden = false
                    }else {
                        self.tableView.isHidden = false
                        self.noDataFoundLbl.isHidden = true
                    }
                    
                }else {
                    //  self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
                //  self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    func preparedSources() -> [(text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment)] {
        return [((previoueData.description?.html2String)!, .word, 4, .justified)]
    }
    
    
    //MARK:- setDataOnScreen.
    func setDataOnScreen() {
        pageControlslider.numberOfPages = 1
        headerLbl.text = previoueData.name
 
        if previoueData.followers_count == "0" {
            numberOfViewLbl.text = "No follower"
        }else if previoueData.followers_count == "1"{
            numberOfViewLbl.text = "1 follower"
        }else {
            numberOfViewLbl.text = "\(String(describing: previoueData.followers_count!)) followers"
        }
        
        if previoueData.likes_count == "0" {
            numberOfLikeLbl.text = "No like"
        }else if previoueData.followers_count == "1"{
            numberOfLikeLbl.text = "1 like"
        }else {
            numberOfLikeLbl.text = "\(String(describing: previoueData.likes_count!)) likes"
        }
        
        if previoueData.is_like == "1" {
            likeImageView.image = UIImage(named: "like_active-1")
        }else{
            likeImageView.image = UIImage(named: "like_gray")
        }
        if previoueData.is_follow == "1" {
            self.followBtn.setTitle(" Unfollow", for: .normal)
        }else {
            self.followBtn.setTitle(" Follow", for: .normal)
            
        }
        totalLikes = Int(previoueData.likes_count!)!
        isFav = previoueData.is_follow ?? ""
        isLike = previoueData.is_like ?? ""
        
    }
    
    /*
     let param : Parameters = ["user_id": currentUser.result!.id! , "guru_id" : previoueData.id!]
     page_no:1
     limit:10
     
     (lldb) po print(((JSON["data"] as! NSArray)[0]as! NSDictionary)["image"] as! String)
     https://bhaktiappproduction.s3.ap-south-1.amazonaws.com/guru_thumbnails/17077min-1613028857image_7.jpg
     0 elements

     */
    
    //MARK:- Api Method.
    func imgThumbnailApi(_ param : Parameters){
        //        if  self.searchClicked == true {
        //            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        //        }
        
        /*key:::guru_id,value:::::87
        key:::user_id,value:::::21714
        key:::page_no,value:::::1
        key:::limit,value:::::10*/
        print("params:::\(param)")
        self.uplaodData1(APIManager.sharedInstance.KImgThumbnailAPI, param) { [self] (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Int == 1 {
//                    self.tableView.reloadData()
                    
                    if (JSON["data"] as! NSArray).count > 0{
                        for i in 0...(JSON["data"] as! NSArray).count-1{
                        
                        print("i:::::::",i)
                        
                        print((((JSON["data"] as! NSArray)[i]as! NSDictionary)["image"] as! String))
                        let imgURl = ((JSON["data"] as! NSArray)[i]as! NSDictionary)["image"] as! String
                        
                    
                        self.imgUrlArray.append(imgURl)
                    }
                    print("imgUrlArray:::",imgUrlArray)

}
                }else {
                    
                    
//                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
                
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    //MARK:- followHit.
    func followGuruApi(_ apiName : String) {
        let param : Parameters = ["user_id": currentUser.result!.id! , "guru_id" : previoueData.id!]
        self.uplaodData(apiName, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    //  self.addAlert(appName, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    if self.likeBtnClicked == 1 {
                        
                        if  JSON.value(forKey: "message") as? String == "User Liked." {
                            self.likeImageView.image = UIImage(named: "like_active-1")
                            
                            if self.totalLikes + 1 == 1 {
                                self.numberOfLikeLbl.text = "1 like"
                            }else {
                                self.numberOfLikeLbl.text = "\(self.totalLikes + 1) likes"
                            }
                            self.totalLikes = self.totalLikes + 1
                            self.isLike = "1"
                            
                        }else {
                            self.likeImageView.image = UIImage(named: "like_gray")
                            
                            if self.totalLikes - 1 == 0{
                                self.numberOfLikeLbl.text = "No like"
                            } else if self.totalLikes - 1 == 1 {
                                self.numberOfLikeLbl.text = "1 like"
                            }else {
                                self.numberOfLikeLbl.text = "\(self.totalLikes - 1) likes"
                            }
                            self.totalLikes = self.totalLikes - 1
                            self.isLike = "0"
                        }
                        self.previoueData.is_like = self.isLike
                        self.previoueData.likes_count = NSString(string : "\(self.totalLikes)") as String
                        self.likeBtnClicked = 0
                    }else {
                        if JSON.value(forKey: "message") as? String == "User Followed." {
                            self.followBtn.setTitle(" Unfollow", for: .normal)
                            self.isFav = "1"
                            
                            
                            if Int(self.previoueData.followers_count!)!+1 == 1 {
                                self.numberOfViewLbl.text = "1 follower"
                            }else {
                                self.numberOfViewLbl.text = "\(Int(self.previoueData.followers_count!)!+1) followers"
                            }
                            self.follersCount = "\(Int(self.previoueData.followers_count!)!+1)"
                        }else {
                            self.followBtn.setTitle(" Follow", for: .normal)
                            self.isFav = "0"
                            if Int(self.previoueData.followers_count!)!-1 == 0 {
                                self.numberOfViewLbl.text = "No follower"
                            } else if Int(self.previoueData.followers_count!)!-1 == 1 {
                                self.numberOfViewLbl.text = "1 follower"
                            }else {
                                self.numberOfViewLbl.text = "\(Int(self.previoueData.followers_count!)!-1) followers"
                            }
                            
                            self.follersCount = "\(Int(self.previoueData.followers_count!)!-1)"
                        }
                        self.previoueData.followers_count = self.follersCount
                        self.previoueData.is_follow = self.isFav
                        
                    }
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
        
    }
    
    
    func shareData(){
        
        let text = "https://apps.apple.com/in/app/sanskar-tv-app/id1497508487 \n https://play.google.com/store/apps/details?id=com.sanskar.tv"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
        return
        
        
        var image = UIImage()
        let textToShare = NSMutableArray(array: [previoueData.name!,previoueData.description!.html2String])
        if let imageUrl = previoueData.profile_image {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: (url)!)
            guard data != nil else{
                Toast.show(message: "Not Available", controller: self)
                return
            }
            image = (UIImage(data: data!))!
            textToShare.add(image)
            let activityControler  = UIActivityViewController(activityItems: textToShare as! [Any], applicationActivities: nil)
            activityControler.popoverPresentationController?.sourceView = self.view //so that iPads won't crash
            // exclude some activity types from the list (optional)
            activityControler.excludedActivityTypes = [ UIActivityType.airDrop ,UIActivityType.postToFacebook , UIActivityType.mail, UIActivityType.message , UIActivityType.postToTwitter]
            self.present(activityControler, animated: true, completion: nil)
        }else  {
            let activityControler  = UIActivityViewController(activityItems: textToShare as! [Any], applicationActivities: nil)
            activityControler.popoverPresentationController?.sourceView = self.view //so that iPads won't crash
            // exclude some activity types from the list (optional)
            activityControler.excludedActivityTypes = [ UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo ]
            self.present(activityControler, animated: true, completion: nil)
        }
    }
    
}

//MARK:- UICollection View DataSource.
extension TBGuruDetailVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL, for: indexPath)
        let guruImageView = cell.viewWithTag(100) as! UIImageView
        if let urlString = previoueData.banner_image {
            guruImageView.sd_setShowActivityIndicatorView(true)
            guruImageView.sd_setIndicatorStyle(.gray)
            guruImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        return cell
    }
    
}

//MARK:- UITbale View dataSource.
extension TBGuruDetailVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clickOnBtn == 0 {
            return relatedVideos.count
        }else if clickOnBtn == 1{
            return relatedAudios.count
        }else if clickOnBtn == 2{
            return 1
        }else if clickOnBtn == 3{
            return imgUrlArray.count
        }
        else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if clickOnBtn == 1 || clickOnBtn == 0{
            return 135
        }
        else if clickOnBtn == 3{
            return 200
        }
        else{
          return UITableViewAutomaticDimension
        }
         
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL)! as! TBGuruDetailCell
        
        let imageVeiw = cell.imageVeiw
        let imageVeiw2 = cell.imageVeiw2
        let nameLbl = cell.nameLbl
        let descriptionLbl = cell.descriptionLbl
        let dateLbl = cell.dateLbl
        let mainView = cell.mainView
        let numberOFViews = cell.numberOFViews
        let mp3ImageView = cell.mp3ImageView
        let downloadBtn = cell.downloadBtn
        mainView?.layer.cornerRadius = 5.0
        mainView?.dropShadow()
        imageVeiw?.layer.cornerRadius = 5.0
        imageVeiw2?.layer.cornerRadius = 5.0
        if clickOnBtn == 0 {
            let post = relatedVideos[indexPath.row]
            let authname = post.author_name
            nameLbl?.text = authname
            descriptionLbl?.text = post.video_desc?.html2String
            mp3ImageView?.image = UIImage(named: "play-1")
            if post.views == "0" {
                numberOFViews?.text = "No view"
            }else if post.views == "1" {
                numberOFViews?.text = "\(post.views ?? "") View"
            }else {
                numberOFViews?.text = "\(post.views ?? "") Views"
            }
            
            var dataWithLong = LONG_LONG_MAX
            dataWithLong = Int64(post.published_date!)!
            let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
            dateLbl?.text = dateFormatter.string(from: formatedData)
            imageVeiw2?.isHidden = true
            imageVeiw?.isHidden = false
            nameLbl?.isHidden = false
            descriptionLbl?.isHidden = false
            numberOFViews?.isHidden = false
            dateLbl?.isHidden = false
            mp3ImageView?.isHidden = false

            downloadBtn?.isHidden = true

            imageVeiw?.sd_setShowActivityIndicatorView(true)
            imageVeiw?.sd_setIndicatorStyle(.gray)
            imageVeiw?.sd_setImage(with: URL(string: post.thumbnail_url!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)

            return cell
        }
        else if clickOnBtn == 1{
            let post = relatedAudios[indexPath.row]
            mp3ImageView?.image = UIImage(named: "mp3")
            let artistname = UserDefaults.standard.object(forKey: "authername") as? String
            print(artistname)
            nameLbl?.text = post.description?.html2String
         //   descriptionLbl?.text =
            numberOFViews?.text = ""
            var dataWithLong = LONG_LONG_MAX
            dataWithLong = Int64(post.published_date!)!
            let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
            dateLbl?.text = dateFormatter.string(from: formatedData)
            imageVeiw2?.isHidden = true
            imageVeiw?.isHidden = false
            nameLbl?.isHidden = false
            descriptionLbl?.isHidden = false
            numberOFViews?.isHidden = false
            dateLbl?.isHidden = false
            mp3ImageView?.isHidden = false
            
            downloadBtn?.isHidden = true

            if let urlString = post.image {
                imageVeiw?.sd_setShowActivityIndicatorView(true)
                imageVeiw?.sd_setIndicatorStyle(.gray)
                imageVeiw?.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
            return cell
        }
        else if clickOnBtn == 3{
            nameLbl?.isHidden = true
            descriptionLbl?.isHidden = true
            numberOFViews?.isHidden = true
            dateLbl?.isHidden = true
            self.noDataFoundLbl.isHidden = true
            imageVeiw?.isHidden = true
            imageVeiw2?.isHidden = false
            mp3ImageView?.isHidden = true
//           let downloadBtn = cell.viewWithTag(201) as? UIButton
//           downloadBtn?.isHidden = true

            downloadBtn?.isHidden = false
            downloadBtn?.tag = indexPath.row
//            index = indexPath.row
            downloadBtn?.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
            
            let post = imgUrlArray[indexPath.row]
            if !post.isEmpty {
                imageVeiw2?.sd_setShowActivityIndicatorView(true)
                imageVeiw2?.sd_setIndicatorStyle(.gray)
                
                imageVeiw2?.sd_setImage(with: URL(string: post), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
            
            return cell
        }
        else{
            
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "about")!
            
            let descriptionLbl = cell3.viewWithTag(333) as! UILabel
            let headingLbl = cell3.viewWithTag(334) as! UILabel
            
//            Jeevan Parichay
            if previoueData.description?.html2String == "जीवन परिचय \n"{
                descriptionLbl.text = ""
                self.noDataFoundLbl.isHidden = false
                headingLbl.isHidden = true
            }
            else{
                descriptionLbl.text = previoueData.description?.html2String
                self.noDataFoundLbl.isHidden = true
                headingLbl.isHidden = false
            }
            
            
            return cell3
        }
        
    }
    @objc func buttonClicked(_ sender:UIButton) {

        downloadPdf(urlArray: [imgUrlArray[sender.tag]] )
    }
    
    func downloadPdf(urlArray: [String]){
        let group = DispatchGroup()

            for str in urlArray {
            print("URL:::",str)
            group.enter()
            let url = URL(string: str)!
            let pdfData = try? Data.init(contentsOf: url)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL

                let result = String(format:"%04d", arc4random_uniform(10000) )
                print("timestamp::",Timestamp)

                self.pdfNameFromUrl = "SANSKAR_\(Timestamp)_\(result).png"
                
            let actualPath = resourceDocPath.appendingPathComponent(self.pdfNameFromUrl)

            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                
                print("pdf successfully saved!")


            } catch {
                print("Pdf could not be saved")
            }
            group.leave()
        }

        group.notify(queue: .main) {
            print("- all pdfs Download done")
            Toast.show(message: "Image saved in sanskar folder", controller: self)
         }
    }
}

//MARK:-TITable View delegates methods.
extension TBGuruDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if clickOnBtn == 0 {
            let post = relatedVideos[indexPath.row]
            
            if post.video_url != ""{
                let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
                recentViewHit(param)
                NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil, userInfo: ["sucess" : post])
            }else{
                let vc : TBYoutubeVideoVC = self.storyboard?.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
        
                vc.songNo = indexPath.row
                vc.post = relatedVideos[indexPath.row]
                vc.videosArr = relatedVideos
                vc.menuMasterId = self.menuMasterId

                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if clickOnBtn == 1{
            
            let post = relatedAudios[indexPath.row]
            MusicPlayerManager.shared.song_no = indexPath.row
            MusicPlayerManager.shared.Bhajan_Track = relatedAudios
            MusicPlayerManager.shared.isDownloadedSong = false
            MusicPlayerManager.shared.isPlayList = false
            MusicPlayerManager.shared.isRadioSatsang = false
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            
            MusicPlayerManager.shared.PlayURl(url: post.media_file!)
            
        }else if clickOnBtn == 2 {
            
        }else{
            
        }
        
    }
}


//MARK:- UIColection View Delegates Methods.
extension TBGuruDetailVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: AppConstant.KSCREENSIZE.width, height: 200)
        return size
    }
}



//MARK:- headerView Delegates
extension TBGuruDetailVC : TBHeaderDelegates {
    func menuBarBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            self.delegate.updateValue(previoueData)
            _ = navigationController?.popViewController(animated: true)
        case 20:
            break
        case 30:
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
            navigationController?.pushViewController(vc, animated: true)
        case 40:
            if currentUser.result!.id! == "163"{
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
//                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
            else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPROFILEVC)
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
}


