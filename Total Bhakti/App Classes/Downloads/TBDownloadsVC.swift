//
//  TBDownloadsVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 08/03/19.
//  Copyright © 2019 MAC MINI. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

var isDownloadAudio = false
var isDownloadVideo = false

var AudioNo = 0
var VideoNo = 0

class TBDownloadsVC: TBInternetViewController{
    
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var relatedVideoAudioView: UIView!
    @IBOutlet weak var relatedVideosBtn: UIButton!
    @IBOutlet weak var relatedAudiosBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    
    @IBOutlet weak var notifCountLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHolder: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var qrcodeBtn: UIButton!
    

    
    var arrAudio : [Audio] = []
    var arrAudio2 : [Audio] = []
    var arrTBVideo : [TBVideos]  = []
    var arrVideo = NSMutableArray()
    var index = Int()
    var clickOnBtn = 0
    var current_Bhajan : Bhajan!
    var isAlreadyPlaying : Bool = false
    
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        searchBar.delegate = self
        
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0
        
        
        noDataFoundLbl.isHidden = true
        
        clickOnBtn = 1
        
        borderForView(relatedVideoAudioView)
//        relatedVideosBtn.layer.cornerRadius = 17.0
        relatedAudiosBtn.layer.cornerRadius = 17.0
        gradientOnBtn(relatedAudiosBtn)
        relatedAudiosBtn.setTitleColor(UIColor.white, for: .normal)
        relatedAudiosBtn.backgroundColor = UIColor.white
//        relatedVideosBtn.setTitleColor(UIColor.black, for: .normal)
        
