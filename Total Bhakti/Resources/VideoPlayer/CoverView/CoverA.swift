//
//  CoverA.swift
//  MMPlayerView
//
//  Created by Millman YANG on 2017/8/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import AVKit
import MMPlayerView
import AVFoundation
import Firebase
import FirebaseDatabase
import FittedSheets
import GoogleCast


class CoverA: UIView, MMPlayerCoverViewProtocol, AVRoutePickerViewDelegate {
    weak var playLayer: MMPlayerLayer?
    fileprivate var isUpdateTime = false
    static let instance = CoverA()
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var labTotal: UILabel!
    @IBOutlet weak var labCurrent: UILabel!
    
    @IBOutlet weak var liveUser_lbl: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    
    var currentTime = CMTime()
    var liveuser = 0
    
    var channelName : String?
    var liveUsers : Int?
    var count = 5
    
    
    @IBOutlet weak var LiveBtn: UIButton!
    @IBOutlet weak var skipAdView: UIView!
    @IBOutlet weak var skipAdlabel: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var eyeOpenImg: UIImageView!
    @IBOutlet weak var forwardActionBtn: UIButton!
    @IBOutlet weak var backwardActionBtn: UIButton!
    @IBOutlet weak var seekBarView: UIView!
    @IBOutlet weak var skipImg: UIImageView!
    @IBOutlet weak var airPlayButton: UIButton!

    var aaScreenRotate = false
    var isPortrait = true
    let airPlayRouteDetector = AVRouteDetector()
    var airPlayPicker = AVRoutePickerView()
    
    var maxValue = 32400.00
    var ref = FIRDatabase.database().reference()
    var firebaseBool = false
    var firebaseBoolRemove = false
    var lastChannelName = ""
    var timer = Timer()
    var last_channel_id: String?
    var current_channel_id: String?
    var tap:UITapGestureRecognizer!
    var timeUntilFire = TimeInterval()
    var direction = Direction.none
    static var playerRate = 1.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        skipImg.isHidden = true
        skipAdView.isHidden = true
        likeView.isHidden = false
//        eyeOpenImg.isHidden = false
        forwardActionBtn.isHidden = false
        backwardActionBtn.isHidden = false
        seekBarView.isHidden = false
//        liveUser_lbl.isHidden = false
        btnPlay.isHidden = false
        seekBarView.isUserInteractionEnabled = true
        btnPlay.imageView?.tintColor = UIColor.white
        //   LiveBtn.isHidden = true
        playLayer?.setCoverView(enable: true)
//        liveUser_lbl.text = "0"
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeChannel), name: NSNotification.Name("didChangeChannel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAdPlay), name: NSNotification.Name("didAdPlay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: NSNotification.Name("pauseTimer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeTimer), name: NSNotification.Name("resumeTimer"), object: nil)
        skipAdView.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        skipAdView.borderWidth = 1
        skipAdView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        skipAdView.isHidden = true
        skipAdView.roundCorners(UIRectCorner.allCorners, radius: 10)
        skipAdlabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        skipAdView.addGestureRecognizer(tap)
        
    }
    
    @objc func didAdPlay(){
        tap.isEnabled = true
        skipImg.isHidden = true
        skipAdView.isHidden = false
        skipAdlabel.isHidden = false
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CoverA.update), userInfo: nil, repeats: true)
        likeView.isHidden = true
//        eyeOpenImg.isHidden = true
        forwardActionBtn.isHidden = false
        backwardActionBtn.isHidden = false
        seekBarView.isUserInteractionEnabled = true
