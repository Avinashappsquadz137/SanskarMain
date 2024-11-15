//
//  TBPremiumDetailVc.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 01/02/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import ExpandableLabel
import YouTubePlayer

class TBPremiumDetailVc: UIViewController, dataDelegate,YouTubePlayerDelegate {

    var premiumData : [freeModel] = []
    var selectedData : freeModel?
    var selectedDataPremium : episode_detail_Model?
    var selectedString = ""
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var seasonTitlelLbl: UILabel!
    @IBOutlet weak var descrptionLbl: ExpandableLabel!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var videoView:UIView!
    var param : Parameters = [:]
    @IBOutlet weak var tapView: UIView!
    var isBool = false
    var is_premium = 0
    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var goPremiumBtn:UIButton!
    var playerCurrentTime: Float?
    var episode_id : String?
    var season_id : String?
    var apiHitBool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializer()
    }
    
    
    func initializer(){
        self.goPremiumBtn.isHidden = true
        playerView.delegate = self
        tapView.isHidden = true
        noDataFoundLbl.isHidden = true
        if selectedString == "promotion" || selectedString == "season"{
            thumbnailImg?.sd_setImage(with: URL(string: selectedData!.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            seasonTitlelLbl.text = selectedData!.season_title
            descrptionLbl?.text = selectedData?.description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
            
            videoView.isHidden = false
            playerView.isHidden = true
            playerView.pause()

            let videoURL : URL?
            if selectedData?.promo_video != ""{
                videoURL = URL(string: selectedData?.promo_video ?? "")
                playVideo(url:videoURL!)
            }
            else if selectedData?.short_video != ""{
                videoURL = URL(string: selectedData?.short_video ?? "")
                playVideo(url:videoURL!)
            }
            else{
                
            }

        }
        if selectedString == "free"{
            thumbnailImg?.sd_setImage(with: URL(string: selectedData!.thumbnail_url), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            seasonTitlelLbl.text = selectedData?.episode_title ?? ""
            descrptionLbl?.text = selectedData?.episode_description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
            videoView.isHidden = true
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            playerView.playerVars = (["playsinline": 1,"controls":1,"modestbranding":1] as AnyObject) as! YouTubePlayerView.YouTubePlayerParameters
            playerView.loadVideoID(selectedData?.yt_episode_url ?? "")
            playerView.contentMode = .scaleToFill
            playerView.isHidden = false

        }
        if selectedString == "premiumSeeMore"{
            
            if isComeFrom == 2{
                seasonTitlelLbl.text = selectedData?.season_title ?? ""
                thumbnailImg?.sd_setImage(with: URL(string: selectedData?.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                descrptionLbl?.text = selectedData?.description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
                
                
                if selectedData?.yt_promo_video != ""{
                    videoView.isHidden = true
                    TV_PlayerHelper.shared.mmPlayer.player?.pause()
                    playerView.playerVars = ["playsinline" : 1 as AnyObject]
                    playerView.loadVideoID(selectedData?.yt_promo_video ?? "")
                    playerView.contentMode = .scaleToFill
                    playerView.isHidden = false
                }
                else{

                    videoView.isHidden = false
                    playerView.isHidden = true
                    playerView.pause()

                    let videoURL : URL?
                    if selectedData?.promo_video != ""{
                        videoURL = URL(string: selectedData?.promo_video ?? "")
                        playVideo(url:videoURL!)
                    }
                }
                
            }
            else{
                thumbnailImg?.sd_setImage(with: URL(string: selectedDataPremium?.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                seasonTitlelLbl.text = selectedDataPremium!.author_name
                descrptionLbl?.text = selectedDataPremium?.description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String

                
                if selectedDataPremium?.yt_promo_video != ""{
                    videoView.isHidden = true
                    TV_PlayerHelper.shared.mmPlayer.player?.pause()
                    playerView.playerVars = ["playsinline" : 1 as AnyObject]
                    playerView.loadVideoID(selectedDataPremium?.yt_promo_video ?? "")
                    playerView.contentMode = .scaleToFill
                    playerView.isHidden = false
                }
                else{

                    videoView.isHidden = false
                    playerView.isHidden = true
                    playerView.pause()

                    let videoURL : URL?
                    if selectedDataPremium?.promo_video != ""{
                        videoURL = URL(string: selectedDataPremium?.promo_video ?? "")
                        playVideo(url:videoURL!)
                    }
                }
            }
        }

        
        print(selectedData)
       
        if selectedString == "free"{
            param = ["user_id":currentUser.result?.id ?? "", "season_id": selectedData?.season_id ?? "", "page_no": "1","limit": "10","episode_id": selectedData?.episode_id ?? ""]
        }
        else if selectedString == "premiumSeeMore"{
            
            if type == "premiumDetail"{
                param = ["user_id":currentUser.result?.id ?? "", "season_id": selectedData?.season_id ?? "", "page_no": "1","limit": "10","episode_id": selectedData?.episode_id ?? ""]
            }
            else{
                param = ["user_id":currentUser.result?.id ?? "", "season_id": selectedDataPremium?.season_id ?? "", "page_no": "1","limit": "10","episode_id": selectedDataPremium?.episode_id ?? ""]
            }
        }
        else{
            
            param = ["user_id":currentUser.result?.id ?? "", "season_id": selectedData?.season_id ?? "", "page_no": "1","limit": "10","episode_id": ""]
        }
        
        getEpisodesApi(param)
    }
    
   
    
    func playVideo(url: URL){
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.set(url: url)
        TV_PlayerHelper.shared.mmPlayer.playView = videoView
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.play()
        
        
//        TV_PlayerHelper.shared.mmPlayer.player?.pause()
//        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
//        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
//        TV_PlayerHelper.shared.mmPlayer.setOrientation(.landscapeLeft)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
//    override func viewWillDisappear(_ animated: Bool) {
//
////        TV_PlayerHelper.shared.mmPlayer.player?.pause()
////        TV_PlayerHelper.shared.mmPlayer.player?.seek(to: kCMTimeZero)
////        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
////        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
//
//
//
//
//    }

    override func viewWillDisappear(_ animated: Bool) {
       if  self.apiHitBool == true
       {
            var param: Parameters = ["user_id":currentUser.result?.id ?? "","type":"\(videoType)","media_id":self.episode_id ?? "","season_id":self.season_id ?? "","pause_at":playerView.getCurrentTime() ?? "","status":"0"]


//        if playerView.getDuration() != "0"{
        let videoDuration = playerView.getDuration()
        let videoCurrentime = playerView.getCurrentTime()
        if videoCurrentime != videoDuration {
            param.updateValue("0", forKey: "status")
        }else{
            param.updateValue("1", forKey: "status")
        }
//            if Int(videoCurrentTime ?? 0) != Int(videoDuration){
//                print("CurrentTime::",playerView.getCurrentTime())
//                self.playerCurrentTime = Float(playerView.getCurrentTime() ?? "")
//
////                UserDefaults.standard.setValue(self.playerCurrentTime, forKey: "playerCurrentTime")
//                print("Current time == Video Duration")
//
////                user_id:13256
////                type:1
////                media_id:865
////                pause_at:1234
////                status:0
//
//                param.updateValue("0", forKey: "status")
//            }
////        }
//        else{
//            param.updateValue("1", forKey: "status")
//        }
        self.continueWatchingApi(param)
        
        
        
        
        
            
        }
        playerView.pause()
        playerView.isHidden = true
        videoView.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
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
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
            }
        }
    }
    //MARK:- Api Method.
    func getEpisodesApi(_ param : Parameters){

        self.uplaodData1(APIManager.sharedInstance.KEpisodeBySeasonId, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})

            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Bool == true {
                    self.premiumData.removeAll()
                    let data = JSON.ArrayofDict("data")
                    
                    let is_premium = JSON.value(forKey: "is_premium") as! Int
                    
                    if is_premium == 0{
                        self.goPremiumBtn.isHidden = false
                    }
                    else{
                        self.goPremiumBtn.isHidden = true
                    }
                    if data.count > 0{
                        _ = data.filter({ (dict) -> Bool in
                            self.premiumData.append(freeModel(dict: dict))

                            return true
                        })
                    }
                    

//                    self.pagerViewUIsetup()
                    self.tableView.reloadData()
//                    self.collectionView.reloadData()
                    
                    
//                    if self.pullToRefreshOn == true {
//                        self.pullToRefreshOn = false
//                    }
//                    self.tableView.reloadData()
                    
                }else {
                    
                    self.tableView.reloadData()
                    self.noDataFoundLbl.isHidden = false

//                    if self.pullToRefreshOn == true {
//                        self.pullToRefreshOn = false
//                    }
//                    self.searchClicked = false
                    
//                    self.tableView.isHidden = true
//                    let indexPath = IndexPath(row: 0, section: 0)
//
//                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "TBPremiumDataCell", for: indexPath) as! TBPremiumDataCell
//                    cell.isHidden = true

//                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
//                if self.pullToRefreshOn == true {
//                    self.pullToRefreshOn = false
//                }
//                self.searchClicked = false
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    @IBAction func menuBtn(_ sender:UIButton){
        slideMenuController()?.openLeft()
    }

    @IBAction func goPremiumBtn(_ sender:UIButton){
        isComeFrom = 0
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumPaymentVC"))!
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func viewAllEpisodesBtn(_ sender:UIButton){
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
////        vc.premiumData = premiumData
//        self.navigationController?.pushViewController(vc, animated: true)
//
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
        
        isComeFrom = 2
        vc.delegate = self
        param.updateValue("", forKey: "episode_id")
        vc.param = param
//        getEpisodesApi(param)

//        let param: Parameters  = ["user_id":currentUser.result?.id ?? "","season_id":season_id,"episode_id":"","page_no":"1","limit":"10"]
        
        
//    let season_id = premiumDataArray[sender.tag].season_id
//        let param: Parameters  = ["user_id":currentUser.result?.id ?? "","season_id":season_id,"episode_id":"","page_no":"1","limit":"10"]
//        vc.param = param
//            vc.modalPresentationStyle = .overCurrentContext
    
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func passData(_ dict: freeModel) {
        print("freeModel::",dict)
        
        
        thumbnailImg?.sd_setImage(with: URL(string: dict.thumbnail_url), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        seasonTitlelLbl.text = dict.episode_title
        getEpisodesApi(param)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TBPremiumDetailVc: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if premiumData.count > 0{
            return 1
            self.noDataFoundLbl.isHidden = false

        }
        else{
            return 0
            
            self.noDataFoundLbl.isHidden = true

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TBPremiumDataCell", for: indexPath) as! TBPremiumDataCell

//        let cell = tableView.dequeueReusableCell(withIdentifier: "TBPremiumDataCell") as! TBPremiumDataCell
        cell.collectionView.delegate = self
        cell.selectionStyle = .none
        cell.collectionView.reloadData()
        return cell
    }
    
    
    
}

extension TBPremiumDetailVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return premiumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
        
        let image = cell.viewWithTag(100) as? UIImageView
        let lockImg = cell.viewWithTag(200) as? UIImageView
        let posts = premiumData[indexPath.row]

        lockImg?.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        if posts.is_locked == "0"{
            lockImg?.isHidden = true
        }
        else{
            lockImg?.isHidden = false
        }
        image?.sd_setIndicatorStyle(.gray)
        image?.sd_setShowActivityIndicatorView(true)
        image?.layer.cornerRadius = 5.0
        image?.clipsToBounds = true
        image?.sd_setImage(with: URL(string: posts.thumbnail_url ), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width) / 2.3 //some width

        return CGSize(width: width  , height: 110)
//
//        return CGSize(width: 120  , height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageUrl = (premiumData[indexPath.row].thumbnail_url)
        let posts = premiumData[indexPath.row]

        if posts.is_locked == "0"{
            thumbnailImg?.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            seasonTitlelLbl.text = (posts.episode_title)
//            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")

            self.episode_id = posts.episode_id
            self.season_id = posts.season_id
            videoView.isHidden = true
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            TV_PlayerHelper.shared.mmPlayer.isHidden = true
//            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
            playerView.playerVars = ["playsinline" : 0 as AnyObject]
            playerView.loadVideoID(posts.yt_episode_url)
            playerView.contentMode = .scaleToFill
            playerView.isHidden = false
            self.apiHitBool = true
            
        }
        else{
            let alert = UIAlertController(title: appName, message: ALERTS.KSubscribe, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Go Premium", style: .default, handler: { (action: UIAlertAction) in
                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                self.navigationController?.pushViewController(vc, animated: true)

            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension TBPremiumDetailVc{
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        playerView.play()
        
        isBool = true
        
        let playerCurrentTime:Float = UserDefaults.standard.float(forKey: "playerCurrentTime")
        if playerCurrentTime != 0{
            print("CurrentTime::",videoPlayer.getCurrentTime())
//            videoPlayer.seekTo(playerCurrentTime, seekAhead: true)
        }
//        forward_btn.isHidden = true
//        backward_btn.isHidden = true
//        playPause_btn.isHidden = true
    }
//    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
//        if playerState == .Paused{
//            playPause_btn.setImage(UIImage(named: "audio_play"), for: .normal)
//        }else{
//            playPause_btn.setImage(UIImage(named: "audio_pause"), for: .normal)
//        }
//
//    }
}
