//
//  TBYoutubeVideoVC.swift
//  Total Bhakti
//
//  Created by Viru on 03/01/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit

import YouTubePlayer
import YoutubePlayer_in_WKWebView


class TBYoutubeVideoVC: UIViewController,UITableViewDelegate,UITableViewDataSource,YouTubePlayerDelegate,MMPlayerLayerProtocol{
    
    
    static let instance = TBYoutubeVideoVC()
    @IBOutlet weak var playerView: WKYTPlayerView!
    var isLoadingList : Bool = false
    //    var postID = ""
    @IBOutlet weak var searchBar: UISearchBar!
    var searchClicked = 0
    @IBOutlet weak var notifCountLabel: UILabel!
    open var mainViewController: UIViewController?
    @IBOutlet weak var forward_btn: UIButton!
    @IBOutlet weak var backward_btn: UIButton!
    @IBOutlet weak var playPause_btn: UIButton!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var tapView: UIView!
    
    @IBOutlet weak var playerviewheight: NSLayoutConstraint!
    
    var youtubeModelArray : [YoutubeModel] = []
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var videosArr : [videosResult] = []
    var videosArrTredning : [trendingVideoModel] = []
    var page_no = 1
    var post:videosResult?
    var postTrending:trendingVideoModel?
    var searchResultVideosArr = NSMutableArray()
    var menuMasterId = ""
    var catid = ""
    
    
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var searchBarHolder: UIView!
    
    
    var isMultipleVideos = false
    
    @IBOutlet weak var lbl_video_title: UILabel!
    @IBOutlet weak var lbl_author_name: UILabel!
    @IBOutlet weak var lbl_creation_time: UILabel!
    @IBOutlet weak var searchBTn: UIButton!
    @IBOutlet weak var qrBtn: UIButton!
    
    
    @IBOutlet weak var lbl_Views: UILabel!
    @IBOutlet weak var lbl_likes: UILabel!
    var trendingString : String!
    //"trending video"
    var songNo = 0
    var isBool = false
    var landscapeBool = false
    var window: UIWindow?
    var playerCurrentTime: Float?
    var playerTotalDuraion:Float = 0.0
    var media_Id:String?
    @IBOutlet weak var homePlayer:UIView!
    var didselectBool = false
    var postYoutube: YoutubeModel?
    var selectedIndex:Int = 0
    let param : Parameters = ["user_id": currentUser.result!.id!]
    var counterThis : Int = 0
    var adMedia = [String]()
    var adUrl: String = ""
    var skipValue = [String]()
    var skipData: String = ""
    var adId = [String]()
    var dataId: String = ""
    var currentTime:String = ""
    var forReload = ""
    var videodata: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(catid)
        print(post?.category)
        print(post?.published_date)
        if UIDevice.current.userInterfaceIdiom == .pad {
                   playerviewheight.constant = 320
               } else {
                   playerviewheight.constant = 220
               }
        
        tapView.isHidden = true
        
        TV_PlayerHelper.shared.mmPlayer.mmDelegate = self
//        searchBar.delegate = self
//        searchBar.backgroundImage = UIImage()
//        searchBar.backgroundColor = UIColor.clear
//        searchBar.dropShadow()
//        searchBarHolder.isHidden = true
//        searchBarHolder.backgroundColor = .white
        
        MyTableView.tableFooterView = UIView(frame: CGRect.zero)
        MyTableView.tableFooterView?.isHidden = true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: MyTableView.bounds.width, height: CGFloat(44))
        self.MyTableView.tableFooterView = spinner
        
        UserDefaults.standard.setValue("yes", forKey: "isTBYoutubeVideoVC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(backAction), name: NSNotification.Name("closeYoutubePlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(showOrHideBtn))
        //        self.tapView.addGestureRecognizer(gesture)
        //        self.tapView.isUserInteractionEnabled = true
        
        
        lbl_creation_time.text = dateConversion(timestamp:post!.published_date ?? "")
        
        if post!.is_like != "0" ||  post!.is_like != nil{
            //                likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            likeImg.image = UIImage(named: "like_gray")
            //                imageLiteral(resourceName: "like_active-1")
        }
        self.media_Id = post!.id ?? ""
        
   //     lbl_video_title.setHTML(html: post!.video_desc ?? "")
        lbl_video_title.text = post!.video_title
        lbl_author_name.text = post!.author_name
        lbl_Views.text = post!.views ?? ""
        lbl_likes.text = post!.likes ?? ""
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        
        let param : Parameters
