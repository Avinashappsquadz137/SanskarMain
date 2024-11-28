//
//  newPreDetails.swift
//  Sanskar
//
//  Created by Warln on 16/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import ExpandableLabel
import YoutubePlayer_in_WKWebView
import FittedSheets


struct EncrypteResponse: Decodable {
    let data: EncrypteUrl
}

struct EncrypteUrl: Decodable {
    let encrypted_url: String
}


class newPreDetails: UIViewController, EpisodeDelegate,GetVideoQualityList, MMPlayerLayerProtocol {
    
    //MARK: IBOutlet
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var descptLbl: UILabel!
    @IBOutlet weak var goPremiumBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var playerViewheight: NSLayoutConstraint!
    
    
    //MARK: Varaiable
    
    var data: [String:Any] = [:]
    var premiumData : [freeModel] = []
    var selectedData : freeModel?
    var darshanList : LiveDarshan!
    var bandwidthArray = [String]()
    var resolutionArray = [String]()
    var allListData: [[String:Any]] = [[:]]
    var allListCount: Int = 0
    var newData: [String:Any] = [:]
    var param: Parameters = [:]
    var selectedString = ""
    var episode_id : String?
    var eposidetitle: String?
    var season_id : String?
    var playerCurrentTime: Float = 0.0
    var didSelect: Bool = false
    var selectedIndex: Int = 1
    var eToken: String = ""
    var videoDict : [String : Any] = [:]
    var promo: Bool = false
    var selectIndex: Int = 0
    var videocome:Bool = false
    var videoUrl = ""
    var selectdata = Int()
    var seasonidback = ""
    var premiumdataArr: [[String:Any]] = [[:]]
    var categorymatch = ""
    var paymentmethod = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     self.goPremiumBtn.isHidden = true
        
        print(season_id)
        print(seasonidback)
        
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","device_type":"2"]
        hitcheckpaymentapi(param)
        
