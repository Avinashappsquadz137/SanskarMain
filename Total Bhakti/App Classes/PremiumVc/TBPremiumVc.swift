//
//  TBPremiumVc.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 30/01/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage
import MMPlayerView
import YouTubePlayer

class TBPremiumVc: TBInternetViewController ,YouTubePlayerDelegate{
    
    var premiumDataArray : [freeModel] = []
    var pullToRefreshOn = false
    var player = AVPlayer()
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var season_short_videos : NSArray!
    var season_thumbnails = [String]()
    @IBOutlet weak var carouselImg : UIImageView!
    @IBOutlet weak var VideoView : UIView!
    
    @IBOutlet weak var sliderCollection: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    var avPlayer = AVPlayer()
    var avPlayerLayer = AVPlayerLayer()
    var ytPlayer: YouTubePlayerView!
    
    var urlArray = [
        "http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8",
        "https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8",
        "https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8",
        "https://devimages.apple.com.edgekey.net/iphone/samples/bipbop/bipbopall.m3u8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params = ["user_id":currentUser.result!.id!]
        getPremiumListApi(params)
        pullToRefresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.successfullPayment(notification:)), name: Notification.Name("paymentDone"), object: nil)
        
    }
    
    @objc func successfullPayment(notification: Notification) {
        
        if ((notification.userInfo?["Bool"]) != nil) == true{
            print("payment Done")
            let params = ["user_id":currentUser.result!.id!]
            getPremiumListApi(params)
        }
    }
    @IBAction func menuBtn(_ sender:UIButton){
        slideMenuController()?.openLeft()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        self.view.endEditing(true)
    }
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    @objc func refresh() {
        let params = ["user_id":currentUser.result!.id!]
        pullToRefreshOn = true
        getPremiumListApi(params)
    }
    
    //    @IBAction func tableHeaderBtnAction(_ sender: UIButton) {
    //
    //    }
    
    @IBAction func tableHeaderBtnAction(_ sender: UIButton) {
        print("sender.tag::::\(sender.tag)\(premiumDataArray[sender.tag].cat_name)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
        
        isComeFrom = 2
        vc.headingSting = premiumDataArray[sender.tag].cat_name?.capitalizingFirstLetter()
        let season_id = premiumDataArray[sender.tag].id
        let param: Parameters  = ["user_id":currentUser.result?.id ?? "","season_id":season_id ?? "","episode_id":"","page_no":"1","limit":"10","category_id":season_id ?? ""]
        vc.param = param
        vc.selectedString = "seeAll"
        //        vc.premiumData = [premiumDataArray[sender.tag]]
        //            vc.modalPresentationStyle = .overCurrentContext
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        if object as AnyObject? === player{
    //            if keyPath == "status" {
    //                if player.status == .readyToPlay {
    //
    //                    TV_PlayerHelper.shared.mmPlayer.player?.play()
    ////                    sliderCollection.reloadData()
    ////                    tableView.reloadData()
    //                }
    //            } else if keyPath == "timeControlStatus" {
    //                if #available(iOS 10.0, *) {
    //                    if player.timeControlStatus == .playing {
    //                        //                        videoCell?.muteButton.isHidden = false
    //                    } else {
    //                        //                        videoCell?.muteButton.isHidden = true
    //                    }
    //                }
    //            } else if keyPath == "rate" {
    //                if player.rate > 0 {
    //                    //                    videoCell?.muteButton.isHidden = false
    //                } else {
    //                    //                    videoCell?.muteButton.isHidden = true
    //                }
    //            }
    //        }
    //    }
    
    
    //    // MARK:- confirm protocol of pagerView and cell size and animation(pagerView.transformer) type of pagerview
    //    func pagerViewUIsetup(){
    //
    //        pagerView.dataSource = self
    //        pagerView.delegate = self
    //        pagerView.transformer = FSPagerViewTransformer(type: .linear)
    //        let transform = CGAffineTransform(scaleX: 0.50, y: 0.70)
    //        self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
    //        pagerView.isInfinite = false
    //        pagerView.contentMode = .scaleAspectFit
    //        pagerView.isUserInteractionEnabled = true
    //        pagerView.itemSize = CGSize(width: self.view.frame.size.width, height: 240)
    //        pagerView.interitemSpacing = 100
    //
    //    }
    
    
    //MARK:- Api Method.
    func getPremiumListApi(_ param : Parameters){
        //        if  self.searchClicked == true {
        //            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        //        }
        self.uplaodData1(APIManager.sharedInstance.KPREMIUMAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                //                self.searchClicked = false
                
                
                if JSON.value(forKey: "status") as? Bool == true {
                    self.season_short_videos = []
                    self.season_thumbnails.removeAll()
                    
                    self.season_short_videos = (JSON["season_promo_videos"] as! NSArray)
                    self.season_thumbnails = JSON["season_thumbnails"] as! [String]
                    
                    self.premiumDataArray.removeAll()
                    let data = JSON.ArrayofDict("data")
                    
                    _ = data.filter({ (dict) -> Bool in
                        
                        let list = dict.ArrayofDict("season_details")
                        if list.count == 0{
                            
                        }else{
                            self.premiumDataArray.append(freeModel(dict: dict))
                        }
                        
                        
                        return true
                    })
                    //                    self.pagerViewUIsetup()
                    self.sliderCollection.reloadData()
                    self.tableView.reloadData()
                    
                    
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    self.sliderCollection.reloadData()
                    self.tableView.reloadData()
                    
                }else {

                    
                    
                    //                    self.searchClicked = false
                    
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
                if self.pullToRefreshOn == true {
                    self.pullToRefreshOn = false
                }
                //                self.searchClicked = false
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK: UITableView DataSourse.
extension TBPremiumVc : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  premiumDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
        cell.dataCollectionView.tag = indexPath.section
        cell.dataCollectionView.delegate = self
        cell.dataCollectionView.dataSource = self
        cell.dataCollectionView.reloadData()
        cell.dataCollectionView.collectionViewLayout.invalidateLayout()
        return cell
    }
    
}
//MARK: UITableView Delegates..
extension TBPremiumVc : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        //            return 50
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL2) as! TBHeaderTableViewCell
        cell.headerBtn.tag = section
        let titleLbl = cell.viewWithTag(100) as! UILabel
        
        titleLbl.text = premiumDataArray[section].cat_name?.capitalizingFirstLetter()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

//MARK: UIColection View DataSource Methods.
extension TBPremiumVc : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == sliderCollection{
            
        }
        else{
            print(premiumDataArray[collectionView.tag].season_details[indexPath.row])
            
            
            let post = premiumDataArray[collectionView.tag].season_details[indexPath.row]
            isComeFrom = 1
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPremiumDetailVC) as! TBPremiumDetailVc
            vc.selectedDataPremium = post
            type = ""
            vc.selectedString = "premiumSeeMore"
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        pageView?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == sliderCollection{
            pageView.numberOfPages = season_thumbnails.count
            return season_thumbnails.count
        }
        else{
            return premiumDataArray[collectionView.tag].season_details.count
        }
    }
    
    //        func collectionView(_ collectionView: UICollectionView,willDisplay cell: UICollectionViewCell,forItemAt indexPath: IndexPath) {
    ////                                    pageView?.currentPage = indexPath.row
    //
    //
    //            if collectionView == sliderCollection{
    //                if let videoView = cell.viewWithTag(21) as? UIView {
    //                    videoView.isHidden = true
    //                    let dict = ((self.season_short_videos)[indexPath.row] as! NSDictionary)
    ////                    if dict["normal"] as? String != nil {
    ////
    ////                        let videoUrl = URL(string: dict["normal"] as! String)
    ////                         TV_PlayerHelper.shared.mmPlayer.set(url: videoUrl)
    ////                         TV_PlayerHelper.shared.mmPlayer.playView = videoView
    ////                         TV_PlayerHelper.shared.mmPlayer.resume()
    ////                         TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
    //////                        TV_PlayerHelper.shared.mmPlayer.thumbImageView.image = season_thumbnails[indexPath.row]
    ////                         TV_PlayerHelper.shared.mmPlayer.player?.play()
    ////                    }
    ////                    if let imageView = cell.viewWithTag(20) as? UIImageView {
    ////                        imageView.contentMode = .scaleToFill
    ////                        imageView.sd_setIndicatorStyle(.gray)
    ////                        imageView.sd_setShowActivityIndicatorView(true)
    ////                        let image = season_thumbnails[indexPath.row]
    ////                        imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
    ////
    //////                        imageView.isHidden = true
    ////                    }
    //                }
    //
    //            }
    //        }
    
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //            sliderCollection.visibleCells.forEach { cell in
    //                // TODO: write logic to stop the video before it begins scrolling
    //                TV_PlayerHelper.shared.mmPlayer.player?.pause()
    //            }
    //        }
    //
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let comedyCell = cell as? TBPremiumSliderCell {
            //        comedyCell.avPlayer.pause()
            //        TV_PlayerHelper.shared.mmPlayer.player?.play()
            //                        sliderCollection.reloadData()
            
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageView?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        
        //            sliderCollection.visibleCells.forEach { cell in
        //                // TODO: write logic to start the video after it ends scrolling
        //                TV_PlayerHelper.shared.mmPlayer.player?.play()
        //                sliderCollection.reloadData()
        //            }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderCollection{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TBPremiumSliderCell
            
            
            
//            cell?.sliderImg.contentMode = .scaleToFill
            cell?.sliderImg.sd_setIndicatorStyle(.gray)
            cell?.sliderImg.sd_setShowActivityIndicatorView(true)
            let image = season_thumbnails[indexPath.row]
            cell?.sliderImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            
            cell?.sliderImg.isHidden = true
            let videoUrl = URL(string: "https://bhaktiappproduction.s3.ap-south-1.amazonaws.com/premium_videos/promo_videos/7541630video1.mp4")!
            cell?.setNeedsLayout()
//            cell?.addPlayer(for: videoUrl, image: image)
            
            let shortVideoData = ((season_short_videos[indexPath.row] as? NSDictionary ?? [:]).value(forKey: "youtube"))
            
            if shortVideoData != nil{
                print("youtube")
            }else{
                print("normal")
                let data = ((season_short_videos[indexPath.row] as? NSDictionary ?? [:]).value(forKey: "normal") as? String ?? "")
                cell?.addPlayer(for: URL(string: data)!, image: image)
            }
            
            
            //            cell?.sliderVideoView.isHidden = true
//            TV_PlayerHelper.shared.mmPlayer.set(url: videoUrl)
//            TV_PlayerHelper.shared.mmPlayer.playView = cell?.sliderVideoView
//            TV_PlayerHelper.shared.mmPlayer.resume()
//            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
//            TV_PlayerHelper.shared.mmPlayer.player?.play()
            //                        TV_PlayerHelper.shared.mmPlayer.thumbImageView.image = season_thumbnails[indexPath.row]
            
            
            
            
            
            return cell!
            
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
            let image = cell.viewWithTag(100) as? UIImageView
            let lockImg = cell.viewWithTag(200) as? UIImageView
            let mainView = cell.viewWithTag(300)
            
            shadow(cell)
            mainView?.layer.cornerRadius = 5.0
            //            lockImg?.tintColor =  colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            let posts = premiumDataArray[collectionView.tag].season_details[indexPath.row]
            lockImg?.isHidden = true
            image?.sd_setIndicatorStyle(.gray)
            image?.sd_setShowActivityIndicatorView(true)
            image?.layer.cornerRadius = 5.0
            image?.clipsToBounds = true
            image?.sd_setImage(with: URL(string: posts.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            
            return cell
            
        }
        
    }
    
}
//extension ViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView == sliderCollection{
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = sliderCollection.frame.size
//        return CGSize(width: size.width, height: size.height)
//    }
//

//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//}
//MARK: UIColection View Delegates Methods.
extension TBPremiumVc : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sliderCollection{
            return 0.0
        }
        else{
            return 10.0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == sliderCollection{
            let size = sliderCollection.frame.size
            //            return CGSize(width: 400  , height: 300)
            
            print("width::\(size.width)----height:::\(size.height)")
            return CGSize(width: size.width, height: size.height)
        }
        
        else{
            return CGSize(width: 120  , height: 130)
        }
    }
    
    
}
//MARK: PagerView Delegates.
extension TBPremiumVc : FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool{
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int){
        
        
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
        //                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].title
        //                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].artist_name
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
        //                    song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].title
        //                    artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[index].artist_name
        //
        //                    SonglikeOrDislike()
        //                    setupTimer()
        //                }
        //            }
        //
        //
        //
        //        }
        //        else{
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
        //                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].title
        //                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track_Trending[index].artist_name
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
        //                    song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[index].title
        //                    artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[index].artist_name
        //
        //                    SonglikeOrDislike()
        //                    AlredayDownloaded()
        //                    AlreadyAddedPlayList()
        //
        //                }
        //            }
        //
        //        }
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
extension TBPremiumVc : FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return season_short_videos.count
        //            season_thumbnails.co
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
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        
        //        let imgUrl = URL(string: season_thumbnails[index])
        //        cell.imageView?.sd_setShowActivityIndicatorView(true)
        //        cell.imageView?.sd_setIndicatorStyle(.gray)
        //        cell.imageView?.clipsToBounds = true
        //        cell.imageView?.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
        
        let videoURL = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        VideoView.layer.addSublayer(playerLayer)
        cell.contentView.addSubview(VideoView)
        player.play()
        
        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        return cell
    }
}

