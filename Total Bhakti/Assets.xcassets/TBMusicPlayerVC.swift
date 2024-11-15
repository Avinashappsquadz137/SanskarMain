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

class TBMusicPlayerVC: UIViewController {
    
    @IBOutlet weak var playOrPaush_Btn: UIButton!
    @IBOutlet weak var previous_Btn: UIButton!
    @IBOutlet weak var next_Btn: UIButton!
    @IBOutlet weak var like_Btn: UIButton!
    @IBOutlet weak var addPlay_ListBtn: UIButton!
    @IBOutlet weak var download_Btn: UIButton!
    @IBOutlet weak var current_TimeLbl: UILabel!
    @IBOutlet weak var duration_Lbl: UILabel!
    @IBOutlet weak var song_Lbl: UILabel!
    @IBOutlet weak var artist_Lbl: UILabel!
    
    @IBOutlet weak var download_Lbl: UILabel!
    @IBOutlet weak var likes_Lbl: UILabel!
    @IBOutlet weak var playlist_Lbl: UILabel!
    
    @IBOutlet weak var dropdown_img: UIImageView!
    
    @IBOutlet weak var MyTableView : UITableView!
    @IBOutlet weak var myView : UIView!
    
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var Activityloader: UIActivityIndicatorView!
    @IBOutlet weak var downloadProgress: CircleProgressView!
    
    var isLikes = ""
    //add_playlist
    var isOpen = false
    
    var viewcontroller = UIViewController()
    var totalLikes = Int()
    
    var timer: Timer?
    var item = Int()
    
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previous_Btn.setImage(UIImage(named: "backward"), for: .normal)
        MusicPlayerManager.shared.songDidChnagedFromNotification = { [weak self] ()  in
            self?.UpdatePlayerUI()
            
        }

        myView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        MyTableView.delegate = self
        MyTableView.dataSource = self
        
        myView.frame = CGRect(x: 0, y: -400, width: self.view.frame.size.width, height: 400)
        myView.alpha = 0.0
        
        self.view.addSubview(myView)
        

        
        MyTableView.register(UINib(nibName: "music_QueueCell", bundle: nil), forCellReuseIdentifier: "music_QueueCell")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        
        if MusicPlayerManager.shared.isDownloadedSong{
            download_Btn.isUserInteractionEnabled = false
        }else{
            download_Btn.setImage(UIImage(named: "download_audio"), for: .normal)
        }
        setupTimer()
        Activityloader.startAnimating()
        playOrPaush_Btn.setImage(UIImage(named:"audio_play"), for: .normal)
        MusicPlayerManager.shared.Slider = Slider
        pagerViewUIsetup()
        PlayNextAutomatic()
        
