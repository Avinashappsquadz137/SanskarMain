////
////  audioPlayerVc.swift
////  Sanskar
////
////  Created by Warln on 18/09/21.
////  Copyright © 2021 MAC MINI. All rights reserved.
////
//
//import UIKit
//import CircleProgressView
//import MediaPlayer
//import CoreData
//import SDWebImage
//import GoogleMobileAds
//
//
//class audioPlayerVc: UIViewController {
//    
//    // IBoutlet
//    @IBOutlet weak var songTitle: UILabel!
//    @IBOutlet weak var artistLbl: UILabel!
//    @IBOutlet weak var songImg: UIImageView!
//    @IBOutlet weak var startTimeLbl: UILabel!
//    @IBOutlet weak var slider: UISlider!
//    @IBOutlet weak var endTimeLbl: UILabel!
//    @IBOutlet weak var Activityloader: UIActivityIndicatorView!
//    @IBOutlet weak var playBtn: UIButton!
//    @IBOutlet weak var fastForwardBtn: UIButton!
//    @IBOutlet weak var fastBackwardBtn: UIButton!
//    @IBOutlet weak var nextSong: UIButton!
//    @IBOutlet weak var backSong: UIButton!
//    @IBOutlet weak var songRepeat: UIButton!
//    @IBOutlet weak var songShuffle: UIButton!
//    @IBOutlet weak var playerbuttonListView: UIVisualEffectView!
//    @IBOutlet weak var addToPlaylistLbl: UILabel!
//    @IBOutlet weak var addToplaylistBtn: UIButton!
//    @IBOutlet weak var downloadProgress: CircleProgressView!
//    @IBOutlet weak var downloadBtn: UIButton!
//    @IBOutlet weak var downloadLbl: UILabel!
//    @IBOutlet weak var likeBtn: UIButton!
//    @IBOutlet weak var likeLbl: UILabel!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var pagerView: FSPagerView! {
//        didSet {
//            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//        }
//    }
//    
//    
//    
//    
//    
//    // Variable
//    
//    var playPauseBool = false
//    var isLikes = ""
//    //add_playlist
//    var isOpen = false
//    var radioChannel:channelModel?
//    var viewcontroller = UIViewController()
//    var totalLikes = Int()
//    var selectedIndex: Int = 0
//    
//    var timer: Timer?
//    var item = Int()
//    var count: Int = 0
//    var imgMedia = [String]()
//    var imgId = [String]()
//    var adId : String = ""
//    var imgURl:String = ""
//    var adIndex: Int = 0
//    
//    
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        backSong.setImage(UIImage(named: "backward"), for: .normal)
//        MusicPlayerManager.shared.songDidChnagedFromNotification = { [weak self] ()  in
//            self?.UpdatePlayerUI()
//            
//        }
//        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
//        scrollView.bounces = false
//        scrollView.alwaysBounceHorizontal = false
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            downloadBtn.isUserInteractionEnabled = false
//        }else{
//            downloadBtn.setImage(UIImage(named: "download_audio"), for: .normal)
//        }
//        setupTimer()
//        Activityloader.startAnimating()
//        playBtn.setImage(UIImage(named:"audio_play"), for: .normal)
//        MusicPlayerManager.shared.Slider = slider
//        pagerViewUIsetup()
//        PlayNextAutomatic()
//        
//        if  MusicPlayerManager.shared.isPlayList{
//            addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//            addToplaylistBtn.isUserInteractionEnabled = false
//            addToPlaylistLbl.text = "Added to PlayList"
//        }
//        if MusicPlayerManager.shared.isRadioSatsang{
//            self.backSong.isHidden = true
//            self.nextSong.isHidden = true
//            self.fastBackwardBtn.isHidden = true
//            self.fastForwardBtn.isHidden = true
//            self.songTitle.text = MusicPlayerManager.shared.radioChannel?.name
//            self.artistLbl.text = "Sanskar"
//
//                    
//            if let urlStr = MusicPlayerManager.shared.radioChannel?.image{
////                self.imgView.isHidden = false
//                
//                if let url = URL(string: urlStr){
////                    imgView.sd_setImage(with: url, completed: nil)
//                }
//            }
//            
//            
//        }
//        else{
////            self.imgView.isHidden = true
////            bannerView.isHidden = true
//        }
//
//
//        
//    }
//    
//    
//    
////MARK:- AudioPlayer IBAction
//    // Slider Action
//    @IBAction func sliderValue(_ sender: UISlider) {
//        
//        if MusicPlayerManager.shared.isRadioSatsang{
//            return
//        }
//        let seconds : Int64 = Int64(sender.value)
//        let targetTime:CMTime = CMTimeMake(seconds, 1)
//        MusicPlayerManager.shared.myPlayer.seek(to: targetTime)
//        
//    }
//    
//    // Play and Pause Button action
//    @IBAction func playAndPause(_ sender: UIButton) {
//        
//        if MusicPlayerManager.shared.isPaused{
//            MusicPlayerManager.shared.myPlayer.play()
//            setupTimer()
//            playPauseBool = true
//        }else{
//            MusicPlayerManager.shared.myPlayer.pause()
//            timer?.invalidate()
//            playPauseBool = false
//        }
//        pauseOrPlay()
//    }
//    
//    // Fast Forward
//    
//    @IBAction func fastForward(_ sender: UIButton) {
//        
//        let time =  CMTimeMake(Int64(15), 1)
//        let forwardTime = time+MusicPlayerManager.shared.myPlayer.currentTime()
//        MusicPlayerManager.shared.myPlayer.seek(to: forwardTime, completionHandler: { [unowned self] (finish) in
//            
//        })
//        
//        if playPauseBool == true{
//            MusicPlayerManager.shared.myPlayer.play()
//            
//        }
//        else{
//            MusicPlayerManager.shared.myPlayer.pause()
//            
//        }
//        
//    }
//    
//    // Fast backward
//    @IBAction func fastbackWard(_ sender: UIButton) {
//        
//        let time =  CMTimeMake(Int64(15), 1)
//        let backTime = MusicPlayerManager.shared.myPlayer.currentTime()-time
//        MusicPlayerManager.shared.myPlayer.seek(to: backTime, completionHandler: { [unowned self] (finish) in
//            
//        })
//        if playPauseBool == true{
//            MusicPlayerManager.shared.myPlayer.play()
//            
//        }
//        else{
//            MusicPlayerManager.shared.myPlayer.pause()
//        }
//        
//    }
//    
//    // Back song Action
//    @IBAction func backSong(_ sender: UIButton) {
//        
//        Activityloader.isHidden = false
//        playBtn.isHidden = true
//        Activityloader.startAnimating()
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            
//            self.item = self.pagerView.currentIndex
//            if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count && self.item != 0{
//                self.pagerView.scrollToItem(at: self.item-1, animated: true)
//                MusicPlayerManager.shared.song_no = self.item
//                songTitle.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item-1].title
//                artistLbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item-1].artist_name
//                MusicPlayerManager.shared.previousSong()
//                SonglikeOrDislike()
//                setupTimer()
//            }
//        }else{
//            self.item = self.pagerView.currentIndex
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count && self.item != 0{
//                    self.pagerView.scrollToItem(at: self.item-1, animated: true)
//                    MusicPlayerManager.shared.song_no = self.item
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item-1].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item-1].artist_name
//                    MusicPlayerManager.shared.previousSong()
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    setupTimer()
//                }
//            }
//            else{
//                if self.item != MusicPlayerManager.shared.Bhajan_Track.count && self.item != 0{
//                    self.pagerView.scrollToItem(at: self.item-1, animated: true)
//                    MusicPlayerManager.shared.song_no = self.item
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track[self.item-1].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item-1].artist_name
//                    MusicPlayerManager.shared.previousSong()
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    setupTimer()
//                }
//            }
//            
//            
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.Activityloader.isHidden = false
//            self.Activityloader.stopAnimating()
//            self.playBtn.isHidden = false
//            
//        }
//        
//    }
//    
//    // Next Song Action
//    @IBAction func nextSong(_ sender: UIButton) {
//        
//        
//        if imgMedia.count > 0 {
//            if count == 3 {
////                self.presentAds()
//                count = 0
//            }else{
//                count += 1
//            }
//        }
//        
//        Activityloader.isHidden = false
//        playBtn.isHidden = true
//        Activityloader.startAnimating()
//        
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            
//            self.item = self.pagerView.currentIndex
//            if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count - 1 {
//                self.pagerView.scrollToItem(at: self.item+1, animated: true)
//                MusicPlayerManager.shared.song_no = self.item
//                songTitle.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].title
//                artistLbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].artist_name
//                MusicPlayerManager.shared.nextSong()
//                SonglikeOrDislike()
//                setupTimer()
//                
//            }
//        }else{
//            self.item = self.selectedIndex
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count - 1 {
//                    self.pagerView.scrollToItem(at: self.item+1, animated: true)
//                    MusicPlayerManager.shared.song_no = self.item
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].artist_name
//                    MusicPlayerManager.shared.nextSong()
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    setupTimer()
//                }
//            }
//            else{
//                if self.item != MusicPlayerManager.shared.Bhajan_Track.count - 1 {
//                    self.pagerView.scrollToItem(at: self.item+1, animated: true)
//                    MusicPlayerManager.shared.song_no = self.item
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].artist_name
//                    MusicPlayerManager.shared.nextSong()
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    setupTimer()
//                }
//            }
//            
//            
//            
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.Activityloader.isHidden = true
//            self.Activityloader.stopAnimating()
//            self.playBtn.isHidden = false
//            
//        }
//    }
//    
//    @IBAction func shuffleSong(_ sender: UIButton) {
//        
//    }
//    
//    @IBAction func repeatSong(_ sender: UIButton){
//        
//    }
//    
//    // Download Song Action
//    @IBAction func downloadSong(_ sender: UIButton) {
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            return
//        }
//        
//        if currentUser.result!.id! == "163"{
//            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//            navigationController?.pushViewController(vc, animated: true)
//            return
//        }
//        
//        downloadAudio()
//        
//    }
//    
//    //Playlist Add
//    @IBAction func playlistAdd(_ sender: UIButton) {
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            _ = SweetAlert().showAlert("", subTitle: "bhajan is already available in download list ", style: AlertStyle.success)
//            return
//        }
//        
//        AddPlayList()
//        
//    }
//    
//    // Share the url
//    @IBAction func sharePressed(_ sender: UIButton) {
//        
//        var text = ""
//        
//        let web_view_bhajan = UserDefaults.standard.value(forKey: "web_view_bhajan")
//        if MusicPlayerManager.shared.isDownloadedSong{
//            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
//            let id = post.id ?? ""
//            text = "\(web_view_bhajan ?? "")\(id)"
//            
//        }else{
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//                let id = post.id
//                text = "\(web_view_bhajan ?? "")\(id)"
//            }
//            else{
//                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//                let id = post.id ?? ""
//                text = "\(web_view_bhajan ?? "")\(id)"
//            }
//            
//            
//        }
//        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//        present(activity, animated: true, completion: nil)
//        
//        
//    }
//    
//    // Like and Dislike
//    
//    @IBAction func likeOrDislikePress(_ sender: UIButton) {
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            guard MusicPlayerManager.shared.ArrDownloadedSongs.count != 0 else {
//                return
//            }
//            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
//            if post.is_like == "0" {
//                self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANLIKES)
//            }else {
//                self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANDISLIKE)
//            }
//        }else{
//            
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                guard MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0 else {
//                    return
//                }
//                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//                if post.is_like == "0" {
//                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANLIKES)
//                }else {
//                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANDISLIKE)
//                }
//            }
//            else{
//                guard MusicPlayerManager.shared.Bhajan_Track.count != 0 else {
//                    return
//                }
//                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//                if post.is_like == "0" {
//                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANLIKES)
//                }else {
//                    self.likeDisLikeApi(APIManager.sharedInstance.KBHAJANDISLIKE)
//                }
//            }
//            
//            
//        }
//    }
//    
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//    
//    func downloadImage(from url: URL) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() {
//                //self.imageView.image = UIImage(data: data)
//                let index = MusicPlayerManager.shared.song_no
//                
//                let img = UIImage(data: data)
//                if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                    var text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].media_file
//                    text += "\n" + "\(MusicPlayerManager.shared.Bhajan_Track_Trending[index].descript )"
//                    let activity = UIActivityViewController(activityItems: [img as Any,text], applicationActivities: nil)
//                    self.present(activity, animated: true, completion: nil)
//                    
//                }
//                else{
//                    var text = MusicPlayerManager.shared.Bhajan_Track[index].media_file ?? ""
//                    text += "\n" + "\(MusicPlayerManager.shared.Bhajan_Track[index].description ?? "")"
//                    let activity = UIActivityViewController(activityItems: [img as Any,text], applicationActivities: nil)
//                    self.present(activity, animated: true, completion: nil)
//                    
//                }
//                
//            }
//        }
//    }
//    
//    
//    
//    
//}
//
////MARK:- FSPager datasource and Delegate
//
//extension audioPlayerVc : FSPagerViewDelegate, FSPagerViewDataSource {
//    
//    public func numberOfItems(in pagerView: FSPagerView) -> Int {
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            return MusicPlayerManager.shared.ArrDownloadedSongs.count
//        }else{
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                return MusicPlayerManager.shared.Bhajan_Track_Trending.count
//            }
//            else{
//                return MusicPlayerManager.shared.Bhajan_Track.count
//            }
//            
//        }
//    }
//    
//    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            
//            let imageArray = MusicPlayerManager.shared.ArrDownloadedSongs[index].image
//            if let url = URL(string: imageArray!) {
//                cell.imageView?.contentMode = .scaleToFill
////                 cell.imageView?.layer.cornerRadius = 12.0
//                cell.imageView?.sd_setShowActivityIndicatorView(true)
//                cell.imageView?.sd_setIndicatorStyle(.gray)
//                cell.imageView?.clipsToBounds = true
//                cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
//            }
//            return cell
//        }
//        else{
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                let imageArray = MusicPlayerManager.shared.Bhajan_Track_Trending[index].image
//                if let url = URL(string: imageArray) {
//                    cell.imageView?.contentMode = .scaleAspectFill
////                     cell.imageView?.layer.cornerRadius = 12.0
//                    cell.imageView?.sd_setShowActivityIndicatorView(true)
//                    cell.imageView?.sd_setIndicatorStyle(.gray)
//                    cell.imageView?.clipsToBounds = true
//                    cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
//                }
//            }
//            else{
//                let imageArray = MusicPlayerManager.shared.Bhajan_Track[index].image
//                if let url = URL(string: imageArray!) {
//                    cell.imageView?.contentMode = .scaleToFill
////                     cell.imageView?.layer.cornerRadius = 12.0
//                    cell.imageView?.sd_setShowActivityIndicatorView(true)
//                    cell.imageView?.sd_setIndicatorStyle(.gray)
//                    cell.imageView?.clipsToBounds = true
//                    cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
//                }
//            }
//            
//            
//        }
//        return cell
//    }
//    
//    
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int){
//        
//        
//        if MusicPlayerManager.shared.isDownloadedSong {
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if MusicPlayerManager.shared.Bhajan_Track.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[index]
//                    let url =  posts.media_file
//                    
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found remove song download again")
//                        return
//                    }
//                    
//                    MusicPlayerManager.shared.PlayURl(url: url!)
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = index
//                    songTitle.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].title
//                    artistLbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].artist_name
//                    
//                    SonglikeOrDislike()
//                    setupTimer()
//                }
//            }
//            else{
//                if MusicPlayerManager.shared.Bhajan_Track.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.ArrDownloadedSongs[index]
//                    let url =  posts.media_file
//                    
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found remove song download again")
//                        return
//                    }
//                    
//                    MusicPlayerManager.shared.PlayURl(url: url!)
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = index
//                    songTitle.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].title
//                    artistLbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].artist_name
//                    
//                    SonglikeOrDislike()
//                    setupTimer()
//                }
//            }
//            
//            
//            
//        }else{
//            
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.Bhajan_Track_Trending[index]
//                    let url =  posts.media_file
//                    
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found")
//                        return
//                    }
//                    
//                    MusicPlayerManager.shared.PlayURl(url: url)
//                    setupTimer()
//                    
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = index
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].artist_name
//                    
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    
//                }
//                
//            }
//            else{
//                if MusicPlayerManager.shared.Bhajan_Track.count != 0
//                {
//                    let posts = MusicPlayerManager.shared.Bhajan_Track[index]
//                    let url =  posts.media_file
//                    
//                    if url == nil || url == ""{
//                        AlertController.alert(title: "bhajan Path not found")
//                        return
//                    }
//                    
//                    MusicPlayerManager.shared.PlayURl(url: url!)
//                    setupTimer()
//                    
//                    Activityloader.isHidden = false
//                    Activityloader.startAnimating()
//                    MusicPlayerManager.shared.song_no = index
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track[index].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track[index].artist_name
//                    
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    
//                }
//            }
//            
//        }
//    }
//    
//}
//
//
////MARK:- Audio player UI update and Functionality
//
//extension audioPlayerVc {
//    
////MARK:- Update Player UI
//    func UpdatePlayerUI(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            if MusicPlayerManager.shared.isDownloadedSong{
//                if MusicPlayerManager.shared.ArrDownloadedSongs.count > 0{
//                    self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
//                    self.songTitle.text = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].title
//                    self.artistLbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].artist_name
//                    self.SonglikeOrDislike()
//                    
//                    let bhajanID = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].id ?? ""
//                    let param : Parameters
//                    param  = ["user_id": currentUser.result!.id!,"bhajan_id":bhajanID]
//                    self.BhajanDetails(param)
//                    
//                }
//            }else{
//                
//                if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                    if MusicPlayerManager.shared.Bhajan_Track_Trending.count > 0{
//                        self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
//                        self.songTitle.text = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].title
//                        self.artistLbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].artist_name
//                        self.SonglikeOrDislike()
//                        self.AlredayDownloaded()
//                        self.AlreadyAddedPlayList()
//                        
//                        let bhajanID = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].id
//                        
//                        let param : Parameters
//                        param  = ["user_id": currentUser.result!.id ?? "","bhajan_id":bhajanID]
//                        self.BhajanDetails(param)
//                        
//                    }
//                }
//                else if MusicPlayerManager.shared.isRadioSatsang{
//                    
//                    
//                }
//                else{
//                    if MusicPlayerManager.shared.Bhajan_Track.count > 0{
//                        self.pagerView.scrollToItem(at: MusicPlayerManager.shared.song_no, animated: false)
//                        self.songTitle.text = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].title
//                        self.artistLbl.text = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].artist_name
//                        self.SonglikeOrDislike()
//                        self.AlredayDownloaded()
//                        self.AlreadyAddedPlayList()
//                        
//                        let bhajanID = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].id ?? ""
//                        
//                        let param : Parameters
//                        param  = ["user_id": currentUser.result!.id ?? "","bhajan_id":bhajanID]
//                        self.BhajanDetails(param)
//                        
//                    }
//                }
//                
//                
//            }
//        }
//    }
//    
//    // MARK:- confirm protocol of pagerView and cell size and animation(pagerView.transformer) type of pagerview
//    func pagerViewUIsetup(){
//        
//        pagerView.dataSource = self
//        pagerView.delegate = self
//        pagerView.transformer = FSPagerViewTransformer(type: .linear)
//        let transform = CGAffineTransform(scaleX: 0.0 , y: 0.0)
//        self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
//        pagerView.isInfinite = false
//        pagerView.contentMode = .scaleToFill
//        pagerView.isUserInteractionEnabled = false
//        pagerView.itemSize = CGSize(width: 170, height: 170)
//        pagerView.interitemSpacing = 100
//        
//    }
//    
//    
////MARK:- Song like and Dislike
//
//    func SonglikeOrDislike(){
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            
//            guard  MusicPlayerManager.shared.ArrDownloadedSongs.count != 0 else {
//                return
//            }
//            self.downloadBtn.setImage(UIImage(named : "downloaded_complete"), for: .normal)
//            
//            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
//            if post.is_like == "1" {
//                self.likeBtn.setImage(UIImage(named : "audio_liked"), for: .normal)
//                totalLikes = Int(MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].likes ?? "0")!
//            }else {
//                self.likeBtn.setImage(UIImage(named : "audio_like"), for: .normal)
//                totalLikes = Int(MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].likes ?? "0")!
//            }
//            
//            if self.totalLikes == 1{
//                self.likeLbl.text = "\(self.totalLikes) like"
//            }else if totalLikes == 0{
//                self.likeLbl.text = "No like"
//            }
//            else{
//                self.likeLbl.text = "\(self.totalLikes) likes"
//            }
//            
//        }else{
//            
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                guard  MusicPlayerManager.shared.Bhajan_Track_Trending.count != 0 else {
//                    return
//                }
//                
//                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//                
//                if post.is_audio_playlist_exist == "1"{
//                    addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                    addToplaylistBtn.isUserInteractionEnabled = false
//                    addToPlaylistLbl.text = "Added to PlayList"
//                }
//                else{
//                    addToplaylistBtn.setImage(UIImage(named : "add_playlist"), for: .normal)
//                    addToPlaylistLbl.text = "Add to PlayList"
//                    addToplaylistBtn.isUserInteractionEnabled = true
//                    print("This song is not available in Play List")
//                }
//                if post.is_like == "1" {
//                    self.likeBtn.setImage(UIImage(named : "audio_liked"), for: .normal)
//                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes )!
//                }else {
//                    self.likeBtn.setImage(UIImage(named : "audio_like"), for: .normal)
//                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes )!
//                }
//                
//            }
//            else{
//                guard  MusicPlayerManager.shared.Bhajan_Track.count != 0 else {
//                    return
//                }
//                
//                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//                if post.is_like == "1" {
//                    self.likeBtn.setImage(UIImage(named : "audio_liked"), for: .normal)
//                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes ?? "0")!
//                }else {
//                    self.likeBtn.setImage(UIImage(named : "audio_like"), for: .normal)
//                    totalLikes = Int(MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes ?? "0")!
//                }
//                
//            }
//            
//            if self.totalLikes == 1{
//                self.likeLbl.text = "\(self.totalLikes) like"
//            }else if totalLikes == 0{
//                self.likeLbl.text = "No like"
//            }
//            else{
//                self.likeLbl.text = "\(self.totalLikes) likes"
//            }
//            
//        }
//    }
//    
//    //MARK:- timer for slider.
//    func setupTimer(){
//        timer = Timer(timeInterval: 0.001, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
//        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
//    }
//    
//    // MARK:- This function will call every 1 second to update the value of slider & time duration label
//    @objc func tick(){
//        
//        endTimeLbl.text = MusicPlayerManager.shared.duration_Lbl
//        startTimeLbl.text = MusicPlayerManager.shared.current_TimeLbl
//        
//        pauseOrPlay()
//        
//        if(MusicPlayerManager.shared.myPlayer.currentTime().seconds == 0.0) {
//            Activityloader.isHidden = false
//            playBtn.isHidden = true
//            Activityloader.startAnimating()
//        }
//        else{
//            Activityloader.isHidden = true
//            playBtn.isHidden = false
//            Activityloader.stopAnimating()
//        }
//        if(MusicPlayerManager.shared.isPaused == false){
//            if(MusicPlayerManager.shared.myPlayer.rate == 0){
//                MusicPlayerManager.shared.myPlayer.play()
//                Activityloader.isHidden = false
//                playBtn.isHidden = true
//                Activityloader.startAnimating()
//            }else{
//                Activityloader.isHidden = true
//                Activityloader.stopAnimating()
//                playBtn.isHidden = false
//            }
//        }
//        
//    }
//    
//    func formatTimeFromSeconds(totalSeconds: Int32) -> String {
//        let seconds: Int32 = totalSeconds%60
//        let minutes: Int32 = (totalSeconds/60)%60
//        let hours: Int32 = totalSeconds/3600
//        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
//    }
//    
//    
////MARK:- Play next song automatic
//    
//    func PlayNextAutomatic(){
//        
//        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
//    }
//    
//    @objc func didPlayToEnd(){
//        PlayNextSong()
//    }
//    
//    //MARK:- This function will call in didPlayToEnd absorver when call
//    func PlayNextSong(){
//        
//        Activityloader.isHidden = false
//        playBtn.isHidden = true
//        Activityloader.startAnimating()
//        
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            self.item = self.pagerView.currentIndex
//            if MusicPlayerManager.shared.ArrDownloadedSongs.count-1 < self.item{
//                return
//            }
//            
//            if self.item != MusicPlayerManager.shared.ArrDownloadedSongs.count - 1 {
//                self.pagerView.scrollToItem(at: self.item+1, animated: true)
//                MusicPlayerManager.shared.song_no = self.item+1
//                songTitle.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].title
//                artistLbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[self.item+1].artist_name
//                SonglikeOrDislike()
//                pauseOrPlay()
//                
//                
//            }
//            
//        }
//        else{
//            self.item = self.pagerView.currentIndex
//            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if MusicPlayerManager.shared.Bhajan_Track_Trending.count-1 < self.item{
//                    return
//                }
//                if self.item != MusicPlayerManager.shared.Bhajan_Track_Trending.count - 1 {
//                    self.pagerView.scrollToItem(at: self.item+1, animated: true)
//                    MusicPlayerManager.shared.song_no = self.item+1
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[self.item+1].artist_name
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    pauseOrPlay()
//                    
//                }
//            }
//            else{
//                if MusicPlayerManager.shared.Bhajan_Track.count-1 < self.item{
//                    return
//                }
//                if self.item != MusicPlayerManager.shared.Bhajan_Track.count - 1 {
//                    self.pagerView.scrollToItem(at: self.item+1, animated: true)
//                    MusicPlayerManager.shared.song_no = self.item+1
//                    songTitle.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].title
//                    artistLbl.text = MusicPlayerManager.shared.Bhajan_Track[self.item+1].artist_name
//                    SonglikeOrDislike()
//                    AlredayDownloaded()
//                    AlreadyAddedPlayList()
//                    pauseOrPlay()
//                    
//                }
//            }
//            
//            
//            
//        }
//        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.Activityloader.isHidden = true
//            self.Activityloader.stopAnimating()
//            self.playBtn.isHidden = false
//            
//        }
//        
//    }
//    
//    func pauseOrPlay(){
//        if MusicPlayerManager.shared.myPlayer.isPlaying{
//            playBtn.setImage(UIImage(named:"audio_pause"), for: .normal)
//            MusicPlayerManager.shared.isPaused = false
//            Activityloader.isHidden = true
//        }
//        else{
//            playBtn.setImage(UIImage(named:"audio_play"), for: .normal)
//            MusicPlayerManager.shared.isPaused = true
//        }
//        
//    }
//    
////MARK:- Add to playlist functionality
//    
//    func AddPlayList(){
//        
//        var param : Parameters
//        param = ["user_id":currentUser.result?.id ?? "", "type":"1", "bhajan_id":""]
//        print("playList")
//        if currentUser.result!.id! == "163"{
//            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//            navigationController?.pushViewController(vc, animated: true)
//            return
//        }else{
//            var tempArr =  NSMutableArray()
//            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                if MusicPlayerManager.shared.Bhajan_Track_Trending.count == 0{
//                    return
//                }
//            }
//            else{
//                if MusicPlayerManager.shared.Bhajan_Track.count == 0{
//                    return
//                }
//            }
//            
//            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//                
//                param.updateValue("\(playingAudioTrack.id)", forKey: "bhajan_id")
//                addToPlaylist(param)
//                
//                if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
//                    tempArr = NSMutableArray.init(array: savedArray)
//                    let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
//                    let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
//                    
//                    if playListArr.count == 0 {
//                        tempArr.add(playingAudioTrack.dictionaryRepresentation())
//                        TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                        addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                        addToPlaylistLbl.text = "Added to PlayList"
//                        print("The song is added successfully in Play List")
//                    }else{
//                        addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                        addToPlaylistLbl.text = "Added to PlayList"
//                        print("This song is already available in Play List")
//                    }
//                    
//                }else{
//                    tempArr.add(playingAudioTrack.dictionaryRepresentation())
//                    TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                    addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                    addToPlaylistLbl.text = "Added to PlayList"
//                    print("This song is already available in Play List")
//                    
//                }
//                
//            }
//            else{
//                let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//                
//                param.updateValue(playingAudioTrack.id ?? "", forKey: "bhajan_id")
//                addToPlaylist(param)
//                if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
//                    tempArr = NSMutableArray.init(array: savedArray)
//                    let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
//                    let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
//                    
//                    if playListArr.count == 0 {
//                        tempArr.add(playingAudioTrack.dictionaryRepresentation())
//                        TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                        addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                        addToPlaylistLbl.text = "Added to PlayList"
//                        print("The song is added successfully in Play List")
//                    }else{
//                        addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                        addToPlaylistLbl.text = "Added to PlayList"
//                        print("This song is already available in Play List")
//                    }
//                    
//                }else{
//                    tempArr.add(playingAudioTrack.dictionaryRepresentation())
//                    TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                    addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                    addToPlaylistLbl.text = "Added to PlayList"
//                    print("This song is already available in Play List")
//                    
//                }
//                
//            }
//            
//        }
//    }
//    
//
//    
//    
//}
//
//// MARK:- number of like and user liked or not and number of views
//
//extension audioPlayerVc {
//    func BhajanDetails(_ param : Parameters) {
//        self.uplaodData(APIManager.sharedInstance.get_bhajan_meta_data , param) { (response) in
//            print(response as Any)
//            if let JSON = response as? NSDictionary {
//                print(JSON)
//                
//                if "\(JSON["status"]!)" == "1"{
//                    
//                    let  data = JSON["data"]! as? Dictionary<String,Any>
//                    let is_like = data!.validatedValue("is_like")
//                    let likes = data!.validatedValue("likes")
//                    
//                    if is_like == "1" {
//                        self.likeBtn.setImage(UIImage(named : "audio_liked"), for: .normal)
//                    }else {
//                        self.likeBtn.setImage(UIImage(named : "audio_like"), for: .normal)
//                    }
//                    
//                    if likes == "1"{
//                        self.likeLbl.text = "\(self.totalLikes) like"
//                    }else if likes == "0"{
//                        self.likeLbl.text = "No like"
//                    }else{
//                        self.likeLbl.text = "\(self.totalLikes) likes"
//                    }
//                    
//                }
//                
//            }
//            else{
//                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
//            }
//        }
//    }
//
////MARK:- Add to playlist API Hit
//    
//    func addToPlaylist(_ param : Parameters) {
//        self.uplaodData(APIManager.sharedInstance.KAddRemovePlaylist , param) { (response) in
//            print(response as Any)
//            if let JSON = response as? NSDictionary {
//                print(JSON)
//                
//                if "\(JSON["status"]!)" == "1"{
//                    
//                }
//                else{
//                    let message = JSON["message"] as! String
//                    self.addAlert(ALERTS.KERROR, message: message, buttonTitle: ALERTS.kAlertOK)
//                }
//                
//            }
//            else{
//                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
//            }
//        }
//    }
//    
////MARK:- like and dislike API hit
//    
//    func likeDisLikeApi(_ apiName : String)  {
//        
//        
//        if currentUser.result!.id! == "163"{
//            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//            navigationController?.pushViewController(vc, animated: true)
//            return
//        }
//        
//        var param : Parameters
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
//            param = ["bhajan_id" : post.id!, "user_id" : currentUser.result!.id ?? ""]
//            
//        }else{
//            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                
//                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//                param = ["bhajan_id" : post.id, "user_id" : currentUser.result!.id ?? ""]
//                
//            }
//            else{
//                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//                param = ["bhajan_id" : post.id!, "user_id" : currentUser.result!.id ?? ""]
//                
//            }
//        }
//        
//        viewcontroller.uplaodData(apiName, param) { (response) in
//            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
//            print(response as Any)
//            self.likeBtn.isUserInteractionEnabled = true
//            
//            if let JSON = response as? NSDictionary {
//                print(JSON)
//                if JSON.value(forKey: "status") as? Bool == true {
//                    if  JSON.value(forKey: "message") as? String == "User liked." {
//                        
//                        self.totalLikes = self.totalLikes + 1
//                        
//                        if self.totalLikes == 1{
//                            self.likeLbl.text = "\(self.totalLikes) like"
//                        }else{
//                            self.likeLbl.text = "\(self.totalLikes) likes"
//                        }
//                        
//                        if MusicPlayerManager.shared.isDownloadedSong{
//                            self.isLikes = "1"
//                            self.updateCoredata()
//                        }
//                        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
//                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].is_like = "1"
//                            self.likeBtn.setImage(UIImage(named : "audio_liked"), for: .normal)
//                        }
//                        else{
//                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
//                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].is_like = "1"
//                            self.likeBtn.setImage(UIImage(named : "audio_liked"), for: .normal)
//                            
//                        }
//                        
//                        
//                    }else{
//                        self.totalLikes = self.totalLikes - 1
//                        if self.totalLikes == 0{
//                            self.likeLbl.text = "No like"
//                        }else if self.totalLikes == 1 {
//                            self.likeLbl.text = "\(self.totalLikes) like"
//                        }else {
//                            self.likeLbl.text = "\(self.totalLikes) likes"
//                        }
//                        
//                        if MusicPlayerManager.shared.isDownloadedSong{
//                            self.isLikes = "0"
//                            self.updateCoredata()
//                        }
//                        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
//                            MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no].is_like = "0"
//                            self.likeBtn.setImage(UIImage(named : "audio_like"), for: .normal)
//                        }
//                        else{
//                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].likes = "\(self.totalLikes)"
//                            MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no].is_like = "0"
//                            self.likeBtn.setImage(UIImage(named : "audio_like"), for: .normal)
//                        }
//                        
//                    }
//                }
//            }
//            
//        }
//    }
//}
//
////MARK:- Update Core data
//
//extension audioPlayerVc {
//    
//    func updateCoredata(){
//        
//        let id =  MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no].id ?? ""
//        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
//            fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
//            do {
//                let results = try context.fetch(fetchRequest) as? [NSManagedObject]
//                if results?.count != 0 {
//                    // Atleast one was returned
//                    // In my case, I only updated the first item in results
//                    results?[0].setValue("\(self.totalLikes)", forKey: "likes")
//                    results?[0].setValue(isLikes, forKey: "is_like")
//                    
//                    getUpdatedLocalSongs()
//                }
//            } catch {
//                print("Fetch Failed: \(error)")
//            }
//            
//            do {
//                try context.save()
//            }
//            catch {
//                print("Saving Core Data Failed: \(error)")
//            }
//            
//        }
//    }
//    
//// MARK:- call this function when like downloaded songs and initialize again
//    func getUpdatedLocalSongs(){
//        
//        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
//                if let theAudio = tempAudio {
//                    MusicPlayerManager.shared.ArrDownloadedSongs = theAudio
//                    do{
//                        try context.save()
//                    }
//                    catch
//                    {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK:- if song is Alreday Downloaded
//
//extension audioPlayerVc{
//    
//    
//    func AlredayDownloaded(){
//        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//            let tempData = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//            let context = appDelegate.persistentContainer.viewContext
//            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
//                if let theAudio = tempAudio {
//                    if let audioUrl = URL(string: tempData.media_file) {
//                        // MARK:-  then lets create your document folder url
//                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                        // MARK:- lets create your destination file url
//                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//                        print(destinationUrl)
//                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                            print("The file already exists at path")
//                            self.downloadBtn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
//                            self.downloadLbl.text = "Downloaded"
//                        }else{
//                            self.downloadBtn.setImage(UIImage(named: "download_audio"), for: .normal)
//                            self.downloadLbl.text = "Download"
//                        }
//                        do {
//                            try context.save()
//                        } catch {
//                            print("Failed saving")
//                        }
//                    }
//                }
//            }
//            
//        }
//        else{
//            let tempData = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//            let context = appDelegate.persistentContainer.viewContext
//            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
//                if let theAudio = tempAudio {
//                    if let audioUrl = URL(string: tempData.media_file!) {
//                        // MARK:-  then lets create your document folder url
//                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                        // MARK:- lets create your destination file url
//                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//                        print(destinationUrl)
//                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                            print("The file already exists at path")
//                            self.downloadBtn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
//                            self.downloadLbl.text = "Downloaded"
//                        }else{
//                            self.downloadBtn.setImage(UIImage(named: "download_audio"), for: .normal)
//                            self.downloadLbl.text = "Download"
//                        }
//                        do {
//                            try context.save()
//                        } catch {
//                            print("Failed saving")
//                        }
//                    }
//                }
//            }
//        }
//        
//    }
//    
////MARK:- Already add to playlist
//
//    func AlreadyAddedPlayList(){
//        
//        if MusicPlayerManager.shared.isDownloadedSong{
//            return
//        }
//        print("playList")
//        var tempArr =  NSMutableArray()
//        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//            let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//            if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
//                tempArr = NSMutableArray.init(array: savedArray)
//                let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
//                let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
//                
//                if playListArr.count != 0 {
//                    addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                    addToPlaylistLbl.text = "Added to PlayList"
//                    print("This song is available in Play List")
//                }else{
//                    addToplaylistBtn.setImage(UIImage(named : "add_playlist"), for: .normal)
//                    addToPlaylistLbl.text = "Add to PlayList"
//                    print("This song is not available in Play List")
//                }
//            }
//        }
//        else{
//            let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//            if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
//                tempArr = NSMutableArray.init(array: savedArray)
//                let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
//                let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
//                
//                if playListArr.count != 0 {
//                    addToplaylistBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//                    addToPlaylistLbl.text = "Added to PlayList"
//                    print("This song is available in Play List")
//                }else{
//                    addToplaylistBtn.setImage(UIImage(named : "add_playlist"), for: .normal)
//                    addToPlaylistLbl.text = "Add to PlayList"
//                    print("This song is not available in Play List")
//                }
//            }
//        }
//        
//        
//    }
//}
//
////MARK:- extentsion for  download song function
//
//extension audioPlayerVc {
//    
//    //MARK:- Download all audio data.
//    func downloadAudio()
//    {
//        if downloadProgress.progress != 0.00
//        {
//            self.downloadBtn.isUserInteractionEnabled = true
//            _ = SweetAlert().showAlert("", subTitle: "Another Audio is Already added on Queue", style: AlertStyle.error)
//            return
//        }
//        
//        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
//            let tempData = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
//            
//            let context = appDelegate.persistentContainer.viewContext
//            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
//                
//                if let theAudio = tempAudio {
//                    
//                    if let audioUrl = URL(string: tempData.media_file) {
//                        // MARK:-  then lets create your document folder url
//                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                        // MARK:- lets create your destination file url
//                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//                        print(destinationUrl)
//                        
//                        // MARK:- to check if it exists before downloading it
//                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                            print("The file already exists at path")
//                            self.downloadBtn.isUserInteractionEnabled = true
//                            _ = SweetAlert().showAlert("", subTitle: "This Audio Already Downloaded", style: AlertStyle.success)
//                        }
//                        else
//                        {
//                            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
//                            Alamofire.download(tempData.media_file , method: .get, parameters: nil,encoding: JSONEncoding.default,headers: nil,to: destination).downloadProgress(closure: { (progress) in
//                                
//                                self.downloadProgress.progress = Double(progress.fractionCompleted)
//                                
//                                
//                                // MARK:-  progress closure
//                                print(progress)
//                            }).response(completionHandler: { (DefaultDownloadResponse) in
//                                // MARK:- here you able to access the DefaultDownloadResponse
//                                // MARK:- result closure
//                                self.downloadProgress.progress = 0.00
//                                
//                                if DefaultDownloadResponse.error != nil
//                                {
//                                    self.downloadProgress.progress = 0.00
//                                    return
//                                }
//                                
//                                let userEntity = NSEntityDescription.entity(forEntityName: "Audio", in: context)!
//                                let audio = NSManagedObject(entity: userEntity, insertInto: context)
//                                audio.setValue(tempData.id, forKeyPath: "id")
//                                audio.setValue(tempData.title, forKey: "title")
//                                
//                                if  DefaultDownloadResponse.destinationURL?.path != nil{
//                                    let urlString: String =  (DefaultDownloadResponse.destinationURL?.path)!
//                                    audio.setValue(urlString, forKey: "media_file")
//                                    print(urlString)
//                                }
//                                
//                                audio.setValue(tempData.artist_name, forKey: "artist_name")
//                                audio.setValue(tempData.image, forKey: "image")
//                                audio.setValue(tempData.is_like, forKey: "is_like")
//                                audio.setValue(tempData.likes, forKey: "likes")
//                                audio.setValue(tempData.artist_name, forKey: "desp")
//                                
//                                self.downloadBtn.isUserInteractionEnabled = true
//                                self.downloadBtn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
//                                self.downloadLbl.text = "Downloaded"
//                            })
//                        }
//                        do {
//                            try context.save()
//                        } catch {
//                            print("Failed saving")
//                        }
//                        
//                    }
//                }
//                
//            }
//        }
//        else{
//            let tempData = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
//            
//            let context = appDelegate.persistentContainer.viewContext
//            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
//                
//                if let theAudio = tempAudio {
//                    
//                    if let audioUrl = URL(string: tempData.media_file!) {
//                        // MARK:-  then lets create your document folder url
//                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                        // MARK:- lets create your destination file url
//                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//                        print(destinationUrl)
//                        
//                        // MARK:- to check if it exists before downloading it
//                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                            print("The file already exists at path")
//                            self.downloadBtn.isUserInteractionEnabled = true
//                            _ = SweetAlert().showAlert("", subTitle: "This Audio Already Downloaded", style: AlertStyle.success)
//                        }
//                        else
//                        {
//                            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
//                            Alamofire.download(tempData.media_file! , method: .get, parameters: nil,encoding: JSONEncoding.default,headers: nil,to: destination).downloadProgress(closure: { (progress) in
//                                
//                                self.downloadProgress.progress = Double(progress.fractionCompleted)
//                                
//                                
//                                // MARK:-  progress closure
//                                print(progress)
//                            }).response(completionHandler: { (DefaultDownloadResponse) in
//                                // MARK:- here you able to access the DefaultDownloadResponse
//                                // MARK:- result closure
//                                self.downloadProgress.progress = 0.00
//                                
//                                if DefaultDownloadResponse.error != nil
//                                {
//                                    self.downloadProgress.progress = 0.00
//                                    return
//                                }
//                                
//                                let userEntity = NSEntityDescription.entity(forEntityName: "Audio", in: context)!
//                                let audio = NSManagedObject(entity: userEntity, insertInto: context)
//                                audio.setValue(tempData.id, forKeyPath: "id")
//                                audio.setValue(tempData.title, forKey: "title")
//                                
//                                if  DefaultDownloadResponse.destinationURL?.path != nil{
//                                    let urlString: String =  (DefaultDownloadResponse.destinationURL?.path)!
//                                    audio.setValue(urlString, forKey: "media_file")
//                                    print(urlString)
//                                }
//                                
//                                audio.setValue(tempData.artist_name, forKey: "artist_name")
//                                audio.setValue(tempData.image, forKey: "image")
//                                audio.setValue(tempData.is_like, forKey: "is_like")
//                                audio.setValue(tempData.likes, forKey: "likes")
//                                audio.setValue(tempData.artist_name, forKey: "desp")
//                                
//                                self.downloadBtn.isUserInteractionEnabled = true
//                                self.downloadBtn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
//                                self.downloadLbl.text = "Downloaded"
//                            })
//                        }
//                        do {
//                            try context.save()
//                        } catch {
//                            print("Failed saving")
//                        }
//                        
//                    }
//                }
//                
//            }
//        }
//        
//        
//        
//    }
//    
//}
//
//
//
//
//
