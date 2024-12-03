//
//  LiveDarshanViewController.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 27/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//
import UIKit
import AVKit
import AVFoundation
import SDWebImage

import YouTubePlayer

@available(iOS 13.0, *)
class LiveDarshanViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var playerYoutube: YouTubePlayerView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewmain: UITableView!
    
    var darshanList : String = ""
    var vdotype : String = ""
    var relatedVidos = [DataModel]()
    
    lazy var mmPlayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        playerYoutube.isHidden = true
        playerYoutube.pause()
        videoPlayer.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        playerYoutube.isHidden = true
        playerYoutube.pause()
        videoPlayer.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func seupUI(){
        tableViewmain.register(UINib(nibName: "TBLiveDetailCell", bundle: nil), forCellReuseIdentifier: "cell")
        let param: Parameters = ["user_id": currentUser.result?.id ?? "163"]
        getMoreForAarti(param)
        if vdotype == "0"{
            uiUpdateYouTube()
        }else {
            uiUpdateCustomPlayer()
        }
    }
    
    
    func uiUpdateYouTube() {
        videoPlayer.isHidden = true
        playerYoutube.isHidden = false
        if let videoID = darshanList.components(separatedBy: "/").last {
            print("Video ID: \(videoID)")
            playerYoutube.delegate = self
            playerYoutube.playerVars = (["playsinline": 1,"controls":1,"modestbranding":1] as AnyObject) as! YouTubePlayerView.YouTubePlayerParameters
            playerYoutube.loadVideoID(videoID)
            playerYoutube.contentMode = .scaleToFill
            playerYoutube.isHidden = false
        }
    }
    
    func uiUpdateCustomPlayer(){
        videoPlayer.isHidden = false
        playerYoutube.isHidden = true
        let videoURL : URL?
        if darshanList != ""{
            videoURL = URL(string: darshanList)
            playVideo(url:videoURL!)
        }
    }
    
    func playVideo(url: URL){
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.set(url: url)
        TV_PlayerHelper.shared.mmPlayer.playView = videoPlayer
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.play()
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
    }
    
    
}

@available(iOS 13.0, *)
extension LiveDarshanViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayer.YouTubePlayerView) {
        playerYoutube.play()
    }
}
@available(iOS 13.0, *)
extension LiveDarshanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedVidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TBLiveDetailCell else {
            return UITableViewCell()}
        
        let video = relatedVidos[indexPath.row]
        if let thumbnailURL = URL(string: video.thumbnail ?? "") {
            cell.configureCell(imageURL: thumbnailURL, itemName: video.title)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = relatedVidos[indexPath.row]
        if let vc = storyBoardNew.instantiateViewController(withIdentifier: CONTROLLERNAMES.KLiveDarshanViewController) as? LiveDarshanViewController {
            let post = video.video_url
            vc.darshanList = post ?? ""
            vc.vdotype = video.video_type ?? ""
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
//MARK: API CALLING
@available(iOS 13.0, *)
extension LiveDarshanViewController {
    
    func getMoreForAarti(_ param: Parameters) {
        DispatchQueue.main.async {
            loader.shareInstance.showLoading(self.view)
        }
        self.uplaodData1(APIManager.sharedInstance.KviewMoreForAarti, param) { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        self.relatedVidos = DataModel.modelsFromDictionaryArray(array: result)
                        if self.relatedVidos.count != 0 {
                            self.tableViewmain.reloadData()
                        }
                    }
                }
            }
        }
    }
}
