//
//  TBhajanVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 21/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import CoreData


class TBhajanVC: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notifCountLabel: UILabel!
    @IBOutlet weak var searchBarHolder: UIView!
    @IBOutlet weak var searchBarBtn: UIButton!
    @IBOutlet weak var qrCode: UIButton!
    @IBOutlet var playerdetailview: UIView!
    @IBOutlet weak var addtoplaylistlbl: UILabel!
    @IBOutlet weak var addtodownloadlbl: UILabel!
    
            
    @IBOutlet weak var showoptionview: UIView!
    @IBOutlet weak var playnowbtn: UIButton!
    @IBOutlet weak var playnextbtn: UIButton!
    @IBOutlet weak var addtoplaylistbtn: UIButton!
    @IBOutlet weak var sharebtn: UIButton!
    @IBOutlet weak var addtofavouritebtn: UIButton!
    @IBOutlet weak var downloadbtn: UIButton!
    
    
    
    //MARK:- Variables
    var BhajanCollectionView0 : UICollectionView!
    var BhajanCollectionView1 : UICollectionView!
    var BhajanCollectionView2 : UICollectionView!
    var BhajanCollectionView3 : UICollectionView!
    var BhajanCollectionView4 : UICollectionView!
    
    var allBhajanData = [BhajanData]()
    var shuffleBhajan = [BhajanData]()
    var bhajanArr = NSMutableArray()
    var refreshControl = UIRefreshControl()
    
    var tableSection = Int()
    var searchClicked = 0
    var pullToRefreshOn = false
    
    var current_Bhajan : Bhajan!
    var dataOFVideos : VideosData1!
    var adsImageArr = [AdsBanners]()
    
    
    var isPaused: Bool!
    var playList: NSMutableArray = NSMutableArray()
    var timer: Timer?
    var playPauseBool = false
    
    
    let screenSize = UIScreen.main.bounds
    
    //MARK:- LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        showoptionview.isHidden = true
        searchBarHolder.isHidden = true
        bhajanApi()
        pullToRefresh()
       // dismissView()
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        iscoming = ""
        
        
//        if  MusicPlayerManager.shared.isPlayList{
//            addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
//            addPlay_ListBtn.isUserInteractionEnabled = false
//            playlist_Lbl.text = "Added to PlayList"
//        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if qrStatus == "0"{
            if #available(iOS 13.0, *) {
                qrCode.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            searchBarBtn.isHidden = true
        }else{
            searchBarBtn.isHidden = false
        }
        UserDefaults.standard.setValue(4, forKey: "SideMneuIndexValue")
       
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        
         // observer of if video is played
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        
        if searchClicked == 1 {
            searchClicked = 0
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        bhajanApi()
        pullToRefreshOn = true
    }
    
    func pauseOrPlay(){
        if MusicPlayerManager.shared.myPlayer.isPlaying{
           // playOrPaush_Btn.setImage(UIImage(named:"audio_pause"), for: .normal)
            MusicPlayerManager.shared.isPaused = false
            
        }
        else{
           // playOrPaush_Btn.setImage(UIImage(named:"audio_play"), for: .normal)
            MusicPlayerManager.shared.isPaused = true
        }
        
    }
    func setupTimer(){
        timer = Timer(timeInterval: 0.001, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    // MARK:- This function will call every 1 second to update the value of slider & time duration label
    @objc func tick(){
        
//        duration_Lbl.text = MusicPlayerManager.shared.duration_Lbl
//        current_TimeLbl.text = MusicPlayerManager.shared.current_TimeLbl
        
        pauseOrPlay()
        
        if(MusicPlayerManager.shared.myPlayer.currentTime().seconds == 0.0) {
//            Activityloader.isHidden = false
//            playOrPaush_Btn.isHidden = true
//            Activityloader.startAnimating()
        }
        else{
//            Activityloader.isHidden = true
//            playOrPaush_Btn.isHidden = false
//            Activityloader.stopAnimating()
        }
        if(MusicPlayerManager.shared.isPaused == false){
            if(MusicPlayerManager.shared.myPlayer.rate == 0){
                MusicPlayerManager.shared.myPlayer.play()
//                Activityloader.isHidden = false
//                playOrPaush_Btn.isHidden = true
//                Activityloader.startAnimating()
            }else{
//                Activityloader.isHidden = true
//                Activityloader.stopAnimating()
//                playOrPaush_Btn.isHidden = false
            }
        }
        
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
    
    @IBAction func searchBtnpressed(_ sender: UIButton){
        
        if sender.isTouchInside {
            searchBarHolder.isHidden = false
            searchBarHolder.backgroundColor = .white
        }
        
    }
    
    @IBAction func searchCancelBtn(_ sender: UIButton){
        if sender.isTouchInside{
            searchBarHolder.isHidden = true
            searchBar.text = ""
            searchBarHolder.backgroundColor = .clear
        }
    }
    
    @IBAction func threedotbtn(_ sender: UIButton) {
//
//        if showoptionview.isHidden {
//            showoptionview.isHidden = false
//            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TBhajanVC.dismissView))
//                    view.addGestureRecognizer(tap)
//            } else {
//                showoptionview.isHidden = true
//                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(getter: TBhajanVC.showoptionview))
//                        view.addGestureRecognizer(tap)
//            }
        
        
          if showoptionview.tag == 0{
              showoptionview.tag = 1
              showoptionview.isHidden = true
          }
          else if showoptionview.tag == 1
          {
              showoptionview.tag = 0
              showoptionview.isHidden = false
          }
    }
//    @objc func dismissView() {
//            self.showoptionview.isHidden = true
//            self.view.removeGestureRecognizer(UITapGestureRecognizer())
//        }
    
       
    @IBAction func barCodeBtnpressed(_ sender: UIButton){
        if qrStatus == "1"{
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

            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannerControl") as! ScannerControl
                navigationController?.pushViewController(vc, animated: true)
            }

        }else{
            if sender.isTouchInside {
                searchBarHolder.isHidden = false
                searchBarHolder.backgroundColor = .white
            }
        }

    }
    
    
    //MARK:- headerTap Action.
    @IBAction func headerBtnAction(_ sender: UIButton) {
        
        if sender.tag == 3 || sender.tag == 4{
            let vc = storyboard?.instantiateViewController(withIdentifier: "TB_Artist_GodsListVC") as! TB_Artist_GodsListVC
            
            if sender.tag == 3{
                vc.godOrArtist = "Artist"
            }else{
                vc.godOrArtist = "God"
            }
            if let bhajanList = self.allBhajanData[sender.tag].bhajan{
                print(bhajanList)
                vc.bhajanList = bhajanList
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if let bhajanList = self.allBhajanData[sender.tag].bhajan{
            self.bhajanArr = NSMutableArray(array: bhajanList)
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KBHAJANLISTVC) as! TBbhajanListVC
        vc.dataToShow = bhajanArr as! [Bhajan]
        vc.allBhajan = allBhajanData[sender.tag]
        vc.current_Bhanjan = current_Bhajan
        if avPlayer != nil
        {
            if avPlayer.timeControlStatus == .playing
            {
                vc.isAudioPlaying = true
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func playnowbtn(_ sender: UIButton) {
        if MusicPlayerManager.shared.isPaused{
            MusicPlayerManager.shared.myPlayer.play()
            setupTimer()
            playPauseBool = true
        }else{
            MusicPlayerManager.shared.myPlayer.pause()
            timer?.invalidate()
            playPauseBool = false
        }
        pauseOrPlay()
    }
    
    @IBAction func playnext(_ sender: UIButton) {
        
    }
    
    @IBAction func addtoplaylistbtn(_ sender: UIButton) {
        if MusicPlayerManager.shared.isDownloadedSong{
            _ = SweetAlert().showAlert("", subTitle: "bhajan is already available in download list ", style: AlertStyle.success)
            return
        }
        
        AddPlayList()
    }
    
    @IBAction func sharebtn(_ sender: UIButton) {
        var text = ""
        
        let web_view_bhajan = UserDefaults.standard.value(forKey: "web_view_bhajan")
        if MusicPlayerManager.shared.isDownloadedSong{
            let post = MusicPlayerManager.shared.ArrDownloadedSongs[MusicPlayerManager.shared.song_no]
            let id = post.id ?? ""
            text = "\(web_view_bhajan ?? "")\(id)"
            
        }else{
            if MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                let post = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                let id = post.id
                text = "\(web_view_bhajan ?? "")\(id)"
            }
            else{
                let post = MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                let id = post.id ?? ""
                text = "\(web_view_bhajan ?? "")\(id)"
            }
            
            
        }
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        

    }
    
    @IBAction func addtofavouitebtn(_ sender: UIButton) {
        
    }
    
    @IBAction func downloadbtn(_ sender: UIButton) {
        
        if MusicPlayerManager.shared.isDownloadedSong{
            return
        }
        
        if currentUser.result!.id! == "163"{
            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
            if sms == "1"{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNewMobileVC)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                iscoming = "musicPlayer"
                present(vc, animated: true, completion: nil)
            }
            return
        }
        
        downloadAudio()
        
    }
    
    //MARK:-GetBhajanApi.
    func bhajanApi(){
        if allBhajanData.count == 0 && self.pullToRefreshOn == false {
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        }else {
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
        }
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","device_id": "\(device_id ?? "")"]
        self.uplaodData1(APIManager.sharedInstance.KBHAJANAPI , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray{
                        print(result)
                        if  self.pullToRefreshOn == true {
                            self.pullToRefreshOn = false
                        }
                        self.allBhajanData = BhajanData.modelsFromDictionaryArray(array: result)
                        self.tableView.reloadData()
                    }
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//               self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
}

//MARK:- UITableView DataSource Methods.
extension TBhajanVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allBhajanData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBBhajanTableViewCell
        if indexPath.section == 0{
           cell.bhajanCollectionView.tag = indexPath.section
            BhajanCollectionView0 = cell.bhajanCollectionView
            if let bhajanList = self.allBhajanData[indexPath.section].bhajan {
                self.bhajanArr = NSMutableArray(array: bhajanList)
                BhajanCollectionView0.reloadData()
                
            }
        }
        else if indexPath.section == 1{
             cell.bhajanCollectionView.tag = indexPath.section
             BhajanCollectionView1 = cell.bhajanCollectionView
            if let bhajanList = self.allBhajanData[indexPath.section].bhajan {
                self.bhajanArr = NSMutableArray(array: bhajanList)
                BhajanCollectionView1.reloadData()
            }
        }
        else if indexPath.section == 2{
             cell.bhajanCollectionView.tag = indexPath.section
             BhajanCollectionView2 = cell.bhajanCollectionView
            if let bhajanList = self.allBhajanData[indexPath.section].bhajan {
                self.bhajanArr = NSMutableArray(array: bhajanList)
                BhajanCollectionView2.reloadData()
            }
        }
        else if indexPath.section == 3{
             cell.bhajanCollectionView.tag = indexPath.section
             BhajanCollectionView3 = cell.bhajanCollectionView
            if let bhajanList = self.allBhajanData[indexPath.section].bhajan {
                self.bhajanArr = NSMutableArray(array: bhajanList)
                BhajanCollectionView3.reloadData()
            }
        }
        else if indexPath.section == 4{
             cell.bhajanCollectionView.tag = indexPath.section
             BhajanCollectionView4 = cell.bhajanCollectionView
            if let bhajanList = self.allBhajanData[indexPath.section].bhajan {
                self.bhajanArr = NSMutableArray(array: bhajanList)
                BhajanCollectionView4.reloadData()
            }
        }

        return cell
        
    }
}

extension TBhajanVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KCELL2")
        let dataArr = allBhajanData[section]
        let titleLbl = cell?.viewWithTag(100) as! UILabel
        let tableHeaderBtn = cell?.viewWithTag(1000) as! UIButton
        tableHeaderBtn.tag = section
        // titleLbl.text = dataArr.category_name?.uppercased()
        titleLbl.text = dataArr.category_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 || indexPath.row == 4{
            return 170
        }else{
            return 190
        }
        
    }
    
}

//MARK:- UIColection View Delegates Methods.
extension TBhajanVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 3 ||  collectionView.tag == 4{
            let size = CGSize(width: 150, height: 170)
            return size
        }
        else {
            return CGSize(width: 250  , height: 180)
        }
        
    }
}

