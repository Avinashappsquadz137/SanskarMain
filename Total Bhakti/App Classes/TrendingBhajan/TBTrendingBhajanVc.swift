//
//  TBTrendingBhajanVc.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 15/02/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class TBTrendingBhajanVc: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var guruCollectionView: UICollectionView!
    var userMoveCollectionCell = 0
    @IBOutlet weak var notifCountLabel: UILabel!
    
    static let sharedInstance = TBTrendingBhajanVc()
    var dataOFVideos : VideosData1!

    //MARK:- variables.
    var dataToShow = NSMutableArray()
    var guruArr = [Bhajan]()
    var guruArrVideo = [videosResult]()
    var refreshControl = UIRefreshControl()
    var dataEnd = 0
    var lastVideo : Bhajan!
    var lastVideos : videosResult!
    var pullToRefreshClicked = 0
    var firstTimeLoadData = 0
    var didSelectCall = 0
    var paginationOn = false
    var searchClicked = 0
    var lbl = UILabel()
    var params = Parameters()
    var page_no = 1
    var menu_master_id : String!
    var category = 1
    var apiEndPoint : String!
    @IBOutlet weak var categoryHeading: UILabel!
    var headingSting : String?

    //MARK:- lifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryHeading.text = headingSting

        guruCollectionView.delegate = self
        guruCollectionView.dataSource = self
        if isComeFromHomeScreen == false {
            
            if apiEndPoint == "trending bhajan"{
                getDataApi(params, APIManager.sharedInstance.KBhajanListByID)
            }
            else{
                getDataApi(params, APIManager.sharedInstance.KVideoListByID)
            }
        } else {
      
        }
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        
        
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
  
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        if avPlayer != nil
        {
            if avPlayer.timeControlStatus == .playing  {
                avPlayer.pause()
            }
        }
        didSelectCall = 0
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
        self.navigationController?.popViewController(animated: true)
        
     }
           
   
   
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: UIControlEvents.valueChanged)
        guruCollectionView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
//        let param : Parameters = ["user_id": currentUser.result!.id!, "last_guru_id":""]

        pullToRefreshClicked = 1
        searchClicked = 0
        
        if apiEndPoint == "trending bhajan"{
            getDataApi(params, APIManager.sharedInstance.KBhajanListByID)
        }
        else{
            getDataApi(params, APIManager.sharedInstance.KVideoListByID)
        }
