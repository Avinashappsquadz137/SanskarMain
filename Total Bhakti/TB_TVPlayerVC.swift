//
//  TB_TVPlayerVC.swift
//  Sanskar
//
//  Created by mac on 01/07/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit
import Firebase
//import IQKeyboardManager
import FirebaseDatabase
import FittedSheets
import Alamofire
import GoogleCast
class TB_TVPlayerVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, GetVideoQualityList,GCKUIMiniMediaControlsViewControllerDelegate, GCKSessionManagerListener {
    
    
    var messageArray : [messageModel] = []
    var completionBlock:vCB?
    var completionBlock2:vCB2?
    
    var index = 0
    var chatKey = ""
    
    var isTrue = true
    var gapDuration:Double = 60.0
    var adMedia = [String]()
    var adUrl: String = ""
    var selectedIndex:Int = 0
    var channelUrl: URL?
    var didSelect: Bool = false
    var adIndex: Int = 0
    var timer = Timer()
    var skipValue:[String] = []
    var skpData:String = ""
    var dataUrl: String = ""
    var bandwidthArray = [String]()
    var resolutionArray = [String]()
    var videoDict : [String : Any] = [:]
    var categoryDataArray : [CategoryModel] = []
    var sessionManager: GCKSessionManager!
    private var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
    var mediaView: UIView!
    
    
    @IBOutlet weak var TVPlayer:UIView!
    @IBOutlet weak var channelCollection: UICollectionView!
    
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var textFiledView : UIView!
    @IBOutlet weak var txtViewChat: GrowingTextView!
    @IBOutlet weak var prifile_img   : UIImageView!
    @IBOutlet weak var notifCountLabel: UILabel!
    @IBOutlet weak var qrButton: UIButton!
    
    @IBOutlet weak var bottomViewConstraints   : NSLayoutConstraint!
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prifile_img.sd_setImage(with: URL(string: currentUser.result?.profile_picture ?? ""), placeholderImage:  UIImage(named: "profile"), options: .refreshCached, completed: nil)
        
        MyTableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        MyTableView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SkipTvAd), name: NSNotification.Name("SkipTvAd"), object: nil)
        
        self.MyTableView.delegate = self
        self.MyTableView.dataSource = self
        

        
        self.channelUrl = URL(string: channelTableArr[0].channel_url ?? "")
        channelCollection.dataSource = self
        channelCollection.delegate = self
        castUpdate()
        
        let param = ["user_id":currentUser.result?.id ?? "163"]
        
        if IsPremiumAct == 1 {
            if TV_PlayerHelper.shared.mmPlayer.playUrl != nil{
                TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
                TV_PlayerHelper.shared.mmPlayer.player?.play()
                
            }else{
                if channelTableArr.count != 0{
                    if channelTableArr[0].channel_url != ""{
                        let current = Date()
                        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
                        let dformat = DateFormatter()
                        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        var dateform = dformat.string(from: oneHourAgo!)
                        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                        print(dateform)
                        if let urlSting = channelTableArr[0].channel_url {
                            dataUrl = "\(urlSting)?start=\(dateform)01:00:00+05:30&end="
                        }
                        playVideo(hlsUrl: dataUrl)
//                        let url = URL(string: dataUrl)
//                        self.channelUrl = url
//
//                        post = channelTableArr[0]
//                        TV_PlayerHelper.shared.mmPlayer.set(url: url)
//                        TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
//                        TV_PlayerHelper.shared.mmPlayer.resume()
//                        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
//                        TV_PlayerHelper.shared.mmPlayer.player?.play()
                    }
                }
                
            }
        }else{
            
            if AdStatus == 1 {
                advertiseApi(param)
               
            }else{
                if TV_PlayerHelper.shared.mmPlayer.playUrl != nil{
                    TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
                    TV_PlayerHelper.shared.mmPlayer.player?.play()
                    
                }else{
                    if channelTableArr.count != 0{
                        if channelTableArr[0].channel_url != ""{
                            let current = Date()
                            let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
                            let dformat = DateFormatter()
                            dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            var dateform = dformat.string(from: oneHourAgo!)
                            dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                            print(dateform)
                            if let urlSting = channelTableArr[0].channel_url {
                                dataUrl = "\(urlSting)?start=\(dateform)01:00:00+05:30&end="
                            }
                            playVideo(hlsUrl: dataUrl)
//                            let url = URL(string: dataUrl)
//
//                            post = channelTableArr[0]
//                            TV_PlayerHelper.shared.mmPlayer.set(url: url)
//                            TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
//                            TV_PlayerHelper.shared.mmPlayer.resume()
//                            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
//                            TV_PlayerHelper.shared.mmPlayer.player?.play()
                        }
                    }
                    
                }
            }
            
        }
        channelDidChanged()
        if post != nil{
            observeMessage()
        }
        observeMessage()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if qrStatus == "1"{
            qrButton.isHidden = false
        }else{
            qrButton.isHidden = true
        }
        TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
        MusicPlayerManager.shared.myPlayer.pause()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeYoutubePlayer"), object: nil)
        
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        IQKeyboardManager.shared.enable = false
        
