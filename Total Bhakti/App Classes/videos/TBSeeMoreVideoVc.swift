//
//  TBSeeMoreVideoVc.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 25/02/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class TBSeeMoreVideoVc: TBInternetViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionViewBG: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var notifCountLabel: UILabel!
    var guruArr = [videosResult]()
    var didSelectCall = 0

    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var params = Parameters()
    var dataToShow = NSMutableArray()
    var firstTimeLoadData = 0
    var paginationOn = false
    var pullToRefreshClicked = 0

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
    var videoCategoryId = "1"
    var dataEnd = 0
    var index = 0
    var data : Category!
    var searchClicked = 0
    var categorySelected = 0
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
    var menuMasterId = ""
    var savedArr = [[videosResult]()]
    var collectionViewIndex = 0
    @IBOutlet weak var categoryHeading: UILabel!
    var headingSting : String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK:- lifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.isHidden = true
        self.tableView.isHidden = true
        UserDefaults.standard.removeObject(forKey: "hiderotation")
        categoryHeading.text = headingSting
        pullToRefresh()
        imageArr = ["image_slider1","image_slider2","image_slider3","image_slider1","image_slider2"]
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        headerLbl = ["All","Motivational","Spiritual","Devotional"]
        tableView.tableFooterView?.isHidden = true
        noDataLbl = noDataLabelCall1(controllerType: self, tableReference: tableView)
        tableView.register(UINib(nibName: "TBDetailCell", bundle: nil), forCellReuseIdentifier: "cell")
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
        UserDefaults.standard.setValue(1, forKey: "SideMneuIndexValue")
        self.tableView.frame = CGRect(x: 0, y: 0, width: 100, height: 100);

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
            /*
             menu_master_id:17
             category:0
             page_no:1
             limit:10
             user_id:21714
             */
            getVideosApi(params)
            
        }else {
            searchClicked = 1
            searchBar.resignFirstResponder()
            let param : Parameters = ["user_id": currentUser.result!.id!,"search_content" : searchBar.text!, "last_video_id" : lastVideoId, "category" : videoCategoryId,"limit":"10","menu_master_id":"\(self.menuMasterId)"]
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
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: .valueChanged)
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            collectionView.addSubview(refreshControl)
        }
        else{
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        self.isLoadingList = false
        self.pullToRefreshClicked = 1
        params.updateValue("1", forKey: "page_no")
        getVideosApi(params)
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
//                    listCollectionView.delegate?.collectionView!(listCollectionView, didSelectItemAt: indexType!)
                }
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                let selectedIndex = self.isSelcted
                if selectedIndex < tabBarCollectionArr.count - 1 {
                    isSelcted = selectedIndex + 1
                    indexType = IndexPath(row:isSelcted ,section:0)
//                    listCollectionView.delegate?.collectionView!(listCollectionView, didSelectItemAt: indexType!)
                }
            default:
                break
            }
        }
    }
    
    
    func getVideosApi(_ param : Parameters)
    {
        if dataToShow.count == 0 && firstTimeLoadData == 0 && self.paginationOn == false {
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        }else {
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
        }
//        self.uplaodData1(APIManager.sharedInstance.KVideoListByID, param) { (response) in
        self.uplaodData1(APIManager.sharedInstance.KVideoListByID , param) { [self] (response) in
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

                            
                                
                                if self.pullToRefreshClicked == 1   {
                                    self.pullToRefreshClicked = 0
                                    self.dataToShow.removeAllObjects()
                                    self.guruArr.removeAll()
                                    self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                    self.guruArr = videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                                    
                                }else {
                                    if self.didSelectCall == 1 {
                                        self.dataToShow.removeAllObjects()
                                        self.guruArr.removeAll()
                                        self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                        self.guruArr = videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                                    }else {
                                        self.dataToShow.removeAllObjects()
//                                        self.guruArr.removeAll()

                                        self.dataToShow.addObjects(from: NSMutableArray(array : result) as! [Any])
                                        self.guruArr = self.guruArr + videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                                    }
                                }
                            


                        }
                        if UIDevice.current.userInterfaceIdiom == .pad{
                            self.collectionView.reloadData()
                            self.collectionView.isHidden = false
                            self.tableView.isHidden = true
                        }
                        else{
                            self.tableView.reloadData()
                            self.collectionView.isHidden = true
                            self.tableView.isHidden = false
                        }

   
                    }
                }else {
                    if self.guruArr.count == 0 {
                        self.tableView.isHidden = true
                        self.noDataLbl.isHidden = false

                        
                    }else {
                        self.tableView.isHidden = false
                        self.noDataLbl.isHidden = true

                    }
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    
                }
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    
    //MARK:- getVideos.

    
    //MARK:- create tableView by cayegory in collectionView.
    func createDataForTableView(_ index: Int) {
        
    }
    
    //MARK:- UICollection View DataSourse.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return tabBarCollectionArr.count
        return self.guruArr.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TBVideoCollectionCell
        let posts = guruArr[indexPath.row]
        cell.mainView.layer.cornerRadius = 5.0
        cell.mainView.dropShadow()
        