        UserDefaults.standard.set(season_id, forKey: "seasonkey")
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.object(forKey: "seasonkey"))
        
        if videocome == true{
            print(videoUrl)
        }else{
            TV_PlayerHelper.shared.mmPlayer.mmDelegate = self
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(PlaySelectedChannel), name: NSNotification.Name("PlaPre"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideTVPlayer"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceiveNotification(notification:)), name: Notification.Name("ActionSheet"), object: nil)
            prePlay = true
            updateUi()
            if allListData.count > 0 {
                allListCount = 2
            }else{
                allListCount = 1
            }
        }
        goPremiumBtn.layer.cornerRadius = goPremiumBtn.frame.height/5
        goPremiumBtn.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        liveTap = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prePum = ""
        if let player = TV_PlayerHelper.shared.mmPlayer.player, player.status == .readyToPlay {
            let videotime = player.currentTime()
            let totaltime = player.currentItem?.duration
            
            let eposideide = UserDefaults.standard.string(forKey: "eposidekey") ?? ""
            UserDefaults.standard.set(selectedData?.season_id ?? "", forKey: "seasonkey")
            UserDefaults.standard.synchronize()
            let seasonId = data["season_id"] as? String ?? ""
            watchedId = seasonId
            UserDefaults.standard.set(seasonId, forKey: "season_Id")
            UserDefaults.standard.synchronize()
            let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
            print(sesiondata)
            if let sesiondata = sesiondata, !sesiondata.isEmpty {
                print(sesiondata)
                // Ensure that selectedData is not nil and season_id is a non-empty String
                let param: Parameters = [
                    "user_id": "\(currentUser.result?.id ?? "")","media_id": eposideide,"season_id": sesiondata,"pause_at": "\(videotime.seconds)","status": "0","type": "2","total_duration": "\(totaltime?.seconds ?? 0)"]
                print(param)
                continuewatching(param)
            } else if let sesiondataa = UserDefaults.standard.string(forKey: "seasonkey"), !sesiondataa.isEmpty {
                print(sesiondataa)
                // Use seasondataa if sesiondata is nil
                let param: Parameters = [
                    "user_id": "\(currentUser.result?.id ?? "")","media_id": eposideide,"season_id": sesiondataa,"pause_at": "\(videotime.seconds)","status": "0","type": "2","total_duration": "\(totaltime?.seconds ?? 0)"]
                print(param)
                continuewatching(param)
            } else {
                print("Error: Unable to retrieve valid season data from UserDefaults.")
            }
        } else {
            print("Player is not ready.")
        }
        
    }
    
    //MARK: Update UI
    
    @objc func pauseHomePlayer(){
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pausePost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseHomePlayer), name: NSNotification.Name("pausePost"), object: nil)
        
    }
    func updateUi(){
        //        playerView.delegate = self
        let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
        if selectedString == "promotion" || selectedString == "season" || ( selectedString == "category wise season") || (selectedString == "author wise season"){
            //            thumbnailImg?.sd_setImage(with: URL(string: selectedData!.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            if let seasonTitle = selectedData?.season_title, !seasonTitle.isEmpty {
                titleLbl.text = seasonTitle
            } else if let episodeTitle = selectedData?.episode_title, !episodeTitle.isEmpty {
                titleLbl.text = episodeTitle
            }
            if let description = selectedData?.description, !description.isEmpty {
                descptLbl?.text = description.trimmingCharacters(in: .whitespacesAndNewlines).html2String
            } else if let episodeDescription = selectedData?.episode_description, !episodeDescription.isEmpty {
                descptLbl?.text = episodeDescription.trimmingCharacters(in: .whitespacesAndNewlines).html2String
            }
            videoPlayer.isHidden = false
            playerView.isHidden = true
            playerView.pauseVideo()
            
            let videoURL : URL?
            if selectedData?.promo_video != ""{
                
                playVideo(url:selectedData?.promo_video ?? "", image: selectedData!.season_thumbnail ?? "")
            }
            else if selectedData?.short_video != ""{
                
                playVideo(url:selectedData?.short_video ?? "", image: selectedData!.season_thumbnail ?? "")
            }
            else{
                let urlString = selectedData?.custom_promo_video ?? ""
                if urlString == "" {
                    promo = true
                }else{
                    //                    playVideo(url: urlString.replacingOccurrences(of: " ", with: "%20") , image: selectedData!.season_thumbnail ?? "")
                    promo = true
                }
            }
        }
        if selectedString == "free"{
            if let seasonTitle = selectedData?.season_title, !seasonTitle.isEmpty {
                titleLbl.text = seasonTitle
            } else if let episodeTitle = selectedData?.episode_title, !episodeTitle.isEmpty {
                titleLbl.text = episodeTitle
            }
            if let description = selectedData?.description, !description.isEmpty {
                descptLbl?.text = description.trimmingCharacters(in: .whitespacesAndNewlines).html2String
            } else if let episodeDescription = selectedData?.episode_description, !episodeDescription.isEmpty {
                descptLbl?.text = episodeDescription.trimmingCharacters(in: .whitespacesAndNewlines).html2String
            }
            videoPlayer.isHidden = true
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            if (selectedData?.yt_episode_url ?? "") != "" {
                playerView.load(withVideoId: selectedData?.yt_episode_url ?? "",playerVars: playvarsDic)
                playerView.contentMode = .scaleToFill
                playerView.isHidden = false
            }else if selectedData?.promo_video != "" {
                let urlString = selectedData?.promo_video ?? ""
                playVideo(url: urlString, image: selectedData?.season_thumbnail ?? "")
            }else {
                guard let token = selectedData?.token else { return }
                eToken = token
                getEpisode(token: token)
            }
        }
        if selectedString == "premiumSeeMore"{
            if isComeFrom == 1 {
                if let seasonTitle = selectedData?.season_title, !seasonTitle.isEmpty {
                    titleLbl.text = seasonTitle
                } else if let episodeTitle = selectedData?.episode_title, !episodeTitle.isEmpty {
                    titleLbl.text = episodeTitle
                }
                if let description = selectedData?.description, !description.isEmpty {
                    descptLbl?.text = description.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                } else if let episodeDescription = selectedData?.episode_description, !episodeDescription.isEmpty {
                    descptLbl?.text = episodeDescription.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                }
                if data["yt_promo_video"] as? String ?? "" != "" {
                    videoPlayer.isHidden = true
                    TV_PlayerHelper.shared.mmPlayer.player?.pause()
                    guard let youtubeUrl = data["yt_promo_video"] as? String else {return}
                    playerView.load(withVideoId: youtubeUrl, playerVars: playvarsDic)
                }else{
                    videoPlayer.isHidden = false
                    playerView.isHidden = true
                    playerView.pauseVideo()
                    let videoURL: URL?
                    let image = data["season_thumbnail"] as? String ?? ""
                    if let shortVideoURL = data["short_video"] as? String, !shortVideoURL.isEmpty {
                        playVideo(url: shortVideoURL, image: image)
                    } else if let promoVideoURL = data["promo_video"] as? String, !promoVideoURL.isEmpty {
                        playVideo(url: promoVideoURL, image: image)
                    } else if let customPromoVideoURL = data["custom_promo_video"] as? String, !customPromoVideoURL.isEmpty {
                        let urlSting = customPromoVideoURL.replacingOccurrences(of: " ", with: "%20").trimmingCharacters(in: .whitespaces)
                        promo = true
                        // playVideo(url: urlSting, image: image)
                    } else {
                        // Handle the case when all video URLs are empty or nil
                        // You may want to provide a default action or log an error.
                    }
                }
                
            }else{
                titleLbl.text = selectedData?.season_title ?? ""
                //                thumbnailImg?.sd_setImage(with: URL(string: selectedData?.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                descptLbl?.text = selectedData?.description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                if selectedData?.yt_promo_video != ""{
                    videoPlayer.isHidden = true
                    TV_PlayerHelper.shared.mmPlayer.player?.pause()
                    playerView.load(withVideoId: selectedData?.yt_promo_video ?? "", playerVars: playvarsDic)
                    playerView.contentMode = .scaleToFill
                    playerView.isHidden = false
                }
                else {
                    videoPlayer.isHidden = false
                    playerView.isHidden = true
                    playerView.pauseVideo()
                    let videoURL : URL?
                    if selectedData?.promo_video != ""{
                        playVideo(url:selectedData?.promo_video ?? "", image: selectedData!.season_thumbnail ?? "")
                    }else{
                        guard let token = selectedData?.token else { return }
                        promo = true                   }
                }
            }
        }
        if selectedString == "free"{
            //selectedData?.season_id
            if selectedData == nil {
                param = ["user_id":currentUser.result?.id ?? "", "season_id": season_id, "page_no": "1","limit": "10","episode_id": selectedData?.episode_id ?? ""]
            }
            else {
                param = ["user_id":currentUser.result?.id ?? "", "season_id": selectedData?.season_id ?? "", "page_no": "1","limit": "10","episode_id": selectedData?.episode_id ?? ""]
            }
        }else if selectedString == "premiumSeeMore" {
            if type == "premiumDetail" {
                if selectedData == nil {
                    param = ["user_id":currentUser.result?.id ?? "", "season_id": season_id, "page_no": "1","limit": "10","episode_id": ""]
                } else {
                    param = ["user_id":currentUser.result?.id ?? "", "season_id":selectedData?.season_id ?? "", "page_no": "1","limit": "10","episode_id": ""]
                }
            }else{
                let seasonId = data["season_id"] as? String ?? ""
                watchedId = seasonId
                UserDefaults.standard.set(seasonId, forKey: "season_Id")
                UserDefaults.standard.synchronize()
                let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
                print(sesiondata)
                param = ["user_id":currentUser.result?.id ?? "","season_id":seasonId,"page_no":"1","limit":"50"]
                print(param)
            }
        }else{
            if selectedData == nil {
                print(UserDefaults.standard.object(forKey: "seasonkey"))
                seasonidback = UserDefaults.standard.object(forKey: "seasonkey") as? String ?? ""
                print(seasonidback)
                if seasonidback.isEmpty {
                    let sesiondata = UserDefaults.standard.string(forKey: "season_Id") ?? ""
                    print(sesiondata)
                    param = ["user_id": currentUser.result?.id ?? "", "season_id": sesiondata, "page_no": "1", "limit": "10", "episode_id": ""]
                    print(param)
                } else {
                    param = ["user_id": currentUser.result?.id ?? "", "season_id": seasonidback, "page_no": "1", "limit": "10", "episode_id": ""]
                    print(param)
                }
            }
            else{
                //        UserDefaults.standard.set(selectedData?.season_id ?? "", forKey: "seasonkey")
                //                    UserDefaults.standard.synchronize()
                //
                //         print(UserDefaults.standard.object(forKey: "seasonkey"))
                //        seasonidback = UserDefaults.standard.object(forKey: "seasonkey")
                
                param = ["user_id":currentUser.result?.id ?? "", "season_id": selectedData?.season_id ?? "", "page_no": "1","limit": "10","episode_id": ""]
            }
        }
        print(param)
        getPremiumlist(param)
        
    }
    //MARK: MMPlayer
    
    func playVideo(url: String, image: String){
        videoPlayer.isHidden = false
        DispatchQueue.global().async {
            self.getUrl(urlStrin: url)
        }
        guard let play = URL(string: url) else { return }
        print(play)
        if let pauseString = selectedData?.pause_at, let pausetime = Double(pauseString) {
            print("Received pause_at: \(pauseString), Converted pausetime: \(pausetime)")
            let targetTime = CMTime(seconds: pausetime, preferredTimescale: 1)
            print("Calculated targetTime: \(targetTime.seconds)")
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
            TV_PlayerHelper.shared.mmPlayer.set(url: play)
            TV_PlayerHelper.shared.mmPlayer.playView = self.videoPlayer
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredMaximumResolution = CGSize(width: 1280, height: 720)
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = 0
            TV_PlayerHelper.shared.mmPlayer.player?.seek(to: targetTime)
            
            setPlayerControlVisibility(true)
            TV_PlayerHelper.shared.mmPlayer.player?.play()
        } else {
            print("pause_at is nil or conversion failed. Playing from the beginning (kCMTimeZero)")
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
            TV_PlayerHelper.shared.mmPlayer.set(url: play)
            TV_PlayerHelper.shared.mmPlayer.playView = self.videoPlayer
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredMaximumResolution = CGSize(width: 1280, height: 720)
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = 0
            TV_PlayerHelper.shared.mmPlayer.player?.seek(to: kCMTimeZero)
            setPlayerControlVisibility(true)
            TV_PlayerHelper.shared.mmPlayer.player?.play()
        }
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true

    }
    
    @objc func PlaySelectedChannel() {
        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
            TV_PlayerHelper.shared.mmPlayer.playView = self.videoPlayer
            
        }else{
        }
        
    }
    
    private func setPlayerControlVisibility(_ isVisible: Bool) {
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: isVisible)
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
                    let str = dic.components(separatedBy: "\n")
                    resolutionArray.append(str[0])
                }
                var bandwith = contents.components(separatedBy: "BANDWIDTH=")
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
    @objc func methodOfReceiveNotification(notification: Notification)
    {
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        let window = UIApplication.shared.keyWindow
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoControlVc") as! VideoControlVc
        controller.delegate = self
        controller.videoDict = videoDict
        let sheetController = SheetViewController(controller: controller)
        sheetController.cornerRadius = 20
        sheetController.setSizes([.fixed(250)])
        window?.rootViewController!.present(sheetController, animated: false, completion: nil)
    }
    
    func getSeletedBitRate(bitrate: Int) {
        let resolution = resolutionArray[bitrate].components(separatedBy: "x")
        TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredMaximumResolution = CGSize(width: Double(resolution[0])!, height: Double(resolution[1])!)
        //        TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = Double(self.bandwidthArray[bitrate])!
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
    
    //MARK:Get Premium list
    func getPremiumlist(_ param : Parameters){
        self.uplaodData1(APIManager.sharedInstance.KEpisodeBySeasonId, param) { (response) in
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                // TBSharedPreference.sharedIntance.clearAllPreference()
                if JSON.value(forKey: "status") as? Bool == true {
                    
                    if let data = JSON["data"] as? [[String: Any]] {
                        print(data)
                        for item in data {
                                if let seasontitle = item["season_title"] as? String {
                                    print(seasontitle)
                                    self.titleLbl.text = seasontitle
                                }
                            }
//
                        for item in data {
                            self.categorymatch = item["category_id"] as? String ?? ""
                            
                            print(self.categorymatch)
                            UserDefaults.standard.set(self.categorymatch, forKey: "yourDesiredKey")
                            let storedCategoryMatch = UserDefaults.standard.string(forKey: "yourDesiredKey")
                            
                            let params = ["user_id":currentUser.result!.id!,"page_no":"1","limit":"50","category_id":storedCategoryMatch]
                            print(params)
                            self.hitDatamorelike(params)
                        }
                    }
                    self.premiumData.removeAll()
                    let data = JSON.ArrayofDict("data")
                    
                    let is_premium = JSON.value(forKey: "is_premium") as! Int
                    UserDefaults.standard.set(is_premium, forKey: "is_premium")
                    UserDefaults.standard.synchronize()
                    
                    let premium_is = UserDefaults.standard.string(forKey: "is_premium")
                    print(premium_is)

                    if let premiumValue = premium_is, premiumValue == "0" {
                        self.goPremiumBtn.isHidden = false
                    } else {
                        self.goPremiumBtn.isHidden = true
                    }

                    if data.count > 0{
                        _ = data.filter({ (dict) -> Bool in
                            self.premiumData.append(freeModel(dict: dict))
                            return true
                            self.updateUi()
                            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                        })
                    }
                    if self.promo == true {
                        
                        guard let token = self.premiumData.first?.token else {return}
                        self.eToken = token
                        self.getEpisode(token: token)
                    }
                 //   DispatchQueue.main.async {
                        
         //               self.tableView.reloadData()
//                    }
                }else {
                    
                    //         self.noDataFoundLbl.isHidden = false
                }
            }else {
                
            }
        }
    }
    func hitDatamorelike(_ param : Parameters){
    //    self.allListData.removeAll()
        self.uplaodData1(APIManager.sharedInstance.Kmorelikethisapi, param) { response in
            
            if let JSON = response as?  [String: Any]{
                print(JSON)
                if let status = JSON["status"] as? Bool, status {
                    let dataArray = JSON["data"] as? [[String: Any]] ?? [[:]]
                    print(dataArray)
                    self.allListData = dataArray
                    print(self.allListData)
                
//                            self.allListData = seasonDetails
//                            print(self.allListData)
                            // Now you can access the season details and perform any further operations.
                        
                    }
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
                }
            }
        }
    
    func hitcheckpaymentapi(_ param : Parameters){
        self.uplaodData1(APIManager.sharedInstance.Kcheckpaymentstatusapi, param) { (response) in
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                    let dataArray = JSON["data"] as? [String: Any] ?? [:]
                    print(dataArray)
                let payment = JSON["payment_method"] as? String ?? ""
                print(payment)
                self.paymentmethod = payment
                print(self.paymentmethod)
                
                    }
                }
            }
    
    func didSelect(_ url: String, _ EpisodeId: String) {
        let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
        DispatchQueue.main.async {
            if self.premiumData.count > 0 {
                for index in 0..<self.premiumData.count{
                    if self.premiumData[index].episode_id == EpisodeId {
                        self.titleLbl.text = self.premiumData[index].season_title
                        self.descptLbl.text = self.premiumData[index].episode_description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                    }
                }
            }
            self.playerView.load(withVideoId: url, playerVars: playvarsDic)
        }
        
    }
    func getEpisode(token: String){
        var dict = Dictionary<String,Any>()
        dict["user_id"] = currentUser.result?.id ?? "163"
        dict["token"] = token
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        HttpHelper.apiCallWithout(postData: dict as NSDictionary,
                                  url: "video_meta/get_video_meta_data",
                                  identifire: "") { result, response, error, data in
       DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(EncrypteResponse.self, from: data)
                let urlString = result.data.encrypted_url
                DispatchQueue.main.async {
                    self.getDecrepte(token: self.eToken, url: urlString)
                }
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
//    func currenttime(){
//        let timeObserver = mmplayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
//            let currentTimeInSeconds = CMTimeGetSeconds(time)
//            print("Current Time: \(currentTimeInSeconds) seconds")
//        }
//    }
    
    @IBAction func backbutton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sharebtn(_ sender: UIButton) {
        let baseURL = "https://app.sanskargroup.in/play_video_new?id="
        if let eposideide = UserDefaults.standard.object(forKey: "eposidekey") as? String,
           let eposideideNumeric = Int(eposideide) {
            let totaleposideNumeric = eposideideNumeric * 37 - 37
            let totaleposide = String(totaleposideNumeric)
            let videoURL = "\(baseURL)\(totaleposide)"
            print(videoURL)
            let activity = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
            print(activity)
            present(activity, animated: true, completion: nil)

        }
        
//        if let player = TV_PlayerHelper.shared.mmPlayer.player, player.status == .readyToPlay {
//            let videotime = player.currentTime()
//            let totaltime = player.currentItem?.duration
//
//            let eposideide = UserDefaults.standard.string(forKey: "eposidekey") ?? ""
//            UserDefaults.standard.set(selectedData?.season_id ?? "", forKey: "seasonkey")
//            UserDefaults.standard.synchronize()
//            let seasonId = data["season_id"] as? String ?? ""
//            watchedId = seasonId
//            UserDefaults.standard.set(seasonId, forKey: "season_Id")
//            UserDefaults.standard.synchronize()
//
//            let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
//            print(sesiondata)
//
//            if let sesiondata = sesiondata, !sesiondata.isEmpty {
//                print(sesiondata)
//                // Ensure that selectedData is not nil and season_id is a non-empty String
//                let param: Parameters = [
//                    "user_id": "\(currentUser.result?.id ?? "")","media_id": eposideide,"season_id": sesiondata,"pause_at": "\(videotime.seconds)","status": "0","type": "2","total_duration": "\(totaltime?.seconds ?? 0)"]
//                print(param)
//                continuewatching(param)
//            } else if let sesiondataa = UserDefaults.standard.string(forKey: "seasonkey"), !sesiondataa.isEmpty {
//                print(sesiondataa)
//                // Use seasondataa if sesiondata is nil
//                let param: Parameters = [
//                    "user_id": "\(currentUser.result?.id ?? "")","media_id": eposideide,"season_id": sesiondataa,"pause_at": "\(videotime.seconds)","status": "0","type": "2","total_duration": "\(totaltime?.seconds ?? 0)"]
//                print(param)
//                continuewatching(param)
//            } else {
//                print("Error: Unable to retrieve valid season data from UserDefaults.")
//            }
//        } else {
//            print("Player is not ready.")
//        }
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        self.navigationController?.popViewController(animated: true)
    }
 
    //MARK: IBaction for button
    @IBAction func premiumBtnPressed(_ sender: UIButton){
        isComeFrom = 0
        
        if paymentmethod == "0" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Newpaymentvc") as! Newpaymentvc
               TV_PlayerHelper.shared.mmPlayer.player?.pause()
               print(selectedData?.season_id ?? "")
               UserDefaults.standard.set(selectedData?.season_id ?? "", forKey: "seasonkey")
                           UserDefaults.standard.synchronize()
               print(UserDefaults.standard.object(forKey: "seasonkey"))
               let seasonId = data["season_id"] as? String ?? ""
            watchedId = seasonId
                           UserDefaults.standard.set(seasonId, forKey: "season_Id")
                           UserDefaults.standard.synchronize()

               let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
               print(sesiondata)
               self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as! TBPremiumPaymentVC
               TV_PlayerHelper.shared.mmPlayer.player?.pause()
               print(selectedData?.season_id ?? "")
               UserDefaults.standard.set(selectedData?.season_id ?? "", forKey: "seasonkey")
                           UserDefaults.standard.synchronize()
               print(UserDefaults.standard.object(forKey: "seasonkey"))
               let seasonId = data["season_id"] as? String ?? ""
            watchedId = seasonId
                           UserDefaults.standard.set(seasonId, forKey: "season_Id")
                           UserDefaults.standard.synchronize()

               let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
               print(sesiondata)
               self.navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
    @IBAction func barcodeBtnPressed(_ sender: UIButton){
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
                
            }
        }
   
    }
    
    @IBAction func searchBTnPressed(_ sender: UIButton){
        
        if sender.isTouchInside{
            
        }
    }
    @IBAction func closeSearchBtn(_ sender: UIButton){
        
    }
    
    @IBAction func notificationBtn(_ sender: UIButton){
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func siderBarBTN(_ sender: UIButton){
        slideMenuController()?.openLeft()
    }
    func continuewatching(_ param : Parameters){
        self.uplaodData1(APIManager.sharedInstance.KContinuewatchingpremium, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
        }
    }
    
    func getDecrepte(token: String, url: String ) {
        
        var genretedAesKey: Array<Character> = Array()
        var genretedVi: Array<Character> = Array()
        let file_url = token.split(separator:"_" ) // Pass your encryption key here
        
        genretedAesKey = []
        genretedVi = []
        for char in file_url[2]{
            genretedAesKey.append(EncryptionHelper.getAesKey(char: char))
            genretedVi.append(EncryptionHelper.getVI(char: char))
        }
        let urlKey = url.components(separatedBy: ":")
        let aesKey = String(genretedAesKey)
        let VI = String(genretedVi)
        let aes128N = AES(key: aesKey, iv: VI)
        let decodedData = NSData(base64Encoded: urlKey.first ?? "" , options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decryptedDataNN = aes128N?.decrypt(data: decodedData as Data?)
        print(decryptedDataNN as Any)
        guard let urlString = URL(string: decryptedDataNN ?? "") else {return}
        DispatchQueue.main.async {
            self.playVideo(url: decryptedDataNN ?? "", image: "")
        }

    }
    
    func touchInVideoRect(contain: Bool) {
        print("\(contain)")
//        let seasonId = data["season_id"] as? String ?? ""
//        
//        print(seasonId)
    
    }

}
//MARK: TableViewDelegate
extension newPreDetails: UITableViewDataSource, AllListTableCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if premiumData.count > 0 {
            return allListCount
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as? seasonCell else {
                return UITableViewCell()
            }
            
            cell.collection.delegate = self
            cell.collection.dataSource = self
            cell.collection.reloadData()
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllListTableCell", for: indexPath) as? AllListTableCell else {
                return UITableViewCell()
            }
            cell.allDataList = allListData
            print(cell.allDataList)
            cell.delegate = self
            return cell
        }
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        print(sender.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "epsiodeDetailVc") as! epsiodeDetailVc
        vc.premiumData = premiumData
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapCollection(_ cell: AllListTableCell, data: [String : Any]) {
       
        print(data)
        let seasonId = data["season_id"] as? String ?? ""
        print(seasonId)
        let seasontitledata = data["season_title"] as? String ?? ""
        self.titleLbl.text = seasontitledata
        param = ["user_id":currentUser.result?.id ?? "","season_id":seasonId,"page_no":"1","limit":"10"]
        selectIndex = 0
        selectedIndex = 0
        promo = true
        getPremiumlist(param)
        videoPlayer.isHidden = false
        playerView.isHidden = false
        setPlayerControlVisibility(true)

        if let player = TV_PlayerHelper.shared.mmPlayer.player, player.status == .readyToPlay {
            let videotime = player.currentTime()
            let totaltime = player.currentItem?.duration

            let eposideide = UserDefaults.standard.string(forKey: "eposidekey") ?? ""
            UserDefaults.standard.set(selectedData?.season_id ?? "", forKey: "seasonkey")
            UserDefaults.standard.synchronize()
            let seasonId = data["season_id"] as? String ?? ""
            watchedId = seasonId
            UserDefaults.standard.set(seasonId, forKey: "season_Id")
            UserDefaults.standard.synchronize()

            let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
            print(sesiondata)

            if let sesiondata = sesiondata, !sesiondata.isEmpty {
                print(sesiondata)
                // Ensure that selectedData is not nil and season_id is a non-empty String
                let param: Parameters = [
                    "user_id": "\(currentUser.result?.id ?? "")","media_id": eposideide,"season_id": sesiondata,"pause_at": "\(videotime.seconds)","status": "0","type": "2","total_duration": "\(totaltime?.seconds ?? 0)"]
                print(param)
                continuewatching(param)
            } else if let sesiondataa = UserDefaults.standard.string(forKey: "seasonkey"), !sesiondataa.isEmpty {
                print(sesiondataa)
                // Use seasondataa if sesiondata is nil
                let param: Parameters = [
                    "user_id": "\(currentUser.result?.id ?? "")","media_id": eposideide,"season_id": sesiondataa,"pause_at": "\(videotime.seconds)","status": "0","type": "2","total_duration": "\(totaltime?.seconds ?? 0)"]
                print(param)
                continuewatching(param)
            } else {
                print("Error: Unable to retrieve valid season data from UserDefaults.")
            }
        } else {
            print("Player is not ready.")
        }
    }

}

