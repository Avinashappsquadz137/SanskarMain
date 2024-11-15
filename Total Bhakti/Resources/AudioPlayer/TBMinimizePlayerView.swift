//
//  TBAudioPlayerView.swift
//  Total Bhakti
//
//  Created by MAC MINI on 30/01/19.
//  Copyright © 2019 MAC MINI. All rights reserved.
//

import UIKit

class TBMinimizePlayerView: UIView {
    
    //MARK: IBOutlets
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    //MARK:- ALL VARIABLE.
    var timer: Timer?
    var isPaused: Bool!
    var arrDownloadedAudio = [Audio]()
    var radioChannel:channelModel?
    var comingFor = "miniPlayer"
    var isStartAd: Bool!
    
    // orgin for hiddin view
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    
    let minimizedOrigin: CGRect = {
        let x = UIScreen.main.bounds.width - UIScreen.main.bounds.width
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 8
        let coordinate = CGRect.init(x: x, y: y, width: UIScreen.main.bounds.width, height: 64)
        return coordinate
    }()
    
    public convenience init() {
        NSLog("   CustomView.init()")
        self.init(frame: CGRect.zero)
    }
    
    public override convenience init(frame: CGRect) {
        NSLog("CustomView.init(frame:)")
        self.init(internal: nil)
        self.frame = frame
    }
    
    public required init?(coder aDecoder: NSCoder) {
        NSLog("CustomView.init(coder:)")
        super.init(coder: aDecoder)
    }
    
    //MARK:-  it has been loaded from an Interface Builder archive, or nib file.
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 4.0
        imageView.clipsToBounds = true
        
