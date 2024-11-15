//
//  TBsearchviedeoViewController.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 18/05/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class TBsearchviedeoViewController: UIViewController {
    
    var videodata: String?
    var videoData = [String:Any]()
    
    @IBOutlet weak var player: WKYTPlayerView!

    @IBOutlet var descrptionlbl: UILabel!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var datelbl: UILabel!
    @IBOutlet var likebtn: UILabel!
    
    @IBOutlet var viewlbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(videodata)
   //     player.load(withVideoId: videodata!)
        player.delegate = self
        let param  = ["user_id": currentUser.result!.id!,"video_id":videodata]
        getsearchvideoApi(param)
        
        

    }
    
    func getsearchvideoApi(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.Ksearchvideo , param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                let data = (JSON["data"] as? [String:Any] ?? [:])
                print(data)
                self.videoData = data
                let like =  self.videoData["likes"] as? String ?? ""
                let view =  self.videoData["views"] as? String ?? ""
                let descp =  self.videoData["video_title"] as? String ?? ""
                let name =  self.videoData["author_name"] as? String ?? ""
                let date =  self.videoData["published_date"] as? String ?? ""
                let youtubeurl =  self.videoData["youtube_url"] as? String ?? ""
                print(like)
                self.likebtn.text = like
                self.namelbl.text = name
                self.descrptionlbl.text = descp
                self.viewlbl.text = view
                self.datelbl.text = date
                self.player.load(withVideoId: youtubeurl)
                
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        player.stopVideo()
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
     //   dismiss(animated: true, completion: nil)
    }
    
    
   
    
}

extension TBsearchviedeoViewController: WKYTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.playVideo()
    }
}