extension newPreDetails: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
                    // Height for the seasonCell
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 250
                   } else {
                       return 200
                   }
                   
                } else {
                    // Height for the AllListTableCell
                    return 300
                    
                }
    }
    
}

//MARK: CollectionView DataSource
extension newPreDetails: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        premiumData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonData", for: indexPath) as? seasonData else {
            return UICollectionViewCell()
        }
        let episodedata = premiumData[indexPath.row].episode_id
        print(episodedata)
        
        UserDefaults.standard.set(episodedata, forKey: "eposidekey")
                    UserDefaults.standard.synchronize()
        print(UserDefaults.standard.object(forKey: "eposidekey"))
        
        let post = premiumData[indexPath.row]
        if selectIndex == indexPath.row {
            cell.playView.isHidden = false
        }else {
            cell.playView.isHidden = true
        }
        if post.is_locked == "0"{
            cell.lockImg.isHidden = true
        }else{
            cell.lockImg.isHidden = false
        }
        cell.Image.sd_setIndicatorStyle(.gray)
        cell.Image.sd_setImage(with: URL(string: post.thumbnail_url ), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        cell.seasonView.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        shadow(cell)
        return cell
    }
}
//MARK: CollectionView Flowlayout

extension newPreDetails: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 120)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 250, height: 150)
               } else {
                   return CGSize(width: 200, height: 120)
               }
    }
}