//        self.ref.child("live_users_channel").value(forKeyPath: "Sanskar TV")
            
        
        
//        self.ref.child("live_users_channel").child("Sanskar TV").observe(.value, with: { (snapshot) in
//
//                if snapshot.exists(){
//
//                   print(snapshot)
//
//                   if let snapDict = snapshot.value as? Int {
//
//                    print(snapDict)
//                   }
//
//               }
//
//           })
//            .child("Sanskar TV").value(forKeyPath: "Sanskar_TV")

        
//        let user = FIRAuth.auth()?.currentUser!//live_users_channel
//        self.ref.child("live_users_channel").child("Sanskar TV").setValue()
//        childByAutoId().setValue(currentUser.result?.id)
//        self.ref.child("sanskarliveUsers").childByAutoId().setValue(dict)
//        self.ref.child("sanskarliveUser").childByAutoId().onDisconnectRemoveValue()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        timer.invalidate()
        IQKeyboardManager.shared.enable = true
    }
    
    func channelDidChanged(){
        if post == nil{
            return
        }
        if post.id == "19"{
            FirebaseChannel = "sanskarTV"
        }
        else if post.id == "Sanskar UK"{
            FirebaseChannel = "sanskarUK"
        }
        else if post.id == "26"{
            FirebaseChannel = "sanskarUSA"
        }
        else if post.id == "23"{
            FirebaseChannel = "SanskarWebTV"
        }
        else if post.id == "20"{
            FirebaseChannel = "satsangTV"
        }
        else if post.id == "24"{
            FirebaseChannel = "satsangWebTV"
        }
        else if post.id == "22"{
            FirebaseChannel = "SubhCinemaTV"
        }
        else if post.id == "27"{
            FirebaseChannel = "SanskarTvRadio"
        }
        else {
            FirebaseChannel = "shubhTV"
        }
        
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
            
        }

        
    }
    
    @IBAction func backActionBtn(_ sender:UIButton){
        
        TV_PlayerHelper.shared.mmPlayer.setOrientation(.protrait)
        TV_PlayerHelper.shared.mmPlayer.playView = nil
        guard let cb = self.completionBlock else {return}
        cb()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        
        TV_PlayerHelper.shared.mmPlayer.playView = nil
        guard let cb = self.completionBlock else {return}
        cb()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func ShareAction(_ sender: UIButton) {
        let text = "https://apps.apple.com/in/app/sanskar-tv-app/id1497508487 \n https://play.google.com/store/apps/details?id=com.sanskar.tv"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    @IBAction func notificationButton(_ sender: UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func SendMesssageAction (_ sender : UIButton) {
        
        let str = txtViewChat.text.replacingOccurrences(of: " ", with: "")
        let str2 = str.replacingOccurrences(of: "\n", with: "")
        
        if str2 == ""{
            return
        }
        
        if currentUser.result!.id! == "163"{
            TV_PlayerHelper.shared.mmPlayer.playView = nil
            guard let cb = self.completionBlock2 else {return}
            self.dismiss(animated: true, completion: {
                cb()
            })
        }
        else{
            composeMessage()
        }
        
    }
    
    //MARK: Google Cast
        
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
            updateControlBarsVisibility(shouldAppear: shouldAppear)
        }
        
        func castUpdate(){
            sessionManager = GCKCastContext.sharedInstance().sessionManager
            mediaView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 30, width: self.view.frame.width, height: 70))
            self.view.addSubview(mediaView!)
            let castContext = GCKCastContext.sharedInstance()
            sessionManager.add(self)
            miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
            miniMediaControlsViewController.delegate = self
            updateControlBarsVisibility(shouldAppear: true)
            installViewController(miniMediaControlsViewController, inContainerView: mediaView!)
        }
        
        func updateControlBarsVisibility(shouldAppear: Bool = false) {
                if shouldAppear {
                    mediaView!.isHidden = false
                } else {
        //            mediaView!.isHidden = true
                }
                UIView.animate(withDuration: 1, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
                view.setNeedsLayout()
            }
        
        func installViewController(_ viewController: UIViewController?, inContainerView containerView: UIView) {
                if let viewController = viewController {
                    addChildViewController(viewController)
                    viewController.view.frame = containerView.bounds
                    containerView.addSubview(viewController.view)
                    viewController.didMove(toParentViewController: self)
                }
            }
        
        
        @objc func castVideo(){
            
    //        TV_PlayerHelper.shared.mmPlayer.player?.pause()
            let current = Date()
            let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
            let dformat = DateFormatter()
            dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            var dateform = dformat.string(from: oneHourAgo!)
            dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
            print(dateform)
            if let urlString = channelTableArr[selectedIndex].channel_url {
                dataUrl = "\(urlString)?start=\(dateform)01:00:00+05:30&end="
            }
            let url = URL.init(string: dataUrl)
            let metaData = GCKMediaMetadata()
            metaData.setString("This is Descriptions", forKey: kGCKMetadataKeyTitle)
            metaData.setString("This is Descriptions", forKey: kGCKMetadataKeySubtitle)
            if let image = channelTableArr[selectedIndex].image {
                metaData.addImage(GCKImage(url: URL(string: image)!, width: 480, height: 360))
            }

            
            let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: url!)
            mediaInfoBuilder.streamType = GCKMediaStreamType.live;
                    mediaInfoBuilder.contentType = ".m3u8"
                    mediaInfoBuilder.metadata = metaData;
                    let mediaInformation = mediaInfoBuilder.build()
                    // Now finally handing over all information and load video
                    if let request =  sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation){
                       request.delegate = self
                        
                    }
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
            
            
            
        }
    