//MARK:- UICollection View DataSource.
extension TBhajanVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let bhajanList = self.allBhajanData[collectionView.tag].bhajan {
            return bhajanList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellArtist", for: indexPath)
            if let bhajanList = self.allBhajanData[collectionView.tag].bhajan,
                let dataToShow = bhajanList[indexPath.row] as? Bhajan {
                
                shadow(cell)
                
                let categoryImageView = cell.viewWithTag(200) as! UIImageView
                let categoryNameLbl = cell.viewWithTag(210) as! UILabel
                categoryNameLbl.text = dataToShow.artist_name
                if let urlString = dataToShow.artist_image {
                    categoryImageView.contentMode = .scaleToFill
                    categoryImageView.sd_setShowActivityIndicatorView(true)
                    categoryImageView.sd_setIndicatorStyle(.gray)
                    categoryImageView.clipsToBounds = true
                    categoryImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                    
                }
            }
            return cell
        }
        else if collectionView.tag == 4{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellArtist", for: indexPath)
            if let bhajanList = self.allBhajanData[collectionView.tag].bhajan,
                let dataToShow = bhajanList[indexPath.row] as? Bhajan {
                
                shadow(cell)
                let categoryImageView = cell.viewWithTag(200) as! UIImageView
                let categoryNameLbl = cell.viewWithTag(210) as! UILabel
                categoryNameLbl.text = dataToShow.god_name
                if let urlString = dataToShow.god_image {
                    categoryImageView.contentMode = .scaleToFill
                    categoryImageView.sd_setShowActivityIndicatorView(true)
                    categoryImageView.sd_setIndicatorStyle(.gray)
                    categoryImageView.clipsToBounds = true
                    categoryImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
            }
            return cell
        }
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTranding", for: indexPath)
            cell.layer.cornerRadius = 5
            if let bhajanList = self.allBhajanData[collectionView.tag].bhajan,
                let dataToShow = bhajanList[indexPath.row] as? Bhajan {
                let categoryImageView = cell.viewWithTag(200) as! UIImageView
                let categoryNameLbl = cell.viewWithTag(210) as! UILabel
                let descroptionLbl = cell.viewWithTag(400) as! UILabel
                
                
                shadow(cell)
                
                descroptionLbl.numberOfLines = 2
                descroptionLbl.text = dataToShow.description?.html2String
                categoryNameLbl.numberOfLines = 1
                categoryNameLbl.text = dataToShow.title
                
                if let urlString = dataToShow.image {
                    categoryImageView.contentMode = .scaleToFill
                    categoryImageView.sd_setShowActivityIndicatorView(true)
                    categoryImageView.sd_setIndicatorStyle(.gray)
                    categoryImageView.clipsToBounds = true
                    categoryImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, options: .refreshCached, completed: nil)
                }
            }
            return cell
        }
    }
}