        if  MusicPlayerManager.shared.isPlayList{
            addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
            addPlay_ListBtn.isUserInteractionEnabled = false
            playlist_Lbl.text = "Added to PlayList"
        }
        
        

        
    }
    
    @IBAction func forward_fifteenSec(_ sender:UIButton){
        
        let time =  CMTimeMake(Int64(15), 1)
        let forwardTime = time+MusicPlayerManager.shared.myPlayer.currentTime()
        MusicPlayerManager.shared.myPlayer.seek(to: forwardTime, completionHandler: { [unowned self] (finish) in
            
        })
        MusicPlayerManager.shared.myPlayer.play()
        
    }
    @IBAction func backward_fifteenSec(_ sender:UIButton){
        let time =  CMTimeMake(Int64(15), 1)
        let backTime = MusicPlayerManager.shared.myPlayer.currentTime()-time
        MusicPlayerManager.shared.myPlayer.seek(to: backTime, completionHandler: { [unowned self] (finish) in
            
        })
        MusicPlayerManager.shared.myPlayer.play()
  
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideTVPlayer"), object: nil)
        
        UpdatePlayerUI()
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
                if MusicPlayerManager.shared.Bhajan_Track.count > 0{
                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
                    self.song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].title
                    self.artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].artist_name
                    self.SonglikeOrDislike()
                    self.AlredayDownloaded()
                    self.AlreadyAddedPlayList()
                   
                    let bhajanID = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].id ?? ""
                    
                    let param : Parameters
                     param  = ["user_id": currentUser.result!.id!,"bhajan_id":bhajanID]
                    self.BhajanDetails(param)
                    
                }
            }
        }
    }
    
    // MARK:- confirm protocol of pagerView and cell size and animation(pagerView.transformer) type of pagerview
    func pagerViewUIsetup(){
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        let transform = CGAffineTransform(scaleX: 0.50, y: 0.70)
        self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
        pagerView.isInfinite = false
        pagerView.contentMode = .scaleAspectFit
        pagerView.isUserInteractionEnabled = true
        pagerView.itemSize = CGSize(width: self.view.frame.size.width, height: 300)
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
            
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            if post.is_like == "1" {
                self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                totalLikes = Int(MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].likes ?? "0")!
            }else {
                self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
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
            guard  MusicPlayerManager.shared.Bhajan_Track.count != 0 else {
                return
            }
            
            let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
            if post.is_like == "1" {
                self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes ?? "0")!
            }else {
                self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
                totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes ?? "0")!
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
        let seconds : Int64 = Int64(sender.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        MusicPlayerManager.shared.myPlayer.seek(to: targetTime)
        
    }
    // MARK:- Download Action Button
    @IBAction func downloadActionBtn(_ sender: UIButton) {
        if MusicPlayerManager.shared.isDownloadedSong{
            return
        }
        
        if currentUser.result!.id! == "163"{
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
            navigationController?.pushViewController(vc, animated: true)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.Activityloader.isHidden = false
            self.Activityloader.stopAnimating()
            self.playOrPaush_Btn.isHidden = false
            
        }
        
    }
    // MARK:- Play Next song
    @IBAction func nextAction(_ sender: UIButton) {
        
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
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.Activityloader.isHidden = true
            self.Activityloader.stopAnimating()
            self.playOrPaush_Btn.isHidden = false
            
        }
        
    }
    
    //MARK:- timer for slider.
    func setupTimer(){
        timer = Timer(timeInterval: 0.001, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    // MARK:- This function will call every 1 second to update the value of slider & time duration label
    @objc func tick(){
        
        duration_Lbl.text = MusicPlayerManager.shared.duration_Lbl
        current_TimeLbl.text = MusicPlayerManager.shared.current_TimeLbl
        
        pauseOrPlay()
        
        if(MusicPlayerManager.shared.myPlayer.currentTime().seconds == 0.0) {
            Activityloader.isHidden = false
            playOrPaush_Btn.isHidden = true
            Activityloader.startAnimating()
        }
        else{
            Activityloader.isHidden = true
            playOrPaush_Btn.isHidden = false
            Activityloader.stopAnimating()
        }
        if(MusicPlayerManager.shared.isPaused == false){
            if(MusicPlayerManager.shared.myPlayer.rate == 0){
                MusicPlayerManager.shared.myPlayer.play()
                Activityloader.isHidden = false
                playOrPaush_Btn.isHidden = true
                Activityloader.startAnimating()
            }else{
                Activityloader.isHidden = true
                Activityloader.stopAnimating()
                playOrPaush_Btn.isHidden = false
            }
        }
        
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
            
        }else{
            MusicPlayerManager.shared.myPlayer.pause()
            timer?.invalidate()
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
            let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
            let id = post.id ?? ""
            text = "\(web_view_bhajan ?? "")\(id)"
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
                
                var text = MusicPlayerManager.shared.Bhajan_Track[index].media_file ?? ""
                text += "\n" + "\(MusicPlayerManager.shared.Bhajan_Track[index].description ?? "")"
                let activity = UIActivityViewController(activityItems: [img as Any,text], applicationActivities: nil)
                self.present(activity, animated: true, completion: nil)
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
            
        }else{
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
            return MusicPlayerManager.shared.Bhajan_Track.count
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
            _ = SweetAlert().showAlert("", subTitle: "Another Audio is Already added on Queue", style: AlertStyle.error)
            return
        }
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

// MARK:- if song is Alreday Downloaded

extension TBMusicPlayerVC{
    func AlredayDownloaded(){
        
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

// MARK:- Song Like Dislike API 

extension TBMusicPlayerVC{
    //MARK:- likeAnd Dislike Api For Audio(Bhajan).
    
    func likeDisLikeApi(_ apiName : String)  {
        
        
        if currentUser.result!.id! == "163"{
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        var param : Parameters
        
        if MusicPlayerManager.shared.isDownloadedSong{
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            param = ["bhajan_id" : post.id!, "user_id" : currentUser.result!.id!]
            
        }else{
            let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
            param = ["bhajan_id" : post.id!, "user_id" : currentUser.result!.id!]
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
                        MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
                        MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].is_like = "1"
                        self.like_Btn.setImage(UIImage(named : "audio_liked"), for: .normal)
                        
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
                        MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
                        MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].is_like = "0"
                        self.like_Btn.setImage(UIImage(named : "audio_like"), for: .normal)
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
        
        print("playList")
        if currentUser.result!.id! == "163"{
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
            navigationController?.pushViewController(vc, animated: true)
            return
        }else{
            var tempArr =  NSMutableArray()
            if MusicPlayerManager.shared.Bhajan_Track.count == 0{
                return
            }
            let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
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
                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
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
        let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
        if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
            tempArr = NSMutableArray.init(array: savedArray)
            let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
            let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
            
            if playListArr.count != 0 {
                addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                playlist_Lbl.text = "Added to PlayList"
                print("This song is available in Play List")
            }else{
                addPlay_ListBtn.setImage(UIImage(named : "add_playlist"), for: .normal)
                playlist_Lbl.text = "Add to PlayList"
                print("This song is not available in Play List")
            }
        }
    }
}

extension TBMusicPlayerVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MusicPlayerManager.shared.isDownloadedSong{
            return  MusicPlayerManager.shared.ArrDownloadedSongs.count
        }else{
            return  MusicPlayerManager.shared.Bhajan_Track.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "music_QueueCell") as! music_QueueCell
        
        if MusicPlayerManager.shared.isDownloadedSong{
            let imageArray = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].image
            if let url = URL(string: imageArray!) {
                cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
            cell.songName_lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].title
            cell.songDesc_lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[indexPath.row].artist_name
            return cell
        }
        else{
            let imageArray = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].image
            if let url = URL(string: imageArray!) {
                cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
            cell.songName_lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].title
            cell.songDesc_lbl.text = MusicPlayerManager.shared.Bhajan_Track[indexPath.row].artist_name
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if MusicPlayerManager.shared.isDownloadedSong {
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
            
        }else{
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
