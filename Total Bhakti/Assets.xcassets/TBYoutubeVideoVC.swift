//
//  TBYoutubeVideoVC.swift
//  Total Bhakti
//
//  Created by Viru on 03/01/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit
import YouTubePlayer


class TBYoutubeVideoVC: UIViewController,UITableViewDelegate,UITableViewDataSource,YouTubePlayerDelegate{
    
    
    @IBOutlet weak var playerView: YouTubePlayerView!
    var isLoadingList : Bool = false
//    var postID = ""
    @IBOutlet weak var searchBar: UISearchBar!
    var searchClicked = 0
    @IBOutlet weak var notifCountLabel: UILabel!
    
    @IBOutlet weak var forward_btn: UIButton!
    @IBOutlet weak var backward_btn: UIButton!
    @IBOutlet weak var playPause_btn: UIButton!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var tapView: UIView!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var videosArr : [videosResult] = []
    var post:videosResult?
    var searchResultVideosArr = NSMutableArray()
    
    
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var likeBtn: UIButton!

    var isMultipleVideos = false
    
    
    @IBOutlet weak var lbl_video_title: UILabel!
    @IBOutlet weak var lbl_author_name: UILabel!
    @IBOutlet weak var lbl_creation_time: UILabel!
    
    
    @IBOutlet weak var lbl_Views: UILabel!
    @IBOutlet weak var lbl_likes: UILabel!
    