//MARK: CollectionView Delegate
extension newPreDetails: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageUrl = (premiumData[indexPath.row].thumbnail_url)
        let posts = premiumData[indexPath.row]
        self.didSelect = true
        self.selectedIndex = indexPath.row
        selectIndex = indexPath.row
        
        if posts.is_locked == "0"{
            titleLbl.text = (posts.season_title)
            self.descptLbl.text = posts.episode_description
            self.eposidetitle = posts.episode_title
            self.titleLbl.text = self.eposidetitle
            self.episode_id = posts.episode_id
            print(self.episode_id)
            self.season_id = posts.season_id
            print(self.season_id)
            videoPlayer.isHidden = true
            if posts.episode_url != "" {
                playVideo(url:posts.episode_url, image: selectedData!.season_thumbnail ?? "")
            }else if posts.youtube_url != "" {
                TV_PlayerHelper.shared.mmPlayer.player?.pause()
                TV_PlayerHelper.shared.mmPlayer.isHidden = false
                TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
                let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
                playerView.load(withVideoId: posts.yt_episode_url,playerVars: playvarsDic)
                playerView.contentMode = .scaleToFill
                playerView.isHidden = false
            }else{
                guard let token = posts.token else { return }
                eToken = token
                getEpisode(token: token)
                
            }
        }
        else{
            let alert = UIAlertController(title: appName, message: ALERTS.KSubscribe, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Go Premium", style: .default, handler: { (action: UIAlertAction) in
                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                TV_PlayerHelper.shared.mmPlayer.player?.pause()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
 }


//MARK: YoutubePlayer Delegate
extension newPreDetails: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
        self.playerCurrentTime = playTime
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        if state == .ended{
            if premiumData[selectedIndex].is_locked == "0"{
                if didSelect == false {
                    if premiumData.count > 0 {
                        self.didSelect = true
                        let data = premiumData[selectedIndex]
                        if selectedIndex < premiumData.count {
                            let mediaId = data.season_id
                            titleLbl.text = data.season_title
                            descptLbl.text = data.episode_description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                            let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
                            playerView.load(withVideoId: premiumData[selectedIndex].yt_episode_url,playerVars: playvarsDic)
                        }else{
                            playerView.seek(toSeconds: 0.0, allowSeekAhead: true)
                            playerView.pauseVideo()
                        }
                    }
                }else{
                    if selectedIndex < premiumData.count{
                        selectedIndex += 1
                        let mediaId = premiumData[selectedIndex].season_id
                        titleLbl.text = premiumData[selectedIndex].season_title
                        descptLbl.text = premiumData[selectedIndex].episode_description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                        let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
                        playerView.load(withVideoId: premiumData[selectedIndex].yt_episode_url,playerVars: playvarsDic)
                    }else{
                        playerView.seek(toSeconds: 0.0, allowSeekAhead: true)
                        playerView.pauseVideo()
                    }
                }
            }else{
                if selectedIndex < premiumData.count{
                    selectedIndex += 1
                    let mediaId = premiumData[selectedIndex].season_id
                    titleLbl.text = premiumData[selectedIndex].season_title
                    descptLbl.text = premiumData[selectedIndex].episode_description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                    let playvarsDic = ["playsinline": 1,"controls":1,"modestbranding":1]
                    playerView.load(withVideoId: premiumData[selectedIndex].yt_episode_url,playerVars: playvarsDic)
                }else{
                    playerView.seek(toSeconds: 0.0, allowSeekAhead: true)
                    playerView.pauseVideo()
                }
            }
            
        }
    }
}