//        cell.nameLbl.text = posts.video_title
//        cell.dercriptionLbl.text = posts.video_desc?.html2String
//
//        if posts.views == "0" {
//            cell.numberOfViewsLbl.text = "No view"
//        }else if posts.views == "1" {
//            cell.numberOfViewsLbl.text = "\(posts.views ?? "") View"
//        }else {
//            cell.numberOfViewsLbl.text = "\(posts.views ?? "") Views"
//        }
//
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(posts.published_date!)!
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
//        cell.dateAndTimeLbl.text = dateFormatter.string(from: formatedData)
        
        print("thumbnail_url : \(posts.thumbnail_url ?? "")")
        
        cell.videoImageView?.sd_setShowActivityIndicatorView(true)
        cell.videoImageView?.sd_setIndicatorStyle(.gray)
        cell.videoImageView.layer.cornerRadius = 4.0
        cell.videoImageView.clipsToBounds = true
        cell.videoImageView.contentMode = .scaleToFill
        cell.videoImageView?.sd_setImage(with: URL(string: posts.thumbnail_url!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
        return cell
        
    }
    
    //MARK:- UICollection view Delegates.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.size.width
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: width/2 - 10, height: 180)
        }
        else{
            return CGSize(width: 355, height: 180)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = guruArr[indexPath.row]
        let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
        recentViewHit(param)
        videoType = 1 //Normal Video

        if post.youtube_url != ""{
            let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
            vc.songNo = indexPath.row
            vc.post = guruArr[indexPath.row]
            vc.videosArr = guruArr
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{ 
            playSelectedVideo(seletedData: post)
        }
        
    
    }
    
}