//MARK:- Hit Advertisment Api
    
    func advertiseApi(_ param: Parameters){
        
        self.uplaodData1(APIManager.sharedInstance.KAds, param) { (response) in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            print(response as Any)
            
            if let JSON = response as?  [String: Any]{
                if JSON["status"] as? Bool == true {
                    self.gapDuration = Double((JSON["gap_duration"] as! NSDictionary)["LIVE_CHANNEL"] as! String) ?? 60.0
                    let adData = (JSON["live_tv"] as? [[String:Any]] ?? [[:]])
                    
                    for index in 0..<adData.count {
                        self.adMedia.append(adData[index]["media"] as? String ?? "")
                        self.skipValue.append(adData[index]["skip"] as? String ?? "")
                    }
                    self.adUrl = self.adMedia.first ?? ""
                    if self.adMedia.count > 0 {
                        self.adDecreaseCounting(urlStr: self.adUrl)
                        self.startTimer()
                    }else{
                        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil{
                            TV_PlayerHelper.shared.mmPlayer.playView = self.TVPlayer
                            TV_PlayerHelper.shared.mmPlayer.player?.play()

                        }else{
                            if channelTableArr.count != 0{
                                if channelTableArr[0].channel_url != ""{
                                    let current = Date()
                                    let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
                                    let dformat = DateFormatter()
                                    dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                    var dateform = dformat.string(from: oneHourAgo!)
                                    dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                                    print(dateform)
                                    if let urlSting = channelTableArr[0].channel_url {
                                        self.dataUrl = "\(urlSting)?start=\(dateform)01:00:00+05:30&end="
                                    }
                                    self.playVideo(hlsUrl: self.dataUrl)
//                                    let url = URL(string: self.dataUrl)
//
//                                    post = channelTableArr[0]
//                                    TV_PlayerHelper.shared.mmPlayer.set(url: url)
//                                    TV_PlayerHelper.shared.mmPlayer.playView = self.TVPlayer
//                                    TV_PlayerHelper.shared.mmPlayer.resume()
//                                    TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
//                                    TV_PlayerHelper.shared.mmPlayer.player?.play()
                                }
                            }

                        }
                    }
                    
                }else{
//
                    if channelTableArr[0].channel_url != ""{
                        let current = Date()
                        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
                        let dformat = DateFormatter()
                        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        var dateform = dformat.string(from: oneHourAgo!)
                        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                        print(dateform)
                        if let urlSting = channelTableArr[0].channel_url {
                            self.dataUrl = "\(urlSting)?start=\(dateform)01:00:00+05:30&end="
                        }
                        self.playVideo(hlsUrl: self.dataUrl)
//                        let url = URL(string: self.dataUrl)
//
//                        post = channelTableArr[0]
//                        TV_PlayerHelper.shared.mmPlayer.set(url: url)
//                        TV_PlayerHelper.shared.mmPlayer.playView = self.TVPlayer
//                        TV_PlayerHelper.shared.mmPlayer.resume()
//                        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
//                        TV_PlayerHelper.shared.mmPlayer.player?.play()
                    }
                
                }
            }else{
                self.addAlert(ALERTS.KERROR, message: ALERTS.KERROR.debugDescription, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    func adDecreaseCounting(urlStr:String ){
        //        adIndex += 1
        UserDefaults.standard.setValue(self.selectedIndex, forKey: "channelPlaying")
        let url = URL(string: urlStr)
        
        TVPlayer.isHidden = false
        
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.set(url: url)
        TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        TV_PlayerHelper.shared.mmPlayer.player?.play()
        TV_PlayerHelper.shared.mmPlayer.player?.seek(to: kCMTimeZero)
        iscoming = "LiveTv"
        if let isplaying = TV_PlayerHelper.shared.mmPlayer.player?.isPlaying,isplaying == true{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didAdPlay"), object: nil)
            UserDefaults.standard.setValue(5, forKey: "counter")
            UserDefaults.standard.setValue(Int(skpData), forKey: "skipValue")
        }
        TV_PlayerHelper.shared.mmPlayer.showCover(isShow: true)
        TV_PlayerHelper.shared.mmPlayer.autoHideCoverType = .disable
    }
    
    @objc func SkipTvAd(){
        
        if adMedia.count > 0 {
            if adIndex >= adMedia.count {
                self.adIndex = 0
                self.adUrl = adMedia[adIndex]
                self.skpData = skipValue[adIndex]
    //            self.adIDUrl = adIDArray[adIndex]
                
            } else {
                self.adUrl = adMedia[adIndex]
                self.skpData = skipValue[adIndex]
    //            self.adIDUrl = adIDArray[adIndex]
            }
        }
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        
        let current = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var dateform = dformat.string(from: oneHourAgo!)
        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
        print(dateform)
        var newDataUrl = ""
        if let urlString = channelTableArr[selectedIndex].channel_url {
            newDataUrl = "\(urlString)?start=\(dateform)01:00:00+05:30&end="
        }
        playVideo(hlsUrl: newDataUrl)
    }
    func playVideo(hlsUrl : String){
        DispatchQueue.main.async {
            guard let content = URL(string: hlsUrl) else {return}
            _ = self.getUrl(urlStrin: hlsUrl)
            let urlAsset = AVURLAsset(url: content)
            TV_PlayerHelper.shared.mmPlayer.set(asset: urlAsset)
            TV_PlayerHelper.shared.mmPlayer.playView = self.TVPlayer
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredMaximumResolution = CGSize(width: 1280, height: 720)
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = 0
            TV_PlayerHelper.shared.mmPlayer.resume()
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
            TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
            TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
            TV_PlayerHelper.shared.mmPlayer.player?.play()
        }
    }
    
    func getUrl(urlStrin:String) -> [String]{
        let subUrl = [String](repeating: "", count: 4)
        if let url = URL(string: urlStrin) {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                
                var resolution = contents.components(separatedBy: "RESOLUTION=")
                
                resolution.remove(at: 0)
                
                for dic in resolution {
                    let str = dic.components(separatedBy: ",")
                    resolutionArray.append(str[0])
                }
                
                var bandwith = contents.components(separatedBy: "AVERAGE-BANDWIDTH=")
                bandwith.remove(at: 0)
                

                for dic in bandwith {
                    let str = dic.components(separatedBy: ",")
                    self.bandwidthArray.append(str[0])
                }
                return subUrl
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        return subUrl
    }
    
    func startTimer() {
        //MARK: TIMER EXECUTION
        timer.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        let duration = gapDuration
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { [weak self] _ in
            // do something here
            print("TIME CROSSED : \(String(describing: self?.timer.timeInterval))")
            if let url = self?.adUrl {
                self?.adDecreaseCounting(urlStr: url)
                self?.adIndex += 1
            }
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification)
    {
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        let window = UIApplication.shared.keyWindow
        

        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoControlVc") as! VideoControlVc
//        let controller = self.storyboard?.instantiateViewController(identifier: "VideoControlVc") as! VideoControlVc
        controller.delegate = self
        controller.videoDict = videoDict
        let sheetController = SheetViewController(controller: controller)
        sheetController.cornerRadius = 20
        sheetController.setSizes([.fixed(250)])
        window?.rootViewController!.present(sheetController, animated: false, completion: nil)
    }
    
    func getSeletedBitRate(bitrate: Int) {
    
        TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = Double(self.bandwidthArray[bitrate])!
        TV_PlayerHelper.shared.mmPlayer.player?.play()
    }
    
    func getSeletedSpeedRate(playBackSpeed: String) {
        CoverA.playerRate = Double(Float(playBackSpeed)!)
        TV_PlayerHelper.shared.mmPlayer.player?.rate = Float(playBackSpeed)!
        

    }
    
    func getBitRateList(data: NSArray,selectionTye: Int) {
        
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qualityVc") as! qualityVc
        
        if selectionTye == 1
        {
            controller.resolutionArray = self.resolutionArray
        }
        else
        {
            controller.resolutionArray = []
            controller.currentPlayBackSpeed = (TV_PlayerHelper.shared.mmPlayer.player?.rate) ?? 1.0
        }
        controller.delegate = self
        let sheetController = SheetViewController(controller: controller)
        sheetController.cornerRadius = 20
        sheetController.setSizes([.fixed(450)])

        let window = UIApplication.shared.keyWindow
        window?.rootViewController!.present(sheetController, animated: false, completion: nil)
    }
    
    func adViewApiHit(_ param: Parameters){

        loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.kupdateAdCounter, param) { (response) in
            DispatchQueue.main.async {
                print(response as Any)
            }
            
        }
        
    }

    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            //   txtFieldViewBottomConstraint?.constant = isKeyboardShowing ? keyboardHeight : 0
            if isKeyboardShowing{
                if UIScreen.main.nativeBounds.height > 1920{
                    bottomViewConstraints?.constant = keyboardHeight-30
                }else{
                    bottomViewConstraints?.constant = keyboardHeight-50
                }
            }
            else{
                bottomViewConstraints?.constant = 0
            }
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if self.messageArray.count-1 > 0{
                    let indexPath = NSIndexPath(item: self.messageArray.count-1, section: 0)
                    self.MyTableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelTableArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TBHomePagerCollectionViewCell", for: indexPath) as! TBHomePagerCollectionViewCell
        
        let onePost = channelTableArr[indexPath.row]

        cell.pagerImage.sd_setShowActivityIndicatorView(true)
         cell.pagerImage.sd_setIndicatorStyle(.gray)
         cell.pagerImage.sd_setImage(with: URL(string: onePost.image ?? ""), placeholderImage:  UIImage(named: "landscape_placeholder"), options: .refreshCached, completed: nil)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var dateform = dformat.string(from: oneHourAgo!)
        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
        print(dateform)
        let po = channelTableArr[indexPath.row]
        if po.channel_url != "" {
            if let urlString = po.channel_url {
                dataUrl = "\(urlString)?start=\(dateform)01:00:00+05:30&end="
//                    let url = URL(string: data)
            }
            self.selectedIndex = indexPath.row
            let url = URL(string: dataUrl)!
            self.channelUrl = url
            if adMedia.count > 0{
                if selectedIndex >= adMedia.count {
                    self.adIndex = 0
                    self.adUrl = adMedia[adIndex]
                    self.skpData = skipValue[adIndex]
                    
                } else {
                    self.adUrl = adMedia[selectedIndex]
                    self.skpData = skipValue[selectedIndex]
                }
                self.adDecreaseCounting(urlStr: adUrl)
            }else{
                playVideo(hlsUrl: dataUrl)
//                TV_PlayerHelper.shared.mmPlayer.set(url: url)
//                TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
//                TV_PlayerHelper.shared.mmPlayer.resume()
//                TV_PlayerHelper.shared.mmPlayer.player?.play()
            }


            post = channelTableArr[indexPath.row]
            channelDidChanged()
            observeMessage()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
            UserDefaults.standard.setValue(indexPath.row, forKey: "channelIndex")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80 , height: 60)
        
        
    }
}


extension TB_TVPlayerVC{
    
    func composeMessage()  {
        
        let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel)
        
        print(ref)
        let childRef = ref.childByAutoId()
        
        let currentTimeStamp = Date().toMillis()
        
        if currentUser.result!.id != nil && currentUser.result!.id != "" && currentUser.result!.username != nil && currentUser.result!.username != ""{
            
            let values = [ "from" : currentUser.result!.id!,
                           "img" : currentUser.result!.profile_picture ?? "",
                           "message" : "\(txtViewChat.text!)",
                "name" : currentUser.result!.username!,
                "seen" : false,
                "status":"1",
                "time":currentTimeStamp as Any,
                "type":"text"] as [String : Any]
            
            childRef.updateChildValues(values)
            txtViewChat.text = ""
            Toast.show(message: "Your comment posted successfully", controller: self)
            
        }else{
            AlertController.alert(title: "Username not found", message: "Please Update your profile to continue live chat")
            
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            
        }
    }
}


extension TB_TVPlayerVC{
    func observeMessage()
    {
        self.messageArray.removeAll()
        self.MyTableView.reloadData()
        var ref: FIRDatabaseQuery

        
        if FirebaseChannel.isEmpty{
            ref = FIRDatabase.database().reference().child("sanskarliveChannels").child("sanskarTV").queryLimited(toLast: 50)
            print("ref:::::",ref)
            
        }
        else {
            ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel).queryLimited(toLast: 50)
        }

        ref.removeAllObservers()
        ref.observe(.childAdded, with: { (snapshot) in
            var dic = snapshot.value as? [String: AnyObject]
            
            if self.isTrue == false{
                self.isTrue = true
                return
            }
            
            if dic != nil{
                dic?["key"] = "\(snapshot.key)" as AnyObject
                self.messageArray.append(messageModel(dict: dic!))
                self.MyTableView.reloadData()
                if self.messageArray.count != 0 && self.messageArray.count>=2{
                    let indexPath = NSIndexPath(item: self.messageArray.count-1, section: 0)
                    self.MyTableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
        })
    }
}


// MARK:- Table View Delegate.
extension TB_TVPlayerVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReciever = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
        
        
        cellReciever.reportButton.tag = indexPath.row
        cellReciever.reportButton.addTarget(self, action: #selector(reportActionBtn), for: .touchUpInside)
        let urlString = messageArray[indexPath.row].img
        
        cellReciever.ProfilePic.sd_setIndicatorStyle(.gray)
        cellReciever.ProfilePic.sd_setShowActivityIndicatorView(true)
        cellReciever.ProfilePic.layer.cornerRadius = 25.0
        cellReciever.ProfilePic.clipsToBounds = true
        cellReciever.ProfilePic.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "profile"), options: .refreshCached, completed: nil)
        
        let timeStamp = messageArray[indexPath.row].time
        
        let date = Date(timeIntervalSince1970: Double(Int(timeStamp)!/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate : String = dateFormatter.string(from: date)
        let datenow = dateFormatter.date(from: localDate)
        let timeValue = (datenow)!.getElapsedInterval()
        
        
        cellReciever.TimeLabel.text = timeValue
        cellReciever.messageLabel.text = messageArray[indexPath.row].message
        cellReciever.NameLabel.text = messageArray[indexPath.row].name
        
        return cellReciever
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func reportActionBtn(_ sender:UIButton){
        
        index = sender.tag
        
        if currentUser.result?.id == messageArray[self.index].from{
            let alert = UIAlertController.init(title: "Take Action", message: "", preferredStyle: .actionSheet)
            let Delete = UIAlertAction.init(title: "Delete", style: .default) { (action) in
                print("Delete")
                self.chatKey = self.messageArray[self.index].key
                self.DeleteMessage()
                self.messageArray.remove(at: self.index)
                self.MyTableView.reloadData()
            }
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                print("Cancel")
            }
            alert.addAction(Delete)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        else{
            
            let alert = UIAlertController.init(title: "Take Action", message: "", preferredStyle: .actionSheet)
            let Report = UIAlertAction.init(title: "Report", style: .default) { (action) in
                
                let chat_node = self.messageArray[self.index].key
                let reported_to = self.messageArray[self.index].from
                let message = self.messageArray[self.index].message
                let reported_by = currentUser.result?.id!
                
                var param : Parameters
                param = ["reported_by":reported_by as Any,"reported_to":reported_to,"channel_id":post.id,"node_id":chat_node,"message":message,"fb_channel_id":FirebaseChannel]
                
                self.reportAPI(param: param)
            }
            
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                print("Cancel")
            }
            alert.addAction(Report)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func reportAPI(param : Parameters){
        
        let url = APIManager.sharedInstance.chat_report
        
        self.uplaodData1(url, param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    Toast.show(message: JSON.value(forKey: "message") as? String ?? "reported", controller: self)
                }
            }
        }
    }
    
    func deleteChatAPI(param : Parameters){
        let url = APIManager.sharedInstance.delete_chat_report
        
        self.uplaodData1(url, param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    
                }
            }
        }
    }
    
}

extension TB_TVPlayerVC{
    
    func DeleteMessage()  {
        
        var param : Parameters
        param = ["node_id":chatKey]
        deleteChatAPI(param: param)
        
        isTrue = false
        let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel).child(chatKey)
        ref.removeValue()
        
    }
}