//MARK: - UICollection View delegates.
extension TBhajanVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let bhajanData1 = allBhajanData[collectionView.tag].bhajan![indexPath.row]
        
        if collectionView.tag == 3{
            let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KBHAJANLISTVC) as! TBbhajanListVC
            vc.artistData = bhajanData1
            vc.allBhajan = allBhajanData[collectionView.tag]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else if collectionView.tag == 4{
            let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KBHAJANLISTVC) as! TBbhajanListVC
            vc.artistData = bhajanData1
            vc.IsGod = true
            vc.allBhajan = allBhajanData[collectionView.tag]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
            
            let post = allBhajanData[collectionView.tag].bhajan![indexPath.row]
            MusicPlayerManager.shared.song_no = indexPath.row
            MusicPlayerManager.shared.Bhajan_Track = allBhajanData[collectionView.tag].bhajan!
            MusicPlayerManager.shared.isDownloadedSong = false
            MusicPlayerManager.shared.isPlayList = false
            MusicPlayerManager.shared.isRadioSatsang = false
//            let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//            self.navigationController?.pushViewController(vc, animated: true)

            
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "TBMusicPlayerVC" ) as! TBMusicPlayerVC
                self.present(vc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
          
            MusicPlayerManager.shared.PlayURl(url: post.media_file!)
        }
    }
}



