//
//  MusicPlayerManager.swift
//  Total Bhakti
//
//  Created by Viru on 19/03/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import Foundation
import MediaPlayer
import CoreData
import CircleProgressView
import AVKit
import SDWebImage
import Alamofire


class MusicPlayerManager{
    
     var songDidChnagedFromNotification = {() -> () in }
    
     
    
    static let shared = MusicPlayerManager()
    
    var nowPlayingInfo = [String:Any]()
    var myPlayer = AVPlayer()
    var Slider: UISlider!
    var timer: Timer?
    var backBtnClicked = 0
    var Bhajan_Track = [Bhajan]()
    var Bhajan_Track_Trending = [trendingBhajanModel]()
    var radioChannel:channelModel?
    var trendingBhajanString : String!
    var ArrDownloadedSongs = [Audio]()
    
    var isPaused = false
    var url = ""
    var duration_Lbl = ""
    var current_TimeLbl = ""
    var isDownloadedSong = false
    var isPlayList = false
    var is_downloaded = false
    var song_no = 0
    var isRadioSatsang = false
    
    
    func sliderTapped(_ sender: UILongPressGestureRecognizer) {
        if isRadioSatsang{
            return
        }
        if let slider = sender.view as? UISlider {
            if slider.isHighlighted { return }
            let point = sender.location(in: slider)
            let percentage = Float(point.x / slider.bounds.width)
            let delta = percentage * (slider.maximumValue - slider.minimumValue)
            let value = slider.minimumValue + delta
            slider.setValue(value, animated: false)
            let seconds : Int64 = Int64(value)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            myPlayer.seek(to: targetTime)
        }
    }
    