//        param  = ["user_id": currentUser.result?.id ?? "" ,"video_id" : post?.id ?? "","limit":"10", "page_no":"\(page_no)", "menu_master_id":"\(menuMasterId)","device_type":"2","current_version": "\(UIApplication.release)"]
        let id = post?.id
        print(id)
            param = ["user_id":currentUser.result?.id ?? "","video_id": id!,"menu_master_id":"\(menuMasterId)","page_no":"\(page_no)","limit":"100"]
            print(param)
            getRelatedVideosApi(param)
      
        //        let param2 : Parameters
        //        param2  = ["user_id": currentUser.result!.id!,"video_id": post!.id ?? ""]
        //        videosDetails(param2)
        
        MyTableView.dataSource = self
        MyTableView.dataSource = self
        playerView.delegate = self
        let playvarsDic = ["playsinline": 1]
        if videoType == 1{
            lbl_video_title.text = post!.video_title
            lbl_author_name.text = post!.author_name
            lbl_creation_time.text = post!.creation_time
            // playerView.load(withVideoId: (post!.youtube_url ?? ""), playerVars:playvarsDic)
        }
        else{
            lbl_video_title.text = post!.video_title
            lbl_author_name.text = post!.author_name
            //            playerView.load(withVideoId: (post?.yt_episode_url ?? ""), playerVars:playvarsDic)
        }
        let parameter : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post?.id ?? ""]
        recentViewHit(parameter)
        NotificationCenter.default.addObserver(self, selector: #selector(youSkipAd), name: NSNotification.Name("youSkipAd"), object: nil)
    }
    
    @objc func youSkipAd(){
        homePlayer.isHidden = true
        self.tapView.isHidden = true
        if kAds == true {
            let param : Parameters = ["user_id": currentUser.result?.id ?? "163","advertisement_id": dataId,"advertisement_status":"1" ]
            adViewApiHit(param)
        }else{
            let param : Parameters = ["user_id": currentUser.result?.id ?? "163","advertisement_id": dataId,"advertisement_status":"0" ]
            adViewApiHit(param)
        }
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
        if didselectBool == false{
            if videoType == 1{
                // playerView.load(withVideoId: "ZuPO3xnOOP8", playerVars:playvarsDic)
                playerView.load(withVideoId: (post?.youtube_url)!, playerVars: playvarsDic)
                let pause_at = Float(post?.pause_at ?? "") ?? 0.0
                playerView.seek(toSeconds: pause_at, allowSeekAhead: true)
                lbl_video_title.text = post!.video_title
                lbl_author_name.text = post!.author_name
                lbl_creation_time.text = dateConversion(timestamp: post?.creation_time ?? "")
                //                playerView.playVideo()
            }
            else{
                lbl_video_title.text = post!.video_title
                lbl_author_name.text = post!.author_name
                lbl_creation_time.text = dateConversion(timestamp: post?.creation_time ?? "")
                playerView.load(withVideoId: (post?.youtube_url ?? ""), playerVars:playvarsDic)
                let pause_at = Float(post?.pause_at ?? "") ?? 0.0
                playerView.seek(toSeconds: pause_at, allowSeekAhead: true)
                //            playerView.playVideo()
                self.tapView.isHidden = true
            }
            
        }
        else{
            
            if self.selectedIndex < self.youtubeModelArray.count {
                self.postYoutube = youtubeModelArray[self.selectedIndex]
                playVideo(post: youtubeModelArray[self.selectedIndex])
                playerView.playVideo()
                self.tapView.isHidden = true
                
                //                isBool = true
                //                forward_btn.isHidden = true
                //                backward_btn.isHidden = true
                //                playPause_btn.isHidden = true
                
                //                self.post?.id = self.postYoutube?.id
                //                self.media_Id = self.postYoutube?.id
                //                lbl_video_title.text = post!.video_title
                //                lbl_author_name.text = post!.author_name
            }
            else{
                
            }
        }
    }
    
    func touchInVideoRect(contain: Bool) {
        print("\(contain)")
    }
    
    //MARK:- view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AppUtility.lockOrientation(.portrait)
        if qrStatus == "1"{
//            searchBTn.isHidden = false
        }else{
       //     searchBTn.isHidden = true
            if #available(iOS 13.0, *) {
                qrBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
        //        let ispremium = UserDefaults.standard.integer(forKey: "isPremium")
        if IsPremiumAct == 1 {
            homePlayer.isHidden = true
            let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
            lbl_video_title.text = post!.video_title
            lbl_author_name.text = post!.author_name
            lbl_creation_time.text = dateConversion(timestamp: post?.creation_time ?? "")
            playerView.load(withVideoId: (post?.youtube_url ?? ""), playerVars:playvarsDic)
            let pause_at = Float(post?.pause_at ?? "") ?? 0.0
            playerView.seek(toSeconds: pause_at, allowSeekAhead: true)
            //            playerView.playVideo()
            self.tapView.isHidden = true
            
        }else{
            //            let adStatus = UserDefaults.standard.integer(forKey: "adStatus")
            if AdStatus == 1 {
                self.advertiseApi(param)
            }else{
                homePlayer.isHidden = true
                let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
                lbl_video_title.text = post!.video_title
                lbl_author_name.text = post!.author_name
                lbl_creation_time.text = dateConversion(timestamp: post?.creation_time ?? "")
                playerView.load(withVideoId: (post?.youtube_url ?? ""), playerVars:playvarsDic)
                let pause_at = Float(post?.pause_at ?? "") ?? 0.0
                playerView.seek(toSeconds: pause_at, allowSeekAhead: true)
                //            playerView.playVideo()
                self.tapView.isHidden = true
            }
        }
        
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideTVPlayer"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
        MusicPlayerManager.shared.isPaused = true
        MusicPlayerManager.shared.myPlayer.pause()
        
        
        if searchClicked == 1 {
            searchClicked = 0
//            searchBar.text = nil
//            searchBar.endEditing(true)
//            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    //MARK:- Advertise Api Method.
    private func advertiseApi(_ param : Parameters){
        
        self.uplaodData1(APIManager.sharedInstance.KAds, param) { [self] (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    let videoData = JSON.ArrayofDict("video")
                    if videoData.count > 0{
                        for index in 0..<videoData.count {
                            self.adMedia.append(videoData[index]["media"] as? String ?? "")
                            self.skipValue.append(videoData[index]["skip"] as? String ?? "")
                            self.adId.append(videoData[index]["id"] as? String ?? "")
                        }
                        self.adUrl = self.adMedia.first ?? ""
                        self.skipData = self.skipValue.first ?? ""
                        self.adDecreaseCounting(url: adUrl)
                    }
                    else{
                        if didselectBool == true {
                            if self.selectedIndex < self.youtubeModelArray.count {
                                self.postYoutube = youtubeModelArray[self.selectedIndex]
                                playVideo(post: youtubeModelArray[self.selectedIndex])
                                playerView.playVideo()
                                self.tapView.isHidden = true
                                
                            }
                        }else{
                            homePlayer.isHidden = true
                            let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
                            lbl_video_title.text = post!.video_title
                            lbl_author_name.text = post!.author_name
                            lbl_creation_time.text = dateConversion(timestamp: post?.creation_time ?? "")
                            playerView.load(withVideoId: (post?.youtube_url ?? ""), playerVars:playvarsDic)
                            let pause_at = Float(post?.pause_at ?? "") ?? 0.0
                            playerView.seek(toSeconds: pause_at, allowSeekAhead: true)
                            //            playerView.playVideo()
                            self.tapView.isHidden = true
                        }
                    }
                }else {
                    self.youSkipAd()
                }
            }else {
                self.addAlert(ALERTS.KERROR, message: ALERTS.KERROR.debugDescription, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    func adViewApiHit(_ param: Parameters){
        
        loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.kupdateAdCounter, param) { (response) in
            DispatchQueue.main.async {
                print(response as Any)
            }
        }
    }
    func adDecreaseCounting(url:String ){
        self.tapView.isHidden = true
        UserDefaults.standard.setValue(0, forKey: "channelPlaying")
        homePlayer.isHidden = false
        let url = URL(string: url)
        TV_PlayerHelper.shared.mmPlayer.set(url: url)
        TV_PlayerHelper.shared.mmPlayer.playView = homePlayer
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.play()
        TV_PlayerHelper.shared.mmPlayer.player?.seek(to: kCMTimeZero)
        if let isplaying = TV_PlayerHelper.shared.mmPlayer.player?.isPlaying,isplaying == true{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didAdPlay"), object: nil)
            UserDefaults.standard.setValue(5, forKey: "counter")
            UserDefaults.standard.setValue(skipData, forKey: "skipValue")
            iscoming = "youtube"
        }
        TV_PlayerHelper.shared.mmPlayer.showCover(isShow: true)
        TV_PlayerHelper.shared.mmPlayer.autoHideCoverType = .disable
        
    }
    @objc func deviceOrientationDidChange() {
        //2
        switch UIDevice.current.orientation {
        case .faceDown:
            print("Face down")
            
        case .faceUp:
            print("Face up")
            
        case .unknown:
            print("Unknown")
        case .landscapeLeft:
            print("landscape left")
            
        case .landscapeRight:
            print("landscape right")
            
        case .portrait:
            print("Portrait")
            
        case .portraitUpsideDown:
            print("Portrait upside down")
            
        }
    }
    //MARK: View Will Disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
        homePlayer.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        UserDefaults.standard.setValue(true, forKey: "postDataDeleted")
        playerView.pauseVideo()
        
        let currentPauseTime = "\(self.playerCurrentTime ?? 0.0)"
        var param: Parameters = ["user_id":currentUser.result?.id ?? "","type":"\(videoType)","media_id":self.media_Id ?? "","pause_at":currentPauseTime ,"status":"0"]
        
        playerView.getDuration { (timeinterval, err) in
            print(timeinterval)
            self.playerTotalDuraion = Float(timeinterval)
            if Int(self.playerCurrentTime ?? 0.00) != Int(self.playerTotalDuraion){
                
                param.updateValue("1", forKey: "status")
            }
            else{
                param.updateValue("0", forKey: "status")
            }
            self.continueWatchingApi(param)
        }
    }
    @objc func backAction(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SkipAd"), object: nil)
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("closeYoutubePlayer"), object: nil)
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Topbar Button action.
    @IBAction func ShareBtnAction (_ sender : UIButton){
        
        let web_view_video = UserDefaults.standard.value(forKey: "web_view_video")
   //     let web_view_video = "https://sanskargroup.page.link/link/video/"
        print(web_view_video)

        let text = "\(web_view_video ?? "")\(post?.id ?? "")"
        print(text)
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        print(activity)
        present(activity, animated: true, completion: nil)
        
//        FirebaseApp.configure()
//
//                if let postID = post?.id {
//                    // Create a Dynamic Link Components
//                    let linkString = "https://sanskargroup.page.link/link/video/"
//                    let dynamicLink = DynamicLinkComponents(link: URL(string: linkString)!, domain: "yourapp.page.link")
//
//                    // Add parameters to the link
//                    dynamicLink.queryItems = [DynamicLinkComponents.QueryItem(name: "id", value: postID)]
//
//                    // Get the generated short URL
//                    dynamicLink.shorten { (shortURL, warnings, error) in
//                        if let error = error {
//                            print("Error creating Dynamic Link: \(error.localizedDescription)")
//                        } else {
//                            // Share the short URL using UIActivityViewController
//                            if let shortURL = shortURL {
//                                let activityItems: [Any] = [shortURL]
//                                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//                                self.present(activityViewController, animated: true, completion: nil)
//                            }
//                        }
//                    }
//                }
        
    }
    
    @IBAction func notificationBtnAction (_ sender : UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancelSearchBtn(_ sender: UIButton){
//        searchBar.text = ""
//        searchBarHolder.isHidden = true
    }
    
    @IBAction func searchBtnpressed(_ sender: UIButton){
//        searchBarHolder.isHidden = false
//        searchBarHolder.backgroundColor = .white
    }
    
    @IBAction func qrCodeBtnPressed(_ sender: UIButton){
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
//                searchBarHolder.isHidden = false
//                searchBarHolder.backgroundColor = .white
            }
        }
    }
    
    @IBAction func menuBtnAction (_ sender : UIButton) {
        slideMenuController()?.openLeft()
    }
    
    @objc func showOrHideBtn(){
        if isBool{
            isBool = false
            forward_btn.isHidden = false
            backward_btn.isHidden = false
            playPause_btn.isHidden = false
            
        }else{
            isBool = true
            forward_btn.isHidden = true
            backward_btn.isHidden = true
            playPause_btn.isHidden = true
        }
    }
    //audio_play
    //audio_pause
    @IBAction func PlayPauseAction(_ sender : UIButton){
        
        if counterThis == 0 {
            playerView.pauseVideo()
            sender.setImage(UIImage(named: "audio_play"), for: .normal)
            counterThis = 1
        }else{
            playerView.playVideo()
            sender.setImage(UIImage(named: "audio_pause"), for: .normal)
            //audio_pause
            counterThis = 0
        }
    }
    @IBAction func forwardAction(_ sender : UIButton){
        songNo = songNo+1
        if videosArr.count > songNo{
            let posts = youtubeModelArray[songNo]
            let param2 : Parameters
            param2  = ["user_id": currentUser.result!.id!,"video_id":posts.id ?? ""]
            videosDetails(param2)
            playVideo(post: posts)
            //            advertiseApi(param)
        }else{
            songNo = songNo-1
        }
        advertiseApi(param)
    }
    @IBAction func backwardAction(_ sender : UIButton){
        songNo = songNo-1
        if videosArr.count > songNo && songNo >= 0{
            let posts = youtubeModelArray[songNo]
            let param2 : Parameters
            param2  = ["user_id": currentUser.result!.id!,"video_id": posts.id ?? ""]
            videosDetails(param2)
            playVideo(post: posts)
            playerView.pauseVideo()
            //            advertiseApi(param)
        }else{
            songNo = 0
        }
        advertiseApi(param)
    }
    func dateConversion(timestamp:String)->String{
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(timestamp) ?? 0
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
        
        return dateFormatter.string(from: formatedData)
    }
    
    @IBAction func backBtnAction (_ sender : UIButton){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SkipAd"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Continue watching Api Method.
    func continueWatchingApi(_ param : Parameters){
        self.uplaodData1(APIManager.sharedInstance.KContinueWatchingAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})

            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Bool == true {
                }else {

                    //                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
            }
        }
    }
    
    @IBAction func LikeBtnAction (_ sender : UIButton){
        
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
//                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if post!.is_like == "0" || post!.is_like == nil{
                likeVideoApi(APIManager.sharedInstance.KVIDEOLIKEAPI,post_ID: post!.id!)
            }else{
                likeVideoApi(APIManager.sharedInstance.KVIDEODISLIKEAPI,post_ID: post!.id!)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if videosArr.count != 0{
        //            return videosArr.count
        //        }
        //
        return youtubeModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as? TBVideoTableCell2 else {
            fatalError("Unable to dequeue cell with identifier: \(KEYS.KCELL)")
        }
        
        if indexPath.row < youtubeModelArray.count {
            let posts = youtubeModelArray[indexPath.row]
            
            cell.numberOfViewsLbl.text = {
                if posts.views == "0" {
                    return "No view"
                } else {
                    return posts.views ?? ""
                }
            }()
            
            if let publishedDate = posts.published_date, !publishedDate.isEmpty {
                cell.dateAndTimeLbl.text = dateConversion(timestamp: publishedDate)
            } else {
                cell.dateAndTimeLbl.text = "No date available"
            }
            
            if let videoImageView = cell.videoImageView {
                videoImageView.sd_setShowActivityIndicatorView(true)
                videoImageView.sd_setIndicatorStyle(.gray)
                videoImageView.contentMode = .scaleToFill
                
                if let thumbnailURL = posts.thumbnail_url, let url = URL(string: thumbnailURL) {
                    videoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                } else {
                    videoImageView.image = UIImage(named: "default_image")
                }
            } else {
                // Handle the case where videoImageView is nil
                cell.videoImageView.image = UIImage(named: "default_image")
            }
            
            cell.mainView.layer.cornerRadius = 5.0
            cell.mainView.dropShadow()
            cell.nameLbl.text = posts.video_title
            cell.dercriptionLbl.text = posts.video_desc?.html2String ?? "No description available"
        } else {
            // Handle the case where indexPath.row is out of range
        }

        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      forReload = "Now"
//        self.MyTableView.reloadRows(at: [indexPath], with: .none)
        didselectBool = true
        self.selectedIndex = indexPath.row
        self.playerView.pauseVideo()
        self.postYoutube = youtubeModelArray[indexPath.row]
        self.media_Id = self.postYoutube?.id
        var param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : self.media_Id ?? ""]
        recentViewHit(param)
        
        post?.id = ""
        post?.id = self.postYoutube?.id
        self.lbl_video_title.text = self.postYoutube?.video_title
        self.lbl_author_name.text = self.postYoutube?.author_name
        self.lbl_creation_time.text = self.postYoutube?.creation_time
        //        videosDetails(param2)
        
        //        songNo = indexPath.row
        //        self.page_no = 1
        //        let relatedparam : Parameters
        //        relatedparam  = ["user_id": currentUser.result?.id ?? "" ,"video_id" : self.media_Id ?? (post?.id ?? ""),"limit":"10", "page_no":"\(page_no)"]
        //        getRelatedVideosApi(relatedparam)
        if adMedia.count > 0 {
            if selectedIndex >= adMedia.count {
                selectedIndex = 0
                self.adUrl = adMedia[selectedIndex]
                self.skipData = skipValue[selectedIndex]
                self.dataId = adId[selectedIndex]
            }else{
                self.adUrl = adMedia[selectedIndex]
                self.skipData = skipValue[selectedIndex]
                self.dataId = adId[selectedIndex]
            }
            self.adDecreaseCounting(url: adUrl)
        }else{
            self.postYoutube = youtubeModelArray[self.selectedIndex]
            guard let playTime = playerCurrentTime else {return}
            let total = String(format: "%.0f", playTime)
            let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "1","media_id": self.media_Id ?? "","device_type":"2","video_status": "1","total_play": "\(total)"]
            hitPlayTime(playParm)
            if postYoutube != nil {
                playVideo(post: youtubeModelArray[self.selectedIndex])
                playerView.playVideo()
                self.tapView.isHidden = true
            }else{
                AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                    if index == 1 {
                        let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }

        let id = post?.id
        param = ["user_id":currentUser.result?.id ?? "","video_id": id!,"menu_master_id":"\(menuMasterId)","page_no":"\(page_no)","limit":"100"]
        print(param)
        getRelatedVideosApi(param)

       // self.MyTableView.reloadData()
    }
    func playVideoTrending(post:trendingVideoModel){
        if post.youtube_url != ""{
            lbl_video_title.text = post.video_title
            lbl_author_name.text = post.author_name
            lbl_creation_time.text = post.published_date
            lbl_Views.text = post.views
            lbl_likes.text = post.likes!
            if post.is_like == "1" {
                //                likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                likeImg.image = UIImage(named: "like_active-1")
                //                    imageLiteral(resourceName: "like_active-1")
            }else{
                //                likeImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                likeImg.image = UIImage(named: "like_gray")
                //                    imageLiteral(resourceName: "like_gray")
            }
            if post.published_date != ""{
                lbl_creation_time.text = dateConversion(timestamp:post.published_date!)
            }else{
                lbl_creation_time.text = ""
            }
            //                        playerView.loadVideoID(post.youtube_url!)
        }
    }
    func playVideo(post:YoutubeModel){
        //        if trendingString == "trending video"{}
        if post.youtube_url != ""{
            lbl_video_title.text = post.video_title
            lbl_author_name.text = post.author_name
            lbl_creation_time.text = post.published_date
            lbl_Views.text = post.views
            lbl_likes.text = post.likes ?? "0"
            if post.is_like == "1" {
                //                likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                likeImg.image =  UIImage(named: "like_active-1")
                //                    imageLiteral(resourceName: "like_active-1")
            }else{
                //                likeImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                likeImg.image =  UIImage(named: "like_default")
                //                    imageLiteral(resourceName: "like_default")
            }
            if post.published_date != ""{
                lbl_creation_time.text = dateConversion(timestamp:post.published_date ?? "")
                
            }else{
                lbl_creation_time.text = ""
            }
            let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
            playerView.load(withVideoId: (post.youtube_url ?? ""), playerVars:playvarsDic)
        }
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
//
//            if youtubeModelArray.count == 0 || youtubeModelArray.count < 10{
//                return
//            }
//
//            self.MyTableView.tableFooterView?.isHidden = false
//            self.isLoadingList = true
//            spinner.startAnimating()
//
//            let lastVideo = youtubeModelArray[youtubeModelArray.count-1]
//            let lastVideoId = lastVideo.id
//
//            page_no += 1
//            let param : Parameters
//            let categoryid = post?.category
//            print(categoryid)
////
////            param = ["user_id":currentUser.result?.id ?? "","category":categoryid!,"menu_master_id":"\(menuMasterId)","page_no":"\(page_no)","limit":"100"]
////            getRelatedVideosApi(param)
//
//            //            if lastVideo.category != nil{
//            //            param  = ["user_id": currentUser.result?.id ?? "" ,"search_content" : "", "last_video_id" : lastVideoId ?? "" , "video_category" : lastVideo.category ?? "","limit":"10"]
//            //            }
//            //            else{
//            //                param  = ["user_id": currentUser.result?.id ?? "" ,"search_content" : "", "last_video_id" : lastVideoId ?? "" , "video_category" : "","limit":"10"]
//            //
//            //            }
//
//            //            getVideosApi(param)
//        }
//    }
    
}
extension TBYoutubeVideoVC {
    //MARK:- getVideos.
    func getVideosApi(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KVIDEOSAPI , param) { (response) in
            
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            self.spinner.stopAnimating()
            if self.isLoadingList{
                self.isLoadingList = false
                self.MyTableView.tableFooterView?.isHidden = true
            }
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                dataOFVideos = VideosData1.init(dictionary: JSON)
                if dataOFVideos.status! {
                    
                    if self.searchClicked == 1 {
                        //                        self.videosArr.removeAll()
                        //  self.videosArr.addObjects(from: NSMutableArray(array : dataOFVideos.result!.videos!) as! [Any])
                        if self.videosArr.count == 0{
                            self.searchClicked = 0
                            //                            self.videosArr = self.searchResultVideosArr
                            Toast.show(message: "Not found",controller: self)
                        }
                    }else{
                    }
                    self.MyTableView.reloadData()
                }
                else {
                    self.addAlert(ALERTS.KERROR, message: dataOFVideos.message!, buttonTitle: ALERTS.kAlertOK)
                }
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}
extension TBYoutubeVideoVC {
    //MARK:- getRelatedVideosApi.
    func getRelatedVideosApi(_ param : Parameters) {
        self.youtubeModelArray.removeAll()
        self.uplaodData(APIManager.sharedInstance.Ksuggestvideo , param) { (response) in
            
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            self.spinner.stopAnimating()
            if self.isLoadingList{
                self.isLoadingList = false
                self.MyTableView.tableFooterView?.isHidden = true
            }
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    let data = JSON.ArrayofDict("data")
                    _ = data.filter({ dict -> Bool in
                        
                        self.youtubeModelArray.append(YoutubeModel(dict: dict))
                        
                        return true
                    })
                    DispatchQueue.main.async {
                        self.MyTableView.reloadData()
                    }
                    
                }
                self.MyTableView.reloadData()
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}

// MARK:- number of like and user liked or not and number of views

extension TBYoutubeVideoVC {
    func videosDetails(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.get_video_meta_data , param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                
                if JSON.value(forKey: "status") as? Int == 1 {
                    
                    let  data = JSON["data"]! as? Dictionary<String,Any>
                    let is_like = data!.validatedValue("is_like")
                    let likes = data!.validatedValue("likes")
                    let views = data!.validatedValue("views")
                    
                    self.lbl_Views.text = views
                    self.lbl_likes.text = likes
                    
                    //                    self.post?.is_like = is_like
                    //                    self.post?.likes = likes
                    //                    self.post?.views = views
                    if is_like != "0"{
                        //                        self.likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                        self.likeImg.image =   UIImage(named: "like_active-1")
                        //                            imageLiteral(resourceName: "like_active-1")
                        
                    }else{
                        //                        self.likeImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                        self.likeImg.image = UIImage(named: "like_gray")
                        //                            imageLiteral(resourceName: "like_gray")
                        
                    }
                }
                
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}

//MARK:- likeVideoApi(APIManager.sharedInstance.KVIDEOLIKEAPI)

//MARK:- LikeVideoHit.

extension TBYoutubeVideoVC {
    func likeVideoApi(_ apiName : String, post_ID : String ) {
        let param : Parameters = ["user_id": currentUser.result!.id! , "video_id" : post_ID]
        self.uplaodData(apiName, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Int == 1 {
                    if  JSON.value(forKey: "message") as? String == "User liked." {
                        //                        self.likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                        self.likeImg.image = UIImage(named: "like_active-1")
                        
                        //                            imageLiteral(resourceName: "like_active-1")
                        
                        // mark comment by Avi tyagi it shoud be crash
                        
//                        let like = Int(self.post!.likes!) ?? 0
//                        self.lbl_likes.text = "\(like+1) like"
//                        self.post!.is_like = "1"
//                        self.post!.likes = "\(like+1)"
                        
                        
                        if let post = self.post {
                            let like = Int(post.likes ?? "0") ?? 0
                            self.lbl_likes.text = "\(like + 1)"
                            post.is_like = "1"
                            post.likes = "\(like + 1)"
                        }

                    }
                    else if JSON.value(forKey: "message") as? String == "Unlike Successfully."{
                        //                        self.likeImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                        self.likeImg.image = UIImage(named: "like_gray")
                        //                            imageLiteral( ≥≤: "like_gray")
                        
                        
                    // mark comment by Avi tyagi it shoud be crash
                        
//                        let like = Int(self.post!.likes!) ?? 0
//                        if like != 0{
//                            self.lbl_likes.text = "\(like-1) like"
//                            self.post?.likes = "\(like-1)"
//                            let is_like = Int(((self.post?.is_like)!))
//                            self.post?.is_like = "\(is_like! - 1)"
//                        }else{
//                            self.lbl_likes.text = "0 like"
//                            self.post?.is_like = "0"
//
//                        }
                        
                        if let post = self.post, let likesString = post.likes, let likes = Int(likesString) {
                            if likes != 0 {
                                self.lbl_likes.text = "\(likes - 1)"
                                self.post?.likes = "\(likes - 1)"

                                if let isLikeString = post.is_like, let isLike = Int(isLikeString) {
                                    self.post?.is_like = "\(isLike - 1)"
                                }
                            } else {
                                self.lbl_likes.text = "0"
                                self.post?.is_like = "0"
                            }
                        } else {
                            // Handle the case when self.post or self.post?.likes is nil
                            print("Error: Unable to update likes. Post or likes information is nil.")
                        }

                    }
                    else {
                        self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    }
                }else {
                    //                    self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
    }
}

extension TBYoutubeVideoVC{
    
    
    
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        //        playerView.play()
        //
        //        isBool = true
        //        if landscapeBool == true{
        //            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        //            playerView.playerVars = (["playsinline" : 1] as AnyObject) as! YouTubePlayerView.YouTubePlayerParameters
        //        }
        //
        //        let playerCurrentTime:Float = Float(post!.pause_at ?? "0.00") ?? 0.00
        //        if playerCurrentTime != 0{
        //            print("CurrentTime::",videoPlayer.getCurrentTime())
        //            videoPlayer.seekTo(playerCurrentTime, seekAhead: true)
        //        }
        //        forward_btn.isHidden = true
        //        backward_btn.isHidden = true
        //        playPause_btn.isHidden = true
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Paused{
            playPause_btn.setImage(UIImage(named: "audio_play"), for: .normal)
        }else{
            playPause_btn.setImage(UIImage(named: "audio_pause"), for: .normal)
        }
        
    }
}
//MARK:- UISearchBarDelegates.
//extension TBYoutubeVideoVC : UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
//
//    }
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        //
//        //        videosArr = searchResultVideosArr
//        //        searchClicked = 0
//        //        searchBar.text = ""
//        //        self.view.endEditing(true)
//        //        searchBar.endEditing(true)
//        //        searchBar.setShowsCancelButton(false, animated: true)
//        //        MyTableView.reloadData()
//    }
//
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //        self.view.endEditing(true)
//        //        searchBar.endEditing(true)
//        //        searchResultVideosArr = videosArr
//        //        searchClicked = 1
//        //        let param : Parameters
//        //        param  = ["user_id": currentUser.result!.id!,"search_content" : searchBar.text!, "last_video_id" : "", "video_category" : "","limit":"10"]
//        //        getVideosApi(param)
//
//    }
//}

extension UILabel {
    func setHTML(html: String) {
        do {
            let attributedString: NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!,options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            self.attributedText = attributedString
        } catch {
            self.text = html
        }
    }
}

extension TBYoutubeVideoVC: WKYTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        print("playerViewDidBecomeReady")
        //                let pause_at = Float(post?.pause_at ?? "") ?? 0.0
        let pause_at = Float(0.0)
        playerView.seek(toSeconds: pause_at, allowSeekAhead: true)
        
        playerView.playVideo()
    }
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
        print("didPlayTime\(playTime)")
        self.playerCurrentTime = playTime
    }
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        print("didChangeTo")
        if state == .ended{
            let currentPauseTime = "\(self.playerCurrentTime ?? 0.0)"
            var param: Parameters = ["user_id":currentUser.result?.id ?? "","type":"\(videoType)","media_id":self.media_Id ?? "","pause_at":currentPauseTime ,"status":"0"]
            if self.didselectBool == false{
                if self.youtubeModelArray.count > 0{
                    self.didselectBool = true
                    guard let playTime = playerCurrentTime else {return}
                    let total = String(format: "%.0f", playTime)
                    let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "1","media_id": self.media_Id ?? "","device_type":"2","video_status": "1","total_play": "\(total)"]
                    hitPlayTime(playParm)
                    if self.selectedIndex < self.youtubeModelArray.count{
                        
                        self.media_Id = self.youtubeModelArray[self.selectedIndex].id
                        let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : self.media_Id ?? ""]
                        recentViewHit(param)
                        post?.id = ""
                        post?.id = self.youtubeModelArray[self.selectedIndex].id
                        lbl_video_title.text = self.youtubeModelArray[self.selectedIndex].video_title
                        lbl_author_name.text = self.youtubeModelArray[self.selectedIndex].author_name
                        lbl_creation_time.text = self.youtubeModelArray[self.selectedIndex].creation_time
                        //                        self.advertiseApi(self.param)
                        if adMedia.count > 0 {
                            if selectedIndex >= adMedia.count {
                                let adIndex = 0
                                self.adUrl = adMedia[adIndex]
                                self.skipData = skipValue[adIndex]
                                self.dataId = adId[adIndex]
                            }else{
                                self.adUrl = adMedia[selectedIndex]
                                self.skipData = skipValue[selectedIndex]
                                self.dataId = adId[selectedIndex]
                            }
                            self.adDecreaseCounting(url: adUrl)
                        }else{
                            self.postYoutube = youtubeModelArray[self.selectedIndex]
                            if postYoutube != nil {
                                playVideo(post: youtubeModelArray[self.selectedIndex])
                                playerView.playVideo()
                            }else{
                                AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                                    if index == 1 {
                                        let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }else{
                    playerView.seek(toSeconds: 0.0, allowSeekAhead: true)
                    playerView.pauseVideo()
                }
            }else{
                if self.selectedIndex < self.youtubeModelArray.count {
                    guard let playTime = playerCurrentTime else {return}
                    let total = String(format: "%.0f", playTime)
                    let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "1","media_id": self.media_Id ?? "","device_type":"2","video_status": "1","total_play": "\(total)"]
                    hitPlayTime(playParm)
                    self.selectedIndex = self.selectedIndex + 1
                    self.media_Id = self.youtubeModelArray[self.selectedIndex].id
                    let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : self.media_Id ?? ""]
                    recentViewHit(param)
                    post?.id = ""
                    post?.id = self.youtubeModelArray[self.selectedIndex].id
                    self.advertiseApi(self.param)
                    lbl_video_title.text = self.youtubeModelArray[self.selectedIndex].video_title
                    lbl_author_name.text = self.youtubeModelArray[self.selectedIndex].author_name
                    lbl_creation_time.text = self.youtubeModelArray[self.selectedIndex].creation_time
                    self.postYoutube = youtubeModelArray[self.selectedIndex]
                    if postYoutube != nil {
                        playVideo(post: youtubeModelArray[self.selectedIndex])
                        playerView.playVideo()
                    }else{
                        AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                            if index == 1 {
                                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                    
                }
                else{
                    playerView.seek(toSeconds: 0.0, allowSeekAhead: true)
                    playerView.pauseVideo()
                }
                
                playerView.getDuration { (timeinterval, err) in
                    print(timeinterval)
                    self.playerTotalDuraion = Float(timeinterval)
                    if Int(self.playerCurrentTime ?? 0.00) != Int(self.playerTotalDuraion){
                        
                        param.updateValue("1", forKey: "status")
                    }
                    else{
                        param.updateValue("0", forKey: "status")
                    }
                    
                    self.continueWatchingApi(param)
                }
                
            }
            
            
        }else if state == .paused {
            guard let playTime = playerCurrentTime else {return}
            let total = String(format: "%.0f", playTime)
            let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "1","media_id": self.media_Id ?? "","device_type":"2","video_status": "0","total_play": "\(total)"]
            hitPlayTime(playParm)
            
        }
    }
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
        print("receivedError")
    }
    func playerView(_ playerView: WKYTPlayerView, didChangeTo quality: WKYTPlaybackQuality) {
        print("didChangeTo quality")
    }
    
    func hitPlayTime(_ parm: Parameters) {
        
        uplaodData1(APIManager.sharedInstance.playTime, parm) { response in
            if let Json = response as? NSDictionary {
                if Json["status"] as? Bool == true {
                    print(Json["status"] as Any)
                }
            }
        }
        
    }
}


