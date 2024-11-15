//
//  TBMusicPlayerVC.swift
//  Total Bhakti
//
//  Created by Viru on 12/03/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import Foundation
import MediaPlayer
import CoreData
import CircleProgressView
import AVKit
import SDWebImage
import GoogleMobileAds
import CLTypingLabel


class TBMusicPlayerVC: UIViewController {
    
    @IBOutlet weak var playOrPaush_Btn: UIButton!
    @IBOutlet weak var previous_Btn: UIButton!
    @IBOutlet weak var next_Btn: UIButton!
    @IBOutlet weak var like_Btn: UIButton!
    @IBOutlet weak var addPlay_ListBtn: UIButton!
    @IBOutlet weak var download_Btn: UIButton!
    @IBOutlet weak var current_TimeLbl: UILabel!
    @IBOutlet weak var duration_Lbl: UILabel!
    @IBOutlet weak var song_Lbl: CLTypingLabel!
    @IBOutlet weak var artist_Lbl: UILabel!
    @IBOutlet weak var radioImg: UIImageView!
    @IBOutlet weak var recomendLbl: UILabel!
    
    @IBOutlet weak var download_Lbl: UILabel!
    @IBOutlet weak var likes_Lbl: UILabel!
    @IBOutlet weak var playlist_Lbl: UILabel!
    
    @IBOutlet weak var dropdown_img: UIImageView!
    
    @IBOutlet weak var MyTableView : UITableView!
    @IBOutlet weak var myView : UIView!
    
    @IBOutlet weak var btnHolderView: UIView!
    
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var Activityloader: UIActivityIndicatorView!
    @IBOutlet weak var downloadProgress: CircleProgressView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var listCollection: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var repeatBtn: UIButton!
    @IBOutlet weak var shuffleBtn: UIButton!
    @IBOutlet weak var downView: UIView!
    
    
    //MARK:- @IBOutlet Ads view on music player
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adImgView1: UIView!
    @IBOutlet weak var imgInside: UIImageView!
    @IBOutlet weak var cancelBtnView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    var playPauseBool = false
    var isLikes = ""
    //add_playlist
    var isOpen = false
    var isStartAd: Bool = false
    
    var viewcontroller = UIViewController()
    var totalLikes = Int()
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    var timer: Timer?
    var item = Int()
    var tap: Bool = false
    var repeatCount : Int = 0
    var shuffleCount: Int = 0
    var shufTap: Bool = true
    var count: Int = 0
    var imgMedia = [String]()
    var imgId = [String]()
    var adId : String = ""
    var imgURl:String = ""
    var adIndex: Int = 0
    var sChange: Bool = true
    var radioIm: String?
    var coming : String?
    var newTime = Timer()
    var musicurl = ""
    var isSeeking = false
    
    
    
    
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(musicurl)
//        self.Slider.minimumValue = 0
        //        previous_Btn.setImage(UIImage(named: "backward"), for: .normal)
        MusicPlayerManager.shared.songDidChnagedFromNotification = { [weak self] ()  in
            self?.UpdatePlayerUI()
            self?.setupTimer()
            self?.setupSlider()
        }
//        btnHolderView.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 5)
        radioImg.isHidden = true
        listCollection.reloadData()
        listCollection.dataSource = self
        listCollection.delegate = self
        downView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(disMissView))
        tapGesture1.delegate = self
        adView.addGestureRecognizer(tapGesture1)
//        scrollView.alwaysBounceHorizontal = false
//        scrollView.bounces = false
        btnHolderView.layer.cornerRadius = btnHolderView.frame.height/5
        btnHolderView.clipsToBounds = true
        
        if MusicPlayerManager.shared.isDownloadedSong{
            download_Btn.isUserInteractionEnabled = false
        }else{
            download_Btn.setImage(UIImage(named: "download_audio"), for: .normal)
        }
        adView.isHidden = true
        setupTimer()
        Activityloader.startAnimating()
        playOrPaush_Btn.setImage(UIImage(named:"audio_pause"), for: .normal)