//        getDataApi(params,"")
        searchBar.text = ""
    }


    
    //MARK:- Api Method.  //https://app.sanskargroup.in/data_model/videos/video_control/get_video_list_by_menu_master
    func getDataApi(_ param : Parameters,_ apiname: String)  {
        if dataToShow.count == 0 && firstTimeLoadData == 0 && self.paginationOn == false {
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        }else {
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
        }
//        self.uplaodData1(APIManager.sharedInstance.KVideoListByID, param) { (response) in
        self.uplaodData1(apiname, param) { [self] (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        if result.count == 0 {
                            self.dataEnd = 1
                        }else {
                            self.dataEnd = 0
                            if self.apiEndPoint == "trending bhajan"{
                                if self.pullToRefreshClicked == 1   {
                                    self.pullToRefreshClicked = 0
                                    self.dataToShow.removeAllObjects()
                                    self.guruArr.removeAll()
                                    self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                    self.guruArr = Bhajan.modelsFromDictionaryArray(array: self.dataToShow)
                                    
                                }else {
                                    if self.didSelectCall == 1 {
                                        self.dataToShow.removeAllObjects()
                                        self.guruArr.removeAll()
                                        self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                        self.guruArr = Bhajan.modelsFromDictionaryArray(array: self.dataToShow)
                                    }else {
                                        self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                        self.guruArr = Bhajan.modelsFromDictionaryArray(array: self.dataToShow)
                                    }
                                }
                            }
                            else{
                                
                                if self.pullToRefreshClicked == 1   {
                                    self.pullToRefreshClicked = 0
                                    self.dataToShow.removeAllObjects()
                                    self.guruArr.removeAll()
                                    self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                    self.guruArrVideo = videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                                    
                                }else {
                                    if self.didSelectCall == 1 {
                                        self.dataToShow.removeAllObjects()
                                        self.guruArr.removeAll()
                                        self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                        self.guruArrVideo = videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                                    }else {
                                        self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                        self.guruArrVideo = videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                                    }
                                }
                            }


                        }
                        
                        self.guruCollectionView.reloadData()
   
                    }
                }else {
                    if self.guruArr.count == 0 {
                        self.guruCollectionView.isHidden = true
                        self.lbl.isHidden = false
                        
                    }else {
                        self.guruCollectionView.isHidden = false
                        self.lbl.isHidden = true
                    }
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    
                }
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    

    
    //MARK:- Search Api
    func SearchApi(_ param : Parameters)  {
        self.uplaodData(APIManager.sharedInstance.KGRURSEARCHAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        self.dataToShow.removeAllObjects()
                        self.guruArr.removeAll()
                        self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                        self.guruArr = Bhajan.modelsFromDictionaryArray(array: self.dataToShow)
                        self.guruCollectionView.reloadData()
                      
                    }
                }else {
                    if self.guruArr.count == 0 {
                        self.guruCollectionView.isHidden = true
                        self.lbl.isHidden = false
                        
                    }else {
                    self.guruCollectionView.isHidden = false
                        self.lbl.isHidden = true
                    }
                   
                    self.searchBar.resignFirstResponder()
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
}

//MARK:- UICollectionView DataSource Methods.
extension TBTrendingBhajanVc : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if apiEndPoint == "trending bhajan"{
            return guruArr.count
      
        }
        else{
            return guruArrVideo.count

        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if apiEndPoint == "trending bhajan"{
            print(apiEndPoint)
            
            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                
                let post = guruArr[indexPath.row]
    //                homeAllDataArray.bhajan![0].audio![indexPath.row]
                MusicPlayerManager.shared.song_no = indexPath.row
                MusicPlayerManager.shared.Bhajan_Track = guruArr
    //                homeAllDataArray.bhajan![0].audio!
                MusicPlayerManager.shared.isDownloadedSong = false
                MusicPlayerManager.shared.isPlayList = false
            MusicPlayerManager.shared.isRadioSatsang = false
                let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//                self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
                MusicPlayerManager.shared.PlayURl(url: post.media_file!)
                
            
        }
        else{
            print(apiEndPoint)
            
            videoType = 1 //Normal Video
                let post = guruArrVideo[indexPath.row]
//                    categoryDataArray[collectionView.tag].trendingVideoList[indexPath.row]
                let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
                
                if post.youtube_url != ""{
                    recentViewHit(param)
                    let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                    vc.songNo = indexPath.row
                    vc.videosArr = guruArrVideo
//                        categoryDataArray[collectionView.tag].videoList
                    vc.post = post
                    vc.menuMasterId = self.menu_master_id
//                    vc.apiEndPoint = self.apiEndPoint
//                        categoryDataArray[collectionView.tag].trendingVideoList[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
    
                }
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL, for: indexPath)
            let imageView = cell.viewWithTag(100) as! UIImageView
//            let lbl =  cell.viewWithTag(200) as! UILabel
            let mainView = cell.viewWithTag(300)
            mainView?.layer.cornerRadius = 5.0
            mainView?.layer.borderWidth = 0.4
            mainView?.layer.borderColor = UIColor.gray.cgColor
            mainView?.clipsToBounds = true
             shadow(cell)
        if apiEndPoint == "trending bhajan"{
            let posts = guruArr[indexPath.row]

            if let urlString = posts.image {
//                lbl.text = posts.title
                imageView.sd_setIndicatorStyle(.gray)
                imageView.sd_setShowActivityIndicatorView(true)
                imageView.layer.cornerRadius = 5.0
                imageView.clipsToBounds = true
//                imageView.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                imageView.sd_setImage(with: URL(string: urlString))
            }
            if isComeFromHomeScreen == false {
                if indexPath.row == guruArr.count - 1  && dataEnd == 0 && searchClicked == 0 {
                    firstTimeLoadData = 1
                    lastVideo = guruArr[indexPath.row]
                    self.page_no += 1
                    let param : Parameters = ["user_id": currentUser.result!.id! , "menu_master_id" : "\(menu_master_id ?? "")","category" : "1","limit":"10", "page_no":"\(page_no)"]

                    print(param)
                    self.paginationOn = true
                    
                        getDataApi(param, APIManager.sharedInstance.KBhajanListByID)
                    
                }else {
                    
                }
            }
        }
        else{
            let posts = guruArrVideo[indexPath.row]

            if let urlString = posts.thumbnail_url {
//                lbl.text = posts.author_name
                imageView.sd_setIndicatorStyle(.gray)
                imageView.sd_setShowActivityIndicatorView(true)
                imageView.layer.cornerRadius = 5.0
                imageView.clipsToBounds = true
//                imageView.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                imageView.sd_setImage(with: URL(string: urlString))
            }
            if isComeFromHomeScreen == false {
                if indexPath.row == guruArrVideo.count - 1  && dataEnd == 0 && searchClicked == 0 {
                    firstTimeLoadData = 1
                    lastVideos = guruArrVideo[indexPath.row]
                    self.page_no += 1
                    let param : Parameters = ["user_id": currentUser.result!.id! , "menu_master_id" : "\(menu_master_id ?? "")","category" : "1","limit":"10", "page_no":"\(page_no)"]

                    print(param)
                    self.paginationOn = true
                    
                    
                        getDataApi(param, APIManager.sharedInstance.KVideoListByID)
                    
                }else {
                    
                }
            }
        }

 
            return cell

    }
}
//TBTrendingBhajanVc
extension TBTrendingBhajanVc : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  30
        let collectionViewSize = guruCollectionView.frame.size.width - padding
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: 370, height: 193)
        }
        else{
            return CGSize(width: 370, height: 193)
        }


    }
    
}