//MARK:- Search Bar Delegates.
extension TBhajanVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchClicked = 1
        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KBHAJANLISTVC) as! TBbhajanListVC
        vc.searchText = searchBar.text!
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchClicked = 0
        searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
}


extension TBhajanVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
        
    }
}
extension TBhajanVC{
    
    func AddPlayList(){
        
        var param : Parameters
        param = ["user_id":currentUser.result?.id ?? "", "type":"1", "bhajan_id":""]
        print("playList")
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
//                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                iscoming = "musicPlayer"
//                present(vc, animated: true, completion: nil)
            }
            return
        }else{
            var tempArr =  NSMutableArray()
            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                if MusicPlayerManager.shared.Bhajan_Track_Trending.count == 0{
                    return
                }
            }
            else{
                if MusicPlayerManager.shared.Bhajan_Track.count == 0{
                    return
                }
            }
            
            if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
                let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
                
                param.updateValue("\(playingAudioTrack.id)", forKey: "bhajan_id")
                addToPlaylist(param)
                
                if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
                    tempArr = NSMutableArray.init(array: savedArray)
                    let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
                    let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
                    
                    if playListArr.count == 0 {
                        tempArr.add(playingAudioTrack.dictionaryRepresentation())
                        TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        addtoplaylistlbl.text = "Added to PlayList"
                        print("The song is added successfully in Play List")
                    }else{
//                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        addtoplaylistlbl.text = "Added to PlayList"
                        print("This song is already available in Play List")
                    }
                    
                }else{
                    tempArr.add(playingAudioTrack.dictionaryRepresentation())
                    TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                    addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                    addtoplaylistlbl.text = "Added to PlayList"
                    print("This song is already available in Play List")
                    
                }
                
            }
            else{
                let playingAudioTrack =  MusicPlayerManager.shared.Bhajan_Track[MusicPlayerManager.shared.song_no]
                
                param.updateValue(playingAudioTrack.id ?? "", forKey: "bhajan_id")
                addToPlaylist(param)
                if let savedArray = TBSharedPreference.sharedIntance.getplaylist() {
                    tempArr = NSMutableArray.init(array: savedArray)
                    let  tempArray1 = Bhajan.modelsFromDictionaryArray(array: savedArray)
                    let playListArr = tempArray1.filter({$0.id == playingAudioTrack.id})
                    
                    if playListArr.count == 0 {
                        tempArr.add(playingAudioTrack.dictionaryRepresentation())
                        TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        addtoplaylistlbl.text = "Added to PlayList"
                        print("The song is added successfully in Play List")
                    }else{
//                        addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                        addtoplaylistlbl.text = "Added to PlayList"
                        print("This song is already available in Play List")
                    }
                    
                }else{
                    tempArr.add(playingAudioTrack.dictionaryRepresentation())
                    TBSharedPreference.sharedIntance.setUserPlaylist(tempArr)
//                    addPlay_ListBtn.setImage(UIImage(named : "added_to_playlist"), for: .normal)
                    addtoplaylistlbl.text = "Added to PlayList"
                    print("This song is already available in Play List")
                    
                }
            }
        }
    }
}
extension TBhajanVC {
    func addToPlaylist(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KAddRemovePlaylist , param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                
                if "\(JSON["status"]!)" == "1"{
                    
                }
                else{
                    let message = JSON["message"] as! String
                    self.addAlert(ALERTS.KERROR, message: message, buttonTitle: ALERTS.kAlertOK)
                }
                
            }
            else{
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}

extension TBhajanVC {
    