        // Add miniPlayerView using this Notification view
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("openMinimizePlayerView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideOrizine), name: NSNotification.Name("hideOrizine"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        
        NSLog("CustomView.awakeFromNib()")
        
        
        // gesture for tap swipe open player
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openPlayer))
        self.addGestureRecognizer(tap)
    }
    
    //MARK:- Run when UIView appears on screen
    override func layoutSubviews() {
        print("run when UIView appears on screen")
        // you can update your label's text or etc.
        
        
    }
    
    
    @objc func hideOrizine(notification : NSNotification){
        
        self.frame.origin = self.hiddenOrigin
        
    }
    
    
    //MARK: IBACTIONS ON BUTTONS.
    @IBAction func clickToAudioPlayer(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "maximizeAudioPlayer"), object: nil)
    }
   
    @IBAction func nextSongAction(_ sender: Any) {
        if MusicPlayerManager.shared.isRadioSatsang{
            //
        }else{
            MusicPlayerManager.shared.nextSong()
            MusicPlayerManager.shared.songDidChnagedFromNotification()
        }
        
    }
    @IBAction func previousSongAction(_ sender: Any) {
        if MusicPlayerManager.shared.isRadioSatsang{
            //
        }else{
        MusicPlayerManager.shared.previousSong()
        MusicPlayerManager.shared.songDidChnagedFromNotification()
        }
    }
    
    @IBAction func btnPlayPauseAction(_ sender: Any) {
        
        if MusicPlayerManager.shared.myPlayer.timeControlStatus == .playing  {
            btnPlayPause.setImage(UIImage(named:"audio_play"), for: .normal)
            MusicPlayerManager.shared.myPlayer.pause()
            MusicPlayerManager.shared.isPaused = true
        } else {
            btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
            MusicPlayerManager.shared.myPlayer.play()
            MusicPlayerManager.shared.isPaused = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pausePost"), object: nil)
            
        }
    }
    
    // MARK:- exit Audio.
    @IBAction func clickToExitPlayer(_ sender: Any) {
        
        self.frame.origin = self.hiddenOrigin
        MusicPlayerManager.shared.myPlayer.pause()
        MusicPlayerManager.shared.isPaused = true
        MusicPlayerManager.shared.timer?.invalidate()
        MusicPlayerManager.shared.myPlayer.replaceCurrentItem(with: nil)
        timer?.invalidate()
        
    }
    
    //MARK:- Open main Full Audio Player
    
    @objc func openPlayer(sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AudioPlayer"), object: nil)
    }
    
    //MARK:- Add player on View
    
    @objc func tapPlayView(notification : NSNotification)
    {
        MusicPlayerManager.shared.songDidChnagedFromNotification = { [weak self] ()  in
            self?.updatePlayerUI()
            
        }

        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("openMinimizePlayerView"), object: nil)
        
        self.frame = self.minimizedOrigin
        let screenSize = UIScreen.main.bounds
        
        
        if UIScreen.main.nativeBounds.height >= 1792{
            
            let x = UIScreen.main.bounds.width - UIScreen.main.bounds.width
            let origin = UIScreen.main.bounds.height-80-70
            let coordinate = CGRect.init(x: x, y: origin, width: UIScreen.main.bounds.width, height: 64)
            self.frame = coordinate
        }
        
        if (screenSize.height == 812)
        {
            let x = UIScreen.main.bounds.width - UIScreen.main.bounds.width
            let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 37
            let coordinate = CGRect.init(x: x, y: y, width: UIScreen.main.bounds.width, height: 64)
            self.frame = coordinate
            
        }
        updatePlayerUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("openMinimizePlayerView"), object: nil)
        
    }
    
    func updatePlayerUI(){
       
        if MusicPlayerManager.shared.myPlayer.timeControlStatus == .playing  {
            btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
        }
        else
        {
            btnPlayPause.setImage(UIImage(named:"audio_play"), for: .normal)
            
        }
        
        if MusicPlayerManager.shared.isDownloadedSong {
            
            if MusicPlayerManager.shared.ArrDownloadedSongs.count == 0{
                return
            }
            
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            imageView.sd_setImage(with: URL(string: post.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            
            
            lblSongName.text = post.title
            lblArtistName.text = post.artist_name
            
            if MusicPlayerManager.shared.myPlayer.isPlaying == true
            {
                btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
            }
            setupTimer()
            
        }else{
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if MusicPlayerManager.shared.Bhajan_Track_Trending.count == 0{
                    return
                }
                
                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                imageView.sd_setImage(with: URL(string: post.image), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                lblSongName.text = post.title
                lblArtistName.text = post.artist_name
                
                if MusicPlayerManager.shared.myPlayer.isPlaying == true
                {
                    btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
                }
                setupTimer()
            }
            else if MusicPlayerManager.shared.isRadioSatsang{
                let post = MusicPlayerManager.shared.radioChannel ?? self.radioChannel
                imageView.sd_setImage(with: URL(string: post?.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                lblSongName.text = post?.name
                lblArtistName.text = "Sanskar"
            }
            else{
                if MusicPlayerManager.shared.Bhajan_Track.count == 0{
                    return
                }
                
                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                imageView.sd_setImage(with: URL(string: post.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                lblSongName.text = post.title
                lblArtistName.text = post.artist_name
                
                if MusicPlayerManager.shared.myPlayer.isPlaying == true
                {
                    btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
                }
                setupTimer()
                

            }

         }
    }
    
    
    
    //MARK:- PROGRESS VIEW.
    @objc func tick()
    {
        if MusicPlayerManager.shared.myPlayer != nil
        {
            if MusicPlayerManager.shared.myPlayer.timeControlStatus == .playing
            {
                if((MusicPlayerManager.shared.myPlayer.currentItem?.asset.duration) != nil){
                    let currentTime1 : CMTime = (MusicPlayerManager.shared.myPlayer.currentItem?.asset.duration)!
                    let seconds1 : Float64 = CMTimeGetSeconds(currentTime1)
                    let time1 : Float = Float(seconds1)
                    let currentTime : CMTime = (MusicPlayerManager.shared.myPlayer.currentTime())
                    let seconds : Float64 = CMTimeGetSeconds(currentTime)
                    let time : Float = Float(seconds)
                    self.progressView.progress = time/time1
                }
            }
            
            if MusicPlayerManager.shared.myPlayer.timeControlStatus == .playing  {
                btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
                
                
            }
            else
            {
                btnPlayPause.setImage(UIImage(named:"audio_play"), for: .normal)
                
            }
            
            
        }
    }
    
    //MARK:- CALL WHEN SONG ENDED.
    
    @objc func didPlayToEnd()
    {
        
        if MusicPlayerManager.shared.isDownloadedSong{
            let item = MusicPlayerManager.shared.song_no
            if MusicPlayerManager.shared.ArrDownloadedSongs.count-1 < item{
                btnPlayPause.setImage(UIImage(named:"audio_play"), for: .normal)
                return
            }
            
            if item != MusicPlayerManager.shared.ArrDownloadedSongs.count - 1 {
                lblSongName.text = MusicPlayerManager.shared.ArrDownloadedSongs[item+1].title
                lblArtistName.text = MusicPlayerManager.shared.ArrDownloadedSongs[item+1].artist_name
                
                let post = MusicPlayerManager.shared.ArrDownloadedSongs[item+1]
                imageView.sd_setImage(with: URL(string: post.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
                
            }
            
        }
        else{
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                let item = MusicPlayerManager.shared.song_no
                if MusicPlayerManager.shared.Bhajan_Track_Trending.count-1 < item{
                    btnPlayPause.setImage(UIImage(named:"audio_play"), for: .normal)
                    return
                }
                if item != MusicPlayerManager.shared.Bhajan_Track_Trending.count - 1 {
                    MusicPlayerManager.shared.song_no = item
                    lblSongName.text = MusicPlayerManager.shared.Bhajan_Track_Trending[item+1].title
                    lblArtistName.text = MusicPlayerManager.shared.Bhajan_Track_Trending[item+1].artist_name
                    
                    let post = MusicPlayerManager.shared.Bhajan_Track_Trending[item+1]
                    imageView.sd_setImage(with: URL(string: post.image), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                    btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
                    
                }
            }
            else{
                let item = MusicPlayerManager.shared.song_no
                if MusicPlayerManager.shared.Bhajan_Track.count-1 < item{
                    btnPlayPause.setImage(UIImage(named:"audio_play"), for: .normal)
                    return
                }
                if item != MusicPlayerManager.shared.Bhajan_Track.count - 1 {
                    MusicPlayerManager.shared.song_no = item
                    lblSongName.text = MusicPlayerManager.shared.Bhajan_Track[item+1].title
                    lblArtistName.text = MusicPlayerManager.shared.Bhajan_Track[item+1].artist_name
                    
                    let post = MusicPlayerManager.shared.Bhajan_Track[item+1]
                    imageView.sd_setImage(with: URL(string: post.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                    btnPlayPause.setImage(UIImage(named:"audio_pause"), for: .normal)
                    
                }
            }


        }
        
    }
    
    //MARK:- timer for slider.
    func setupTimer(){
        
        timer = Timer(timeInterval: 0.001, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
}

// MARK: Protocol extension

fileprivate protocol _CustomView {
}

extension TBMinimizePlayerView: _CustomView {
}

fileprivate extension _CustomView {
    
    init(internal: Int?) {
        self = Bundle.main.loadNibNamed("TBAudioPlayerView", owner:nil, options:nil)![0] as! Self;
    }
}



extension UIViewController{
    
    func AddNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.openPlayer), name: NSNotification.Name("AudioPlayer"), object: nil)
    }
    
    @objc func openPlayer(){

        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
        vc.isStartAd = true
        (TBHomeTabBar.currentInstance?.selectedViewController as? UINavigationController)?.present(vc, animated: true)
        
    }
}