    //MARK:- timer for slider.
    func setupTimer(){
        if isRadioSatsang{
            duration_Lbl = "0.00"
            current_TimeLbl = "0.00"
            return
        }
        timer = Timer(timeInterval: 0.001, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc func tick(){
        
        
        if backBtnClicked == 0 {
            
            if((myPlayer.currentItem?.asset.duration) != nil){
                let currentTime1 : CMTime = (myPlayer.currentItem?.asset.duration)!
                let seconds1 : Float64 = CMTimeGetSeconds(currentTime1)
                let time1 : Float = Float(seconds1)
                self.Slider?.minimumValue = 0.0
                self.Slider?.maximumValue = time1
                let currentTime : CMTime = (myPlayer.currentTime())
                let seconds : Float64 = CMTimeGetSeconds(currentTime)
                let time : Float = Float(seconds)
                self.Slider?.value = time
                duration_Lbl =  self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((myPlayer.currentItem?.asset.duration) ?? CMTimeMakeWithSeconds(0,0) )))))
                
                let Currenttime =  myPlayer.currentItem?.currentTime()
                let str =  self.convert(second: Currenttime?.seconds ?? 0.0)



                current_TimeLbl = str
                    
//                    self.convert(second: (totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((myPlayer.playe myPlayer.currentItem?.currentTime()) ?? CMTimeMakeWithSeconds(0,0)))))))
                    
//                    self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((myPlayer.playe myPlayer.currentItem?.currentTime()) ?? CMTimeMakeWithSeconds(0,0))))))
                
                
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds((myPlayer.currentItem?.currentTime() ?? CMTimeMakeWithSeconds(1,1)))
                self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
                MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
                
                
            }
            else {
                duration_Lbl = "Live stream"
            }
        }
    }
    
    func PlayNextAutomatic(){
        if isRadioSatsang{
            return
        }
        if UserDefaults.standard.bool(forKey: "bhajanCountBool") == true{
            
            if trendingBhajanString == "trending bhajan"{
                let param : Parameters = ["user_id": currentUser.result?.id ?? "" , "bhajan_id": MusicPlayerManager.shared.Bhajan_Track_Trending[song_no].id]
                bhajanCountSendApi(param)
                UserDefaults.standard.setValue(false, forKey: "bhajanCountBool")
            }
            else{
                let param : Parameters = ["user_id": currentUser.result?.id ?? "" , "bhajan_id": MusicPlayerManager.shared.Bhajan_Track[song_no].id ?? ""]
                bhajanCountSendApi(param)
                UserDefaults.standard.setValue(false, forKey: "bhajanCountBool")
            }
        }
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    @objc func didPlayToEnd(){
        nextSong()
    }
    
    
    func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
    
    fileprivate func convert(second: Double) -> String {
            let component =  Date.dateComponentFrom(second: second)
            if let hour = component.hour ,
               let min = component.minute ,
               let sec = component.second {
                
                let fix =  hour > 0 ? NSString(format: "%02d:", hour) : ""
                return NSString(format: "%@%02d:%02d", fix,min,sec) as String
            } else {
                return "-:-"
            }
        }
    
    func PlayOrPause(_ sender:UIButton){
        pauseOrPlay()
    }
    
    func pauseOrPlay(){
        
        if myPlayer.isPlaying{
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            myPlayer.pause()
            isPaused = true
            timer?.invalidate()
        }
        else{
            
            myPlayer.play()
            PlayNextAutomatic()
            isPaused = false
            self.setupTimer()
            
        }
    }
    
    // MARK:- call this function by sending parameter of song url and play song
    func PlayURl(url:String){
        
        let url2 = URL(string:(url))
        //Get url of documents
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // lets create your destination file url
        
//        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url2!.lastPathComponent)     //  comment by avi tyagi
//                print(destinationUrl)      //  comment by avi tyagi
        if let url2 = url2 {
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url2.lastPathComponent)
            print(destinationUrl)
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                
                myPlayer.pause()
                myPlayer = AVPlayer(playerItem: AVPlayerItem(url: destinationUrl))
                myPlayer.play()
                self.setupTimer()
                PlayNextAutomatic()
                setupNotificationView()
                isPaused = false
                
            }else{
                myPlayer.pause()
                myPlayer = AVPlayer(url: URL(string: url)!)
                myPlayer.play()
                self.setupTimer()
                PlayNextAutomatic()
                setupNotificationView()
                isPaused = false
            }
            // Use destinationUrl as needed
        } else {
            print("Error: url2 is nil")
            // Handle the case where url2 is nil, throw an error, or take appropriate action
        }
        
        //MARK:-  play from local if exist in local
       
        
        if isDownloadedSong{
            let param : Parameters = ["user_id": currentUser.result!.id! , "type": "1" , "media_id" : ArrDownloadedSongs[song_no].id ?? ""]
            recentViewHit(param)
            
        }
        else{
            if trendingBhajanString == "trending bhajan"{
                let param : Parameters = ["user_id": currentUser.result!.id! , "type": "1" , "media_id" : Bhajan_Track_Trending[song_no].id]
                recentViewHit(param)

            }
            else if self.isRadioSatsang{
                
            }
//            else if Bhajan_Track != nil{
//                let param : Parameters = ["user_id": currentUser.result!.id! , "type": "1" , "media_id" : Bhajan_Track[song_no].id ?? ""]
//                recentViewHit(param)
//
//            }   // comment by avi tyagi
            else {
                let param : Parameters = ["user_id": currentUser.result!.id! , "type": "1" ]
                recentViewHit(param)
            }
        }
    }
    // MARK:- recent played songs API
    
    func recentViewHit(_ param: [String: Any]) {
        let url = APIManager.sharedInstance.KBASEURL + APIManager.sharedInstance.KRECENTVIEWAPI

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                print("key::::::\(key)----value:::::\(value)")

                if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else {
                    print("Unsupported value type for key: \(key)")
                }
            }
        }, to: url, method: .post)
        .responseJSON { response in
            switch response.result {
            case .success(let jsonResponse):
                if let statusCode = response.response?.statusCode, statusCode == APIManager.sharedInstance.KHTTPSUCCESS {
                    print("Success Response: \(jsonResponse)")
                } else {
                    print("Failed with status code: \(response.response?.statusCode ?? -1)")
                }

            case .failure(let error):
                print("Upload failed: \(error.localizedDescription)")
            }
        }
    }

    // MARK:- call this function didFinishLaunching in appDelegate this function create session for AVPlayer
    func playAudioBackground() {
        do {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupCommandCenter()
            
        } catch {
            print(error)
        }
    }
    
}

//MARK:- call these funtion from any where play next and previous song

extension MusicPlayerManager{
    func previousSong(){
        
        let previousIndex = song_no-1
        var bhajanId = ""
        if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
          if  previousIndex >= 0{
            bhajanId = MusicPlayerManager.shared.Bhajan_Track_Trending[previousIndex].id
          }
         
        }
        else{
            if MusicPlayerManager.shared.Bhajan_Track.count > 0,previousIndex >= 0{
                bhajanId = MusicPlayerManager.shared.Bhajan_Track[previousIndex].id ?? ""
            }
            
        }
        let param : Parameters = ["user_id": currentUser.result?.id ?? "" , "bhajan_id": bhajanId]

        bhajanCountSendApi(param)