//        MusicPlayerManager.shared.Slider = Slider
        pagerViewUIsetup()
        
        
        if  MusicPlayerManager.shared.isPlayList{
            addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
            addPlay_ListBtn.isUserInteractionEnabled = false
            playlist_Lbl.text = "Added to PlayList"
        }
        
        if goToRadio == "radio" {
            radioImg.isHidden = false
            radioImg.sd_setImage(with: URL(string: roImg), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            btnHolderView.isHidden = true

            recomendLbl.isHidden = true
            pagerView.isHidden = true
            song_Lbl.text = "Satsang Radio"
        }else{
    //        Slider.isHidden = false
            pagerView.isHidden = false
            PlayNextAutomatic()
        }

    }
    
    @IBAction func repeatAction(_ sender: UIButton) {
        repeatCount += 1
        if sender.isTouchInside {
            if repeatCount == 1 {
                tap = true
                self.repeatBtn.tintColor = .red
            }else{
                repeatCount = 0
                tap = false
                self.repeatBtn.tintColor = UIColor.systemOrange
            }
        }
        
    }
    
    @IBAction func shuffle(_ sender: UIButton){
        shuffleCount += 1
        if sender.isTouchInside {
            if shuffleCount == 1 {
                shufTap = true
                self.shuffleBtn.tintColor = .red
            }else{
                shuffleCount = 0
                tap = false
                self.shuffleBtn.tintColor = UIColor.systemOrange
            }
        }
        
    }
    
    @IBAction func forward_fifteenSec(_ sender:UIButton){
        
        let time =  CMTimeMake(Int64(15), 1)
        let forwardTime = time+MusicPlayerManager.shared.myPlayer.currentTime()
        MusicPlayerManager.shared.myPlayer.seek(to: forwardTime, completionHandler: { [unowned self] (finish) in
            
        })
        
        if playPauseBool == true{
            MusicPlayerManager.shared.myPlayer.play()
            
        }
        else{
            MusicPlayerManager.shared.myPlayer.pause()
            
        }
        
    }
    @IBAction func backward_fifteenSec(_ sender:UIButton){
        let time =  CMTimeMake(Int64(15), 1)
        let backTime = MusicPlayerManager.shared.myPlayer.currentTime()-time
        MusicPlayerManager.shared.myPlayer.seek(to: backTime, completionHandler: { [unowned self] (finish) in
            
        })
        if playPauseBool == true{
            MusicPlayerManager.shared.myPlayer.play()
            
        }
        else{
            MusicPlayerManager.shared.myPlayer.pause()
        }
        
    }
    @IBAction func dropDownAction(_ sender:UIButton){
        
        if isOpen == false{
            UIView.animate(withDuration: 0.3) {
                self.myView.frame.origin.y = self.pagerView.frame.origin.y
                self.myView.alpha = 1.0
                self.dropdown_img.image = UIImage(named: "cancel_black")
            }
            isOpen = true
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.myView.frame.origin.y = -400
                self.myView.alpha = 0.0
                self.dropdown_img.image = UIImage(named: "down_arrow")
            }
            isOpen = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163"]
        if IsPremiumAct == 1 {
            adView.isHidden = true
        }else{
            if AdStatus == 1 {
                advertiseApi(param)
            }else{
                adView.isHidden = true
                
            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideTVPlayer"), object: nil)
        
        UpdatePlayerUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        NotificationCenter.default.post(name: Notification.Name("openMinimizePlayerView"), object: nil)
    }
    
    func UpdatePlayerUI(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if MusicPlayerManager.shared.isDownloadedSong{
                if MusicPlayerManager.shared.ArrDownloadedSongs.count > 0{
                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                    self.song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].title
                    self.artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].artist_name
                    self.SonglikeOrDislike()
                    
                    let bhajanID = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].id ?? ""
                    let param : Parameters
                    param  = ["user_id": currentUser.result!.id!,"bhajan_id":bhajanID]
                    self.BhajanDetails(param)
                    
                }
            }else{
                if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                    if MusicPlayerManager.shared.Bhajan_Track_Trending.count > 0{
                        self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                        self.song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].title
                        self.artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].artist_name
                        self.SonglikeOrDislike()
                        self.AlredayDownloaded()
                        self.AlreadyAddedPlayList()
                        
                        let bhajanID = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].id
                        
                        let param : Parameters
                        param  = ["user_id": currentUser.result!.id ?? "","bhajan_id":bhajanID]
                        self.BhajanDetails(param)
                    }
                }
                else{
                    if MusicPlayerManager.shared.Bhajan_Track.count > 0{
                        self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                        self.song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].title
                        self.artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].artist_name
                        self.SonglikeOrDislike()
                        self.AlredayDownloaded()
                        self.AlreadyAddedPlayList()
                        
                        let bhajanID = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].id ?? ""
                        
                        let param : Parameters
                        param  = ["user_id": currentUser.result!.id ?? "","bhajan_id":bhajanID]
                        self.BhajanDetails(param)
                        
                    }
                }
            }
        }
    }
    
    //MARK: Music Player Ad Api hit
    
    private func advertiseApi(_ param : Parameters){
        
        self.uplaodData1(APIManager.sharedInstance.KAds, param) { [self] (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    
                    let imgData = JSON.ArrayofDict("bhajan")
                    if imgData.count > 0{
                        for index in 0..<imgData.count{
                            self.imgMedia.append(imgData[index]["media"] as? String ?? "")
                            self.imgId.append(imgData[index]["id"] as? String ?? "")
                            
                        }
                        self.imgURl = self.imgMedia.randomElement() ?? ""
                        self.adId = self.imgId.randomElement() ?? ""
                        
                    }
                    if imgMedia.count > 0 {
                        
                        if isStartAd != true {
                            presentAds()
                        }else{
                            self.adView.isHidden = true
                        }
                    }
                    
                }else {
                    
                }
            }else {
                self.addAlert(ALERTS.KERROR, message: ALERTS.KERROR.debugDescription, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    //MARK:- adView Api hit
    
    func adViewApiHit(_ param: Parameters){
        loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.kupdateAdCounter, param) { (response) in
            DispatchQueue.main.async {
                print(response as Any)
            }
            
        }
    }

    func adViewViewState(){
        UIView.animate(withDuration: 0.5) {
            self.adView.alpha = 0
        }
        self.adImgView1.isHidden = false
        self.cancelBtnView.isHidden = false
    }
    
    func presentAds(){
        UIView.animate(withDuration: 0.5) {
            self.adView.alpha = 1
        }
        self.adView.isHidden = false
        self.cancelBtnView.isHidden = true
        if adIndex >= imgMedia.count {
            self.adIndex = 0
            self.imgURl = imgMedia[adIndex]
            self.adId = imgId[adIndex]
            if let url = URL(string: self.imgURl){
                self.imgInside.sd_setImage(with: url, completed: nil)
            }
            
        }else{
            self.imgURl = imgMedia[adIndex]
            self.adId = imgId[adIndex]
            
            if let url = URL(string: self.imgURl){
                self.imgInside.sd_setImage(with: url, completed: nil)
            }
            adIndex += 1
        }
    }
    
    @IBAction func adCancelBtnPressed(_ sender: UIButton){
        disMissView()
    }
    
    @objc func disMissView()  {
        UIView.animate(withDuration: 0.3) {
            self.adView.alpha = 0
        }
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","advertisement_id": adId,"advertisement_status":"2" ]
        adViewApiHit(param)
        // Do any additional setup after loading the view.
    }
    // MARK:- confirm protocol of pagerView and cell size and animation(pagerView.transformer) type of pagerview
    func pagerViewUIsetup(){
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        let transform = CGAffineTransform(scaleX: 0.50, y: 0.70)
        self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
        pagerView.isInfinite = false
        pagerView.contentMode = .scaleAspectFill
        pagerView.isUserInteractionEnabled = true
  //              pagerView.itemSize = CGSize(width: self.view.frame.size.width, height: 300)
        pagerView.itemSize = CGSize(width: 250 , height: 250)
        pagerView.interitemSpacing = 100
        
    }
    
    func PlayNextAutomatic(){
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK:- call this function when like downloaded songs and initialize again
    func getUpdatedLocalSongs(){
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
                if let theAudio = tempAudio {
                    MusicPlayerManager.shared.ArrDownloadedSongs = theAudio
                    do{
                        try context.save()
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
        }
    }
    func SonglikeOrDislike(){
        
        if MusicPlayerManager.shared.isDownloadedSong{
            
            guard  MusicPlayerManager.shared.ArrDownloadedSongs.count != 0 else {
                return
            }
            self.download_Btn.setImage(UIImage(named : "downloaded_complete"), for: .normal)
            
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            if post.is_like == "1" {
                //                self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                self.like_Btn.tintColor = UIColor.systemOrange
                totalLikes = Int(MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].likes ?? "0")!
            }else {
                //                self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
                self.like_Btn.tintColor = UIColor.systemGray
                totalLikes = Int(MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].likes ?? "0")!
            }
            
            if self.totalLikes == 1{
                self.likes_Lbl.text = "\(self.totalLikes) like"
            }else if totalLikes == 0{
                self.likes_Lbl.text = "No like"
            }
            else{
                self.likes_Lbl.text = "\(self.totalLikes) likes"
            }
            
        }else{
            
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                guard  MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0 else {
                    return
                }
                
                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                
                if post.is_audio_playlist_exist == "1"{
                    //                    addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                    addPlay_ListBtn.tintColor = UIColor.systemOrange
                    addPlay_ListBtn.isUserInteractionEnabled = false
                    playlist_Lbl.text = "Added to PlayList"
                }
                else{
                    //                    addPlay_ListBtn.setImage(UIImage(named : "add_playlist"), for: .normal)
                    addPlay_ListBtn.tintColor = UIColor.systemGray
                    playlist_Lbl.text = "Add to PlayList"
                    addPlay_ListBtn.isUserInteractionEnabled = true
                    print("This song is not available in Play List")
                }
                if post.is_like == "1" {
                    self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes )!
                }else {
                    self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes )!
                }
                
            }
            else{
                guard  MusicPlayerManager.shared.Bhajan_Track.count != 0 else {
                    return
                }
                
                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                if post.is_like == "1" {
                    self.like_Btn.tintColor = UIColor.systemOrange
                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes ?? "0")!
                }else {
                    self.like_Btn.tintColor = UIColor.systemOrange
                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes ?? "0")!
                }
                
            }
            
            if self.totalLikes == 1{
                self.likes_Lbl.text = "\(self.totalLikes) like"
            }else if totalLikes == 0{
                self.likes_Lbl.text = "No like"
            }
            else{
                self.likes_Lbl.text = "\(self.totalLikes) likes"
            }
            
        }
    }
    
    @objc func didPlayToEnd(){
        PlayNextSong()
    }
    
    // MARK:- slider
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        isSeeking = true
               timer?.invalidate()
               let seconds = Float64(sender.value)
        let targetTime = CMTimeMakeWithSeconds(seconds, 600)
               MusicPlayerManager.shared.myPlayer.seek(to: targetTime) { _ in
                   self.isSeeking = false
                   self.setupTimer()
               }
    }
    
    @IBAction func sliderTouchDown(_ sender: UISlider) {
            timer?.invalidate()
        }

        @IBAction func sliderTouchUpInside(_ sender: UISlider) {
            isSeeking = false
            setupTimer()
        }
    
    // MARK:- Download Action Button
    @IBAction func downloadActionBtn(_ sender: UIButton) {
        
        if MusicPlayerManager.shared.isDownloadedSong{
            return
        }
        
        if currentUser.result!.id! == "163"{
            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
            if sms == "1"{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.Kloginvc)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }
            return
        }
        
        downloadAudio()
        
    }
    // MARK:- Add to Play List Action Button
    @IBAction func AddPlayListActionBtn(_ sender: UIButton) {
        
        if MusicPlayerManager.shared.isDownloadedSong{
            _ = SweetAlert().showAlert("", subTitle: "bhajan is already available in download list ", style: AlertStyle.success)
            return
        }
        
        AddPlayList()
        
    }
    // MARK:- Like and Dislike Action Button
    @IBAction func LikeDislikeActionBtn(_ sender: UIButton) {
        if MusicPlayerManager.shared.isDownloadedSong{
            guard MusicPlayerManager.shared.ArrDownloadedSongs.count != 0 else {
                return
            }
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            if post.is_like == "0" {
                self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANLIKES)
            }else {
                self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANDISLIKE)
            }
        }else{
            
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                guard MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0 else {
                    return
                }
                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                if post.is_like == "0" {
                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANLIKES)
                }else {
                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANDISLIKE)
                }
            }
            else{
                guard MusicPlayerManager.shared.Bhajan_Track.count != 0 else {
                    return
                }
                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                if post.is_like == "0" {
                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANLIKES)
                }else {
                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANDISLIKE)
                }
            }
            
            
        }
    }
    
    // MARK:- Play Previous song
    @IBAction func previousAction(_ sender: UIButton) {
        
        Activityloader.isHidden = false
        playOrPaush_Btn.isHidden = true
        Activityloader.startAnimating()
        
        if MusicPlayerManager.shared.isDownloadedSong{
            
            self.item = self.pagerView.currentIndex
            if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count && self.item != 0{
                self.pagerView.scrollToItem(at: self.item-1, animated: true)
                MusicPlayerManager.shared.song_no = self.item
                song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item-1].title
                artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item-1].artist_name
                MusicPlayerManager.shared.previousSong()
                SonglikeOrDislike()
                setupTimer()
            }
        }else{
            self.item = self.pagerView.currentIndex
            
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count && self.item != 0{
                    self.pagerView.scrollToItem(at: self.item-1, animated: true)
                    MusicPlayerManager.shared.song_no = self.item
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item-1].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item-1].artist_name
                    MusicPlayerManager.shared.previousSong()
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                    setupTimer()
                }
            }
            else{
                if self.item != MusicPlayerManager.shared.Bhajan_Track.count && self.item != 0{
                    self.pagerView.scrollToItem(at: self.item-1, animated: true)
                    MusicPlayerManager.shared.song_no = self.item
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item-1].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item-1].artist_name
                    MusicPlayerManager.shared.previousSong()
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                    setupTimer()
                }
            }
            
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.Activityloader.isHidden = false
            self.Activityloader.stopAnimating()
            self.playOrPaush_Btn.isHidden = false
            
        }
        
    }
    // MARK:- Play Next song
    @IBAction func nextAction(_ sender: UIButton) {
        
        if imgMedia.count > 0 {
            if count == 3 {
                self.presentAds()
                count = 0
            }else{
                count += 1
            }
        }

        
        Activityloader.isHidden = false
        playOrPaush_Btn.isHidden = true
        Activityloader.startAnimating()
        
        
        if MusicPlayerManager.shared.isDownloadedSong{
            
            self.item = self.pagerView.currentIndex
            if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count - 1 {
                self.pagerView.scrollToItem(at: self.item+1, animated: true)
                MusicPlayerManager.shared.song_no = self.item
                song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].title
                artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].artist_name
                MusicPlayerManager.shared.nextSong()
                SonglikeOrDislike()
                setupTimer()
                
            }
        }else{
            self.item = self.pagerView.currentIndex
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count - 1 {
                    self.pagerView.scrollToItem(at: self.item+1, animated: true)
                    MusicPlayerManager.shared.song_no = self.item
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].artist_name
                    MusicPlayerManager.shared.nextSong()
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                    setupTimer()
                }
            }
            else{
                if self.item != MusicPlayerManager.shared.Bhajan_Track.count - 1 {
                    self.pagerView.scrollToItem(at: self.item+1, animated: true)
                    MusicPlayerManager.shared.song_no = self.item
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].artist_name
                    MusicPlayerManager.shared.nextSong()
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                    setupTimer()
                }
            }
            
            
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.Activityloader.isHidden = true
            self.Activityloader.stopAnimating()
            self.playOrPaush_Btn.isHidden = false
            
        }
    }
    
    //MARK:- This function will call in didPlayToEnd absorver when call
    func PlayNextSong(){
        
        Activityloader.isHidden = false
        playOrPaush_Btn.isHidden = true
        Activityloader.startAnimating()
        
        if repeatCount == 1 {
            
            if MusicPlayerManager.shared.isDownloadedSong{
                self.item = self.pagerView.currentIndex
                if MusicPlayerManager.shared.ArrDownloadedSongs.count-1 < self.item{
                    return
                }
                
                if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count - 1 {
                    self.pagerView.scrollToItem(at: self.item, animated: true)
                    MusicPlayerManager.shared.song_no = self.item
                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item].title
                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item].artist_name
                    SonglikeOrDislike()
                    pauseOrPlay()
                    
                    
                }
                
            }
            else{
                self.item = self.pagerView.currentIndex
                if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                    if MusicPlayerManager.shared.Bhajan_Track_Trending.count-1 < self.item{
                        return
                    }
                    if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count - 1 {
                        self.pagerView.scrollToItem(at: self.item, animated: true)
                        MusicPlayerManager.shared.song_no = self.item
                        song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item].title
                        artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item].artist_name
                        SonglikeOrDislike()
                        AlredayDownloaded()
                        AlreadyAddedPlayList()
                        pauseOrPlay()
                        
                    }
                }
                else{
                    if MusicPlayerManager.shared.Bhajan_Track.count-1 < self.item{
                        return
                    }
                    if self.item != MusicPlayerManager.shared.Bhajan_Track.count - 1 {
                        self.pagerView.scrollToItem(at: self.item, animated: true)
                        MusicPlayerManager.shared.song_no = self.item
                        song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item].title
                        artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item].artist_name
                        SonglikeOrDislike()
                        AlredayDownloaded()
                        AlreadyAddedPlayList()
                        pauseOrPlay()
                        
                    }
                }
                
                
                
            }
            
        }else if shuffleCount == 1 {
            if MusicPlayerManager.shared.isDownloadedSong{
                self.item = self.pagerView.currentIndex
                if MusicPlayerManager.shared.ArrDownloadedSongs.count-1 < self.item{
                    return
                }
                
                if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count - 1 {
                    self.pagerView.scrollToItem(at: self.item+1+1, animated: true)
                    MusicPlayerManager.shared.song_no = self.item+1+1
                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1+1].title
                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1+1].artist_name
                    SonglikeOrDislike()
                    pauseOrPlay()
                    
                    
                }
                
            }
            else{
                self.item = self.pagerView.currentIndex
                if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                    if MusicPlayerManager.shared.Bhajan_Track_Trending.count-1 < self.item{
                        return
                    }
                    if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count - 1 {
                        self.pagerView.scrollToItem(at: self.item+1+1, animated: true)
                        MusicPlayerManager.shared.song_no = self.item+1+1
                        song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1+1].title
                        artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1+1].artist_name
                        SonglikeOrDislike()
                        AlredayDownloaded()
                        AlreadyAddedPlayList()
                        pauseOrPlay()
                        
                    }
                }
                else{
                    if MusicPlayerManager.shared.Bhajan_Track.count-1 < self.item{
                        return
                    }
                    if self.item != MusicPlayerManager.shared.Bhajan_Track.count - 1 {
                        self.pagerView.scrollToItem(at: self.item+1+1, animated: true)
                        MusicPlayerManager.shared.song_no = self.item+1+1
                        song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1+1].title
                        artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1+1].artist_name
                        SonglikeOrDislike()
                        AlredayDownloaded()
                        AlreadyAddedPlayList()
                        pauseOrPlay()
                        
                    }
                }
             
            }
            
        }else{
            if MusicPlayerManager.shared.isDownloadedSong{
                self.item = self.pagerView.currentIndex
                if MusicPlayerManager.shared.ArrDownloadedSongs.count-1 < self.item{
                    return
                }
                
                if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count - 1 {
                    self.pagerView.scrollToItem(at: self.item+1, animated: true)
                    MusicPlayerManager.shared.song_no = self.item+1
                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].title
                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].artist_name
                    SonglikeOrDislike()
                    pauseOrPlay()
                    
                }
            }
            else{
                self.item = self.pagerView.currentIndex
                if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                    if MusicPlayerManager.shared.Bhajan_Track_Trending.count-1 < self.item{
                        return
                    }
                    if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count - 1 {
                        self.pagerView.scrollToItem(at: self.item+1, animated: true)
                        MusicPlayerManager.shared.song_no = self.item+1
                        song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].title
                        artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].artist_name
                        SonglikeOrDislike()
                        AlredayDownloaded()
                        AlreadyAddedPlayList()
                        pauseOrPlay()
                    }
                }
                else{
                    if MusicPlayerManager.shared.Bhajan_Track.count-1 < self.item{
                        return
                    }
                    if self.item != MusicPlayerManager.shared.Bhajan_Track.count - 1 {
                        self.pagerView.scrollToItem(at: self.item+1, animated: true)
                        MusicPlayerManager.shared.song_no = self.item+1
                        song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].title
                        artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].artist_name
                        SonglikeOrDislike()
                        AlredayDownloaded()
                        AlreadyAddedPlayList()
                        pauseOrPlay()
                        
                    }
                }
      
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.Activityloader.isHidden = true
            self.Activityloader.stopAnimating()
            self.playOrPaush_Btn.isHidden = false
            
        }
    }
    
    //MARK:- timer for slider.
    func setupTimer() {
           timer = Timer(timeInterval: 0.001, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
           RunLoop.current.add(timer!, forMode: .commonModes) // Corrected to RunLoop.Mode.commonModes
       }

    @objc func tick() {
     guard !isSeeking else { return }
        
        // Update labels
        duration_Lbl.text = MusicPlayerManager.shared.duration_Lbl
        current_TimeLbl.text = MusicPlayerManager.shared.current_TimeLbl
        
        // Update slider
        if let currentTime = MusicPlayerManager.shared.myPlayer.currentItem?.currentTime().seconds,
           let duration = MusicPlayerManager.shared.myPlayer.currentItem?.duration.seconds, !duration.isNaN {
            Slider.minimumValue = 0
            Slider.maximumValue = Float(duration)
            Slider.value = Float(currentTime)
        }
        
        // Handle play/pause button and activity indicator
        if MusicPlayerManager.shared.myPlayer.currentTime().seconds == 0.0 {
            Activityloader.isHidden = false
            playOrPaush_Btn.isHidden = true
            Activityloader.startAnimating()
        } else {
            Activityloader.isHidden = true
            playOrPaush_Btn.isHidden = false
            Activityloader.stopAnimating()
        }
        
        if !MusicPlayerManager.shared.isPaused {
            if MusicPlayerManager.shared.myPlayer.rate == 0 {
                MusicPlayerManager.shared.myPlayer.play()
                Activityloader.isHidden = false
                playOrPaush_Btn.isHidden = true
                Activityloader.startAnimating()
            } else {
                Activityloader.isHidden = true
                Activityloader.stopAnimating()
                playOrPaush_Btn.isHidden = false
            }
        }
    }
        
        func setupSlider() {
        //    slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            Slider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
            Slider.addTarget(self, action: #selector(sliderTouchUpInside(_:)), for: .touchUpInside)
            Slider.addTarget(self, action: #selector(sliderTouchUpInside(_:)), for: .touchUpOutside)
        }
    
    
    func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
  
    @IBAction func PlayOrPause(_ sender:UIButton){
        
        if MusicPlayerManager.shared.isPaused{
            MusicPlayerManager.shared.myPlayer.play()
            setupTimer()
            playPauseBool = true
        }else{
            MusicPlayerManager.shared.myPlayer.pause()
            timer?.invalidate()
            playPauseBool = false
        }
        pauseOrPlay()
    }
    
    @IBAction func shareAction(_ sender:UIButton){
        
        var text = ""
        
        let web_view_bhajan = UserDefaults.standard.value(forKey: "web_view_bhajan")
        if MusicPlayerManager.shared.isDownloadedSong{
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            let id = post.id ?? ""
            text = "\(web_view_bhajan ?? "")\(id)"
        }else{
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                let id = post.id
                text = "\(web_view_bhajan ?? "")\(id)"
            }
            else{
                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                let id = post.id ?? ""
                text = "\(web_view_bhajan ?? "")\(id)"
            }
            
        }
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                //self.imageView.image = UIImage(data: data)
                let index = MusicPlayerManager.shared.song_no
                
                let img = UIImage(data: data)
                if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                    var text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].media_file
                    text += "\n" + "\(MusicPlayerManager.shared.Bhajan_Track_Trending[index].descript )"
                    let activity = UIActivityViewController(activityItems: [img as Any,text], applicationActivities: nil)
                    self.present(activity, animated: true, completion: nil)
                    
                }
                else{
                    var text = MusicPlayerManager.shared.Bhajan_Track[index].media_file ?? ""
                    text += "\n" + "\(MusicPlayerManager.shared.Bhajan_Track[index].description ?? "")"
                    let activity = UIActivityViewController(activityItems: [img as Any,text], applicationActivities: nil)
                    self.present(activity, animated: true, completion: nil)
                    
                }
                
            }
        }
    }
    
    @IBAction func backAction(_ sender:UIButton){
        NotificationCenter.default.post(name: Notification.Name("openMinimizePlayerView"), object: nil)
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("openMinimizePlayerView"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pauseOrPlay(){
        if MusicPlayerManager.shared.myPlayer.isPlaying{
            playOrPaush_Btn.setImage(UIImage(named:"audio_pause"), for: .normal)
            MusicPlayerManager.shared.isPaused = false
            Activityloader.isHidden = true
        }
        else{
            playOrPaush_Btn.setImage(UIImage(named:"audio_play"), for: .normal)
            MusicPlayerManager.shared.isPaused = true
        }
        
    }
}

//MARK:- PagerView Delegates.
extension TBMusicPlayerVC : FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
    }
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool{
        return true
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int){
        
        if MusicPlayerManager.shared.isDownloadedSong {
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if MusicPlayerManager.shared.Bhajan_Track.count != 0
                {
                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[index]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found remove song download again")
                        return
                    }
                    
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = index
                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].title
                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].artist_name
                    
                    SonglikeOrDislike()
                    setupTimer()
                }
            }
            else{
                if MusicPlayerManager.shared.Bhajan_Track.count != 0
                {
                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[index]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found remove song download again")
                        return
                    }
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = index
                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].title
                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].artist_name
                    
                    SonglikeOrDislike()
                    setupTimer()
                }
            }
         }else{
            
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0
                {
                    let posts = MusicPlayerManager.shared.Bhajan_Track_Trending[index]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found")
                        return
                    }
                    MusicPlayerManager.shared.PlayURl(url: url)
                    setupTimer()
                    
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = index
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].artist_name
                    
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                }
            }
            else{
                if MusicPlayerManager.shared.Bhajan_Track.count != 0
                {
                    let posts = MusicPlayerManager.shared.Bhajan_Track[index]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found")
                        return
                    }
                    
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    setupTimer()
                    
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = index
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[index].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[index].artist_name
                    
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                    
                }
            }
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int){
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int){
        
    }
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView){
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int){
        
        //        guard targetIndex >= 0 else {
        //            return
        //        }
        
        //        if MusicPlayerManager.shared.isDownloadedSong{
        //            song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[targetIndex].title
        //            artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[targetIndex].artist_name
        //        }else{
        //            song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[targetIndex].title
        //            artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[targetIndex].artist_name
        //        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView){
        
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView){
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView){
        
    }
}
//MARK:-  pagerView dataSource
extension TBMusicPlayerVC : FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        if MusicPlayerManager.shared.isDownloadedSong{
            return MusicPlayerManager.shared.ArrDownloadedSongs.count
        }else{
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                return MusicPlayerManager.shared.Bhajan_Track_Trending.count
            }
            else{
                return MusicPlayerManager.shared.Bhajan_Track.count
            }
        }
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        if MusicPlayerManager.shared.isDownloadedSong{
            
            let imageArray = MusicPlayerManager.shared.ArrDownloadedSongs[index].image
            if let url = URL(string: imageArray!) {
                cell.imageView?.contentMode = .scaleToFill
                // cell.imageView?.layer.cornerRadius = 12.0
                cell.imageView?.sd_setShowActivityIndicatorView(true)
                cell.imageView?.sd_setIndicatorStyle(.gray)
                cell.imageView?.clipsToBounds = true
                cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
            return cell
        }
        else{
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                let imageArray = MusicPlayerManager.shared.Bhajan_Track_Trending[index].image
                if let url = URL(string: imageArray) {
                    cell.imageView?.contentMode = .scaleToFill
                    // cell.imageView?.layer.cornerRadius = 12.0
                    cell.imageView?.sd_setShowActivityIndicatorView(true)
                    cell.imageView?.sd_setIndicatorStyle(.gray)
                    cell.imageView?.clipsToBounds = true
                    cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
            }
            else{
                let imageArray = MusicPlayerManager.shared.Bhajan_Track[index].image
                if let url = URL(string: imageArray!) {
                    cell.imageView?.contentMode = .scaleToFill
                    // cell.imageView?.layer.cornerRadius = 12.0
                    cell.imageView?.sd_setShowActivityIndicatorView(true)
                    cell.imageView?.sd_setIndicatorStyle(.gray)
                    cell.imageView?.clipsToBounds = true
                    cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
            }
        }
        return cell
    }
}
//MARK:- Extension For Download song function