    //MARK:- Download all audio data.
    func downloadAudio()
    {
//        if downloadProgress.progress != 0.00
//        {
//            self.download_Btn.isUserInteractionEnabled = true
//            _ = SweetAlert().showAlert("", subTitle: "Another Audio is Already added on Queue", style: AlertStyle.error)
//            return
//        }
        
        if  MusicPlayerManager.shared.trendingBhajanString == "trending bhajan"{
            let tempData = MusicPlayerManager.shared.Bhajan_Track_Trending[MusicPlayerManager.shared.song_no]
            
            let context = appDelegate.persistentContainer.viewContext
            if let tempAudio = try? context.fetch(Audio.fetchRequest()) as? [Audio] {
                
                if let theAudio = tempAudio {
                    
                    if let audioUrl = URL(string: tempData.media_file) {
                        // MARK:-  then lets create your document folder url
                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // MARK:- lets create your destination file url
                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                        print(destinationUrl)
                        
                        // MARK:- to check if it exists before downloading it
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            print("The file already exists at path")
//                            self.download_Btn.isUserInteractionEnabled = true
                            _ = SweetAlert().showAlert("", subTitle: "This Audio Already Downloaded", style: AlertStyle.success)
                        }
                        else
                        {
                            guard let mediaFileURL = tempData.media_file else {
                                print("Invalid media file URL")
                                return
                            }

                            let destination: DownloadRequest.Destination = { _, _ in
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let fileURL = documentsURL.appendingPathComponent("\(tempData.id).mp3")
                                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                            }

                            AF.download(mediaFileURL, to: destination)
                                .downloadProgress { progress in
                                    DispatchQueue.main.async {
                                        print("Download Progress: \(progress.fractionCompleted)")
                                        // Uncomment if using UI progress indicator
                                        // self.downloadProgress.progress = Float(progress.fractionCompleted)
                                    }
                                }
                                .response { response in
                                    DispatchQueue.main.async {
                                        // Uncomment if using UI progress indicator
                                        // self.downloadProgress.progress = 0.00
                                    }

                                    if let error = response.error {
                                        print("Download failed: \(error.localizedDescription)")
                                        return
                                    }

                                    guard let filePath = response.fileURL?.path else {
                                        print("File path not found")
                                        return
                                    }

                                    print("Downloaded file path: \(filePath)")

                                    // Save to Core Data
                                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                    let entity = NSEntityDescription.entity(forEntityName: "Audio", in: context)!
                                    let audio = NSManagedObject(entity: entity, insertInto: context)

                                    audio.setValue(tempData.id, forKey: "id")
                                    audio.setValue(tempData.title, forKey: "title")
                                    audio.setValue(filePath, forKey: "media_file")
                                    audio.setValue(tempData.artist_name, forKey: "artist_name")
                                    audio.setValue(tempData.image, forKey: "image")
                                    audio.setValue(tempData.is_like, forKey: "is_like")
                                    audio.setValue(tempData.likes, forKey: "likes")
                                    audio.setValue(tempData.artist_name, forKey: "desp")

                                    do {
                                        try context.save()
                                        print("Audio file saved to Core Data")
                                    } catch {
                                        print("Failed to save audio file: \(error.localizedDescription)")
                                    }

                                    // UI Updates
                                    DispatchQueue.main.async {
                                        self.downloadbtn.isUserInteractionEnabled = true
                                        // Uncomment if using UI elements
                                        // self.downloadbtn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
                                        // self.downloadbtn.text = "Downloaded"
                                    }
                                }
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
        else{
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
                            self.downloadbtn.isUserInteractionEnabled = true
                            _ = SweetAlert().showAlert("", subTitle: "This Audio Already Downloaded", style: AlertStyle.success)
                        }
                        else
                        {
                            guard let mediaFileURL = tempData.media_file else {
                                print("Invalid media file URL")
                                return
                            }

                            let destination: DownloadRequest.Destination = { _, _ in
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let fileURL = documentsURL.appendingPathComponent("\(tempData.id).mp3")
                                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                            }

                            AF.download(mediaFileURL, to: destination)
                                .downloadProgress { progress in
                                    DispatchQueue.main.async {
                                        print("Download Progress: \(progress.fractionCompleted)")
                                        // Uncomment if using a UI progress indicator
                                        // self.downloadProgress.progress = Float(progress.fractionCompleted)
                                    }
                                }
                                .response { response in
                                    if let error = response.error {
                                        print("Download failed: \(error.localizedDescription)")
                                        return
                                    }

                                    guard let filePath = response.fileURL?.path else {
                                        print("File path not found")
                                        return
                                    }

                                    print("Downloaded file path: \(filePath)")

                                    // Save to Core Data
                                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                    let entity = NSEntityDescription.entity(forEntityName: "Audio", in: context)!
                                    let audio = NSManagedObject(entity: entity, insertInto: context)

                                    audio.setValue(tempData.id, forKey: "id")
                                    audio.setValue(tempData.title, forKey: "title")
                                    audio.setValue(filePath, forKey: "media_file")
                                    audio.setValue(tempData.artist_name, forKey: "artist_name")
                                    audio.setValue(tempData.image, forKey: "image")
                                    audio.setValue(tempData.is_like, forKey: "is_like")
                                    audio.setValue(tempData.likes, forKey: "likes")
                                    audio.setValue(tempData.artist_name, forKey: "desp")

                                    do {
                                        try context.save()
                                        print("Audio file saved to Core Data")
                                    } catch {
                                        print("Failed to save audio file: \(error.localizedDescription)")
                                    }

                                    // UI Updates
                                    DispatchQueue.main.async {
                                        self.downloadbtn.isUserInteractionEnabled = true
                                        // Uncomment if using UI elements
                                        // self.downloadbtn.setImage(UIImage(named: "downloaded_complete"), for: .normal)
                                        // self.downloadbtn.text = "Downloaded"
                                    }
                                }
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
    
}