//        liveUser_lbl.isHidden = true
        LiveBtn.isHidden = true
    }
    
    @objc func update() {
        tap.isEnabled = false
        print("Avi Tyagi")
        if let isPlaying = TV_PlayerHelper.shared.mmPlayer.player?.isPlaying,isPlaying != true{
            return
        }
        
        let skipData = UserDefaults.standard.integer(forKey: "skipValue")
    
        
        if (skipData == 0){
            skipAdView.isHidden = true
        }else{
            var counter = UserDefaults.standard.integer(forKey: "counter")

            print("Skip ad in \(counter) and \(timer.timeInterval)")
            if(counter > 0) {

                skipAdlabel.text = "Skip ad in \(counter)"
                counter -= 1
                UserDefaults.standard.setValue(counter, forKey: "counter")
            }
            else{
                skipAdlabel.text = "Skip ad"
                skipImg.isHidden = false
                skipAdView.isUserInteractionEnabled = true
                tap.isEnabled = true
                timer.invalidate()
            }
        }
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Skip ad:::::")
        if iscoming == "tbHomeVC"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SkipAd"), object: nil)
            skipAdView.isHidden = true
            likeView.isHidden = false
            eyeOpenImg.isHidden = false
            forwardActionBtn.isHidden = false
            backwardActionBtn.isHidden = false
            seekBarView.isHidden = false
            liveUser_lbl.isHidden = false
            btnPlay.isHidden = false
            LiveBtn.isHidden = false
            seekBarView.isUserInteractionEnabled = true
        }else if iscoming == "youtube"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "youSkipAd"), object: nil)
            skipAdView.isHidden = true
            likeView.isHidden = false
            eyeOpenImg.isHidden = false
            forwardActionBtn.isHidden = false
            backwardActionBtn.isHidden = false
            seekBarView.isHidden = false
            liveUser_lbl.isHidden = false
            btnPlay.isHidden = false
            seekBarView.isUserInteractionEnabled = true
        }else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SkipTvAd"), object: nil)
            skipAdView.isHidden = true
            likeView.isHidden = false
            eyeOpenImg.isHidden = false
            forwardActionBtn.isHidden = false
            backwardActionBtn.isHidden = false
            seekBarView.isHidden = false
            liveUser_lbl.isHidden = false
            btnPlay.isHidden = false
            LiveBtn.isHidden = false
            seekBarView.isUserInteractionEnabled = true
        }
    }
    
    func resetLiveUser(){
        
        let CurrentChannel = UserDefaults.standard.value(forKey: "CurrentChannel") as? String ?? ""
        
        if  CurrentChannel != ""{
            
            if liveuser != 0{
                liveuser = liveuser - 1
                self.UpdateLiveUser(number: self.liveuser)
            }
        }
        
        let channel = FirebaseChannel
        UserDefaults.standard.setValue(channel, forKey: "CurrentChannel")
        
        // observeLiveUser()
        
    }
    //    @objc func didChangeChannel(){
    //
    //        if post == nil{
    //            likesImage.image = UIImage(named: "")
    //            likesLabel.text = ""
    //            likesLabel.isHidden = true
    //
    //            return
    //        }
    //
    //
    //        if post.is_likes == "1"{
    //            likesImage.image = UIImage(named: "audio_liked")
    //        }else{
    //            likesImage.image = UIImage(named: "white_thumb_like")
    //        }
    //        if Int(post.likes) ?? 0 > 0{
    //            likesLabel.text = post.likes + " likes"
    //            likesLabel.isHidden = false
    //            post.likes = "0"
    //        }
    //        else{
    //            likesImage.image = UIImage(named: "")
    //            likesLabel.text = ""
    //            likesLabel.isHidden = true
    //        }
    //
    //
    //        channelSelected()
    //
    //    }
    
    @objc func pauseTimer()
    {
        //Get the difference in seconds between now and the future fire date
        
//        timeUntilFire = timer.fireDate.timeIntervalSinceNow
        //Stop the timer
        timer.invalidate()
    }
    
    @objc func resumeTimer()
    {
        //Start the timer again with the previously invalidated timers time left with timeUntilFire
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CoverA.update), userInfo: nil, repeats: true)
    }
    
    
    func appforegroundAddLiveUser(){
        let channel = UserDefaults.standard.string(forKey: "channelName")
        if channel != nil && channel != ""{
            userForegroundUser(currrentFirebaseChannel: channel ?? "")
        }
    }
    func userForegroundUser(currrentFirebaseChannel: String){
        let label = self.viewWithTag(2) as? UILabel
        
        var live = 0
        //        DispatchQueue.main.async {
        
        self.ref.child("live_users_channel").child(currrentFirebaseChannel).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                
                if let snapDict = snapshot.value as? Int {
                    print("Add::",snapDict)
                    
                    let FirebaseForegroundBool =  UserDefaults.standard.bool(forKey: "FirebaseForegroundBool")
                    if FirebaseForegroundBool == true{
                        label?.text = "\(snapDict)"
                        live = snapDict + 1
                        self.ref.child("live_users_channel").child(currrentFirebaseChannel).setValue(live)
                        label?.text = "\(live)"
                        UserDefaults.standard.setValue(false, forKey: "FirebaseForegroundBool")
                    }
                    //                    else{
                    //                        self.liveUser_lbl.text = "\(snapDict)"
                    //                    }
                    
                }
            }
            
            //        if self.firebaseBool == true{
            //
            //            if currrentFirebaseChannel != UserDefaults.standard.string(forKey: "channelName"){
            //
            //            live = live + 1
            //            self.ref.child("live_users_channel").child(currrentFirebaseChannel).setValue(live)
            //
            //                if AppDelegate.instance.FirebaseForegroundBool == true{
            //                    label?.text = "\(live)"
            ////                    CoverA.instance.liveUser_lbl.text! = "\(live)"
            //                }
            //                else{
            //                    self.liveUser_lbl.text! = "\(live)"
            //                }
            //
            //            self.firebaseBool = false
            //                live = 0
            //            UserDefaults.standard.setValue(currrentFirebaseChannel, forKey: "channelName")
            //            }
            //
            //        }
        }
    }
    func removeCurrentLiveUserToOffline(){
        var liveUser = 0
        
        let lastChannel = UserDefaults.standard.string(forKey: "channelName")
        if lastChannel != "" && lastChannel != nil{
            self.ref.child("live_users_channel").child(lastChannel ?? "").observeSingleEvent(of: .value) { (snapshot) in
                
                if snapshot.exists(){
                    print("snapshot:::",snapshot)
                    
                    if let snapDict = snapshot.value as? Int {
                        liveUser = snapDict
                        print("Remove live data::",liveUser)
                        if liveUser > 0{
                            liveUser = liveUser - 1
                        }
                        
                        self.ref.child("live_users_channel").child(lastChannel ?? "").setValue((liveUser))
                        
                    }
                    
                }
            }
        } else {
            self.postRemovalUpdate()
        }
        
    }
    func removeLiveUser(){
        firebaseBoolRemove = true
        var liveUser = 0
        
        let lastChannel = UserDefaults.standard.string(forKey: "channelName")
        if lastChannel != "" && lastChannel != nil{
            self.ref.child("live_users_channel").child(lastChannel ?? "").observeSingleEvent(of: .value) { (snapshot) in
                
                if snapshot.exists(){
                    print(snapshot)
                    
                    if let snapDict = snapshot.value as? Int {
                        liveUser = snapDict
                        print("Remove live data::",liveUser)
                        if liveUser != 0{
                            self.liveUser_lbl.text = "\(liveUser)"
                        }
                        
                    }
                    
                }
                if self.firebaseBoolRemove == true{
                    
                    //                                if lastChannel != FirebaseChannel{
                    print("Live count = \(liveUser) for channel \(lastChannel ?? "")")
                    if liveUser > 0{
                        liveUser = liveUser - 1
                        
                        self.ref.child("live_users_channel").child(lastChannel ?? "").setValue((liveUser))
                        self.liveUser_lbl.text = "\(liveUser)"
                        liveUser = 0
                        UserDefaults.standard.removeObject(forKey: "channelName")
                        self.firebaseBoolRemove = false
                        self.postRemovalUpdate()
                    }
                    //                            }
                }
            }
        } else {
            self.postRemovalUpdate()
        }
        
    }
    @objc func didChangeChannel(){
  
        
        //        self.removeLiveUser()
        postRemovalUpdate()
        //        channelSelected()
    }
    
    func postRemovalUpdate() {
        firebaseBool = true
        
        if post == nil{
            return
        }
        
        
        if post.is_likes == "1"{
            likesImage.image = UIImage(named: "audio_liked")
        }else{
            likesImage.image = UIImage(named: "white_thumb_like")
        }
        likesLabel.text = post.likes + " likes"
        
        channelSelected()
    }
    
    func channelSelected(){
        
        if post == nil{
            return
        }
        if post.id == "19"{ //"id": "19","name": "Sanskar TV",
            FirebaseChannel = "Sanskar TV"
        }
        else if post.id == "20"{  //"id": "20","name": "Satsang TV",
            FirebaseChannel = "Satsang TV"
        }
        else if post.id == "21"{ //"id": "21","name": "Shubh TV",
            FirebaseChannel = "Shubh TV"
        }
        else if post.id == "22"{ //"id": "22","name": "Sanskar UK",
            FirebaseChannel = "Sanskar UK"
        }
        else if post.id == "23"{ //"id": "23","name": "Sanskar USA",
            FirebaseChannel = "Sanskar USA"
        }
        else if post.id == "24"{ //"id": "24","name": "Shubh Cinema TV",
            FirebaseChannel = "Shubh Cinema TV"
        }
        else if post.id == "25"{ //"id": "25","name": "Sanskar Web TV",
            FirebaseChannel = "Sanskar Web TV"
        }
        else if post.id == "26"{ //"id": "26","name": "Satsang Web TV",
            FirebaseChannel = "Satsang Web TV"
        }
        else if post.id == "27"{ //"id": "27","name": "Total Bhakti",
            FirebaseChannel = "Total Bhakti"
        }
        else if post.id == "29"{
            FirebaseChannel = "Sanskar Radio"
        }
        
        //        userUpdate(currrentFirebaseChannel: FirebaseChannel)
        //        continueUpdate(firebaseCurrentChannel:FirebaseChannel)
        
//              self.forwardActionBtn.isHidden = true
        self.current_channel_id = post.id
        
        last_channel_id = UserDefaults.standard.value(forKey: "last_channel_id") as? String
        if current_channel_id == last_channel_id{
            let param: Parameters = ["channel_id":current_channel_id ?? ""]
            liveUserCountApi(param)
        }
        else{
            let param: Parameters = ["user_id": currentUser.result?.id ?? "", "channel_id":current_channel_id ?? "", "last_channel_id":last_channel_id ?? ""]
//            updateLiveUserApi(param)
        }
    }
    
    //MARK:- UpdateLiveUser
    func updateLiveUserApi(_ param : Parameters) {
        self.uplaodData1(APIManager.sharedInstance.KUpdateLiveUsers , param) { (response) in
            
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    
                    UserDefaults.standard.setValue(self.current_channel_id, forKey: "last_channel_id")
                    let param: Parameters = ["channel_id":self.current_channel_id ?? ""]
                    self.liveUserCountApi(param)
                    
                }
                else{
                    
                }
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    //MARK:- UpdateLiveUser
    func removeLiveUserApi() {
        
        let last_channel_id = UserDefaults.standard.string(forKey: "last_channel_id")
        
        print("last_channel_id::",last_channel_id ?? "")
        let param: Parameters = ["user_id": currentUser.result?.id ?? "", "channel_id":"", "last_channel_id":last_channel_id ?? ""]
        
        self.uplaodData1(APIManager.sharedInstance.KUpdateLiveUsers , param) { (response) in
            
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    
                    UserDefaults.standard.setValue(self.current_channel_id, forKey: "last_channel_id")
                    let param: Parameters = ["channel_id":self.current_channel_id ?? ""]
                    self.liveUserCountApi(param)
                    
                }
                else{
                    
                }
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    //MARK:- liveUserCount
    func liveUserCountApi(_ param : Parameters) {
        self.uplaodData1(APIManager.sharedInstance.KGetLiveUserCount , param) { (response) in
            
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    guard let liveUserCount = JSON["data"] as? String else {return}
                    self.liveUser_lbl.text = liveUserCount
                    self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.liveUserTimer), userInfo: nil, repeats: true)
                    
                }
                else{
                    
                }
                
                //                self.liveUser_lbl.text = "\(liveUser)"
                
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    @objc func liveUserTimer(){
        self.timer.invalidate()
        let param: Parameters = ["channel_id":self.current_channel_id ?? ""]
        self.liveUserCountApi(param)
    }
    func continueUpdate(firebaseCurrentChannel:String){
        
        self.ref.child("live_users_channel").child(firebaseCurrentChannel).observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                
                if let snapDict = snapshot.value as? Int {
                    self.liveUser_lbl.text = "\(snapDict)"
                    
                }
            }
        })
    }
    func userUpdate(currrentFirebaseChannel: String){
        let label = self.viewWithTag(2) as? UILabel
        
        var live = 0
        //        DispatchQueue.main.async {
        
        self.ref.child("live_users_channel").child(currrentFirebaseChannel).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                
                if let snapDict = snapshot.value as? Int {
                    print("Add::",snapDict)
                    
                    let FirebaseForegroundBool =  UserDefaults.standard.bool(forKey: "FirebaseForegroundBool")
                    if FirebaseForegroundBool == true{
                        label?.text = "\(snapDict)"
                        
                        UserDefaults.standard.setValue(false, forKey: "FirebaseForegroundBool")
                    }
                    else{
                        self.liveUser_lbl.text = "\(snapDict)"
                    }
                    live = snapDict
                    
                }
            }
            
            if self.firebaseBool == true{
                
                if currrentFirebaseChannel != UserDefaults.standard.string(forKey: "channelName"){
                    
                    live = live + 1
                    self.ref.child("live_users_channel").child(currrentFirebaseChannel).setValue(live)
                    
                    if AppDelegate.instance.FirebaseForegroundBool == true{
                        label?.text = "\(live)"
                        //                    CoverA.instance.liveUser_lbl.text! = "\(live)"
                    }
                    else{
                        self.liveUser_lbl.text! = "\(live)"
                    }
                    
                    self.firebaseBool = false
                    live = 0
                    UserDefaults.standard.setValue(currrentFirebaseChannel, forKey: "channelName")
                }
                
            }
        }
    }
    
    @IBAction func btnAction() {
        
        let isMinimize = UserDefaults.standard.value(forKey: "isMinimize") as? String ?? ""
        
        if isMinimize == "Yes"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        }
        self.playLayer?.setCoverView(enable: true)
        self.playLayer?.delayHideCover()
        if playLayer?.player?.rate == 0{
            self.playLayer?.player?.play()
            exact = getTime()
            UserDefaults.standard.set(exact, forKey: "playTime")
        }
        else {
            self.playLayer?.player?.pause()
            exact = getTime()
            guard let playTime = UserDefaults.standard.value(forKey: "playTime") as? Int else {return}
            guard let contentId = UserDefaults.standard.value(forKey: "contentID") as? String else {return}
            let total = exact - playTime
            let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "3","media_id": contentId,"device_type":"2","video_status": "0","total_play": "\(total)"]
            hitPlayTime(playParm)
        }
    }
    
    @IBAction func LiveActionBtn() {
        if playLayer?.playUrl != nil{
            playLayer!.player?.seek(to: kCMTimePositiveInfinity)
        }
    }
    
    @IBAction func changeBitRateAction(_ sender:UIButton){
        if epgPlay == true {
            NotificationCenter.default.post(name: Notification.Name("epgPixelSheet"), object: nil, userInfo: nil)
        }else if prePlay == true {
            NotificationCenter.default.post(name: Notification.Name("ActionSheet"), object: nil, userInfo: nil)
        }
        else{
            NotificationCenter.default.post(name: Notification.Name("PixelActionSheet"), object: nil, userInfo: nil)
        }
        
    }
    
    func getStatus(){
        playLayer?.getOrientationChange(status: { (orientation) in
            print(orientation.desc)
            if orientation == .protrait{
                self.isPortrait = true
            }else{
                self.isPortrait = false
            }
        })
    }
    func getTime() -> Int{
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
    
    
    @IBAction func landscapPortraitAction(_ sender:UIButton){
        getStatus()
        if isPortrait{
            self.playLayer?.setOrientation(.landscapeLeft)
        }else{
            self.playLayer?.setOrientation(.protrait)
        }
    }
    
    @IBAction func forwardAction(_ sender:UIButton){
        
        let time =  CMTimeMake(Int64(15), 1)
        let forwardTime = time+currentTime
        self.playLayer?.player?.seek(to: forwardTime, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
        self.playLayer?.player?.play()
    }
    
    
    @IBAction func backwardAction(_ sender:UIButton){
        
        let time =  CMTimeMake(Int64(15), 1)
        let backTime = currentTime-time
        self.playLayer?.player?.seek(to: backTime, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
        self.playLayer?.player?.play()
    }
    @IBAction func ShareAction(_ sender: UIButton) {
        let text = "https://apps.apple.com/in/app/sanskar-tv-app/id1497508487"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(activity, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func likesAction(_ sender: UIButton) {
        self.likeDislikeAPI()
    }
    
    @available(iOS 13.0, *)
    @IBAction func airplayBtnPressed(_ sender: UIButton){
        self.playLayer?.player?.allowsExternalPlayback = true
        self.playLayer?.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        casting = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "castVideo"), object: nil)
    }
    
    @IBAction func pictureInPicturePressed(_ sender: UIPanGestureRecognizer){
        
    }
    
    
    
    // MARK: - Update BitRate
    
    func airPlay(){
        
    }
    
    @objc func updatePreferredBitRate(to value: Double) {
        
        self.playLayer?.player?.currentItem?.preferredPeakBitRate = value
         
        
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
    
    
    private func prepareAirPlayRouteDetection() {
        airPlayRouteDetector.isRouteDetectionEnabled = true
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(airplayPossibleRouteChanged),
            name:.AVRouteDetectorMultipleRoutesDetectedDidChange,
            object:nil)
        airPlayRouteDetector.isRouteDetectionEnabled = true
    }
    
    @objc func airplayPossibleRouteChanged(_ notification: Notification) {
        print("Should hide airPlayButton: \(!airPlayRouteDetector.multipleRoutesDetected)")
    }
    
    func prepareAirPlayBtn(_ sender:UIView){
        guard let button = sender as? UIView else {
            return
        }
        let alert = UIAlertController.init(title: "AirPlay", message: "", preferredStyle: .actionSheet)
        
        getStatus()
        if !isPortrait{
            alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
        }
        
        let action4 = UIAlertAction.init(title: "iphone", style: .default) { (action) in
            
        }
        
        let action = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let action1 = UIAlertAction.init(title: "", style: .default) { (action) in
            
        }
        let action3 = UIAlertAction.init(title: "", style: .default) { (action) in
            
        }
        
        
        alert.addAction(action1)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action)
        
        
        if let window = UIApplication.shared.keyWindow {
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = button
                presenter.sourceRect = button.bounds
            }
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func qualitySheet(sender:UIView){
        guard let button = sender as? UIView else {
            return
        }
        let alert = UIAlertController.init(title: "Streaming Quality", message: "", preferredStyle: .actionSheet)
        
        getStatus()
        if !isPortrait{
            alert.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2) )
        }
        
        let action4 = UIAlertAction.init(title: "Auto", style: .default) { (action) in
            self.updatePreferredBitRate(to: .leastNonzeroMagnitude)
        }
        
        let action = UIAlertAction.init(title: "Low Quality", style: .default) { (action) in
            self.updatePreferredBitRate(to: 504297.0)
        }
        let action1 = UIAlertAction.init(title: "Medium Quality", style: .default) { (action) in
            self.updatePreferredBitRate(to: 779818.0)
        }
        let action3 = UIAlertAction.init(title: "High Quality", style: .default) { (action) in
            self.updatePreferredBitRate(to: 1018534.0)
        }
        
        alert.addAction(action4)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(action3)
        
        if let window = UIApplication.shared.keyWindow {
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = button
                presenter.sourceRect = button.bounds
            }
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func currentPlayer(status: PlayStatus) {
        
        switch status {
        case .failed(err: "isloading"):
            btnPlay.isHidden = false
            seekBarView.isHidden = false
            print("Stop")
        case .playing:
            btnPlay.isHidden = false
            seekBarView.isHidden = false
            
            self.btnPlay.setImage(#imageLiteral(resourceName: "white_pause.png"), for: .normal)
            MusicPlayerManager.shared.myPlayer.pause()
            resumeTimer()
        default:
            btnPlay.isHidden = false
            seekBarView.isHidden = false

            self.btnPlay.setImage(#imageLiteral(resourceName: "white_play.png"), for: .normal)
            pauseTimer()
        }
    }
    
    
    func timerObserver(time: CMTime) {
        currentTime = time
        if let duration = self.playLayer?.player?.currentItem?.asset.duration ,
           !duration.isIndefinite ,
           !isUpdateTime {
            if self.playSlider.maximumValue != Float(duration.seconds) {
                self.playSlider.maximumValue = Float(duration.seconds)
                LiveBtn.isHidden = true
            }
            self.labCurrent.text = self.convert(second: time.seconds)
            self.labTotal.text = self.convert(second: duration.seconds-time.seconds)
            self.playSlider.value = Float(time.seconds)
            if labTotal.text == "00:00"{
                kAds = true
                if iscoming == "tbHomeVC"{
                    LiveBtn.isHidden = false
                    print(labTotal.text!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SkipAd"), object: nil)
                    skipAdView.isHidden = true
                    likeView.isHidden = false
                    eyeOpenImg.isHidden = false
                    forwardActionBtn.isHidden = false
                    backwardActionBtn.isHidden = false
                    seekBarView.isHidden = false
                    liveUser_lbl.isHidden = false
                    btnPlay.isHidden = false
                    seekBarView.isUserInteractionEnabled = true
                }else if iscoming == "youtube"{
                    print(labTotal.text!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "youSkipAd"), object: nil)
                    skipAdView.isHidden = true
                    likeView.isHidden = false
                    eyeOpenImg.isHidden = false
                    forwardActionBtn.isHidden = false
                    backwardActionBtn.isHidden = false
                    seekBarView.isHidden = false
                    liveUser_lbl.isHidden = false
                    btnPlay.isHidden = false
                    seekBarView.isUserInteractionEnabled = true
                }else if iscoming == "LiveTv"{
                    print(labTotal.text!)
                    LiveBtn.isHidden = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SkipTvAd"), object: nil)
                    skipAdView.isHidden = true
                    likeView.isHidden = false
                    eyeOpenImg.isHidden = false
                    forwardActionBtn.isHidden = false
                    backwardActionBtn.isHidden = false
                    seekBarView.isHidden = false
                    liveUser_lbl.isHidden = false
                    btnPlay.isHidden = false
                    seekBarView.isUserInteractionEnabled = true
                }

                
            }
            LiveBtn.isHidden = true
        }else{
            
            //  LiveBtn.isHidden = false
            // print("time-----> \(time.seconds)")
            if playSlider.maximumValue <= Float(time.seconds){
                playSlider.maximumValue = Float(time.seconds)
                playSlider.value = Float(time.seconds)
                
            }
            if epgLive == true {
                playSlider.maximumValue = playSlider.value
                LiveBtn.isHidden = false
                labTotal.text = "00:00:00"
                epgLive = false
            }
            self.labCurrent.text = self.convert(second: time.seconds)
        }
    }
    
    
    
    
    fileprivate func convert(second: Double) -> String {
        let component =  Date.dateComponentFrom(second: second)
        if let hour = component.hour ,
           let min = component.minute ,
           let sec = component.second {
            
            let fix =  hour > 0 ? NSString(format: "%02d:", hour) : ""
            return NSString(format: "%@%02d:%02d", fix,min,sec) as String
        } else {
            return "-:-"
        }
    }
    
    @IBAction func sliderValueChange(slider: UISlider) {
        self.playLayer?.player?.pause()
        self.isUpdateTime = true
        self.playLayer?.delayHideCover()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delaySeekTime), object: nil)
        self.perform(#selector(delaySeekTime), with: nil, afterDelay: 0.1)
    }
    
    @objc func delaySeekTime() {
        
        let time =  CMTimeMake(Int64(self.playSlider.value), 1)
        self.playLayer?.player?.seek(to: time, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
        self.playLayer?.player?.play()

    }
    
    
    func player(isMuted: Bool) {
        
    }
    func currenttime(){
//        let timeObserver = playLayer?.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
//            let currentTimeInSeconds = CMTimeGetSeconds(time)
//            print("Current Time: \(currentTimeInSeconds) seconds")
//        }
        let currenttime = self.playLayer?.player?.currentTime().value
        print(currenttime)
    }
}

extension Date {
    static func dateComponentFrom(second: Double) -> DateComponents {
        let interval = TimeInterval(second)
        let date1 = Date()
        let date2 = Date(timeInterval: interval, since: date1)
        let c = NSCalendar.current
        
        var components = c.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: date1, to: date2)
        components.calendar = c
        return components
    }
}

extension CoverA{
    //http://164.52.192.251/sanskar_staging/index.php/data_model/videos/Video_control/dislike_channel
    
    //http://164.52.192.251/sanskar_staging/index.php/data_model/videos/Video_control/like_channel
    
    func likeDislikeAPI(){
        
        if post == nil{
            return
        }
        
        var param : Parameters
        param = ["user_id":currentUser.result?.id! as Any,"channel_id":post.id]
        
        var url = "videos/Video_control/like_channel"
        if post.is_likes == "1"{
            url = "videos/Video_control/dislike_channel"
        }else{
            url = "videos/Video_control/like_channel"
        }
        
        self.uplaodData1(url, param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if post.is_likes == "1"{
                        post.is_likes = "0"
                        let likes = Int(post.likes ?? "1") ?? 1
                        let totalLike = likes-1
                        post.likes = "\(totalLike)"
                        
                    }else{
                        let likes = Int(post.likes ?? "0") ?? 0
                        let totalLike = likes+1
                        post.likes = "\(totalLike)"
                        post.is_likes = "1"
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
                
                }
            }
        }
    }
}





extension CoverA{
    func uplaodData1(_ url: String, _ param : Parameters , _ success:@escaping (_ response: Any?) -> ()) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, to: APIManager.sharedInstance.KBASEURL+url, method: .post, headers: nil,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    if let responseData = response.response {
                        switch responseData.statusCode {
                        case APIManager.sharedInstance.KHTTPSUCCESS:
                            guard let result = response.result.value else {
                                success("")
                                return
                            }
                            success(result)
                            return
                        default:
                            break
                        }
                    }
                    success(nil)
                    DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                    if let err = response.result.error as? URLError {
                        if err.code == .notConnectedToInternet || err.code == .timedOut {
                            
                        }
                    }
                }
                
            case .failure(let encodingError):
                
                success(nil)
                print("error:\(encodingError)")
            }
        })
    }
}