extension TBMusicPlayerVC{
    
    //MARK:- Download all audio data.
    func downloadAudio()
    {
        if downloadProgress.progress != 0.00
        {
            self.download_Btn.isUserInteractionEnabled = true
            _ = SweetAlert().showAlert("", subTitle: " Plaese wait! Your song downloading in progress", style: AlertStyle.error)
            return
        }
        
        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
            let tempData = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
            
            let context = appDelegate.persistentContainer.viewContext
            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
                
                if let theAudio = tempAudio {
                    
                    if let audioUrl = URL(string: tempData.media_file) {
                        // MARK:-  then lets create your document folder url
                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // MARK:- lets create your destination file url
                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                        print(destinationUrl)
                        
                        // MARK:- to check if it exists before downloading it
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            print("The file already exists at path")
                            self.download_Btn.isUserInteractionEnabled = true
                            _ = SweetAlert().showAlert("", subTitle: "This Audio Already Downloaded", style: AlertStyle.success)
                        }
                        else
                        {
                            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
                            Alamofire.download(tempData.media_file , method: .get, parameters: nil,encoding: JSONEncoding.default,headers: nil,to: destination).downloadProgress(closure: { (progress) in
                                
                                self.downloadProgress.progress = Double(progress.fractionCompleted)
                                
                                
                                // MARK:-  progress closure
                                print(progress)
                            }).response(completionHandler: { (DefaultDownloadResponse) in
                                // MARK:- here you able to access the DefaultDownloadResponse
                                // MARK:- result closure
                                self.downloadProgress.progress = 0.00
                                
                                if DefaultDownloadResponse.error != nil
                                {
                                    self.downloadProgress.progress = 0.00
                                    return
                                }
                                
                                let userEntity = NSEntityDescription.entity(forEntityName: "Audio", in: context)!
                                let audio = NSManagedObject(entity: userEntity, insertInto: context)
                                audio.setValue(tempData.id, forKeyPath: "id")
                                audio.setValue(tempData.title, forKey: "title")
                                
                                if  DefaultDownloadResponse.destinationURL?.path != nil{
                                    let urlString: String =  (DefaultDownloadResponse.destinationURL?.path)!
                                    audio.setValue(urlString, forKey: "media_file")
                                    print(urlString)
                                }
                                
                                audio.setValue(tempData.artist_name, forKey: "artist_name")
                                audio.setValue(tempData.image, forKey: "image")
                                audio.setValue(tempData.is_like, forKey: "is_like")
                                audio.setValue(tempData.likes, forKey: "likes")
                                audio.setValue(tempData.artist_name, forKey: "desp")
                                
                                self.download_Btn.isUserInteractionEnabled = true
                                self.download_Btn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
                                self.download_Lbl.text = "Downloaded"
                          //  _ = SweetAlert().showAlert("", subTitle: "Your song is downloaded sucessful", style: AlertStyle.success)
                                self.handleDownloadSuccess()
                            })
                        }
                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                        
                    }
                }
                
            }
        }
        else{
            let tempData = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
            
            let context = appDelegate.persistentContainer.viewContext
            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
                
                if let theAudio = tempAudio {
                    
                    if let audioUrl = URL(string: tempData.media_file!) {
                        // MARK:-  then lets create your document folder url
                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // MARK:- lets create your destination file url
                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                        print(destinationUrl)
                        
                        // MARK:- to check if it exists before downloading it
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            print("The file already exists at path")
                            self.download_Btn.isUserInteractionEnabled = true
                            _ = SweetAlert().showAlert("", subTitle: "This Audio Already Downloaded", style: AlertStyle.success)
                        }
                        else
                        {
                            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
                            Alamofire.download(tempData.media_file! , method: .get, parameters: nil,encoding: JSONEncoding.default,headers: nil,to: destination).downloadProgress(closure: { (progress) in
                                
                                self.downloadProgress.progress = Double(progress.fractionCompleted)
                                
                                
                                // MARK:-  progress closure
                                print(progress)
                            }).response(completionHandler: { (DefaultDownloadResponse) in
                                // MARK:- here you able to access the DefaultDownloadResponse
                                // MARK:- result closure
                                self.downloadProgress.progress = 0.00
                                
                                if DefaultDownloadResponse.error != nil
                                {
                                    self.downloadProgress.progress = 0.00
                                    return
                                }
                                
                                let userEntity = NSEntityDescription.entity(forEntityName: "Audio", in: context)!
                                let audio = NSManagedObject(entity: userEntity, insertInto: context)
                                audio.setValue(tempData.id, forKeyPath: "id")
                                audio.setValue(tempData.title, forKey: "title")
                                
                                if  DefaultDownloadResponse.destinationURL?.path != nil{
                                    let urlString: String =  (DefaultDownloadResponse.destinationURL?.path)!
                                    audio.setValue(urlString, forKey: "media_file")
                                    print(urlString)
                                }
                                
                                audio.setValue(tempData.artist_name, forKey: "artist_name")
                                audio.setValue(tempData.image, forKey: "image")
                                audio.setValue(tempData.is_like, forKey: "is_like")
                                audio.setValue(tempData.likes, forKey: "likes")
                                audio.setValue(tempData.artist_name, forKey: "desp")
                                
                                self.download_Btn.isUserInteractionEnabled = true
                                self.download_Btn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
                                self.download_Lbl.text = "Downloaded"
                             //   _ = SweetAlert().showAlert("", subTitle: "Your song is downloaded sucessful", style: AlertStyle.success)
                                self.handleDownloadSuccess()
                            })
                        }
                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                        
                    }
                }
                
            }
        }
        
        
        
    }
    func handleDownloadSuccess() {
            let alert = UIAlertController(title: "Download Success", message: "Your song has been successfully downloaded.", preferredStyle: .alert)

            // Add a custom image to the alert
            if let successImage = UIImage(named: "successImage") {
                let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 40, height: 40))
                imageView.image = successImage
                alert.view.addSubview(imageView)
            }

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)

            // Present the alert
            present(alert, animated: true, completion: nil)
        }
    
}