        getVideos()
        getSounds()
  
    }
    override func viewWillAppear(_ animated: Bool) {
        if qrStatus == "0"{
            if #available(iOS 13.0, *) {
                qrcodeBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
                
            } else {
                // Fallback on earlier versions
            }
            
        }else{
            
        }
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Topbar Button action.
    @IBAction func shareBtnAction (_ sender : UIButton) {
        let text = "https://sanskargroup.page.link/"
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
    
    @IBAction func searchBarBtnPressed(_ sender: UIButton){
        searchBarHolder.isHidden = false
        searchBarHolder.backgroundColor = .white
    }
    
    @IBAction func searchCancelBtn(_ sender: UIButton){
        
        searchBar.text = ""
        searchBarHolder.isHidden = true
        searchBarHolder.backgroundColor = .clear
    }
    
    func borderForView(_ view : UIView)  {
        view.layer.cornerRadius = 17.0
        //  view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
    }
    
    func gradientOnBtn(_ button : UIButton)  {
        let layer = gradientBackground()
        layer.frame = headerView.bounds
        button.clipsToBounds = true
        button.layer.insertSublayer(layer, at: 0)
    }
    
    
    func getSounds() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
                if let theAudio = tempAudio {
                    arrAudio = theAudio
                    arrAudio2 = theAudio
                    tableView.reloadData()
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
    
    func getVideos() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let tempVideo = try? context.fetch(TBVideos.fetchRequest()) as? [TBVideos] {
                if let theVideos = tempVideo {
                    arrTBVideo = theVideos
                    tableView.reloadData()
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
    
    
    @IBAction func screenBtnAction (_ sender : UIButton) {
        switch sender.tag {
            
        case 10:
            
            slideMenuController()?.openLeft()
            
//        case 50://relatedVideos
//            if clickOnBtn == 1 {
//
////                gradientOnBtn(relatedVideosBtn)
//                relatedVideosBtn.setTitleColor(UIColor.white, for: .normal)
//                relatedAudiosBtn.layer.sublayers?.remove(at: 0)
//                relatedAudiosBtn.backgroundColor = UIColor.white
//                relatedAudiosBtn.setTitleColor(UIColor.black, for: .normal)
//                clickOnBtn = 0
//                self.tableView.reloadData()
//            }
            
        case 60 ://relatedAudios
            if clickOnBtn == 0 {
                
                gradientOnBtn(relatedAudiosBtn)
                relatedAudiosBtn.setTitleColor(UIColor.white, for: .normal)
//                relatedVideosBtn.layer.sublayers?.remove(at: 0)
//                relatedVideosBtn.backgroundColor = UIColor.white
//                relatedVideosBtn.setTitleColor(UIColor.black, for: .normal)
                clickOnBtn = 1
                self.tableView.reloadData()
                
            }
        case 20:
            if currentUser.result!.id! == "163"{
                let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                if sms == "1"{
                    let record = UserDefaults.standard.integer(forKey: "recorddata")
                        print(record)

                        if record == 1 {
                        self.dismiss(animated: true) {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "usersuggestionlogin") as! usersuggestionlogin
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
                    }
                    else {
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
                    }
                }else{
//                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
            else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPROFILEVC)
                navigationController?.pushViewController(vc, animated: true)
            }
        case 30:
            _ = navigationController?.popViewController(animated: true)
            
        default:
            break
        }
    }
    
}

//MARK:- UITable View dataSource.
extension TBDownloadsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clickOnBtn == 0 {
            if arrTBVideo.count == 0{
                self.noDataFoundLbl.isHidden = false
            }else{
                self.noDataFoundLbl.isHidden = true
            }
            return arrTBVideo.count
        }else {
            if arrAudio.count == 0{
                self.noDataFoundLbl.isHidden = false
            }else{
                self.noDataFoundLbl.isHidden = true
            }
            return arrAudio.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView
        let nameLbl = cell.viewWithTag(110) as! UILabel
        let descriptionLbl = cell.viewWithTag(120) as! UILabel
        let mainView = cell.viewWithTag(150)
        let moreButton = cell.viewWithTag(160) as? UIButton
        mainView?.layer.cornerRadius = 5.0
        mainView?.dropShadow()
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleToFill
        
        if clickOnBtn == 0
        {
            if arrTBVideo.count > 0
            {
                
                let dic = arrTBVideo[indexPath.row]
                let str = dic.video_desc?.replacingOccurrences(of: "<h3 style=\"color:#aaa;font-style:italic;\"><strong><font face=\"monospace\"<p>o", with: "")
                nameLbl.text = dic.video_title
                descriptionLbl.text = str?.html2String
                if let urlString = dic.thumbnail_url {
                    imageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
            }
        }
        else
        {
            let dic = arrAudio[indexPath.row]
            nameLbl.text = dic.title
            descriptionLbl.text = dic.desp?.html2String
            if let urlString = dic.image {
                imageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
        }
        moreButton?.tag = indexPath.row
        moreButton?.addTarget(self, action: #selector(TBDownloadsVC.clickToDelete), for: .touchUpInside)
        return cell
    }
    
    @objc func clickToDelete(sender : UIButton)
    {
        let alertController = UIAlertController(title: appName, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction) in
            
            if self.clickOnBtn == 1{
                if MusicPlayerManager.shared.isDownloadedSong{
                    if MusicPlayerManager.shared.song_no == sender.tag{
                        AlertController.alert(title: "bhajan is currently playing can't be delete")
                    }else{
                        self.deleteDownloadedItems(index : sender.tag)
                    }
                }else{
                    self.deleteDownloadedItems(index : sender.tag)
                }
            }else{
                self.deleteDownloadedItems(index : sender.tag)
                
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteDownloadedItems(index : Int)
    {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        if clickOnBtn == 1
        {
            if let tempAudio = try? context?.fetch(Audio.fetchRequest()) as? [Audio] {
                let temp = tempAudio?.filter({$0.id == arrAudio[index].id})
                if temp?.count != 0{
                    
                    let url = URL(string: temp![0].media_file!)
                    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent)
                    print(destinationUrl)
                    print(temp![0].media_file!)
                    do {
                        try FileManager.default.removeItem(at: destinationUrl)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error.localizedDescription)")
                        AlertController.alert(title: error.localizedDescription)
                    }
                    context?.delete((temp?[0])!)
                    do{
                        try context?.save()
                        
                        reloadAudioData()
                        return
                        
                    }
                    catch
                    {
                        print(error)
                    }
                    
                }
            }
            
            
        }
        else
        {
            if let tempAudio = try? context?.fetch(Audio.fetchRequest()) as? [TBVideos] {
                let temp = tempAudio?.filter({$0.id == arrTBVideo[index].id})
                if temp?.count != 0{
                    
                    let url = URL(string: temp![0].video_url!)
                    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent)
                    print(destinationUrl)
                    print(temp![0].video_url!)
                    do {
                        try FileManager.default.removeItem(at: destinationUrl)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error.localizedDescription)")
                        AlertController.alert(title: error.localizedDescription)
                    }
                    context?.delete((temp?[0])!)
                    do{
                        try context?.save()
                        
                        reloadVideoData()
                        
                        return
                    }
                    catch
                    {
                        print(error)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func reloadAudioData(){
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        if let tempAudio = try? context?.fetch(Audio.fetchRequest()) as? [Audio] {
            arrAudio = []
            if let theAudio = tempAudio {
                arrAudio = theAudio
                if arrAudio.count == 0
                {
                    MusicPlayerManager.shared.ArrDownloadedSongs = theAudio
                    if MusicPlayerManager.shared.isDownloadedSong{
                        MusicPlayerManager.shared.song_no =  0
                    }
                    tableView.reloadData()
                }
                else
                {
                    MusicPlayerManager.shared.ArrDownloadedSongs = theAudio
                    if MusicPlayerManager.shared.isDownloadedSong{
                        MusicPlayerManager.shared.song_no =  MusicPlayerManager.shared.song_no-1
                    }
                    tableView.reloadData()
                }
                
            }
            
        }
        
    }
    
    
    func reloadVideoData(){
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        if let tempAudio = try? context?.fetch(TBVideos.fetchRequest()) as? [TBVideos] {
            arrTBVideo = []
            if let theVideo = tempAudio {
                arrTBVideo = theVideo
                if arrAudio.count == 0
                {
                    
                }
                else
                {
                    
                }
                tableView.reloadData()
            }
        }
    }
    
    
}

//MARK:-TITable View delegates methods.
extension TBDownloadsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        index = indexPath.row
        if clickOnBtn == 0
        {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
            
            
            
            if MusicPlayerManager.shared.myPlayer.isPlaying{
                MusicPlayerManager.shared.myPlayer.pause()
            }
            let url = URL(string:(arrTBVideo[index].video_url!))
            
            //Get url of documents
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url!.lastPathComponent)
            print(destinationUrl)
            
            let player = AVPlayer(url: destinationUrl)
            let vc = AVPlayerViewController()
            vc.player = player
            present(vc, animated: true) {
                vc.player?.play()
            }
        }
        else
        {
            let post = arrAudio[indexPath.row]
            MusicPlayerManager.shared.song_no = indexPath.row
            MusicPlayerManager.shared.ArrDownloadedSongs = arrAudio
            MusicPlayerManager.shared.isDownloadedSong = true
            MusicPlayerManager.shared.isPlayList = false
            MusicPlayerManager.shared.isRadioSatsang = false
            let url = post.media_file
            
            if url == nil || url == ""{
                AlertController.alert(title: "bhajan Path not found delete and download again")
                return
            }
            
            let vc:TBMusicPlayerVC = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            
            MusicPlayerManager.shared.PlayURl(url: post.media_file!)
            
        }
    }
    
}


//MARK:- searchBar Delegate Methods.
extension TBDownloadsVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            searchBar.text = nil
            searchBar.endEditing(true)
            self.view.endEditing(true)
            
             arrAudio = arrAudio2
             tableView.reloadData()
 
        }else{
            
            arrAudio = arrAudio2.filter { (audio) -> Bool in
                let stringMatch = audio.title?.lowercased().range(of: Text.lowercased())
                let str = audio.artist_name?.lowercased().range(of: Text.lowercased())
                
                return stringMatch != nil || str != nil ? true : false
            }
             
            if arrAudio.count == 0{
                arrAudio = arrAudio2
            }
             
            tableView.reloadData()
            
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         getSounds()
         searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        arrAudio = arrAudio2
        searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        arrAudio = arrAudio2.filter { (audio) -> Bool in
            let stringMatch = audio.title?.lowercased().range(of: searchBar.text!.lowercased())
            let str = audio.artist_name?.lowercased().range(of: searchBar.text!.lowercased())
            
            return stringMatch != nil || str != nil ? true : false
        }
         
        if arrAudio.count == 0{
            arrAudio = arrAudio2
        }
        
        searchBar.resignFirstResponder()
 
        
    }
}