    var songNo = 0
    var isBool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        
        MyTableView.tableFooterView = UIView(frame: CGRect.zero)
        MyTableView.tableFooterView?.isHidden = true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: MyTableView.bounds.width, height: CGFloat(44))
        self.MyTableView.tableFooterView = spinner
        
        UserDefaults.standard.setValue("yes", forKey: "isTBYoutubeVideoVC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(backAction), name: NSNotification.Name("closeYoutubePlayer"), object: nil)
        
        lbl_creation_time.text = dateConversion(timestamp:post!.creation_time)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(showOrHideBtn))
        self.tapView.addGestureRecognizer(gesture)
        
        
        if post!.is_like != "0"{
            likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        
        lbl_video_title.setHTML(html: post!.video_desc)
        lbl_video_title.text = post!.video_title
        lbl_author_name.text = post!.author_name
        lbl_Views.text = (post!.views) + " views"
        lbl_likes.text = (post!.likes) + " like"
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        
        let param : Parameters
        param  = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : "" , "video_category" : post!.category,"limit":"10"]
        getVideosApi(param)
        
        
        let param2 : Parameters
        param2  = ["user_id": currentUser.result!.id!,"video_id":post!.id]
        videosDetails(param2)
        
        
        MyTableView.dataSource = self
        MyTableView.dataSource = self
        playerView.delegate = self
        
        
        playerView.playerVars = ["playsinline" : 1 as AnyObject]
        playerView.loadVideoID(post!.id)
        playerView.contentMode = .scaleToFill
        
        let parameter : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post!.id]
        recentViewHit(parameter)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as? String ?? "0"
        notifCountLabel.text = notification_counter
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideTVPlayer"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
        MusicPlayerManager.shared.isPaused = true
        MusicPlayerManager.shared.myPlayer.pause()
        
        
        if searchClicked == 1 {
            searchClicked = 0
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        playerView.pause()
        playPause_btn.setImage(UIImage(named: "audio_play"), for: .normal)
        UserDefaults.standard.removeObject(forKey: "isTBYoutubeVideoVC")
    }
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("closeYoutubePlayer"), object: nil)
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Topbar Button action.
    @IBAction func ShareBtnAction (_ sender : UIButton){
        let web_view_video = UserDefaults.standard.value(forKey: "web_view_video")

        //        let text = "https://www.youtube.com/watch?v=\(videoID)"
        let text = "\(web_view_video ?? "")\(post?.id ?? "")"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func notificationBtnAction (_ sender : UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
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
        if playerView.playerState == .Paused{
            playerView.play()
            sender.setImage(UIImage(named: "audio_pause"), for: .normal)
        }else{
            playerView.pause()
            sender.setImage(UIImage(named: "audio_play"), for: .normal)
        }
    }
    
    
    @IBAction func forwardAction(_ sender : UIButton){
        
        songNo = songNo+1
        if videosArr.count > songNo{
            let posts = videosArr[songNo]
            
            let param2 : Parameters
            param2  = ["user_id": currentUser.result!.id!,"video_id":posts.id]
            videosDetails(param2)
            
            playVideo(post: posts)
        }else{
            songNo = songNo-1
        }
    }
    @IBAction func backwardAction(_ sender : UIButton){
        songNo = songNo-1
        if videosArr.count > songNo && songNo >= 0{
            let posts = videosArr[songNo]
            
            let param2 : Parameters
            param2  = ["user_id": currentUser.result!.id!,"video_id":posts.id]
            videosDetails(param2)
            
            playVideo(post: posts)
        }else{
            songNo = 0
        }
    }
    
    func dateConversion(timestamp:String)->String{
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(timestamp)!
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
        
        return dateFormatter.string(from: formatedData)
    }
    
    
    
    @IBAction func backBtnAction (_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func LikeBtnAction (_ sender : UIButton){
        
        if currentUser.result!.id! == "163"{
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            if post!.is_like == "0"{
                likeVideoApi(APIManager.sharedInstance.KVIDEOLIKEAPI,post_ID: post!.youtube_url)
            }else{
                likeVideoApi(APIManager.sharedInstance.KVIDEODISLIKEAPI,post_ID: post!.youtube_url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videosArr.count != 0{
            return videosArr.count
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBVideoTableCell2
        let posts = videosArr[indexPath.row]

        cell.mainView.layer.cornerRadius = 5.0
        cell.mainView.dropShadow()
        
        cell.nameLbl.text = posts.video_title
        cell.dercriptionLbl.text = posts.video_desc.html2String
        
        if posts.views == "0" {
            cell.numberOfViewsLbl.text = "No view"
        }else if posts.views == "1" {
            cell.numberOfViewsLbl.text = "\(posts.views) View"
        }else {
            cell.numberOfViewsLbl.text = "\(posts.views) Views"
        }
        
        if posts.creation_time != ""{
            cell.dateAndTimeLbl.text = dateConversion(timestamp:posts.creation_time)
        }
        
        
        cell.videoImageView?.sd_setShowActivityIndicatorView(true)
        cell.videoImageView?.sd_setIndicatorStyle(.gray)
        cell.videoImageView.contentMode = .scaleToFill
        cell.videoImageView?.sd_setImage(with: URL(string: posts.thumbnail_url), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let posts = videosArr[indexPath.row]
        let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : posts.id]
        recentViewHit(param)
        
        let param2 : Parameters
        param2  = ["user_id": currentUser.result!.id!,"video_id":posts.id]
        videosDetails(param2)
        
        playVideo(post: post!)
        songNo = indexPath.row
    }
    
    
    func playVideo(post:videosResult){
        
        if post.youtube_url != ""{
            
            lbl_video_title.text = post.video_title
            lbl_author_name.text = post.author_name
            lbl_creation_time.text = post.creation_time
            lbl_Views.text = post.views
            lbl_likes.text = post.likes + " like"
            
            if post.is_like == "1" {
                likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }else{
                likeImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            }
            if post.creation_time != ""{
                lbl_creation_time.text = dateConversion(timestamp:post.creation_time)
                
            }else{
                lbl_creation_time.text = ""
                
            }
            playerView.loadVideoID(post.youtube_url)
        }
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            
            if videosArr.count == 0 || videosArr.count < 10{
                return
            }
            
            self.MyTableView.tableFooterView?.isHidden = false
            self.isLoadingList = true
            spinner.startAnimating()
            
            let lastVideo = videosArr[videosArr.count-1]
            let lastVideoId = lastVideo.id
            let param : Parameters
            param  = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : lastVideoId , "video_category" : lastVideo.category,"limit":"10"]
            getVideosApi(param)
        }
    }
    
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
                        self.videosArr.removeAll()
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
                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
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
                
                if "\(JSON["status"]!)" == "1"{
                    
                    let  data = JSON["data"]! as? Dictionary<String,Any>
                    let is_like = data!.validatedValue("is_like")
                    let likes = data!.validatedValue("likes")
                    let views = data!.validatedValue("views")
                    
                    self.lbl_Views.text = views + " views"
                    self.lbl_likes.text = likes + " like"
                    
                    if is_like != "0"{
                        self.likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    }else{
                        self.likeImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                    }
                }
                
            }
            else{
                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
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
                if JSON.value(forKey: "status") as? Bool == true {
                    if  JSON.value(forKey: "message") as? String == "User liked." {
                        self.likeImg.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                        
                        let like = Int(self.post!.likes) ?? 0
                        self.lbl_likes.text = "\(like+1) like"
                        self.post!.is_like = "1"
                        self.post!.likes = "\(like+1)"
                    }
                    else if JSON.value(forKey: "message") as? String == "Unlike Successfully."{
                        self.likeImg.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                        
                        let like = Int(self.post!.likes) ?? 0
                        if like != 0{
                            self.lbl_likes.text = "\(like-1) like"
                            self.post?.likes = "\(like-1)"
                        }else{
                            self.lbl_likes.text = "0 like"
                        }
                        
                        self.post?.is_like = "0"
                    }
                    else {
                        self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    }
                }else {
                    self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
    }
}

extension TBYoutubeVideoVC{
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        playerView.play()
        
        isBool = true
        forward_btn.isHidden = true
        backward_btn.isHidden = true
        playPause_btn.isHidden = true
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
extension TBYoutubeVideoVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
        //        videosArr = searchResultVideosArr
        //        searchClicked = 0
        //        searchBar.text = ""
        //        self.view.endEditing(true)
        //        searchBar.endEditing(true)
        //        searchBar.setShowsCancelButton(false, animated: true)
        //        MyTableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        self.view.endEditing(true)
        //        searchBar.endEditing(true)
        //        searchResultVideosArr = videosArr
        //        searchClicked = 1
        //        let param : Parameters
        //        param  = ["user_id": currentUser.result!.id!,"search_content" : searchBar.text!, "last_video_id" : "", "video_category" : "","limit":"10"]
        //        getVideosApi(param)
        
    }
}

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