// MARK:- if song is Alreday Downloaded

extension TBMusicPlayerVC{
    func AlredayDownloaded(){
        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
            let tempData = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
            let context = appDelegate.persistentContainer.viewContext
            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
                if let theAudio = tempAudio {
                    if let audioUrl = URL(string: tempData.media_file) {
                        // MARK:-  then lets create your document folder url
                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // MARK:- lets create your destination file url
                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                        print(destinationUrl)
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            print("The file already exists at path")
                            self.download_Btn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
                            self.download_Lbl.text = "Downloaded"
                        }else{
                            self.download_Btn.setImage(UIImage(named: "download_audio"), for: .normal)
                            self.download_Lbl.text = "Download"
                        }
                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                    }
                }
            }
            
        }
        else{
            let tempData = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
            let context = appDelegate.persistentContainer.viewContext
            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
                if let theAudio = tempAudio {
                    if let audioUrl = URL(string: tempData.media_file!) {
                        // MARK:-  then lets create your document folder url
                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // MARK:- lets create your destination file url
                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                        print(destinationUrl)
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            print("The file already exists at path")
                            self.download_Btn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
                            self.download_Lbl.text = "Downloaded"
                        }else{
                            self.download_Btn.setImage(UIImage(named: "download_audio"), for: .normal)
                            self.download_Lbl.text = "Download"
                        }
                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                    }
                }
            }
        }
        
    }
}

