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
import YoutubePlayer_in_WKWebView

@available(iOS 13.0, *)
class LiveDarshanViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var playerYoutube: WKYTPlayerView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewmain: UITableView!
    @IBOutlet weak var lblVideoTitle: UILabel!
    
    var vdotype: String = "" {
        willSet {
            print("vdotype will be updated to: \(newValue)")
        }
        didSet {
            guard !darshanList.isEmpty else {
                print("darshanList is empty. Skipping UI update.")
                return
            }
            guard !vdotype.isEmpty else {
                print("darshanList is empty. Skipping UI update.")
                return
            }
            updateUI(for: vdotype)
        }
    }
    
    var darshanList: String = "" {
        willSet {
            print("darshanList will be updated to: \(newValue)")
        }
        didSet {
            print("darshanList is now: \(darshanList)")
        }
    }
    var titleData = ""
    var relatedVidos = [DataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAllPlayers()
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        stopAllPlayers()
        self.navigationController?.popViewController(animated: true)
    }
    
    func seupUI(){
        tableViewmain.register(UINib(nibName: "TBLiveDetailCell", bundle: nil), forCellReuseIdentifier: "cell")
        let param: Parameters = ["user_id": currentUser.result?.id ?? "163"]
        getMoreForAarti(param)
        updateUI(for: vdotype)
        self.lblVideoTitle.text = titleData
    }
    
    // MARK: - UI Update Methods
    func updateUI(for type: String) {
        if type == "0" {
            guard !darshanList.isEmpty else {
                return
            }
            uiUpdateYouTube()
        } else {
            guard !darshanList.isEmpty else {
                return
            }
            uiUpdateCustomPlayer()
        }
    }

    
    func uiUpdateYouTube() {
        videoPlayer.isHidden = true
        playerYoutube.isHidden = false
        guard let videoID = darshanList.components(separatedBy: "/").last, !videoID.isEmpty else {
            return
        }
        print("Video ID: \(videoID)")
        let playVars = ["playsinline": 1, "controls": 1, "modestbranding": 1]
        playerYoutube.load(withVideoId: videoID, playerVars: playVars)
    }
    
    func uiUpdateCustomPlayer(){
        videoPlayer.isHidden = false
        playerYoutube.isHidden = true
        guard let videoURL = URL(string: darshanList), !darshanList.isEmpty else {
            return
        }
        playVideo(url: videoURL)
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
    func stopAllPlayers() {
        playerYoutube.isHidden = true
        videoPlayer.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
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
        guard let videoURL = video.video_url, !videoURL.isEmpty,
              let videoType = video.video_type else {
            return
        }
        DispatchQueue.main.async {
            self.darshanList = videoURL
            self.vdotype = videoType
            self.lblVideoTitle.text = video.title
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
@available(iOS 13.0, *)
extension LiveDarshanViewController: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        print("YouTube player ready.")
        playerView.seek(toSeconds: 0, allowSeekAhead: true)
        playerView.playVideo()
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        print("YouTube player state changed: \(state)")
    }
    
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
        print("YouTube player error: \(error)")
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo quality: WKYTPlaybackQuality) {
        print("YouTube player quality changed: \(quality)")
    }
}