        if isDownloadedSong{
            if ArrDownloadedSongs.count > previousIndex && previousIndex >= 0{
                let posts = ArrDownloadedSongs[previousIndex]
                let url =  posts.media_file
                MusicPlayerManager.shared.PlayURl(url: url!)
                song_no = previousIndex
            }
        }else{
            if trendingBhajanString == "trending bhajan"{
                if Bhajan_Track_Trending.count > previousIndex && previousIndex >= 0{
                    let posts = Bhajan_Track_Trending[previousIndex]
                    let url =  posts.media_file
                    MusicPlayerManager.shared.PlayURl(url: url)
                    song_no = previousIndex
                }
            }
            else{
                if Bhajan_Track.count > previousIndex && previousIndex >= 0{
                    let posts = Bhajan_Track[previousIndex]
                    let url =  posts.media_file
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    song_no = previousIndex
                }
            }

        }
    }
    //MARK:- Played bhajan count send.
    func bhajanCountSendApi(_ param: [String: Any]) {
        let url = APIManager.sharedInstance.KBASEURL + APIManager.sharedInstance.KBhajanCount

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                print("key::::::\(key)----value:::::\(value)")

                if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else {
                    print("Unsupported value type for key: \(key)")
                }
            }
        }, to: url, method: .post)
        .responseJSON { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }

            switch response.result {
            case .success(let jsonResponse):
                if let statusCode = response.response?.statusCode, statusCode == APIManager.sharedInstance.KHTTPSUCCESS {
                    print("Success Response: \(jsonResponse)")
                } else {
                    print("Failed with status code: \(response.response?.statusCode ?? -1)")
                }

            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        if urlError.code == .notConnectedToInternet {
                            AlertController.alert(title: ALERTS.kNoInterNetConnection)
                        } else if urlError.code == .timedOut {
                            AlertController.alert(title: "Connection time out")
                        } else if urlError.code == .networkConnectionLost {
                            AlertController.alert(title: "Network Connection Lost")
                        }
                    }
                }
            }
        }
    }

    func nextSong(){
        let nextIndex = MusicPlayerManager.shared.song_no+1
        var bhajanId = ""
        if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
         bhajanId = MusicPlayerManager.shared.Bhajan_Track_Trending[nextIndex].id
        }
        else{
            if MusicPlayerManager.shared.Bhajan_Track.count > nextIndex{
                bhajanId = MusicPlayerManager.shared.Bhajan_Track[nextIndex].id ?? ""
            }
            
        }
        let param : Parameters = ["user_id": currentUser.result?.id ?? "" , "bhajan_id": bhajanId]

        bhajanCountSendApi(param)
        if isDownloadedSong{
            if ArrDownloadedSongs.count > nextIndex {
                let posts = ArrDownloadedSongs[nextIndex]
                let url =  posts.media_file
                
                if url == nil || url == ""{
                    myPlayer.pause()
                    isPaused = true
                    return
                }
                
                MusicPlayerManager.shared.PlayURl(url: url!)
                MusicPlayerManager.shared.song_no = nextIndex
            }
        }else{
            if trendingBhajanString == "trending bhajan"{
                if Bhajan_Track_Trending.count > nextIndex {
                    let posts = Bhajan_Track_Trending[nextIndex]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        myPlayer.pause()
                        isPaused = true
                        
                        return
                    }
                    
                    MusicPlayerManager.shared.PlayURl(url: url)
                    MusicPlayerManager.shared.song_no = nextIndex
                }
            }
            else{
                if Bhajan_Track.count > nextIndex {
                    let posts = Bhajan_Track[nextIndex]
                    let url =  posts.media_file
                    
                    if url == nil || url == ""{
                        myPlayer.pause()
                        isPaused = true
                        
                        return
                    }
                    
                    MusicPlayerManager.shared.PlayURl(url: url!)
                    MusicPlayerManager.shared.song_no = nextIndex
                }
            }


        }
    }
}


extension MusicPlayerManager {
    
    // MARK:- call this function once in playAudioBackground() function
    private func setupCommandCenter() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.ratingCommand.isEnabled = false
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            
            self.myPlayer.play()
            
            self.isPaused = false
            
            return .success
        }
        commandCenter.pauseCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            
            self.myPlayer.pause()
            self.isPaused = true
            
            return .success
        }
        
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { event in
            self.nextSong()
            self.songDidChnagedFromNotification()
            return .success
        }
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {event in
            self.previousSong()
            self.songDidChnagedFromNotification()
            return .success
        }
        MPRemoteCommandCenter.shared().seekForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            