// MARK:- Song Like Dislike API

extension TBMusicPlayerVC{
    //MARK:- likeAnd Dislike Api For Audio(Bhajan).
    
    func likeDisLikeApi(_ apiName : String)  {
        
        
        if currentUser.result!.id! == "163"{
            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
            if sms == "1"{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNewMobileVC)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }
            
            return
        }
        
        var param : Parameters
        
        if MusicPlayerManager.shared.isDownloadedSong{
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            param = ["bhajan_id" : post.id!, "user_id" : currentUser.result!.id ?? ""]
            
        }else{
            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                
                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                param = ["bhajan_id" : post.id, "user_id" : currentUser.result!.id ?? ""]
                
            }
            else{
                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                param = ["bhajan_id" : post.id!, "user_id" : currentUser.result!.id ?? ""]
                
            }
        }
        
        viewcontroller.uplaodData(apiName, param) { (response) in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            print(response as Any)
            self.like_Btn.isUserInteractionEnabled = true
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if  JSON.value(forKey: "message") as? String == "User liked." {
                        
                        self.totalLikes = self.totalLikes + 1
                        
                        if self.totalLikes == 1{
                            self.likes_Lbl.text = "\(self.totalLikes) like"
                        }else{
                            self.likes_Lbl.text = "\(self.totalLikes) likes"
                        }
                        
                        if MusicPlayerManager.shared.isDownloadedSong{
                            self.isLikes = "1"
                            self.updateCoredata()
                        }
                        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].is_like = "1"
                            self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                        }
                        else{
                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].is_like = "1"
                            self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                            
                        }
                        
                        
                    }else{
                        self.totalLikes = self.totalLikes - 1
                        if self.totalLikes == 0{
                            self.likes_Lbl.text = "No like"
                        }else if self.totalLikes == 1 {
                            self.likes_Lbl.text = "\(self.totalLikes) like"
                        }else {
                            self.likes_Lbl.text = "\(self.totalLikes) likes"
                        }
                        
                        if MusicPlayerManager.shared.isDownloadedSong{
                            self.isLikes = "0"
                            self.updateCoredata()
                        }
                        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].is_like = "0"
                            self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
                        }
                        else{
                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].is_like = "0"
                            self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
                        }
                        
                    }
                }
            }
            
        }
    }
    
}