//MARK:- UItableView DataSource.
extension TBSeeMoreVideoVc : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.guruArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TBDetailCell else {
            return UITableViewCell()}
        let posts = guruArr[indexPath.row]
        cell.img?.sd_setShowActivityIndicatorView(true)
        cell.img?.sd_setIndicatorStyle(.gray)
        cell.img.layer.cornerRadius = 4.0
        cell.img.clipsToBounds = true
        cell.img.contentMode = .scaleToFill
        cell.img.sd_setImage(with: URL(string: posts.thumbnail_url ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL) as! TBVideoTableCell2
//        let posts = guruArr[indexPath.row]
//        cell.mainView.layer.cornerRadius = 5.0
//        cell.mainView.dropShadow()
//        var dataWithLong = LONG_LONG_MAX
//        dataWithLong = Int64(posts.published_date!)!
//        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
////        cell.dateAndTimeLbl.text = dateFormatter.string(from: formatedData)
//        
//        print("thumbnail_url : \(posts.thumbnail_url ?? "")")
//        
//        cell.videoImageView?.sd_setShowActivityIndicatorView(true)
//        cell.videoImageView?.sd_setIndicatorStyle(.gray)
//        cell.videoImageView.layer.cornerRadius = 4.0
//        cell.videoImageView.clipsToBounds = true
//        cell.videoImageView.contentMode = .scaleToFill
//        cell.videoImageView?.sd_setImage(with: URL(string: posts.thumbnail_url!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            
            if guruArr.count == 0 || guruArr.count < 10{
                return
            }
            
            self.isLoadingList = true
            
            self.tableView.tableFooterView?.isHidden = false
            firstTimeData = 1
            paginationForSearch = 1
            lastVideo = guruArr [guruArr.count-1]
            lastVideoId = lastVideo.id!
            let param : Parameters
            if userSearched == 1 {
                param  = ["user_id": currentUser.result!.id!,"search_content" : searchText, "last_video_id" : lastVideo.id , "category" : videoCategoryId,"limit":"10"]
                getVideosApi(param)
            }else {
                params.updateValue("\(currentPage + 1 )", forKey: "page_no")

                getVideosApi(params)
            }
        }
        else{
//            loader.shareInstance.hideLoading()
//            self.isLoadingList = false

            self.tableView.tableFooterView?.isHidden = true

        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- UITableView Delegates Methods.
extension TBSeeMoreVideoVc : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = guruArr[indexPath.row]
        let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
        recentViewHit(param)
        videoType = 1 //Normal Video

        if post.youtube_url != ""{
            let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
            vc.songNo = indexPath.row
            vc.post = guruArr[indexPath.row]
            vc.videosArr = guruArr
            vc.menuMasterId = self.menuMasterId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            playSelectedVideo(seletedData: post)
        }
        
        
//        {
//
//            if apiEndPoint == "trending bhajan"{
//                print(apiEndPoint)
//
//
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//
//                    let post = guruArr[indexPath.row]
//        //                homeAllDataArray.bhajan![0].audio![indexPath.row]
//                    MusicPlayerManager.shared.song_no = indexPath.row
//                    MusicPlayerManager.shared.Bhajan_Track = guruArr
//        //                homeAllDataArray.bhajan![0].audio!
//                    MusicPlayerManager.shared.isDownloadedSong = false
//                    MusicPlayerManager.shared.isPlayList = false
//
//                    let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                    MusicPlayerManager.shared.PlayURl(url: post.media_file!)
//
//
//            }
//            else{
//                print(apiEndPoint)
//
//
//                    let post = guruArrVideo[indexPath.row]
//    //                    categoryDataArray[collectionView.tag].trendingVideoList[indexPath.row]
//                    let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
//
//                    if post.youtube_url != ""{
//                        recentViewHit(param)
//                        let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
//                        vc.songNo = indexPath.row
//                        vc.videosArr = guruArrVideo
//    //                        categoryDataArray[collectionView.tag].videoList
//                        vc.post = post
//    //                        categoryDataArray[collectionView.tag].trendingVideoList[indexPath.row]
//                        self.navigationController?.pushViewController(vc, animated: true)
//
//                    }
//
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 10
//        }else {
            return CGFloat.leastNormalMagnitude
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
}
//TBSeeMoreVideoVc
//MARK:- UISearchBarDelegates.
extension TBSeeMoreVideoVc : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            searchText = ""
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if searchClicked == 1 {
            
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
            searchClicked = 0
            searchText = ""
            searchCrossBtnClicked = 1
            let param : Parameters
            if index == 0 {
                param = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : "", "category" : "","limit":"10"]
            }else {
                param = ["user_id": currentUser.result!.id!,"search_content" : "", "last_video_id" : "", "category" : videoCategoryId,"limit":"10"]
            }
            getVideosApi(param)
        }else {
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        userSearched = 1
        searchClicked = 1
        searchText = searchBar.text!
        let param : Parameters
        param  = ["user_id": currentUser.result!.id!,"search_content" : searchText, "last_video_id" : "", "video_category" : videoCategoryId,"limit":"10"]
        getVideosApi(param)
        
    }
    
}

extension TBSeeMoreVideoVc : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

