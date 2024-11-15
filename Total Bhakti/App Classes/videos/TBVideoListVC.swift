//
//  TBVideoListVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 13/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBVideoListVC: TBInternetViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionViewBG: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var SearchBarHolder: UIView!
    @IBOutlet weak var searchBarBtn: UIButton!
    @IBOutlet weak var qrCodeScanner: UIButton!
    
    @IBOutlet weak var notifCountLabel: UILabel!
    
    var currentPage : Int = 0
    var isLoadingList : Bool = false
    var videodata = [[String:Any]]()
    //var categorylist = [String]()
 //   var jsondata = NSDictionary()
    //MARK:- variables.
    var headerLbl = [String]()
    var isSelcted = 0
    var imageArr = [String]()
    var allVideos = NSMutableArray()
    var categoryName = NSArray()
    var indexType : IndexPath?
    var screenVideos = [videosResult]()
    var refreshControl = UIRefreshControl()
    var videosArr : [videosResult] = []
    var tabBarCollectionArr = [Category]()
    var firstTimeData = 0
    var videoCategoryId = String()
    var dataEnd = 0
    var index = 0
    var data : Category!
    var searchClicked = 0
    var categorySelected = 0
    var pulltoRefreshClicked = 0
    var lastVideo : videosResult!
    var userSearched = 0
    var searchText = ""
    var lastVideoId = ""
    var searchCrossBtnClicked = 0
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var noDataLbl = UILabel()
    var paginationForSearch = 0
    var apiHit = 0
    var userMoveCollectionCell = 0
    
    var savedArr = [[videosResult]()]
    var collectionViewIndex = 0
    
    
    //MARK:- lifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "hiderotation")
        
        pullToRefresh()
        imageArr = ["image_slider1","image_slider2","image_slider3","image_slider1","image_slider2"]
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        headerLbl = ["All","Motivational","Spiritual","Devotional"]
        tableView.tableFooterView?.isHidden = true
        noDataLbl = noDataLabelCall1(controllerType: self, tableReference: tableView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.tableView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.tableView.addGestureRecognizer(swipeLeft)
        indexType =  IndexPath(row:0 ,section:0)
        
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        SearchBarHolder.isHidden = true
        headerView.isHidden = false
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.3
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        videoApiCall()
        //loader for tableView.
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if qrStatus == "0"{
            if #available(iOS 13.0, *) {
                qrCodeScanner.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            searchBarBtn.isHidden = true
        }else{
            searchBarBtn.isHidden = false
        }
        UserDefaults.standard.setValue(1, forKey: "SideMneuIndexValue")
        
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        
        //        if  MusicPlayerManager.shared.myPlayer.isPlaying
        //        {
        //            MusicPlayerManager.shared.myPlayer.pause()
        //            MusicPlayerManager.shared.isPaused = true
        //
        //        }
        //        NotificationCenter.default.post(name: Notification.Name("hideOrizine"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        
    }
    
    func videoApiCall() {
        if searchBar.text?.isEmpty == true {
            searchClicked = 0
            searchBar.resignFirstResponder()
            let device_id = UserDefaults.standard.string(forKey: "device_id")
            let param : Parameters = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : lastVideoId, "video_category" : videoCategoryId,"limit":"10","device_type":"2","current_version": "\(UIApplication.release)","device_id": "\(device_id ?? "")"]
            print(param)
            getVideosApi(param)
            
        }else {
            searchClicked = 1
            searchBar.resignFirstResponder()
            let device_id = UserDefaults.standard.string(forKey: "device_id")
            let param : Parameters = ["user_id": currentUser.result!.id!,"search_content" : searchBar.text!, "last_video_id" : lastVideoId, "video_category" : videoCategoryId,"limit":"10","device_type":"2","current_version": "\(UIApplication.release)","device_id": "\(device_id ?? "")"]
            print(param)
            getVideosApi(param)
        }
    }
    
    
    //MARK:- ScrollViewDelegte For PageControl Current Page.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
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
    
    @IBAction func cancelSearchBtn(_ sender: UIButton){
        searchBar.text = ""
        SearchBarHolder.isHidden = true
        SearchBarHolder.backgroundColor = .white
    }
    
    @IBAction func searchBarBtnPressed(_ sender: UIButton){
        
        SearchBarHolder.isHidden = false
        SearchBarHolder.backgroundColor = .white
    }
    
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        let param : Parameters!
        pulltoRefreshClicked = 1
        if index == 0 {
            param  = ["user_id": currentUser.result!.id!,"search_content" : searchText, "last_video_id" : "", "video_category" : "","limit":"10","device_type":"2","current_version": "\(UIApplication.release)"]
        }else {
            param  = ["user_id": currentUser.result!.id!,"search_content" : searchText, "last_video_id" : "", "video_category" : data.id!,"limit":"10","device_type":"2","current_version": "\(UIApplication.release)"]
        }
        getVideosApi(param)
    }
    
    //MARK:- responce to swipe gesture.
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                let selectedIndex = self.isSelcted
                if selectedIndex > 0 {
                    self.isSelcted = selectedIndex - 1
                    indexType = IndexPath(row:isSelcted ,section:0)
                    listCollectionView.delegate?.collectionView!(listCollectionView, didSelectItemAt: indexType!)
                }
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                let selectedIndex = self.isSelcted
                if selectedIndex < tabBarCollectionArr.count - 1 {
                    isSelcted = selectedIndex + 1
                    indexType = IndexPath(row:isSelcted ,section:0)
                    listCollectionView.delegate?.collectionView!(listCollectionView, didSelectItemAt: indexType!)
                }
            default:
                break
            }
        }
    }
    
    
    
    
    //MARK:- getVideos.
    func getVideosApi(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KVIDEOSAPI , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                let data = (JSON["data"] as? [String:Any] ?? [:])
                print(data)
                self.videodata = (data["videos"] as? [[String:Any]] ?? [])
                print(self.videodata)
            
                //self.jsondata = response as! NSDictionary
//                for i in 0..<videodata.count{
//                    let category = videodata[i]["category"] as? String ?? ""
//
//                    self.categorylist.append(category)
//                }
//                print(self.categorylist)
                
                dataOFVideos = VideosData1.init(dictionary: JSON)
                
                if dataOFVideos.status! {
                    
                    if (dataOFVideos.result?.videos?.isEmpty)! {
                        self.dataEnd = 1
                        if  self.firstTimeData == 0 && self.searchClicked == 1 {
                            self.videosArr.removeAll()
                            self.videosArr = dataOFVideos.result!.videos!
                            
                        }else {
                            if self.searchClicked == 1 && self.paginationForSearch == 0 {
                                self.videosArr.removeAll()
                                self.videosArr = dataOFVideos.result!.videos!
                            }
                        }
                        
                    }else {
                        
                        if self.isLoadingList{
                            self.videosArr = self.videosArr + dataOFVideos.result!.videos!
                            self.isLoadingList = false
                        }
                        
                        else if self.pulltoRefreshClicked == 1 {
                            self.videosArr.removeAll()
                            self.videosArr = dataOFVideos.result!.videos!
                            self.pulltoRefreshClicked = 0
                            
                        }
                        
                        else if self.searchClicked == 1 {
                            self.searchClicked = 0
                            self.videosArr.removeAll()
                            self.videosArr = dataOFVideos.result!.videos!
                            
                            
                        }
                        else if self.searchCrossBtnClicked == 1 {
                            self.searchCrossBtnClicked = 0
                            self.videosArr.removeAll()
                            self.videosArr = dataOFVideos.result!.videos!
                        }
                        
                        
                        else{
                            self.videosArr = dataOFVideos.result!.videos!
                        }
                        
                        
                        //                        self.dataEnd = 0
                        //                        self.apiHit = 1
                        //                        if self.pulltoRefreshClicked == 1 {
                        //                             self.videosArr.removeAll()
                        //                            self.videosArr = dataOFVideos.result!.videos!
                        //                            self.pulltoRefreshClicked = 0
                        //                        }else {
                        //                            if self.searchClicked == 1 {
                        //                                self.videosArr.removeAll()
                        //                                self.videosArr = dataOFVideos.result!.videos!
                        //                            }else {
                        //                                if self.searchCrossBtnClicked == 1 {
                        //                                    self.videosArr.removeAll()
                        //                                    self.videosArr = dataOFVideos.result!.videos!
                        //                                }else {
                        //                                    self.videosArr = dataOFVideos.result!.videos!
                        //                                }
                        //                            }
                        //                        }
                        
                    }
                    
                    
                    
                    if self.videosArr.count == 0 {
                        self.noDataLbl.isHidden = false
                        self.tableView.bringSubview(toFront: self.noDataLbl)
                    }else {
                        self.noDataLbl.isHidden = true
                        // self.tableView.bringSubview(toFront: self.noDataLbl)
                    }
                    
                    
                    
                    if self.firstTimeData == 0 && self.categorySelected == 0 {
                        self.tabBarCollectionArr = (dataOFVideos.result?.category)!
                        
                        let allNameDict = NSDictionary()
                        let obj = Category.init(dictionary: allNameDict)
                        obj?.category_name = "All"
                        self.tabBarCollectionArr.insert(obj!, at: 0)
                        
                        for index in 0..<self.tabBarCollectionArr.count {
                            if index == 0 {
                                self.tabBarCollectionArr[index].isSelected = true
                            } else {
                                self.tabBarCollectionArr[index].isSelected = false
                            }
                        }
                        self.listCollectionView.reloadData()
                    }
                    
                    
                    self.tableView.reloadData()
                    
                    
                }else {
                    
                    self.addAlert(ALERTS.KERROR, message: dataOFVideos.message!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
                
//                                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    //MARK:- create tableView by cayegory in collectionView.
    func createDataForTableView(_ index: Int) {
        
    }
    
    //MARK:- UICollection View DataSourse.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tabBarCollectionArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL, for: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        label.textColor = UIColor(red: 248/255, green: 160/255, blue: 44/255, alpha: 1.0)
        let lineLbl = cell.viewWithTag(200) as! UILabel
        
        label.text = tabBarCollectionArr[indexPath.row].category_name
        if let isSelected = tabBarCollectionArr[indexPath.row].isSelected, isSelected {
            lineLbl.backgroundColor = UIColor(red: 248/255, green: 160/255, blue: 44/255, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.textColor = .white
            
            
        } else {
            label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            lineLbl.backgroundColor = UIColor.clear
            
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 15
            label.layer.borderWidth = 1
            label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        return cell
        
        
    }
    
    //MARK:- UICollection view Delegates.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == listCollectionView {
            let data = tabBarCollectionArr[indexPath.row]
            var dem: CGSize? = data.category_name?.size(withAttributes: nil)
            dem?.width += 55
            dem?.height = 40
            return dem!
        }else{
            return CGSize(width: 355, height: 180)
        }
        // return CGSize(width: 130.0, height: 99.0)
        // return (dem)!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionViewIndex = indexPath.row
        listCollectionView.selectItem(at: IndexPath(item: indexPath.item, section:0), animated: false, scrollPosition: [.centeredHorizontally])
        data = tabBarCollectionArr[indexPath.row]
        index = indexPath.row
        if let isSelected = data.isSelected {
            if isSelected == false {
                data.isSelected = true
                for index in 0..<tabBarCollectionArr.count{
                    if index != indexPath.row {
                        tabBarCollectionArr[index].isSelected = false
                    }
                }
                videosArr.removeAll()
                self.tableView.reloadData()
                let param : Parameters!
                if indexPath.row == 0 {
                    param  = ["user_id": currentUser.result!.id!, "search_content" : searchText, "last_video_id" : "", "video_category" : "","limit":"10","device_type":"2","current_version": "\(UIApplication.release)"]
                    videoCategoryId = ""
                }else {
                    param  = ["user_id": currentUser.result!.id!, "search_content" : searchText, "last_video_id" : "", "video_category" : data.id!,"limit":"10","device_type":"2","current_version": "\(UIApplication.release)"]
                    videoCategoryId = "\(data.id!)"
                }
                
                getVideosApi(param)
                categorySelected = 1
                //self.createDataForTableView(indexPath.row)
            }
        }
        
        if collectionView == listCollectionView {
            isSelcted = indexPath.item
            listCollectionView.reloadData()
        }else {
            
        }
    }
    
}

//MARK:- UItableView DataSource.
extension TBVideoListVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videosArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL) as! TBVideoTableCell2
        let posts = videosArr[indexPath.row] 
        cell.mainView.layer.cornerRadius = 5.0
        cell.mainView.dropShadow()
        
        cell.nameLbl.text = posts.video_title
        cell.dercriptionLbl.text = posts.video_desc?.html2String
        
        if posts.views == "0" {
            cell.numberOfViewsLbl.text = "No view"
        }else if posts.views == "1" {
            cell.numberOfViewsLbl.text = "\(posts.views ?? "") View"
        }else {
            cell.numberOfViewsLbl.text = "\(posts.views ?? "") Views"
        }
        
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(posts.published_date!)!
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
        cell.dateAndTimeLbl.text = dateFormatter.string(from: formatedData)
        
        print("thumbnail_url : \(posts.thumbnail_url ?? "")")
        
        cell.videoImageView?.sd_setShowActivityIndicatorView(true)
        cell.videoImageView?.sd_setIndicatorStyle(.gray)
        cell.videoImageView.layer.cornerRadius = 4.0
        cell.videoImageView.clipsToBounds = true
        cell.videoImageView.contentMode = .scaleToFill
        cell.videoImageView?.sd_setImage(with: URL(string: posts.thumbnail_url!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
//        cell.alpha = 0
//
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.05 * Double(indexPath.row),
//            animations: {
//                cell.alpha = 1
//        })
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            
            if videosArr.count == 0 || videosArr.count < 10{
                return
            }
            
            self.isLoadingList = true
            
            self.tableView.tableFooterView?.isHidden = false
            firstTimeData = 1
            paginationForSearch = 1
            lastVideo = videosArr[videosArr.count-1]
            lastVideoId = lastVideo.id!
            let param : Parameters
            if userSearched == 1 {
                param  = ["user_id": currentUser.result!.id!,"search_content" : searchText, "last_video_id" : lastVideo.id , "video_category" : videoCategoryId,"limit":"50","device_type":"2","current_version": "\(UIApplication.release)"]
                getVideosApi(param)
            }else {
                param  = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : lastVideo.id , "video_category" : videoCategoryId,"limit":"50","device_type":"2","current_version": "\(UIApplication.release)"]
                getVideosApi(param)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- UITableView Delegates Methods.
extension TBVideoListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(data)
//        let videodata = (data["videos"] as? [[String:Any]] ?? [])
//        print(videodata)
        let categoryid  = videodata[indexPath.row]["category"] as? String ?? ""
        // let catagory = videosResult.category
        if currentUser.result!.id == "163" {
            AlertController.alert(title: "SignIn", message: "Please sign in to the App", acceptMessage: "Ok") {
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
        }else{
            let post = videosArr[indexPath.row]
            let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
            recentViewHit(param)
            
            if post.youtube_url != ""{
                let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                vc.catid = categoryid
                vc.songNo = indexPath.row
                print(videosArr[indexPath.row])
                vc.post = videosArr[indexPath.row]
                vc.videosArr = videosArr
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                    if index == 1 {
                        let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                playSelectedVideo(seletedData: post)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return 400
        }
        else if UIDevice.current.userInterfaceIdiom == .phone{
            return UITableViewAutomaticDimension
        }
        else{
            return 0
        }
    }
}

//MARK:- UISearchBarDelegates.
extension TBVideoListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            searchText = ""
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
            SearchBarHolder.isHidden = true
            SearchBarHolder.backgroundColor = .white
           let param : Parameters
            if index == 0 {
                param = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : "", "video_category" : "","limit":"10","device_type":"2","current_version": "\(UIApplication.release)"]
            }else {
                param = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : "", "video_category" : videoCategoryId,"limit":"10","device_type":"2","current_version": "\(UIApplication.release)"]
            }
            getVideosApi(param)
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        userSearched = 1
        searchClicked = 1
        searchText = searchBar.text!
        //searchBar.placeholder = searchText
        let param : Parameters
        param  = ["user_id": currentUser.result!.id!,
                  "search_content" : searchText,
                  "last_video_id" : "",
                  "video_category" : videoCategoryId,
                  "limit":"10",
                  "device_type":"2",
                  "current_version": "\(UIApplication.release)"]
        searchBar.text = searchText // Assigning search text back to the search bar
        getVideosApi(param)
    }

    
}

extension TBVideoListVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