extension TBMusicPlayerVC{
    
    func updateCoredata(){
        
        let id =  MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].id ?? ""
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
            fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
            do {
                let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                if results?.count != 0 {
                    // Atleast one was returned
                    // In my case, I only updated the first item in results
                    results?[0].setValue("\(self.totalLikes)", forKey: "likes")
                    results?[0].setValue(isLikes, forKey: "is_like")
                    
                    getUpdatedLocalSongs()
                }
            } catch {
                print("Fetch Failed: \(error)")
            }
            
            do {
                try context.save()
            }
            catch {
                print("Saving Core Data Failed: \(error)")
            }
            
        }
    }
}


// MARK:- Add PlayList Operation
extension TBMusicPlayerVC{
    
    func AddPlayList(){
        
        var param : Parameters
        param = ["user_id":currentUser.result?.id ?? "", "type":"1", "bhajan_id":""]
        print("playList")
        if currentUser.result!.id! == "163"{
            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
            if sms == "1"{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNewMobileVC)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }
            return
        }else{
            var tempArr =  NSMutableArray()
            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if MusicPlayerManager.shared.Bhajan_Track_Trending.count == 0{
                    return
                }
            }
            else{
                if MusicPlayerManager.shared.Bhajan_Track.count == 0{
                    return
                }
            }
            
            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                
                param.updateValue("\(playingAudioTrack.id)", forKey: "bhajan_id")
                addToPlaylist(param)
                