extension CoverA{
    func observeLiveUser()
    {
        let CurrentChannel = UserDefaults.standard.value(forKey: "CurrentChannel") as? String ?? ""
        liveuser = 0
        let ref = FIRDatabase.database().reference().child("sanskarliveUsers").child(CurrentChannel)
        ref.removeAllObservers()
        ref.observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? Int
            
            if value != nil{
                
                if self.liveuser == 0{
                    let num = value! + 1
                    print(num)
                    self.UserUpdated()
                    self.UpdateLiveUser(number: num)
                }
            }
        })
    }
}

extension CoverA{
    func UserUpdated()
    {
        let CurrentChannel = UserDefaults.standard.value(forKey: "CurrentChannel") as? String ?? ""
        liveuser = 0
        let ref = FIRDatabase.database().reference().child("sanskarliveUsers").child(CurrentChannel)
        ref.removeAllObservers()
        ref.observe(.childChanged, with: { (snapshot) in
            let value = snapshot.value as? Int
            if value != nil{
                self.liveuser = value!
                
            }
        })
    }
}



extension CoverA{
    
    func UpdateLiveUser(number : Int) {
        
        let CurrentChannel = UserDefaults.standard.value(forKey: "CurrentChannel") as? String ?? ""
        
        var param : Parameters
        param = ["count":number]
        
        let ref = FIRDatabase.database().reference().child("sanskarliveUsers").child(CurrentChannel).updateChildValues(param)
        liveuser = 0
        
        
        
    }
}