extension TBTrendingBhajanVc : UICollectionViewDelegate  {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        didSelectCall = 1
//        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KGRURDETAILVC) as! TBGuruDetailVC
//        vc.previoueData = guruArr[indexPath.row]
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
}


//MARK:- Search Bar Delegates.
extension TBTrendingBhajanVc : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            
            if isComeFromHomeScreen == false {
                let param : Parameters = ["user_id": currentUser.result!.id!, "last_guru_id":""]
                
                
                if apiEndPoint == "trending bhajan"{
                    getDataApi(params, APIManager.sharedInstance.KBhajanListByID)
                }
                else{
                    getDataApi(params, APIManager.sharedInstance.KVideoListByID)
                }
                
            } else {
               
            }
          
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.isEmpty == false {
            self.dataToShow.removeAllObjects()
            self.guruArr.removeAll()
            let param : Parameters = ["user_id": currentUser.result!.id!, "last_guru_id":""]
//            getDataApi(param)
            searchClicked = 0
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }else {
          
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != ""{
            let param : Parameters = ["user_id": currentUser.result!.id!, "keyword":searchBar.text!]
            self.searchClicked = 1
            SearchApi(param)
           
        }
        
    }
}

//MARK:- UITableView delegates Methods.
//extension TBTrendingBhajanVc : TBGuruDetailVCDelegates {
//    func updateValue(_ data: guruData) {
//        if let updateId = data.id {
//            let tempArr = NSMutableArray(array : guruArr)
//
//            if let replacedData = tempArr.filter({ (result) -> Bool in
//                return ((result as! guruData).id == updateId)
//            }).first {
//                let index = tempArr.index(of: replacedData)
//                tempArr.replaceObject(at: index, with: data)
//                guruArr = tempArr as! [guruData]
//            }
//
//        }
//    }
//}

//MARK:- headerView Delegates
extension TBTrendingBhajanVc : TBHeaderDelegates {
    func menuBarBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            if isComeFromHomeScreen == true {
                isComeFromHomeScreen = false
                _ = navigationController?.popViewController(animated: true)
            } else {
                _ = navigationController?.popViewController(animated: true)
              //  slideMenuController()?.openLeft()
            }
        case 20:
            let SC = TBchannelTableView()
            SC.delegate = self
            SC.modalPresentationStyle = .overCurrentContext
            present(SC, animated: false, completion: nil)
            
        case 30:
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
            navigationController?.pushViewController(vc, animated: true)
        case 40:
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
        default:
            break
        }
    }
    
}

extension TBTrendingBhajanVc : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
    }
}