                if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
                    tempArr = NSMutableArray.init(array: savedArray)
                    let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
                    let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
                    
                    if playListArr.count == 0 {
                        tempArr.add(playingAudioTrack.dictionaryRepresentation())
                        TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        playlist_Lbl.text = "Added to PlayList"
                        print("The song is added successfully in Play List")
                    }else{
                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        playlist_Lbl.text = "Added to PlayList"
                        print("This song is already available in Play List")
                    }
                    
                }else{
                    tempArr.add(playingAudioTrack.dictionaryRepresentation())
                    TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
                    addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                    playlist_Lbl.text = "Added to PlayList"
                    print("This song is already available in Play List")
                    
                }
                
            }
            else{
                let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                
                param.updateValue(playingAudioTrack.id ?? "", forKey: "bhajan_id")
                addToPlaylist(param)
                if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
                    tempArr = NSMutableArray.init(array: savedArray)
                    let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
                    let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
                    
                    if playListArr.count == 0 {
                        tempArr.add(playingAudioTrack.dictionaryRepresentation())
                        TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        playlist_Lbl.text = "Added to PlayList"
                        print("The song is added successfully in Play List")
                    }else{
                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        playlist_Lbl.text = "Added to PlayList"
                        print("This song is already available in Play List")
                    }
                    
                }else{
                    tempArr.add(playingAudioTrack.dictionaryRepresentation())
                    TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
                    addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                    playlist_Lbl.text = "Added to PlayList"
                    print("This song is already available in Play List")
                    
                }
                
            }
            
        }
    }
}

// MARK:- Add playlist

extension TBMusicPlayerVC {
    func addToPlaylist(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KAddRemovePlaylist , param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                
                if "\(JSON["status"]!)" == "1"{
                    
                }
                else{
                    let message = JSON["message"] as! String
                    self.addAlert(ALERTS.KERROR, message: message, buttonTitle: ALERTS.kAlertOK)
                }
                
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}
// MARK:- number of like and user liked or not and number of views

extension TBMusicPlayerVC {
    func BhajanDetails(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.get_bhajan_meta_data , param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                
                if "\(JSON["status"]!)" == "1"{
                    
                    let  data = JSON["data"]! as? Dictionary<String,Any>
                    let is_like = data!.validatedValue("is_like")
                    let likes = data!.validatedValue("likes")
                    
                    if is_like == "1" {
                        self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                    }else {
                        self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
                    }
                    
                    if likes == "1"{
                        self.likes_Lbl.text = "\(self.totalLikes) like"
                    }else if likes == "0"{
                        self.likes_Lbl.text = "No like"
                    }else{
                        self.likes_Lbl.text = "\(self.totalLikes) likes"
                    }
                    
                }
                
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}

// MARK:- if already Added in PlayList

extension TBMusicPlayerVC{
    
