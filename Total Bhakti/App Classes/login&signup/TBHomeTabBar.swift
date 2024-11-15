//
//  TBHomeTabBar.swift
//  Total Bhakti
//
//  Created by Sudeep  on 8/12/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBHomeTabBar: UITabBarController,UITabBarControllerDelegate {
    
    @IBOutlet var minimizePlayerView: TBMinimizePlayerView!
    
    @IBOutlet weak var stackViewTopConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var liveViewHeight: NSLayoutConstraint!
    @IBOutlet weak var liveViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var liveViewtop: NSLayoutConstraint!
    
    @IBOutlet var MiniTVView: UIView!
    @IBOutlet var MiniTVPlayer: UIView!
    @IBOutlet var moveGestureView: UIView!
    
    @IBOutlet var playPauseBtnMiniTV: UIButton!
    
    @IBOutlet var cancelplayerbtn: UIButton!
    
    @IBOutlet var CustomTabbarView: UIView!
    @IBOutlet var liveView: UIView!
    var categoryDataArray : [CategoryModel] = []
    @IBOutlet var img_home: UIImageView!
    @IBOutlet var img_premium: UIImageView!
    @IBOutlet var img_videos: UIImageView!
    @IBOutlet var img_bhajan: UIImageView!
    @IBOutlet var img_guru: UIImageView!
    @IBOutlet var img_shorts: UIImageView!
    
    @IBOutlet var home_lbl: UILabel!
    @IBOutlet var premium_lbl: UILabel!
    @IBOutlet var videos_lbl: UILabel!
    @IBOutlet var bhajan_lbl: UILabel!
    @IBOutlet var livetvlbl: UILabel!
    @IBOutlet weak var shortslbl:UILabel!
    
    @IBOutlet weak var oldStackView: UIStackView!
    @IBOutlet weak var newStackView: UIStackView!
    var premiumBool = false
    static private(set) var currentInstance: TBHomeTabBar?
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 50
        let coordinate = CGPoint.init(x: x, y:  y)
        return coordinate
    }()
    var top = CGFloat()
    
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
//        if is_premium_active == "1"{
//
//
//            oldStackView.isHidden = false
//            newStackView.isHidden = true
//        }
//        else{
//            oldStackView.isHidden = true
//            newStackView.isHidden = false
//        }
//
        TBHomeTabBar.currentInstance = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(HideTV), name: NSNotification.Name("HideTVPlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidetabbar), name: NSNotification.Name("hidetabbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showtabbar), name: NSNotification.Name("showtabbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideminiplayershorts), name: NSNotification.Name("hideminiplayershorts"), object: nil)
        
        let window = UIApplication.shared.keyWindow
        top = (window?.safeAreaInsets.top)!+60+54
        
        self.minimizePlayerView.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        img_home.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        customTabbar()
        notificationForChatDecision()
        miniTVConfi()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(DidmoveTVView))
        moveGestureView.addGestureRecognizer(gesture)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(DidTapTVView))
        moveGestureView.addGestureRecognizer(tapGesture)
        playPauseBtnMiniTV.isHidden = true
        cancelplayerbtn.isHidden = true
    }
    
    @IBAction func cancelplayerbtnaction(_ sender: UIButton) {
      //  NotificationCenter.default.addObserver(self, selector: #selector(HideTV), name: NSNotification.Name("HideTVPlayer"), object: nil)
        hideMiniTV()
    }
    @IBAction func playPauseActionTVMini(_ sender:UIButton){
        if TV_PlayerHelper.shared.mmPlayer.player?.timeControlStatus == .playing{
            self.playPauseBtnMiniTV.setImage(UIImage(named: "audio_play"), for: .normal)
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
        }else{
            TV_PlayerHelper.shared.mmPlayer.player?.play()
            self.playPauseBtnMiniTV.setImage(UIImage(named: "audio_pause"), for: .normal)
        }
    }
    func hideMiniTV() {
        UIView.animate(withDuration: 0.3) {
            self.MiniTVView.alpha = 0.0
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
            TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.MiniTVView.frame = CGRect(x: self.view.frame.width - 192, y: self.view.frame.height - self.CustomTabbarView.frame.height - 108, width: 192, height: 108)
        }
        // Add any additional cleanup or stopping logic here
    }
    func miniTVConfi(){
        self.MiniTVView.frame = CGRect(x: self.view.frame.width-192, y: self.view.frame.height-self.CustomTabbarView.frame.height-108, width: 192, height: 108)
        MiniTVView.alpha = 0.0
        self.view.addSubview(MiniTVView)
    }
    @objc func HideTV(){
        MiniTVView.alpha = 0.0
        if selectedIndex != 0{
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        }
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
    }
    @objc func hidetabbar(){
        CustomTabbarView.isHidden = true
    }
    @objc func showtabbar() {
        CustomTabbarView.isHidden = false
    }
    @objc func hideminiplayershorts(){
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        self.MiniTVView.isHidden = true
    }
    func customTabbar(){
        let origin =  self.tabBar.frame.origin.y
        let size = self.tabBar.frame.size
        CustomTabbarView.frame.origin.y = origin
        CustomTabbarView.frame.origin.x = 0
        CustomTabbarView.frame.size.height = size.height
        CustomTabbarView.frame.size.width = self.tabBar.frame.size.width
        if UIScreen.main.nativeBounds.height >= 1792{
 //            stackViewTopConstrant.constant = 5.0
            
//            liveViewtop.constant = -20.0
            
//            liveViewHeight.constant = 60.0
//            liveViewWidth.constant = 60.0
            
            CustomTabbarView.frame.origin.y = origin-30
            CustomTabbarView.frame.size.height = size.height+30
            self.tabBar.alpha = 0
        }
        
        self.view.addSubview(CustomTabbarView)
    }
    @objc func DidmoveTVView(_ sender:UIPanGestureRecognizer){
        let point = sender.location(in: view)
        
        if point.x >= self.view.frame.width-192{
            return
        }
        self.MiniTVView.frame.origin.x = point.x
        
        if sender.state == .ended {
            if point.x < self.view.frame.width-200{
                UIView.animate(withDuration: 0.3) {
                    self.MiniTVView.frame.origin.x = 0
                    self.MiniTVView.alpha = 0
                    TV_PlayerHelper.shared.mmPlayer.player?.pause()
                    TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
                    TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    self.MiniTVView.frame = CGRect(x: self.view.frame.width-192, y: self.view.frame.height-self.CustomTabbarView.frame.height-108, width: 192, height: 108)
                    
                }
                exact = exactTime()
                guard let playTime = UserDefaults.standard.value(forKey: "playTime") as? Int else {return}
                guard let contentId = UserDefaults.standard.value(forKey: "contentID") as? String else {return}
                let total = exact - playTime
                let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "3","media_id": contentId,"device_type":"2","video_status": "0","total_play": "\(total)"]
                hitPlayTime(playParm)
            }
            
        }
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
    
    @objc func DidTapTVView(_ sender:UITapGestureRecognizer){
        
        if playPauseBtnMiniTV.isHidden{
            
            UIView.animate(withDuration: 0.3) {
                self.playPauseBtnMiniTV.isHidden = false
                self.cancelplayerbtn.isHidden = false
                if TV_PlayerHelper.shared.mmPlayer.player?.timeControlStatus == .playing{
                    self.playPauseBtnMiniTV.setImage(UIImage(named: "audio_pause"), for: .normal)
                }else{
                    self.playPauseBtnMiniTV.setImage(UIImage(named: "audio_play"), for: .normal)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                UIView.animate(withDuration: 0.3) {
                    self.playPauseBtnMiniTV.isHidden = true
                    self.cancelplayerbtn.isHidden = true
                }
            }
            return
        }
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        fullTV()
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        if let window = UIApplication.shared.keyWindow {
            window.viewWithTag(2)?.removeFromSuperview()
            self.view.addSubview(self.minimizePlayerView)
        }
    }
    func showMiniTV(){
        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
            self.MiniTVView.alpha = 1.0
            TV_PlayerHelper.shared.mmPlayer.playView = self.MiniTVPlayer
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        }
    }
    
    @IBAction func TabBarActionButton(_ sender:UIButton){
        
        if MusicPlayerManager.shared.myPlayer.timeControlStatus == .playing  {
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            self.MiniTVView.alpha = 0.0
            NotificationCenter.default.post(name: Notification.Name("openMinimizePlayerView"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeYoutubePlayer"), object: nil)
        }
        else if TV_PlayerHelper.shared.mmPlayer.player?.timeControlStatus == .playing && sender.tag != 2 && sender.tag != 0{
            
            NotificationCenter.default.post(name: Notification.Name("hideOrizine"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeYoutubePlayer"), object: nil)
            MusicPlayerManager.shared.myPlayer.pause()
            MusicPlayerManager.shared.isPaused = true
            showMiniTV()
        }
        else{
        }
        
        if sender.tag == 0{
            
            if selectedIndex == 0{
                popAllpushVCFromTabbar()
            }else{
                self.selectedIndex = 0
            }
            
            if ((TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.topViewController as? TBChannelListVC) != nil{
                if TV_PlayerHelper.shared.mmPlayer.player?.timeControlStatus == .playing{
                    self.MiniTVView.alpha = 1.0
                }
            }else{
                self.MiniTVView.alpha = 0.0
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
            }
            prePum = ""
            UIView.animate(withDuration: 0.6) {
                
                self.img_home.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_shorts.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_videos.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_guru.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
              //  self.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                
                self.home_lbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.bhajan_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.shortslbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            }
        }
        else if sender.tag == 1{ //Video
            if selectedIndex == 1{
                popAllpushVCFromTabbar()
            }else{
                self.selectedIndex = 1
            }
            UIView.animate(withDuration: 0.6) {
                self.img_home.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_shorts.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_videos.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        self.img_videos.image = UIImage(named: "video_active")
                        
                self.img_guru.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
          //      self.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.shortslbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.home_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.bhajan_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
               self.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)

            }
        }
        else if sender.tag == 2{  // livetv
            prePum = ""
            self.livetvlbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.home_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.bhajan_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.shortslbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
            fullTV()
            return
        }
        else if sender.tag == 3{ //shorts
            
            if selectedIndex == 2{
                popAllpushVCFromTabbar()
            }else{
                self.selectedIndex = 2
            }
            
            UIView.animate(withDuration: 0.6) {
                
                self.img_home.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_shorts.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_videos.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_guru.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
              //  self.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)

                self.home_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.shortslbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.bhajan_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)

            }
        }
        else if sender.tag == 4{ // bhajan
            
            if selectedIndex == 3{
                popAllpushVCFromTabbar()
            }else{
                self.selectedIndex = 3
            }
            UIView.animate(withDuration: 0.6) {
                
                self.img_home.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_shorts.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_videos.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_guru.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             //   self.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)

                self.home_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.videos_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.shortslbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)

            }
            
        }
        else if sender.tag == 5{ // premium

            if selectedIndex == 4{
                popAllpushVCFromTabbar()
            }else{
                self.selectedIndex = 4
            }

            UIView.animate(withDuration: 0.6) {
                DispatchQueue.main.async {
                    self.MiniTVView.alpha = 0.0
                    TV_PlayerHelper.shared.mmPlayer.player?.pause()
                }
                self.img_home.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_shorts.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_videos.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.img_guru.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
          //      self.img_premium.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             //   self.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)

                self.home_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.bhajan_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.premium_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            }
            
        }
        else{
            
        }
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
        
    }
    
    
    func fullTV(){
        if epgIos == "1" {
            if channelTableArr.count == 0{
                return
            }
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MXVc") as! MXVc
            vc.modalPresentationStyle = .overFullScreen
            vc.completionBlock = {() -> ()in
                if self.selectedIndex == 0{
                    self.MiniTVView.alpha = 0.0
                    if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
                    }
                }else{
                    if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                        if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                            self.MiniTVView.alpha = 1.0
                        }
                    }
                    self.MiniTVView.frame = CGRect(x: self.view.frame.width-192, y: self.view.frame.height-self.CustomTabbarView.frame.height-108, width: 192, height: 108)
                    TV_PlayerHelper.shared.mmPlayer.playView = self.MiniTVPlayer
                    TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
                    
                }
            }
            
            vc.completionBlock2 = {() -> ()in
                if currentUser.result!.id! == "163"{
                    
                    if self.selectedIndex != 0{
                        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                            if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                                self.MiniTVView.alpha = 1.0
                            }
                        }
                    }else{
                        if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
                        }
                    }
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
//                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }

                    
                }else{
                    
                    if self.selectedIndex != 0{
                        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                            if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                                self.MiniTVView.alpha = 1.0
                            }
                            
                        }
                    }else{
                        
                        if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
                        }
                    }
                    
                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPROFILEVC)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            self.MiniTVView.alpha = 0.0
            (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        }else{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TB_TVPlayerVC") as! TB_TVPlayerVC
            vc.modalPresentationStyle = .overFullScreen
            vc.completionBlock = {() -> ()in
                if self.selectedIndex == 0{
                    self.MiniTVView.alpha = 0.0
                    if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
                    }
                }else{
                    if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                        if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                            self.MiniTVView.alpha = 1.0
                        }
                    }
                    self.MiniTVView.frame = CGRect(x: self.view.frame.width-192, y: self.view.frame.height-self.CustomTabbarView.frame.height-108, width: 192, height: 108)
                    TV_PlayerHelper.shared.mmPlayer.playView = self.MiniTVPlayer
                    TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
                    
                }
            }
            
            vc.completionBlock2 = {() -> ()in
                if currentUser.result!.id! == "163"{
                    
                    if self.selectedIndex != 0{
                        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                            if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                                self.MiniTVView.alpha = 1.0
                            }
                        }
                    }else{
                        if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
                        }
                    }
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
//                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }

                    
                }else{
                    
                    if self.selectedIndex != 0{
                        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                            if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                                self.MiniTVView.alpha = 1.0
                            }
                            
                        }
                    }else{
                        
                        if TV_PlayerHelper.shared.mmPlayer.player!.rate == 1.0{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayTV"), object: nil)
                        }
                    }
                    
                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPROFILEVC)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            self.MiniTVView.alpha = 0.0
            (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        }
        

    }
    

    
    func popAllpushVCFromTabbar(){
        
        let vc = (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)
        vc?.popToRootViewController(animated: true)
    }
    
}