class messageModel:NSObject{
    
    var from = ""
    var img = ""
    var message = ""
    var name = ""
    var seen = ""
    var status = ""
    var time = ""
    var type = ""
    var key = ""
    
    init(dict: [String: AnyObject]) {
         
        self.from    = dict.validatedValue("from")
        self.img     = dict.validatedValue("img")
        self.message = dict.validatedValue("message")
        self.name    = dict.validatedValue("name")
        self.seen    = dict.validatedValue("seen")
        self.status  = dict.validatedValue("status")
        self.time    = dict.validatedValue("time")
        self.type    = dict.validatedValue("type")
        self.key     = dict.validatedValue("key")
        
        
    }
    
}

/*
 if FirebaseChannel.isEmpty{
     let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child("sanskarTV").queryLimited(toLast: 50)

 }
 else{
     let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel).queryLimited(toLast: 50)

 }
 */
//extension UITextView {
//
//   func addDoneButtonOnKeyboard() {
//       let keyboardToolbar = UIToolbar()
//       keyboardToolbar.sizeToFit()
//       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//           target: nil, action: nil)
//       let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
//           target: self, action: #selector(resignFirstResponder))
//       keyboardToolbar.items = [flexibleSpace, doneButton]
//       self.inputAccessoryView = keyboardToolbar
//   }
//}