    func AlreadyAddedPlayList(){
        
        if MusicPlayerManager.shared.isDownloadedSong{
            return
        }
        print("playList")
        var tempArr =  NSMutableArray()
        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
            let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
            if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
                tempArr = NSMutableArray.init(array: savedArray)
                let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
                let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
                
                if playListArr.count != 0 {
                    //                    addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                    addPlay_ListBtn.tintColor = UIColor.systemOrange
                    playlist_Lbl.text = "Added to PlayList"
                    print("This song is available in Play List")
                }else{
                    //                    addPlay_ListBtn.setImage(UIImage(named : "add_playlist"), for: .normal)
                    addPlay_ListBtn.tintColor = UIColor.systemGray
                    playlist_Lbl.text = "Add to PlayList"
                    print("This song is not available in Play List")
                }
            }
        }
        else{
            let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
            if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
                tempArr = NSMutableArray.init(array: savedArray)
                let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
                let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
                
                if playListArr.count != 0 {
                    addPlay_ListBtn.tintColor = UIColor.systemOrange
                    playlist_Lbl.text = "Added to PlayList"
                    print("This song is available in Play List")
                }else{
                    addPlay_ListBtn.tintColor = UIColor.systemGray
                    playlist_Lbl.text = "Add to PlayList"
                    print("This song is not available in Play List")
                }
            }
        }
        
        
    }
}

//extension TBMusicPlayerVC:UITableViewDelegate,UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if MusicPlayerManager.shared.isDownloadedSong{
//            return  MusicPlayerManager.shared.ArrDownloadedSongs.count
//        }else{
//            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                return  MusicPlayerManager.shared.Bhajan_Track_Trending.count
//            }
//            else{
//                return  MusicPlayerManager.shared.Bhajan_Track.count
//            }
//
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "music_QueueCell") as! music_QueueCell
//
//        if MusicPlayerManager.shared.isDownloadedSong{
//            let imageArray = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].image
//            if let url = URL(string: imageArray!) {
//                cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
//            }
//            cell.songName_lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].title
//            cell.songDesc_lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].artist_name
//            return cell
//        }
//        else{
//            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                let imageArray = MusicPlayerManager.shared.Bhajan_Track_Trending [indexPath.row].image
//                if let url = URL(string: imageArray) {
//                    cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
//                }
//                cell.songName_lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row].title
//                cell.songDesc_lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row].artist_name
//
//            }
//            else{
//                let imageArray = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].image
//                if let url = URL(string: imageArray!) {
//                    cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
//                }
//                cell.songName_lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].title
//                cell.songDesc_lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].artist_name
//
//            }
//
//            return cell
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//        if MusicPlayerManager.shared.isDownloadedSong {
//            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row]
//                    let url =  posts.media_file
//
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found remove song download again")
//                        return
//                    }
//
//
//                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].title
//                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].artist_name
//
//                    MusicPlayerManager.shared.PlayURl(url: url!)
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = indexPath.row
//                    SonglikeOrDislike()
//                    setupTimer()
//
//                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
//                }
//            }
//            else{
//                if MusicPlayerManager.shared.Bhajan_Track.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row]
//                    let url =  posts.media_file
//
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found remove song download again")
//                        return
//                    }
//
//
//                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].title
//                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].artist_name
//
//                    MusicPlayerManager.shared.PlayURl(url: url!)
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = indexPath.row
//                    SonglikeOrDislike()
//                    setupTimer()
//
//                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
//                }
//            }
//
//
//
//        }else{
//
//            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row]
//                    let url =  posts.media_file
//
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found")
//                        return
//                    }
//
//
//                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row].title
//                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row].artist_name
//
//                    MusicPlayerManager.shared.PlayURl(url: url)
//                    setupTimer()
//
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = indexPath.row
//
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//
//                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
//
//                }
//
//            }
//            else{
//                if MusicPlayerManager.shared.Bhajan_Track.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.Bhajan_Track[indexPath.row]
//                    let url =  posts.media_file
//
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found")
//                        return
//                    }
//
//
//                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].title
//                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].artist_name
//
//                    MusicPlayerManager.shared.PlayURl(url: url!)
//                    setupTimer()
//
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = indexPath.row
//
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//
//                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
//
//                }
//            }
//
//
//
//        }
//    }
//
//}



//MARK: - UICollectionView
extension TBMusicPlayerVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if goToRadio != "radio" {
            if MusicPlayerManager.shared.isDownloadedSong{
                return  MusicPlayerManager.shared.ArrDownloadedSongs.count
            }else{
                if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                    return  MusicPlayerManager.shared.Bhajan_Track_Trending.count
                }
                else{
                    return  MusicPlayerManager.shared.Bhajan_Track.count
                }
                
            }
        }else{
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = listCollection.dequeueReusableCell(withReuseIdentifier: "audioCell", for: indexPath) as? audioCell else {
            return UICollectionViewCell()
        }
        
        if MusicPlayerManager.shared.isDownloadedSong{
            let imageArr = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].image
            if let Url = URL(string: imageArr ?? ""){
                cell.songImg.sd_setImage(with: Url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
        }else {
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan" {
                let imageArr = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row].image
                if let Url = URL(string: imageArr ){
                    cell.songImg.sd_setImage(with: Url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
            }else{
                
                let imageArr = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].image
                if let Url = URL(string: imageArr ?? ""){
                    cell.songImg.sd_setImage(with: Url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
            }
        }
        shadow(cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(120)
        let width = CGFloat(240)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if MusicPlayerManager.shared.isDownloadedSong {
            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0
                {
                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found remove song download again")
                        return
                    }
                    
                    
                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].title
                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].artist_name
                    
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = indexPath.row
                    SonglikeOrDislike()
                    setupTimer()
                    
                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                }
            }
            else{
                if MusicPlayerManager.shared.Bhajan_Track.count != 0
                {
                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found remove song download again")
                        return
                    }
                    
                    
                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].title
                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].artist_name
                    
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = indexPath.row
                    SonglikeOrDislike()
                    setupTimer()
                    
                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                }
            }
            
            
            
        }else{
            
            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0
                {
                    let posts = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found")
                        return
                    }
                    
                    
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[indexPath.row].artist_name
                    
                    MusicPlayerManager.shared.PlayURl(url: url)
                    setupTimer()
                    
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = indexPath.row
                    
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                    
                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                    
                }
                
            }
            else{
                if MusicPlayerManager.shared.Bhajan_Track.count != 0
                {
                    let posts = MusicPlayerManager.shared.Bhajan_Track[indexPath.row]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        AlertController.alert(title: "bhajan Path not found")
                        return
                    }
                    
                    
                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].title
                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].artist_name
                    
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    setupTimer()
                    
                    Activityloader.isHidden = false
                    Activityloader.startAnimating()
                    MusicPlayerManager.shared.song_no = indexPath.row
                    
                    SonglikeOrDislike()
                    AlredayDownloaded()
                    AlreadyAddedPlayList()
                    
                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                    
                }
            }
            
            
            
        }
    }
    
    
}

//MARK:- UIGestureRecognizerDelegate

extension TBMusicPlayerVC :  UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension TBMusicPlayerVC {
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
            
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}





extension TBMusicPlayerVC: GADBannerViewDelegate{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