//            self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds((self.myPlayer.currentItem?.currentTime() ?? CMTimeMakeWithSeconds(0,0)))
//            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            
            
            return .success
        }
        MPRemoteCommandCenter.shared().seekBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            
            
        
            
//            self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds((self.myPlayer.currentItem?.currentTime() ?? CMTimeMakeWithSeconds(0,0)))
//            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
            guard let self = self else {return .commandFailed}
            let playerRate = self.myPlayer.rate
            
            
            self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds((self.myPlayer.currentItem?.currentTime() ?? CMTimeMakeWithSeconds(0,0)))
            self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
           
            if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
                self.myPlayer.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
                    guard let self = self else {return}
                    if success {
                        self.myPlayer.rate = playerRate
                        
                       
                        
                    }
                })
                return .success
            }
            return .commandFailed
        }
        
        
        
    }
    
    
    // MARK:- call this call whenever play song or change song means in the PlayURl(url:String) function
    func setupNotificationView(){
        
        if isDownloadedSong{
            nowPlayingInfo[MPMediaItemPropertyTitle] = ArrDownloadedSongs[song_no].title
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = ""
            nowPlayingInfo[MPMediaItemPropertyArtist] = ArrDownloadedSongs[song_no].artist_name
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = myPlayer.currentItem?.asset.duration
            
            
            self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize.init(width: 150.0, height: 150.0), requestHandler: { (size) -> UIImage in
                return #imageLiteral(resourceName: "1024")
            })
            
            let urlStr =  ArrDownloadedSongs[song_no].image
            if urlStr != nil{
                let url = URL(string: urlStr!)!
                downloadImage(from: url)
            }
            
        }else{
            if trendingBhajanString == "trending bhajan"{
                nowPlayingInfo[MPMediaItemPropertyTitle] = Bhajan_Track_Trending[song_no].title
                nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = ""
                nowPlayingInfo[MPMediaItemPropertyArtist] = Bhajan_Track_Trending[song_no].artist_name
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = myPlayer.currentItem?.asset.duration
                
                self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize.init(width: 150.0, height: 150.0), requestHandler: { (size) -> UIImage in
                    return #imageLiteral(resourceName: "1024")
                })
                
                let urlStr =  Bhajan_Track_Trending[song_no].image
                if urlStr != ""{
                    let url = URL(string: urlStr)!
                    downloadImage(from: url)
                }

            }
            
            else if MusicPlayerManager.shared.isRadioSatsang{
                //
            }
            else  {
               
             //    nowPlayingInfo[MPMediaItemPropertyTitle] = Bhajan_Track[song_no].title    // comment by avi tyagi
                if song_no >= 0 && song_no < Bhajan_Track.count {
                    nowPlayingInfo[MPMediaItemPropertyTitle] = Bhajan_Track[song_no].title
                } else {
                    print("Error: Index out of range for Bhajan_Track array")
                   
                }
                nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = ""
                //    nowPlayingInfo[MPMediaItemPropertyTitle] = Bhajan_Track[song_no].artist_name    // comment by avi tyagi
                if song_no >= 0 && song_no < Bhajan_Track.count {
                    nowPlayingInfo[MPMediaItemPropertyTitle] = Bhajan_Track[song_no].artist_name
                } else {
                    print("Error: Index out of range for Bhajan_Track array")
                   
                }
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = myPlayer.currentItem?.asset.duration
                
                self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize.init(width: 150.0, height: 150.0), requestHandler: { (size) -> UIImage in
                    return #imageLiteral(resourceName: "1024")
                })
              //  let urlStr =  Bhajan_Track[song_no].image   // comment by Avi tyagi
                if song_no >= 0 && song_no < Bhajan_Track.count {
                    let urlStr = Bhajan_Track[song_no].image
                    if urlStr != nil{
                        let url = URL(string: urlStr!)!
                        downloadImage(from: url)
                    }
                    // Use urlStr as needed
                } else {
                    print("Error: Index out of range for Bhajan_Track array")
                    // Handle the case where song_no is out of bounds, throw an error, or take appropriate action
                }
                

            }

            
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds((myPlayer.currentItem?.currentTime() ?? CMTimeMakeWithSeconds(0,0)))
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension MusicPlayerManager{
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                // self.ProfileImageView.image = UIImage(data: data)
                //  UserDefaults.standard.set(data, forKey: "profilePic")
                let image = UIImage(data: data)!
                self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (size) -> UIImage in
                    return image
                })
                MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
