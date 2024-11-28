//
//  TBHomeVC.swift
//  Total Bhakti
//
//  Created by Prashant on 21/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//


import UIKit
import AVKit
import MMPlayerView
import GoogleCast
import Alamofire
import FittedSheets
import SDWebImage
import GoogleMobileAds

var post: channelModel!

var homeAllDataArray : HomeAllData!
var channelTableArr  = [channelModel]()

class TBHomeVC: TBInternetViewController,AAPlayerDelegate,shortCutDelegate,MMPlayerLayerProtocol,GetVideoQualityList, GCKSessionManagerListener, GCKUIMiniMediaControlsViewControllerDelegate,GADFullScreenContentDelegate{
    
    let window = UIApplication.shared.keyWindow
    /* The player state. */
    enum PlaybackMode: Int {
        case none = 0
        case local
        case remote
    }
    //MARK:- IBOutlets.
    let smallVideoPlayerViewController = AVPlayerViewController()
    var videoList : [videosResult] = []
    var bhajanList : [trendingBhajanModel] = []
    var newList : [News] = []
    
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var videoGifMainView: UIView!
    @IBOutlet weak var notifCountLabel: UILabel!
    @IBOutlet weak var playTBbtn: UIButton!
    @IBOutlet weak var homePlayer:UIView!
    @IBOutlet weak var adPlayer:UIView!
    @IBOutlet weak var searchBarHolder: UIView!
    @IBOutlet weak var searchBarBtn: UIButton!
    @IBOutlet weak var qrScanner: UIButton!
    @IBOutlet weak var apsLbl: UILabel!
    @IBOutlet var holieventbtn: UIButton!
    @IBOutlet weak var holieventimg:UIImageView!
    
    
    var newsArray : News!
    var dataOFVideos : VideosData1!
    var live_tvList : [live_tvModel] = []
    var videoAdList : [live_tvModel] = []
    var bhajanAdList : [live_tvModel] = []
    var adURl:String = ""
    var gapDuration : Double = 60.0
    var newTime = Timer()
    var urlString : [String] = []
    var dataArray: [Any] = []
    var videoDict : [String : Any] = [:]
    var dataUrl : String = ""
    var labeldata = ["Avi tyagi","vaibhav","Manish","ashish","pankaj"]
    var imagedata = ["profilelogo1","profilelogo2","profilelogo3","profilelogo4","profilelogo4"]
    var datalist  = [[String:Any]]()
    var recorduserdata = 1
    
    
    //MARK:- Variables.
    
    var refreshControl: UIRefreshControl!
    var lbl = UILabel()
    
    var searchText = ""
    var searchClicked = false
    var pullToRefreshOn = false
    var videosArr  = [Videos]()
    let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    let workItem = DispatchWorkItem {
        print("done")
    }
    var categoryDataArray : [CategoryModel] = []
    var sessionManager: GCKSessionManager!
    private var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
    var castDiscovery:GCKDiscoveryManager!
    var mediaView: UIView!
    
    var dataCollectionView0 : UICollectionView!
    var dataCollectionView1 : UICollectionView!
    var dataCollectionView2 : UICollectionView!
    fileprivate var sourceArray: Array<Any>!
    fileprivate var currentIndex = 0
    var urlStrinfFirstPart = String()
    var secondPartOfUrlString = String()
    var jointUrl  = String()
    var isSelected = false
    var postData : videosResult?
    static let instance = TBHomeVC()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var isRadioSatsang = false
    var radioChannel:channelModel?
    // google cast
    private var castSession: GCKCastSession!
    var selectedIndex:Int = 0
    var channelUrl:URL?
    var adIndex = 0
    var adMediaArray = [String]()
    var adIDArray = [String]()
    var adIDUrl: String = ""
    var skipValue = [String]()
    var skipData: String = ""
    var playBtnHide: Bool = false
    var bandwidthArray = [String]()
    var resolutionArray = [String]()
    var seasondata = [[String:Any]]()
    var chTap:Int = 0
    var keydata = ""
    var profile_id = ""
    var shortsvalue = ""
    var holivalue = ""
    let adUnitID = "ca-app-pub-1618767157139570/5766265057"
     var rewardedAd: GADRewardedAd?
    var record: Int?
    var playerLayer : AVPlayerLayer? = nil
    var pipController: AVPictureInPictureController?
    //Advertise Img
    //    @IBOutlet weak var advertiseView: UIView!
    //    @IBOutlet weak var advertiseImg: UIImageView!
    //    @IBOutlet weak var blurBtn: UIButton!
    
    //MARK:- lifeCycle Methode.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.holieventbtn.isHidden = true
        self.holieventimg.isHidden = true

         let shortsValue = UserDefaults.standard.object(forKey: "shortdataKey") as? String
        let holiValue = UserDefaults.standard.object(forKey: "holidataKey") as? String
        self.shortsvalue = shortsValue ?? ""
            print("Shorts Value: \(self.shortsvalue)")
        self.holivalue = holiValue ?? ""
        print(self.holivalue)
            if !self.shortsvalue.isEmpty {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBshortsVC") as! TBshortsVC
                vc.deeplinkshortid = self.shortsvalue
                UserDefaults.standard.removeObject(forKey: "shortdataKey")
                UserDefaults.standard.synchronize()
                navigationController?.pushViewController(vc, animated: true)
            } else if !self.holivalue.isEmpty   {
                if currentUser.result?.id == "163" {
                   
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
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "activeuserprofileViewController") as!  activeuserprofileViewController
                        vc.guruid = self.holivalue
                        print(vc.guruid)
                        UserDefaults.standard.removeObject(forKey: "holidataKey")
                        UserDefaults.standard.synchronize()
                        navigationController?.pushViewController(vc, animated: true)
                    }
                 }
        else {
            print("haala")
        }
        
        let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
        print(sesiondata)

        print("device_tokken::::",deviceTokanStr)
        TV_PlayerHelper.shared.mmPlayer.mmDelegate = self
        if universalType == "1" || universalType == "2" || universalType == "3"{
            let params = UserDefaults.standard.value(forKey: "universalParam")
            self.universalLinkApi(params as! Parameters, url: APIManager.sharedInstance.KUniversalLinkApi)
        }
        epgPlay = false
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TBHomeVC.advertiseImgTappedMethod(_:)))
        castUpdate()
        DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view)})
        UserDefaults.standard.removeObject(forKey: "CurrentChannel")
        NotificationCenter.default.addObserver(self, selector: #selector(PlaySelectedChannel), name: NSNotification.Name("PlayTV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseHomePlayer), name: NSNotification.Name("pausePost"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(castVideo), name: NSNotification.Name("castVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("PixelActionSheet"), object: nil)
        AddNotification()
        comeFromHomeScreen = 1
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "paymentalertcell", bundle: nil), forCellReuseIdentifier: "paymentalertcell")
        UserDefaults.standard.set("true", forKey: "hiderotation")
        
        lbl = noDataLabelCall(controllerType: self, tableReference: tableView)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
//        if currentUser.status == true {
//            currentUser = User.init(dictionary: TBSharedPreference.sharedIntance.getUserData()!)
//        }else {
//            currentUser = nil
//        }
        
        pullToRefresh()
        
        urlStrinfFirstPart = "http://ec2-52-66-203-146.ap-south-1.compute.amazonaws.com:1935/vipul/_definst_/amazons3/mp4:bhaktiappproduction/videos/"
        secondPartOfUrlString = "/playlist.m3u8"
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0

        let button = UIButton()
        button.tag = 0
        
        let notification_type = UserDefaults.standard.value(forKey: "notification_type") as? String ?? ""
        let title = UserDefaults.standard.value(forKey: "noteTitle") as? String ?? ""
        if notification_type == "video"{
            button.tag = 1
            TBHomeTabBar.currentInstance?.TabBarActionButton(button)
        }
        else if notification_type == "bhajan"{
            button.tag = 3
            TBHomeTabBar.currentInstance?.TabBarActionButton(button)
        }
        else if notification_type == "news"{
            button.tag = 4
            TBHomeTabBar.currentInstance?.TabBarActionButton(button)
        }
        else{
        }
        updateVersion()
        NotificationCenter.default.addObserver(self, selector: #selector(SkipAd), name: NSNotification.Name("SkipAd"), object: nil)
        let device_id = UserDefaults.standard.string(forKey: "device_id")

        let param : Parameters = ["user_id": currentUser.result?.id,"device_type":"2","current_version": "\(UIApplication.release)","profile_id":profile_id,"device_id": "\(device_id ?? "")"]
        print(param)
       
            self.getCategoryApi(param)
        
      
        let param1: Parameters = ["device_id": device_id]
        print(param1)
        loginuserrecordapi(param1)
        setupPiP()
    }
    func loadAndShowRewardedAd() {
           GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
               if let error = error {
                   print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                   return
               }
               self?.rewardedAd = ad
               self?.rewardedAd?.fullScreenContentDelegate = self
               print("Rewarded ad loaded.")
               self?.showRewardedAd()
           }
       }
    func showRewardedAd() {
           if let ad = rewardedAd {
               ad.present(fromRootViewController: self) {
                   let reward = ad.adReward
                   print("User earned reward of \(reward.amount) \(reward.type).")
               }
           } else {
               print("Ad wasn't ready.")
               loadAndShowRewardedAd()
           }
       }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
           print("Ad did fail to present full screen content with error: \(error.localizedDescription)")
           loadAndShowRewardedAd()
       }

       func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
           print("Ad did present full screen content.")
       }

       func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
           print("Ad did dismiss full screen content.")
           presentAlert()
       }

    func presentAlert() {
            let alert = UIAlertController(title: "", message: "To Continue Enjoying Ads-free Subscribe to Premium", preferredStyle: .alert)
        let goPremiumAction = UIAlertAction(title: "Subscribe", style: .default, handler: { action in
            
            // This will navigate to the premium page
            self.showPremiumPage()
        })
        
            let notNowAction = UIAlertAction(title: "Not Now", style: .cancel, handler: { action in
                // This will dismiss the alert
                alert.dismiss(animated: true, completion: nil)
            })
        
            alert.addAction(goPremiumAction)
            alert.addAction(notNowAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    
    func loginuserrecordapi(_ param1: Parameters) {
        self.uplaodData(APIManager.sharedInstance.KuserRecord, param1) { (response) in
            DispatchQueue.main.async { loader.shareInstance.hideLoading() }
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    let recorddata = self.recorduserdata
                    print(recorddata)
                       UserDefaults.standard.set(recorddata, forKey: "recorddata")
                    
                }
            }
        }
    }
        func showPremiumPage() {
            // Assuming "PremiumViewController" is the identifier for your premium page view controller in the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let premiumVC = storyboard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as? TBPremiumPaymentVC {
                self.navigationController?.pushViewController(premiumVC, animated: true)
            }
        }
    func startTimer() {
        //MARK: TIMER EXECUTION
        //        newTime.invalidate()// just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        //        let duration = gapDuration / 1000
        //        newTime = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { [weak self] _ in
        //            // do something here
        //            print("TIME CROSSED : \(self?.newTime.timeInterval)")
        //            if let url = self?.adURl {
        //                self?.adDecreaseCounting(urlStr: url)
        //                self?.adIndex += 1
        //            }
        //        }
    }
    
    func touchInVideoRect(contain: Bool) {
        print("\(contain)")
    }
    func universalLinkApi(_ param : Parameters, url:String){
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                print("key::\(key),,value::\(value)")
                print("url::",url)
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, to: APIManager.sharedInstance.KBASEURL+url, method: .post, headers: nil,
                         encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                    if let responseData = response.response {
                        switch responseData.statusCode {
                        case APIManager.sharedInstance.KHTTPSUCCESS:
                            guard let result = response.result.value else {
                                return
                            }
                            print(result)
                            switch universalType {
                            case "1":
                                print("Video switch::::")
                                TBHomeTabBar.currentInstance?.selectedIndex = 0
                                TBHomeTabBar.currentInstance?.img_home.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_videos.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_guru.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.home_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                TBHomeTabBar.currentInstance?.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.bhajan_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                if let JSON = result as? NSDictionary {
                                    print(JSON)
                                    let data = JSON["data"] as? NSDictionary
                                    self.videoList.append(videosResult(dictionary: data!)!)
                                    let post = self.videoList[0]
                                    
                                    if post.youtube_url != ""{
                                        let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                                        videoType = 1
                                        vc.post = post
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            case "2":
                                print("Bhajan switch::::")
                                TBHomeTabBar.currentInstance?.selectedIndex = 0
                                TBHomeTabBar.currentInstance?.img_home.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_videos.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_guru.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.home_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                TBHomeTabBar.currentInstance?.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.bhajan_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                
                                if let JSON = result as? NSDictionary {
                                    print(JSON)
                                    let data = JSON["data"] as? NSDictionary
                                    self.bhajanList.append(trendingBhajanModel(dict: data! as! Dictionary<String, Any>))
                                    let post = self.bhajanList[0]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                                    MusicPlayerManager.shared.song_no = 0
                                    MusicPlayerManager.shared.trendingBhajanString = "trending bhajan"
                                    MusicPlayerManager.shared.Bhajan_Track_Trending = [post]
                                    
                                    MusicPlayerManager.shared.isDownloadedSong = false
                                    MusicPlayerManager.shared.isPlayList = false
                                    MusicPlayerManager.shared.Slider?.minimumValue = 0.0
                                    MusicPlayerManager.shared.isRadioSatsang = false
                                    
                                    let vc : TBMusicPlayerVC = storyBoard.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
                                    
                                    //                                    self.navigationController?.pushViewController(vc, animated: true)
                                    self.present(vc, animated: true, completion: nil)
                                    
                                    MusicPlayerManager.shared.PlayURl(url: post.media_file)
                                }
                                
                            case "3":
                                print("News switch::::")
                                TBHomeTabBar.currentInstance?.selectedIndex = 0
                                TBHomeTabBar.currentInstance?.img_home.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_bhajan.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_videos.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_guru.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.img_premium.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                 TBHomeTabBar.currentInstance?.home_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                TBHomeTabBar.currentInstance?.videos_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.bhajan_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.livetvlbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                TBHomeTabBar.currentInstance?.premium_lbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                
                                if let JSON = result as? NSDictionary {
                                    print(JSON)
                                    let data = JSON["data"] as? NSDictionary
                                    //      JSON.ArrayofDict("data")
                                 self.newList.append(News(dictionary: data!)!)
                                    let post = self.newList[0]
                                    let vc : TBNewsDetailVC = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
                                    
                                    NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
                                    vc.dataToShow = post
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                    
                            default:
                                break
                            }
                        default:
                            break
                        }
                    }
                    if let err = response.result.error as? URLError {
                        if err.code == .notConnectedToInternet{
                            AlertController.alert(title: ALERTS.kNoInterNetConnection)
                        }
                        else if err.code == .timedOut{
                            // AlertController.alert(title: "Connection time out")
                        }else if err.code == .networkConnectionLost{
                            // AlertController.alert(title: "Network Connection Lost")
                        }
                    } else {
                        // AlertController.alert(title: ALERTS.kNoInterNetConnection)
                    }
                }
                
            case .failure(let encodingError):
                DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                // AlertController.alert(title: ALERTS.KSOMETHINGWRONG)
                print("error:\(encodingError)")
            }
        })
        
    }
    
    //MARK: - View wil Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if playBtnHide == true {
            playTBbtn.isHidden = false
            playBtnHide = false
        }
        liveTap = "tap"
        AppUtility.lockOrientation(.all)
        appDelegate?.delegate = self
        if let index = appDelegate?.selectedIndex{
            self.tabBarController?.selectedIndex = index
        }
//        if currentUser.result!.id! == "163"{
//            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNewMobileVC)
//                    self.navigationController?.pushViewController(vc, animated: true)
//               }else{
        print(UserDefaults.standard.object(forKey: "keyAccess"))
                   self.keydata = UserDefaults.standard.object(forKey: "keyAccess") as? String ?? ""
                   print(self.keydata)
        let components = self.keydata.components(separatedBy: "=")

        if components.count == 2 {
            let value = components[1]
            print(value)
            let params: Parameters = ["user_id": currentUser.result?.id ?? "163","id": value ]
                          print(params)
            self.gettvlogin(params)
        } else {
            print("Invalid format")
        }
        
 //               }
//        DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view)})
//        let param : Parameters = ["user_id": "458500","device_type":"2","current_version": "\(UIApplication.release)","profile_id":profile_id]
//        print(param)
       DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.3) {
//            self.getCategoryApi(param)
//            let params: Parameters = ["user_id": currentUser.result!.id!,"id": self.keydata ]
//                          print(params)
//            self.gettvlogin(params)
            
        }
        if self.isRadioSatsang == true{
            homePlayer.isHidden = true
        }else{
            homePlayer.isHidden = false
        }
        
        print("called")
        UserDefaults.standard.setValue(0, forKey: "SideMneuIndexValue")
        
//        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as? String ?? "0"
//        notifCountLabel.text = notification_counter
     //   loadAndShowRewardedAd()
    }
    
    func shortCutIndex(index: Int) {
        if index == 1{
            if self.tabBarController is TBHomeTabBar{
                let tabbar = self.tabBarController as! TBHomeTabBar
                tabbar.fullTV()
            }
        }else{
            self.tabBarController?.selectedIndex = index
        }
    }
    
     // Comment  by Avi tyagi ;-

//    @objc func advertiseImgTappedMethod(_ sender:UIButton){
//        print("you tap image number")
//        //        advertiseView.isHidden = true
//        //        blurBtn.isHidden = true
//        let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
//        navigationController?.pushViewController(vc, animated: true)
//  
//    }
    //MARK:- Barcode scanner
    
    @IBAction func barCodescanner(_ sender: UIButton){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Newpaymentvc") as! Newpaymentvc
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func searchBarBtnPressed(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBViewController") as! TBViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func searchDismiss(_ sender: UIButton){
        searchBar.text = ""
        searchBarHolder.isHidden = true
        searchBarHolder.backgroundColor = .clear
    }
    
    //MARK:- Api Method.
       func gettvlogin(_ params : Parameters){
           DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
           self.uplaodData1(APIManager.sharedInstance.ktvlogin, params) { (response) in
               DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
               print(response as Any)
               DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
               if let json = response as? NSDictionary {
                   print(json)
                   
                   if json["status"] as? Bool == true {
                       AlertController.alert(message: json["message"] as? String ?? "")
                       self.navigationController?.popToRootViewController(animated: false)
                   }
//                   else if json["status"] as? Bool == false {
//                       AlertController.alert(message:"Please Login first")
//                   }
                   
   //                json["status"] as? Bool == true
   //                    AlertController.alert(message: "Login sussces")
                      
               }
           }
       }
    //MARK:- Duration Advertise Api Method.
    func advertiseApi(_ param : Parameters){
        self.uplaodData1(APIManager.sharedInstance.KAds, param) { [self] (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                self.searchClicked = false
                if JSON.value(forKey: "status") as? Bool == true {

                    self.live_tvList.removeAll()
                    //                    self.gapDuration = Double((((JSON["gap_duration"]as! NSDictionary)["LIVE_CHANNEL"]) as? Int ?? 0)/1000)
                    self.gapDuration = Double((JSON["gap_duration"] as! NSDictionary)["LIVE_CHANNEL"] as! String) ?? 60.0
                    let data = (JSON["live_tv"] as? Array ?? [])
                    self.dataArray = data
                    let live_tvdata = JSON.ArrayofDict("live_tv")
                    if live_tvdata.count > 0 {
                        for index in 0..<live_tvdata.count {
                            self.adMediaArray.append(live_tvdata[index]["media"] as? String ?? "")
                            self.adIDArray.append(live_tvdata[index]["id"] as? String ?? "")
                            self.skipValue.append(live_tvdata[index]["skip"] as? String ?? "")
                        }
                        self.adURl = self.adMediaArray.first ?? ""
                        self.adIDUrl = self.adIDArray.first ?? ""
                        self.skipData = self.skipValue.first ?? ""
                        
                    }
                    _ = live_tvdata.filter({ dict -> Bool in
                        self.live_tvList.append(live_tvModel(dict: dict))
                        return true
                    })
                    
                }else {
                    if let url = self.channelUrl{
                        //                        TV_PlayerHelper.shared.mmPlayer.set(url: url)
                        //                        TV_PlayerHelper.shared.mmPlayer.playView = self.homePlayer
                        //                        TV_PlayerHelper.shared.mmPlayer.resume()
                        //                        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
                        //                        TV_PlayerHelper.shared.mmPlayer.player?.play()
                        
                    }
                }
            }else {
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    
    // Comment by Avi tyagi :-
    
    
//    func getSub(with param: Parameters) {
//        
//        self.uplaodData(APIManager.sharedInstance.playPop, param) { response in
//            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
//            if let json = response as? NSDictionary {
//                if json["status"] as? Bool == true {
//                    let data = (json["data"] as? NSDictionary ?? [:])["thumbnail"] as? String ?? ""
//                    let msg = (json["data"] as? NSDictionary ?? [:])["title"] as? String ?? ""
//                    UserDefaults.standard.set(data, forKey: "img")
//                    IosAlertView().showAlert(title: msg, message: "Please subscibe ", ButtonTitle: ["Cancel"], animationType: .zoomIn) { value in
//                        if value == true {
//                            let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    //MARK: Google Cast

    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
        updateControlBarsVisibility(shouldAppear: shouldAppear)
    }
    
    func castUpdate(){
        sessionManager = GCKCastContext.sharedInstance().sessionManager
        mediaView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 30, width: self.view.frame.width, height: 70))
        self.view.addSubview(mediaView!)
        let castContext = GCKCastContext.sharedInstance()
        sessionManager.add(self)
        miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        miniMediaControlsViewController.delegate = self
        updateControlBarsVisibility(shouldAppear: true)
        installViewController(miniMediaControlsViewController, inContainerView: mediaView!)
    }
    
    func updateControlBarsVisibility(shouldAppear: Bool = false) {
        if shouldAppear {
            mediaView!.isHidden = false
        } else {
            //            mediaView!.isHidden = true
            print("Disapear")
        }
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        view.setNeedsLayout()
    }
    func installViewController(_ viewController: UIViewController?, inContainerView containerView: UIView) {
        if let viewController = viewController {
            addChildViewController(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
        }
    }
    @objc func castVideo(){
        
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        let current = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var dateform = dformat.string(from: oneHourAgo!)
        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
        print(dateform)
        if let urlString = channelTableArr[selectedIndex].channel_url {
            dataUrl = "\(urlString)?start=\(dateform)01:00:00+05:30&end="
        }
        let url = URL.init(string: dataUrl)
        let metaData = GCKMediaMetadata()
        metaData.setString("This is Descriptions", forKey: kGCKMetadataKeyTitle)
        metaData.setString("This is Descriptions", forKey: kGCKMetadataKeySubtitle)
        if let image = channelTableArr[selectedIndex].image {
            metaData.addImage(GCKImage(url: URL(string: image)!, width: 480, height: 360))
        }
        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: url!)
        mediaInfoBuilder.streamType = GCKMediaStreamType.live;
        mediaInfoBuilder.contentType = ".m3u8"
        mediaInfoBuilder.metadata = metaData;
        let mediaInformation = mediaInfoBuilder.build()
        // Now finally handing over all information and load video
        if let request =  sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation){
            request.delegate = self
            
        }
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
    
    //MARK: - Device Orientation
    
    @objc func deviceOrientationDidChange() {
        //2
        switch UIDevice.current.orientation {
        case .faceDown:
            print("Face down")
            if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                TV_PlayerHelper.shared.mmPlayer.setOrientation(.landscapeRight)
            }
        case .faceUp:
            print("Face up")
            //            if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
            //                TV_PlayerHelper.shared.mmPlayer.setOrientation(.landscapeLeft)
            //            }
        case .unknown:
            print("Unknown")
        case .landscapeLeft:
            print("landscape left")
            if TV_PlayerHelper.shared.mmPlayer.playUrl != nil  {
                TV_PlayerHelper.shared.mmPlayer.setOrientation(.landscapeLeft)
            }
        case .landscapeRight:
            print("landscape right")
            if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                TV_PlayerHelper.shared.mmPlayer.setOrientation(.landscapeRight)
            }
        case .portrait:
            print("Portrait")
            if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                TV_PlayerHelper.shared.mmPlayer.setOrientation(.protrait)
            }
        case .portraitUpsideDown:
            print("Portrait upside down")
            if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
                TV_PlayerHelper.shared.mmPlayer.setOrientation(.protrait)
            }
        }
    }
    @objc func rotated() {
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) && TV_PlayerHelper.shared.mmPlayer.playUrl != nil{
            TV_PlayerHelper.shared.mmPlayer.setOrientation(.landscapeLeft)
        }else{
            TV_PlayerHelper.shared.mmPlayer.setOrientation(.protrait)
        }
    }
    
    @objc func pauseHomePlayer(){
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pausePost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseHomePlayer), name: NSNotification.Name("pausePost"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        AppUtility.lockOrientation(.all)
        newTime.invalidate()
        goToRadio = ""
        appDelegate?.selectedIndex = nil
        prePum = "premium" 
        
        //                TV_PlayerHelper.shared.mmPlayer.player?.pause()
        //                TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        //                TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        //                TV_PlayerHelper.shared.mmPlayer.isHidden = true
    }
    @IBAction func advertiseCrossBtn(_ sender:UIButton){
        //        advertiseView.isHidden = true
        //        blurBtn.isHidden = true
        
    }
    
    // MARK: - Play Btn
    @IBAction func PlayBTnAction(_ sender:UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        startTimer()
        
        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
            playTBbtn.isHidden = true
            TV_PlayerHelper.shared.mmPlayer.playView = homePlayer
            TV_PlayerHelper.shared.mmPlayer.resume()
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
            TV_PlayerHelper.shared.mmPlayer.player?.play()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
            MusicPlayerManager.shared.myPlayer.pause()
        }
        else if self.isRadioSatsang == true{
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
            playTBbtn.isHidden = false
            homePlayer.isHidden = true
            var img = ""
            MusicPlayerManager.shared.trendingBhajanString = ""
            MusicPlayerManager.shared.isDownloadedSong = false
            MusicPlayerManager.shared.isPlayList = false
            MusicPlayerManager.shared.isRadioSatsang = true
            MusicPlayerManager.shared.radioChannel = self.radioChannel
            if let imgStr = radioChannel?.image{
                playerImage?.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                img = imgStr
            }
            let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
            //                        vc.radioChannel = self.radioChannel
            //            self.navigationController?.pushViewController(vc, animated: true)
            goToRadio = "radio"
            roImg = img
            self.present(vc, animated: true, completion: nil)
            
            MusicPlayerManager.shared.PlayURl(url: self.radioChannel?.channel_url ?? "")
        }
        else if channelTableArr.count != 0{
            if adMediaArray.count > 0 {
                self.adDecreaseCounting(urlStr: adURl)
                                
            }else{
                newTime.invalidate()
                if channelTableArr[0].channel_url != ""{
                    let current = Date()
                    let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
                    let dformat = DateFormatter()
                    dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    var dateform = dformat.string(from: oneHourAgo!)
                    dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                    print(dateform)
                    if let urlSting = channelTableArr[0].channel_url {
                        dataUrl = "\(urlSting)?start=\(dateform)&end="
                        
                    }
                    exact = exactTime()
                    UserDefaults.standard.set(exact, forKey: "playTime")
                    chTap += 1
                    playTBbtn.isHidden = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
                    if currentUser.result?.id == "163" {
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
                            
                        }
                        
                        chTap = 0
                    }else{
                        if dataUrl != "" {
                            self.playVideo(hlsUrl: dataUrl)
                        }else{
                            AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                                if index == 1 {
                                    let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
                    
                }else{
                    AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                        if index == 1 {
                            let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc func PlaySelectedChannel() {
        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil {
            playTBbtn.isHidden = true
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
            TV_PlayerHelper.shared.mmPlayer.playView = homePlayer
            
        }else{
            playTBbtn.isHidden = false
        }
    }
    
    //MARK:- Topbar Button action.
    @IBAction func shareBtnAction (_ sender : UIButton) {
//        let text = "https://sanskargroup.page.link/"
//        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//        present(activity, animated: true, completion: nil)
        
        if currentUser.result?.id == "163" {
            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
            if sms == "1" {
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
                            }

            
            else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                navigationController?.pushViewController(vc, animated: true)
            }
            
       
        }
        else {
            let vc =  storyBoard.instantiateViewController(withIdentifier: "TBProfileVC") as! TBProfileVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func holibtn(_ sender: UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: "allholiprogramlist") as! allholiprogramlist
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func notificationBtnAction (_ sender : UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuBtnAction (_ sender : UIButton) {
        slideMenuController()?.openLeft()
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
    }
    
    @IBAction func tableHeaderBtnAction(_ sender: UIButton) {
        if currentUser.result?.id == "163" {
            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
            if sms == "1" {
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
            }
            
            
            else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else {
            if  categoryDataArray[sender.tag].type == "bhajan"{
                UserDefaults.standard.setValue(4, forKey: "SideMneuIndexValue")
                let btn = UIButton()
                btn.tag = 3
                TBHomeTabBar.currentInstance?.TabBarActionButton(btn)
                
            }
            else if categoryDataArray[sender.tag].type == "trending bhajan"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBTrendingBhajanVc") as! TBTrendingBhajanVc
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                let params: Parameters = ["user_id": currentUser.result!.id! , "menu_master_id" : categoryDataArray[sender.tag].id,"category" : "1","limit":"50", "page_no":"1"]
                
                vc.params = params
                vc.apiEndPoint = "trending bhajan"
                vc.menu_master_id = categoryDataArray[sender.tag].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            else if categoryDataArray[sender.tag].type == "trending video"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBTrendingBhajanVc") as! TBTrendingBhajanVc
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                let params: Parameters = ["user_id": currentUser.result!.id! , "menu_master_id" : categoryDataArray[sender.tag].id,"category" : "1","limit":"50", "page_no":"1"]
                vc.apiEndPoint = "trending video"
                vc.params = params
                videoType = 1 //Normal Video
                
                vc.menu_master_id = categoryDataArray[sender.tag].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "video"{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBSeeMoreVideoVc") as! TBSeeMoreVideoVc
                videoType = 1 //Normal Video
                vc.menuMasterId = categoryDataArray[sender.tag].id
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                let params: Parameters = ["user_id": currentUser.result!.id! , "menu_master_id" : categoryDataArray[sender.tag].id,"category": "0","limit":"50", "page_no":"1"]
                
                vc.params = params
                //            vc.videosArr = categoryDataArray[sender.tag].videoList
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "news"{
                let btn = UIButton()
                btn.tag = 4
                UserDefaults.standard.setValue(5, forKey: "SideMneuIndexValue")
                TBHomeTabBar.currentInstance?.TabBarActionButton(btn)
                
            }
            else if  categoryDataArray[sender.tag].type == "channel"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBChannelListVC") as! TBChannelListVC
                vc.channelList = categoryDataArray[sender.tag].channelList
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if categoryDataArray[sender.tag].type == "live darshan" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBGuruListViewController") as! TBGuruListViewController
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                vc.menuMasterId = categoryDataArray[sender.tag].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "guru"{///
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBGuruListViewController") as! TBGuruListViewController
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                UserDefaults.standard.setValue(2, forKey: "SideMneuIndexValue")
                vc.menuMasterId = categoryDataArray[sender.tag].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "season"{   // season
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
                
                videoType = 2 //Premium Video
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                if categoryDataArray[sender.tag].menu_title == "continue watching"
                {
                    let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category":"4","page_no":"1","limit":"50","menu_type_id":"6"]
                    print(param)
                    vc.param = param
                    isComeFrom = 2
                }
                else  if categoryDataArray[sender.tag].menu_title == "What's New"
                {
                    let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category":"5","page_no":"1","limit":"50","menu_type_id":"6"]
                    print(param)
                    vc.param = param
                    isComeFrom = 2
                }
                else
                {
                    let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category":"1","page_no":"1","limit":"50","menu_type_id":"6"]
                    vc.param = param
                    isComeFrom = 2
                }
                //            vc.premiumData = categoryDataArray[sender.tag].freeList
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            else if categoryDataArray[sender.tag].type == "Whats's New" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
                isComeFrom = 1
                videoType = 2 //Premium Video
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category":"1","page_no":"1","limit":"50","menu_type_id":"6"]
                vc.param = param
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "guru wise katha"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
                isComeFrom = 1
                videoType = 2 //Premium Video
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                
                let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category":"1","page_no":"1","limit":"50","menu_type_id":"16","premium_auth_id":categoryDataArray[sender.tag].premium_auth_id]
                vc.param = param
                type = "season"
                isComeFromHome = 1
                
                //            vc.premiumData = categoryDataArray[sender.tag].freeList
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "category wise season"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
                isComeFrom = 1
                videoType = 2 //Premium Video
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                
                let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category":"1","page_no":"1","limit":"50","menu_type_id":"6","premium_auth_id": categoryDataArray[sender.tag].premium_auth_id]
                vc.param = param
                type = "season"
                isComeFromHome = 1
                
                //            vc.premiumData = categoryDataArray[sender.tag].freeList
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "promotion"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
                isComeFrom = 1
                videoType = 2 //Premium Video
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category":"2","page_no":"1","limit":"50","menu_type_id":"9"]
                vc.param = param
                type = "promotion"
                isComeFromHome = 1
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if  categoryDataArray[sender.tag].type == "free"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
                videoType = 2 //Premium Video
                vc.headingSting = categoryDataArray[sender.tag].menu_title.capitalizingFirstLetter()
                isComeFrom = 1
                let param: Parameters  = ["user_id":currentUser.result?.id ?? "","menu_master_id":categoryDataArray[sender.tag].id,"category_id":"2","page_no":"1","limit":"50","menu_type_id":"10"]
                vc.param = param
                type = "free"
                isComeFromHome = 1
                
                //            vc.premiumData = categoryDataArray[sender.tag].freeList
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
            }
        }
    }
    //    "bhajan"
    //    "news"//
    //    "video"///
    //    "guru"///
    //    "channel"//
    //    "season"///
    //    "promotion"
    //    "free"
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    func updateVersion() {
        HttpHelper.apiCallWithout(postData: [:], url: "version/Version/get_version", identifire: "") { result, response, error, data in
            if let Json = data,(response?["status"] as? Bool == true), response != nil {
                let decoder = JSONDecoder()
                do{
                    let safeData = try decoder.decode(VersionResponse.self, from: Json)
                    let result = safeData.data.aws_sms_ios
                    let showads = safeData.data.show_ads
                    print(showads)
                    UserDefaults.standard.set(result, forKey: "sms")
                    UserDefaults.standard.set(showads, forKey: "iosads")
                    self.showadsinios()
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func showadsinios() {
        let adskey = UserDefaults.standard.value(forKey: "iosads") as? String ?? ""
        if adskey == "1"{
            let value = UserDefaults.standard.value(forKey: "prim") as? Int ?? 0
            print(value)
            if value == 0 {
                
                loadAndShowRewardedAd()
            }
            else {
                print("no ads")
            }
            
            }else {
    //                   presentAlert()
                
            }
            
            
            
        
    }
    @objc func refresh() {
        
        let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
        print(sesiondata)
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","device_type":"2","current_version": "\(UIApplication.release)","profile_id":profile_id,"device_id": "\(device_id ?? "")"]
        pullToRefreshOn = true
        getCategoryApi(param)
        self.showadsinios()
    }
    
    //MARK:- shadow on view
    func shadowEffect(_ view : UIView)  {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius =   1.0
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 0.5
    }
    
    //optional method
    func callBackDownloadDidFinish(_ status: playerItemStatus?) {
        let status:playerItemStatus = status!
        switch status {
        case .readyToPlay:
            
            break
        case .failed:
            break
        default:
            break
        }
    }
    //MARK:- Api Method.
    func getCategoryApi(_ param : Parameters){
        //        if  self.searchClicked == true {
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        //        }
        let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
        print(sesiondata)
        self.uplaodData1(APIManager.sharedInstance.KCategoryAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
          
                    
                    if let JSON = response as? NSDictionary {
                        print(JSON)
                        if JSON["status"] as? Bool == false {
                            self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK) {
                                self.navigationToLogincontroller()
                            }
                        }
                            else {
                        let notification_counter = JSON["notification_count"] as? Int ?? 0
                        print("Notification Count:", notification_counter)
                        self.notifCountLabel.text = String(notification_counter)
                        UserDefaults.standard.setValue(notification_counter, forKey: "notification_counter")
                        
                        let invitationevent = JSON["invitation_event"] as? Int ?? 0
                        if invitationevent == 1 {
                            self.holieventbtn.isHidden = false
                            self.holieventimg.isHidden = false
                        }
                        else {
                        }
                        self.searchClicked = false
                        self.categoryDataArray.removeAll()
                        if JSON.value(forKey: "status") as? Bool == true {
                            
                            let data = JSON.ArrayofDict("data")
                            let season_data = (JSON["season_data"] as? [[String:Any]] ?? [[:]])
                            print(season_data)
                            self.seasondata = season_data
                            _ = data.filter({ (dict) -> Bool in
                                let list = dict.ArrayofDict("list")
                                if list.count == 0{
                                }else{
                                    self.categoryDataArray.append(CategoryModel(dict: dict))
                                }
                                return true
                            })
                            self.channelUrl = URL(string: channelTableArr[0].channel_url ?? "")
                            if self.pullToRefreshOn == true {
                                self.pullToRefreshOn = false
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            guard let web_view_bhajan = JSON["web_view_bhajan"],
                                  let web_view_news = JSON["web_view_news"],
                                  let web_view_video = JSON["web_view_video"],
                                  let is_premium_active = JSON["is_premium_active"],
                                  let isPremium = JSON["is_premium"],
                                  let adStatus = JSON["advertisement_status"],
                                  let qrdata  = JSON["qr_scanner"],
                                  let epg = JSON["tv_guide_ios"] else {return}
                            AdStatus = adStatus as? Int
                            epgIos = epg as? String
                            IsPremiumAct = isPremium as? Int
                            qrStatus = qrdata as? String
                            UserDefaults.standard.set(isPremium, forKey: "prim")
                            if is_premium_active as! String == "1"{
                                TBHomeTabBar.currentInstance?.newStackView.isHidden = false
                                TBHomeTabBar.currentInstance?.oldStackView.isHidden = true
                            }
                            else{
                                TBHomeTabBar.currentInstance?.newStackView.isHidden = true
                                TBHomeTabBar.currentInstance?.oldStackView.isHidden = false
                            }
                            if isPremium as! Int == 1 {
                                //                        UserDefaults.standard.setValue(premActive, forKey: "isPremium")
                            }
                            else{
                                if adStatus as! Int == 1 {
                                    let param : Parameters = ["user_id": currentUser.result?.id ?? "163"]
                                    self.advertiseApi(param)
                                }else{
                                    
                                }
                            }
                            let param : Parameters = ["user_id": currentUser.result?.id ?? "163"]
       //                     self.getSub(with: param)
                            if qrStatus == "0"{
                                if #available(iOS 13.0, *) {
                                    self.qrScanner.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
                                } else {
                                    // Fallback on earlier versions
                                }
                                self.searchBarBtn.isHidden = true
                            }else{
                                self.searchBarBtn.isHidden = false
                            }
                            UserDefaults.standard.setValue(web_view_bhajan, forKey: "web_view_bhajan")
                            UserDefaults.standard.setValue(web_view_news, forKey: "web_view_news")
                            UserDefaults.standard.setValue(web_view_video, forKey: "web_view_video")
                            //                    UserDefaults.standard.setValue(is_premium_active, forKey: "is_premium_active")
                        }else {
                            if self.pullToRefreshOn == true {
                                self.pullToRefreshOn = false
                            }
                            self.searchClicked = false

                        }
                    }
                }else {
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    self.searchClicked = false
                  
                }
            
        }
    }
    
    @objc func buttonClicked(_ sender:UIButton) {
        print(sender.tag)
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        
        let alert = UIAlertController.init(title: "", message: "", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction.init(title: "Play now", style: .default) { (action) in
            
            let post = self.categoryDataArray[section].trendingBhajanList[row]
            let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
            MusicPlayerManager.shared.song_no = row
            MusicPlayerManager.shared.trendingBhajanString = "trending bhajan"
            MusicPlayerManager.shared.Bhajan_Track_Trending = self.categoryDataArray[section].trendingBhajanList
            MusicPlayerManager.shared.isDownloadedSong = false
            MusicPlayerManager.shared.isPlayList = false
            MusicPlayerManager.shared.isRadioSatsang = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
            //            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            
            MusicPlayerManager.shared.PlayURl(url: post.media_file)
        }
        let action2 = UIAlertAction.init(title: "Play next", style: .default) { (action) in
        }
        let action3 = UIAlertAction.init(title: "Add to Queue", style: .default) { (action) in
        }
        let action4 = UIAlertAction.init(title: "Download", style: .default) { (action) in
        }
        let action5 = UIAlertAction.init(title: "Share", style: .default) { (action) in
        }
        let action6 = UIAlertAction.init(title: "Cancel", style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action5)
        alert.addAction(action6)
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    //MARK:- Search Api.
    func searchApiHome(param : Parameters)  {
        self.uplaodData(APIManager.sharedInstance.KHOMESEARCHAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                self.searchClicked = true
                if JSON.value(forKey: "status") as? Bool == true {
                    homeAllDataArray = HomeAllData.init(dictionary: JSON)
                    //                    let categoryData = CategoryModel.init(dict: JSON as! Dictionary<String, Any>)
                    //                    self.categoryDataArray = [categoryData]
                    ////                    self.categoryDataArray.append(CategoryModel(dict: JSON as! Dictionary<String, Any>))
                    
                    //                    post = CategoryModel.init(dict: JSON as! Dictionary<String, Any>)
                    
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    self.tableView.reloadData()
                    
                }else {
                    
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    self.searchClicked = false
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
                if self.pullToRefreshOn == true {
                    self.pullToRefreshOn = false
                }
                self.searchClicked = false
                //                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}
    
extension UIViewController {
    func addAlert(_ title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


    
//MARK:- UIColection View DataSource Methods.
extension TBHomeVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Assuming collectionView.tag is used to identify the specific category
        
        // Check if the tag is within the valid range of categoryDataArray indices
        guard collectionView.tag < categoryDataArray.count else {
            return 0
        }
        
        let categoryType = categoryDataArray[collectionView.tag].type

        switch categoryType {
        case "bhajan":
            let itemCount = min(10, categoryDataArray[collectionView.tag].bhajanList.count)
            print("bhajanList.count::::::", itemCount)
            return itemCount

        case "news":
            let itemCount = min(10, categoryDataArray[collectionView.tag].newList.count)
            print("newList.count::::::", itemCount)
            return itemCount

        case "video":
            let itemCount = min(10, categoryDataArray[collectionView.tag].videoList.count)
            print("videoList.count::::::", itemCount)
            return itemCount

        case "guru":
            let itemCount = min(10, categoryDataArray[collectionView.tag].guruList.count)
            print("guruList.count::::::", itemCount)
            return itemCount
        case "live darshan":
            let itemCount = min(50, categoryDataArray[collectionView.tag].liveDarshanList.count)
            print("liveDarshan.count::::::", itemCount)
            return itemCount
            
        case "shorts":
            let itemCount = min(10, categoryDataArray[collectionView.tag].shortslist.count)
            print("shortslist.count::::::", itemCount)
            return itemCount

        case "channel":
            let itemCount = min(11, categoryDataArray[collectionView.tag].channelList.count)
            print("channelList.count::::::", itemCount)
            return itemCount

        case "season":
            let itemCount = min(10, categoryDataArray[collectionView.tag].seasonList.count)
            print("seasonList.count::::::", itemCount)
            return itemCount

        case "promotion":
            let itemCount = min(10, categoryDataArray[collectionView.tag].promotionList.count)
            print("promotionList.count::::::", itemCount)
            return itemCount

        case "free":
            let itemCount = min(10, categoryDataArray[collectionView.tag].freeList.count)
            print("freeList.count::::::", itemCount)
            return itemCount

        case "trending video":
            let itemCount = min(10, categoryDataArray[collectionView.tag].trendingVideoList.count)
            print("trendingVideoList.count::::::", itemCount)
            return itemCount

        case "trending bhajan":
            let itemCount = min(10, categoryDataArray[collectionView.tag].trendingBhajanList.count)
            print("trendingBhajanList.count::::::", itemCount)
            return itemCount

        case "continue watching":
            let itemCount = min(10, categoryDataArray[collectionView.tag].videoList.count)
            print("videoList.count::::::", itemCount)
            return itemCount

        case "author wise season":
            let itemCount = min(10, categoryDataArray[collectionView.tag].authwise.count)
            return itemCount

        case "category wise season":
            let itemCount = min(10, categoryDataArray[collectionView.tag].catwise.count)
            return itemCount
            

        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if categoryDataArray[collectionView.tag].type == "bhajan"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let viewLbl = cell.viewWithTag(101) as? UILabel
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = true
                viewLbl?.isHidden = true
                
                let lbl = cell.viewWithTag(200) as? UILabel
                let mainView = cell.viewWithTag(300)
                let playIcon = cell.viewWithTag(500) as! UIImageView
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                
                playIcon.isHidden = true
                let posts = categoryDataArray[collectionView.tag].bhajanList[indexPath.row]
                lbl?.isHidden = true
                
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                //            threeDotBtn.tag = (collectionView.tag * 1000) + indexPath.row
                image?.sd_setImage(with: URL(string: posts.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                return cell
                
            }
            else if categoryDataArray[collectionView.tag].type == "trending video"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let viewLbl = cell.viewWithTag(101) as? UILabel
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = true
                viewLbl?.isHidden = true
                
                let lbl = cell.viewWithTag(200) as? UILabel
                let mainView = cell.viewWithTag(300)
                let playIcon = cell.viewWithTag(500) as! UIImageView
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                lbl?.isHidden = true
                playIcon.isHidden = false
                //            image?.contentMode = .scaleAspectFit
                let posts = categoryDataArray[collectionView.tag].trendingVideoList[indexPath.row]
                let integerViews = Int(posts.views ?? "") ?? 0
                //            let integerYoutubeViews = Int(posts.youtube_views ?? "")
                //            let totalViews = integerViews ?? 0 + integerYoutubeViews!
                if integerViews == 1{
                    
                    print(formatNumber(integerViews))
                    viewLbl?.text = "\(formatNumber(integerViews)) View"
                    
                }
                else if integerViews > 1 {
                    print(formatNumber(integerViews))
                    
                    viewLbl?.text = "\(formatNumber(integerViews)) Views"
                }
                else if integerViews == 0{
                    viewLbl?.text = ""
                }
                //            lbl?.text = posts.author_name
                //            lbl?.numberOfLines = 1
                //            descriptionLbl.isHidden = false
                //            descriptionLbl.text = posts.video_desc?.html2String
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                image?.sd_setImage(with: URL(string: posts.thumbnail_url ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
            }
            
            else if categoryDataArray[collectionView.tag].type == "trending bhajan"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let lbl = cell.viewWithTag(200) as? UILabel
                let viewLbl = cell.viewWithTag(101) as? UILabel
                viewLbl?.isHidden = true
                let mainView = cell.viewWithTag(300)
                let playIcon = cell.viewWithTag(500) as! UIImageView
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = true
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                lbl?.isHidden = true
                playIcon.isHidden = true
                //            threeDotBtn.tag = indexPath.row
                
                let posts = categoryDataArray[collectionView.tag].trendingBhajanList[indexPath.row]
                //            lbl?.text = posts.artist_name
                //            lbl?.numberOfLines = 1
                //            descriptionLbl.isHidden = false
                //            descriptionLbl.text = posts.descript.html2String
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                
                image?.sd_setImage(with: URL(string: posts.thumbnail1), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
            }
            else if categoryDataArray[collectionView.tag].type == "news"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let viewLbl = cell.viewWithTag(101) as? UILabel
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = true
                viewLbl?.isHidden = true
                
                let lbl = cell.viewWithTag(200) as? UILabel
                let mainView = cell.viewWithTag(300)
                let playIcon = cell.viewWithTag(500) as! UIImageView
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                lbl?.isHidden = false
                lbl?.numberOfLines = 2
                playIcon.isHidden = true
                let posts = categoryDataArray[collectionView.tag].newList[indexPath.row]
                let integerViews = Int(posts.views_count ?? "")
                
                if integerViews == 1{
                    
                    viewLbl?.text = "\(formatNumber(integerViews!)) View"
                    
                }
                else if integerViews ?? 0 > 1 {
                    viewLbl?.text = "\(formatNumber(integerViews!)) Views"
                }
                else if integerViews == 0{
                    viewLbl?.text = ""
                }
                else if integerViews == 0{
                    viewLbl?.text = ""
                }
                //            else{
                //                viewLbl?.isHidden = true
                //            }
                lbl?.text = posts.title
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                image?.sd_setImage(with: URL(string: posts.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
            }
            
        else if categoryDataArray[collectionView.tag].type == "video"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
            let image = cell.viewWithTag(100) as? UIImageView
            let viewLbl = cell.viewWithTag(101) as? UILabel
            viewLbl?.isHidden = true
            
            let lbl = cell.viewWithTag(200) as? UILabel
            let mainView = cell.viewWithTag(300)
            let playIcon = cell.viewWithTag(500) as! UIImageView
            let logo = cell.viewWithTag(201) as? UIImageView
            logo?.isHidden = true
            shadow(cell)
            mainView?.layer.cornerRadius = 5.0
            lbl?.isHidden = true
            
            playIcon.isHidden = false
            
            //  MARK  this is comment by AVI TYAGI
            
            // let posts = categoryDataArray[collectionView.tag].videoList[indexPath.row]
            
            let categoryIndex = collectionView.tag
            let videoList = categoryDataArray[categoryIndex].videoList
            
            if indexPath.row < videoList.count {
                let posts = videoList[indexPath.row]
                print(posts)
                
                // Use `posts` here
                
                let integerViews = Int(posts.views ?? "") ?? 0
                
                //            let integerYoutubeViews = Int(posts.youtube_views ?? "") ?? 0
                //            let totalViews = integerViews + integerYoutubeViews
                if integerViews == 1{
                    
                    viewLbl?.text = "\(formatNumber(integerViews)) View"
                }
                else if integerViews > 1 {
                    viewLbl?.text = "\(formatNumber(integerViews)) Views"
                }
                else if integerViews == 0{
                    viewLbl?.text = ""
                }
                image?.clipsToBounds = true
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.sd_setImage(with: URL(string: posts.thumbnail_url!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
                return cell
                
            }
             else if categoryDataArray[collectionView.tag].type ==  "live darshan"{
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                 let image = cell.viewWithTag(100) as? UIImageView
                 let viewLbl = cell.viewWithTag(101) as? UILabel
                 let logo = cell.viewWithTag(201) as? UIImageView
                 logo?.isHidden = true
                 viewLbl?.isHidden = true
                 
                 let lbl = cell.viewWithTag(200) as? UILabel
                 let mainView = cell.viewWithTag(300)
                 let playIcon = cell.viewWithTag(500) as! UIImageView
                 shadow(cell)
                 mainView?.layer.cornerRadius = 5.0
                 lbl?.isHidden = false
                 
                 playIcon.isHidden = true
                 let posts = categoryDataArray[collectionView.tag].liveDarshanList[indexPath.row]    //guruList[indexPath.row]
                // lbl?.text = posts.title
                 lbl?.numberOfLines = 2
                 image?.sd_setIndicatorStyle(.gray)
                 image?.sd_setShowActivityIndicatorView(true)
                 image?.layer.cornerRadius = 5.0
                 image?.clipsToBounds = true
                 image?.sd_setImage(with: URL(string: posts.thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                 
                 return cell
             }
               else if categoryDataArray[collectionView.tag].type == "guru"{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let viewLbl = cell.viewWithTag(101) as? UILabel
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = true
                viewLbl?.isHidden = true
                
                let lbl = cell.viewWithTag(200) as? UILabel
                let mainView = cell.viewWithTag(300)
                let playIcon = cell.viewWithTag(500) as! UIImageView
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                lbl?.isHidden = false
                
                playIcon.isHidden = true
                let posts = categoryDataArray[collectionView.tag].guruList[indexPath.row]
                lbl?.text = posts.name
                lbl?.numberOfLines = 2
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                image?.sd_setImage(with: URL(string: posts.profile_image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
                
            }
            else if categoryDataArray[collectionView.tag].type == "channel"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TBHomePagerCollectionViewCell", for: indexPath) as!  TBHomePagerCollectionViewCell 
                shadow(cell)
                cell.liveLbl.isHidden = true
                cell.tvImage.isHidden = true
                let po = categoryDataArray[collectionView.tag].channelList[0]
                if self.isRadioSatsang == true{
                    let imgStr = categoryDataArray[collectionView.tag].channelList.last
                    // let imgStr = categoryDataArray[collectionView.tag].channelList[channelCount]
                    playerImage?.sd_setImage(with: URL(string: imgStr?.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }else{
                    playerImage?.sd_setImage(with: URL(string: po.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
                
                if indexPath.row == UserDefaults.standard.value(forKey: "channelPlaying") as? Int{
                    cell.liveLbl.isHidden = false
                    cell.tvImage.isHidden = false
                }
                
                cell.contentView.layer.cornerRadius = 10.0
                //  MARK  this is comment by AVI TYAGI
//                let onePost = categoryDataArray[collectionView.tag].channelList[indexPath.row]
                
                let categoryIndex = collectionView.tag
                let channelList = categoryDataArray[categoryIndex].channelList
                
                if indexPath.row < channelList.count {
                    let onePost = channelList[indexPath.row]
                    print(onePost)
                    
                    cell.pagerImage.sd_setShowActivityIndicatorView(true)
                    cell.pagerImage.sd_setIndicatorStyle(.gray)
                    cell.pagerImage.sd_setImage(with: URL(string: onePost.image!), placeholderImage:  UIImage(named: "landscape_placeholder"), options: .refreshCached, completed: nil)
                }
                
                return cell
                
            }
        else if categoryDataArray[collectionView.tag].type == "season"{
            
            if categoryDataArray[collectionView.tag].menu_title == "continue watching" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let mainView = cell.viewWithTag(300)
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = false
                if #available(iOS 13.0, *) {
                    logo?.image = UIImage(systemName: "tatacrown")
                } else {
                    // Fallback on earlier versions
                }
                
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                
                //  MARK  this is comment by AVI TYAGI
                //     let posts = categoryDataArray[collectionView.tag].seasonList[indexPath.row]
                
                
                let categoryIndex = collectionView.tag
                let seasonList = categoryDataArray[categoryIndex].seasonList
                
                if indexPath.row < seasonList.count {
                    let posts = seasonList[indexPath.row]
                    image?.sd_setIndicatorStyle(.gray)
                    image?.sd_setShowActivityIndicatorView(true)
                    image?.layer.cornerRadius = 5.0
                    image?.clipsToBounds = true
                    
                    
                    image?.sd_setImage(with: URL(string: posts.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
                return cell
            }
            else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let mainView = cell.viewWithTag(300)
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = false
                if #available(iOS 13.0, *) {
                    logo?.image = UIImage(systemName: "tatacrown")
                } else {
                    // Fallback on earlier versions
                }
                
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                
                //  MARK  this is comment by AVI TYAGI
                //     let posts = categoryDataArray[collectionView.tag].seasonList[indexPath.row]
                
                
                let categoryIndex = collectionView.tag
                let seasonList = categoryDataArray[categoryIndex].seasonList
                
                if indexPath.row < seasonList.count {
                    let posts = seasonList[indexPath.row]
                    image?.sd_setIndicatorStyle(.gray)
                    image?.sd_setShowActivityIndicatorView(true)
                    image?.layer.cornerRadius = 5.0
                    image?.clipsToBounds = true
                    
                    
                    image?.sd_setImage(with: URL(string: posts.vertical_banner ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                }
                return cell
            }
        }
        else if categoryDataArray[collectionView.tag].type == "author wise season" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let mainView = cell.viewWithTag(300)
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = false
                if #available(iOS 13.0, *) {
                    logo?.image = UIImage(systemName: "tatacrown")
                } else {
                    // Fallback on earlier versions
                }
                
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                
                let posts = categoryDataArray[collectionView.tag].authwise[indexPath.row]
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                
                image?.sd_setImage(with: URL(string: posts.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
                
            }else if categoryDataArray[collectionView.tag].type == "category wise season" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let mainView = cell.viewWithTag(300)
                let logo = cell.viewWithTag(201) as? UIImageView
                logo?.isHidden = false
                if #available(iOS 13.0, *) {
                    logo?.image = UIImage(systemName: "tatacrown")
                } else {
                    // Fallback on earlier versions
                }
                
                shadow(cell)
                mainView?.layer.cornerRadius = 5.0
                
                let posts = categoryDataArray[collectionView.tag].catwise[indexPath.row]
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                
                image?.sd_setImage(with: URL(string: posts.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
            }
            
            else if categoryDataArray[collectionView.tag].type == "promotion"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let mainView = cell.viewWithTag(300)
                shadow(cell)
                
                mainView?.layer.cornerRadius = 5.0
                let posts = categoryDataArray[collectionView.tag].promotionList[indexPath.row]
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                
                image?.sd_setImage(with: URL(string: posts.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
            }
        
        else if categoryDataArray[collectionView.tag].type == "shorts"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
            let image = cell.viewWithTag(100) as? UIImageView
            let lbl = cell.viewWithTag(200) as? UILabel
            let viewLbl = cell.viewWithTag(101) as? UILabel
            viewLbl?.isHidden = true
            let mainView = cell.viewWithTag(300)
            let playIcon = cell.viewWithTag(500) as! UIImageView
            let logo = cell.viewWithTag(201) as? UIImageView
            logo?.isHidden = true
            shadow(cell)
            mainView?.layer.cornerRadius = 5.0
            lbl?.isHidden = true
            playIcon.isHidden = true
            
            let posts = categoryDataArray[collectionView.tag].shortslist[indexPath.row]
            image?.sd_setIndicatorStyle(.gray)
            image?.sd_setShowActivityIndicatorView(true)
            image?.layer.cornerRadius = 5.0
            image?.clipsToBounds = true
            
            image?.sd_setImage(with: URL(string: posts.thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            
            return cell
        }
        
        
        
            
            else if categoryDataArray[collectionView.tag].type == "free"{
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let label = cell.viewWithTag(200) as? UILabel
                let logo = cell.viewWithTag(201) as? UIImageView
                if #available(iOS 13.0, *) {
                    logo?.image = UIImage(systemName: "tatacrown")
                   // logo?.sd_setImage(with: URL(string: "crown.fill"))
                } else {
                    // Fallback on earlier versions
                }
                logo?.isHidden = false
                label?.isHidden = true
                let mainView = cell.viewWithTag(300)
                shadow(cell)
                let playIcon = cell.viewWithTag(500) as! UIImageView
                playIcon.isHidden = true
                
                
                mainView?.layer.cornerRadius = 5.0
                let posts = categoryDataArray[collectionView.tag].freeList[indexPath.row]
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                
                image?.sd_setImage(with: URL(string: posts.thumbnail_url), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
            }
            else if categoryDataArray[collectionView.tag].type == "continue watching"{
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL1, for: indexPath)
                let image = cell.viewWithTag(100) as? UIImageView
                let lbl = cell.viewWithTag(200) as? UILabel
                lbl?.isHidden = true
                let mainView = cell.viewWithTag(300)
                let viewLbl = cell.viewWithTag(101) as? UILabel
                viewLbl?.isHidden = true
                shadow(cell)
                let playIcon = cell.viewWithTag(500) as! UIImageView
                playIcon.isHidden = false
                
                mainView?.layer.cornerRadius = 5.0
                let posts = categoryDataArray[collectionView.tag].videoList[indexPath.row]
                
                let integerViews = Int(posts.views ?? "") ?? 0
                if integerViews == 1{
                    
                    viewLbl?.text = "\(formatNumber(integerViews)) View"
                    
                }
                else if integerViews > 1 {
                    
                    viewLbl?.text = "\(formatNumber(integerViews)) Views"
                }
                else if integerViews == 0{
                    viewLbl?.text = ""
                }
                
                image?.sd_setIndicatorStyle(.gray)
                image?.sd_setShowActivityIndicatorView(true)
                image?.layer.cornerRadius = 5.0
                image?.clipsToBounds = true
                
                image?.sd_setImage(with: URL(string: posts.thumbnail_url ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dummyCell", for: indexPath)
                return cell
                
            }
        
       
    }
    
    func adDecreaseCounting(urlStr:String ){
        //        adIndex += 1
        UserDefaults.standard.setValue(self.selectedIndex, forKey: "channelPlaying")
        let url = URL(string: urlStr)
        playTBbtn.isHidden = true
        homePlayer.isHidden = false
        
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.set(url: url)
        TV_PlayerHelper.shared.mmPlayer.playView = homePlayer
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        TV_PlayerHelper.shared.mmPlayer.player?.play()
        TV_PlayerHelper.shared.mmPlayer.player?.seek(to: kCMTimeZero)
        iscoming = "tbHomeVC"
        if let isplaying = TV_PlayerHelper.shared.mmPlayer.player?.isPlaying,isplaying == true{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didAdPlay"), object: nil)
            UserDefaults.standard.setValue(5, forKey: "counter")
            UserDefaults.standard.setValue(Int(skipData), forKey: "skipValue")
            
        }
        TV_PlayerHelper.shared.mmPlayer.showCover(isShow: true)
        TV_PlayerHelper.shared.mmPlayer.autoHideCoverType = .disable
        playerImage.isHidden = true
        adPlayer.isHidden = true
    }
    //MARK:- Skip Ads
    
    @objc func SkipAd(){
        
        if adIndex >= adMediaArray.count {
            self.adIndex = 0
            self.adURl = adMediaArray[adIndex]
            self.adIDUrl = adIDArray[adIndex]
            self.skipData = skipValue[adIndex]
            
        } else {
            self.adURl = adMediaArray[adIndex]
            self.adIDUrl = adIDArray[adIndex]
            self.skipData = skipValue[adIndex]
        }
        
        if kAds == true {
            let param : Parameters = ["user_id": currentUser.result?.id ?? "163","advertisement_id": adIDUrl,"advertisement_status":"1" ]
            adViewApiHit(param)
        }else{
            let param : Parameters = ["user_id": currentUser.result?.id ?? "163","advertisement_id": adIDUrl,"advertisement_status":"0" ]
            adViewApiHit(param)
        }
        
        homePlayer.isHidden = false
        adPlayer.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        let current = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var dateform = dformat.string(from: oneHourAgo!)
        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
        print(dateform)
        if let urlString = channelTableArr[selectedIndex].channel_url {
            dataUrl = "\(urlString)?start=\(dateform)01:00:00+05:30&end="
        }
        self.playVideo(hlsUrl: dataUrl)
    }
    
    //MARK: - Video Time
    
    func hitPlayTime(_ parm: Parameters) {
        
        uplaodData1(APIManager.sharedInstance.playTime, parm) { response in
            if let Json = response as? NSDictionary {
                if Json["status"] as? Bool == true {
                    print(Json["status"] as Any)
                }
            }
        }
        
    }
    //MARK: - Quality Player
    
    func playVideo(hlsUrl: String) {
        getUrl(urlString: hlsUrl) { subUrl in
            DispatchQueue.main.async {
                guard let content = URL(string: hlsUrl) else { return }
                
                let urlAsset = AVURLAsset(url: content)
                TV_PlayerHelper.shared.mmPlayer.player?.pause()
                TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
                TV_PlayerHelper.shared.mmPlayer.set(url: content)
                TV_PlayerHelper.shared.mmPlayer.player?.seek(to: kCMTimeZero) // Use kCMTimeZero if it's available
                TV_PlayerHelper.shared.mmPlayer.playView = self.homePlayer
                TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredMaximumResolution = CGSize(width: 1280, height: 720)
                TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = 0
                TV_PlayerHelper.shared.mmPlayer.resume()
                TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
                TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
                TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
                TV_PlayerHelper.shared.mmPlayer.player?.play()
                self.setupPiP()
            }
        }
    }

    func getUrl(urlString: String, completion: @escaping ([String]) -> Void) {
        // Initialize an empty array to store results
        var subUrl = [String](repeating: "", count: 4)
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(subUrl)
            return
        }
        
        // Fetch data asynchronously with URLSession
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load URL: \(error.localizedDescription)")
                completion(subUrl)
                return
            }
            
            // Ensure the data is valid
            guard let data = data, let contents = String(data: data, encoding: .utf8) else {
                print("Failed to load data")
                completion(subUrl)
                return
            }
            
            print(contents) // Debug: Print fetched contents

            // Parse resolutions
            var resolutionArray = [String]()
            var bandwidthArray = [String]()
            
            var resolution = contents.components(separatedBy: "RESOLUTION=")
            resolution.remove(at: 0)
            for dic in resolution {
                let str = dic.components(separatedBy: ",")
                resolutionArray.append(str[0])
            }
            
            // Parse bandwidths
            var bandwith = contents.components(separatedBy: "AVERAGE-BANDWIDTH=")
            bandwith.remove(at: 0)
            for dic in bandwith {
                let str = dic.components(separatedBy: ",")
                bandwidthArray.append(str[0])
            }
            
            // Combine parsed values into subUrl array
            subUrl = resolutionArray + bandwidthArray
            
            // Send parsed data back on main thread
            DispatchQueue.main.async {
                completion(subUrl)
            }
        }.resume()
    }
    
    @objc func methodOfReceivedNotification(notification: Notification)
    {
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        let window = UIApplication.shared.keyWindow
        
        
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoControlVc") as! VideoControlVc
        //        let controller = self.storyboard?.instantiateViewController(identifier: "VideoControlVc") as! VideoControlVc
        controller.delegate = self
        controller.videoDict = videoDict
        let sheetController = SheetViewController(controller: controller)
        sheetController.cornerRadius = 20
        sheetController.setSizes([.fixed(250)])
        window?.rootViewController!.present(sheetController, animated: false, completion: nil)
    }
    
    func getSeletedBitRate(bitrate: Int) {
        let resolution = resolutionArray[bitrate].components(separatedBy: "x")
        TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredMaximumResolution = CGSize(width: Double(resolution[0])!, height: Double(resolution[1])!)
        //        TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = Double(self.bandwidthArray[bitrate])!
        TV_PlayerHelper.shared.mmPlayer.player?.play()
    }
    
    func getSeletedSpeedRate(playBackSpeed: String) {
        CoverA.playerRate = Double(Float(playBackSpeed)!)
        TV_PlayerHelper.shared.mmPlayer.player?.rate = Float(playBackSpeed)!
        
    }
    
    func getBitRateList(data: NSArray,selectionTye: Int) {
        
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qualityVc") as! qualityVc
        
        if selectionTye == 1
        {
            controller.resolutionArray = self.resolutionArray
        }
        else
        {
            controller.resolutionArray = []
            controller.currentPlayBackSpeed = (TV_PlayerHelper.shared.mmPlayer.player?.rate) ?? 1.0
        }
        controller.delegate = self
        let sheetController = SheetViewController(controller: controller)
        sheetController.cornerRadius = 20
        sheetController.setSizes([.fixed(450)])
        
        let window = UIApplication.shared.keyWindow
        window?.rootViewController!.present(sheetController, animated: false, completion: nil)
        
    }
    func adViewApiHit(_ param: Parameters){
        
        loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.kupdateAdCounter, param) { (response) in
            DispatchQueue.main.async {
                print(response as Any)
            }
            
        }
        
    }
}

//MARK:- UIColection View Delegates Methods.
@available(iOS 13.0, *)
extension TBHomeVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//                   if UIDevice.current.userInterfaceIdiom == .pad{
//                       if categoryDataArray[collectionView.tag].type == "channel"{
//                           
//                           return CGSize(width: 200 , height: 100)
//                       }
//                   }
//                   if UIDevice.current.userInterfaceIdiom == .phone{
//                       if categoryDataArray[collectionView.tag].type == "channel"{
//                           return CGSize(width: 120 , height: 80)
//                         //  return CGSize(width: 80, height: 60)
//                       }
//                   }
//                   
//                   //        if categoryDataArray[collectionView.tag].type == "guru"{
//                   //            let width = (self.view.frame.size.width) / 2.3 //some width
//                   //            let height = width * 3.5 //ratio
//                   //
//                   //            if UIDevice.current.userInterfaceIdiom == .pad{
//                   //                return CGSize(width: 224, height: 170)
//                   //            }
//                   //            if UIDevice.current.userInterfaceIdiom == .phone{
//                   //                return CGSize(width: width  , height: 110)
//                   //            }
//                   //
//                   //
//                   //        }
//                   //        if categoryDataArray[collectionView.tag].type == "news"{
//                   //            let width = (self.view.frame.size.width) / 2.3 //some width
//                   //            let height = width * 3.5 //ratio
//                   //
//                   //            if UIDevice.current.userInterfaceIdiom == .pad{
//                   //                return CGSize(width: 224  , height: 170)
//                   //            }
//                   //            if UIDevice.current.userInterfaceIdiom == .phone{
//                   //                return CGSize(width: width, height: 170)
//                   //            }
//                   //
//                   //        }
//        
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            
//            if categoryDataArray[collectionView.tag].type == "season"{
//                if categoryDataArray[collectionView.tag].menu_title == "continue watching" {
//                    let width = (self.view.frame.size.width) / 2.3 //some width
//                    return CGSize(width: 250  , height: 120)
//                    
//                    
//                }
//                else
//                {
//                    
//                    let width = (self.view.frame.size.width) / 2.3 //some width
//                    return CGSize(width: 150  , height: 250)
//                }
//            }
//        }
//        
//        if UIDevice.current.userInterfaceIdiom == .pad{
//            
//            if categoryDataArray[collectionView.tag].type == "season"{
//                if categoryDataArray[collectionView.tag].menu_title == "continue watching" {
//                    let width = (self.view.frame.size.width) / 2.3 //some width
//                    return CGSize(width: 320  , height: 120)
//                    
//                    
//                }
//                else
//                {
//                    
//                    let width = (self.view.frame.size.width) / 2.3 //some width
//                    return CGSize(width: 150  , height: 250)
//                }
//            }
//        }
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            if categoryDataArray[collectionView.tag].type == "promotion"{
//                let width = (self.view.frame.size.width) / 2.3 //some width
//                return CGSize(width: 250  , height: 120)
//            }
//        }
//                  if categoryDataArray[collectionView.tag].type == "shorts" {
//                      return CGSize(width: 250, height: 120)
//             
//                 }
//                   if categoryDataArray[collectionView.tag].type == "free"{
//                       let width = (self.view.frame.size.width) / 2.3 //some width
//                       
//                       if UIDevice.current.userInterfaceIdiom == .pad{
//                           return CGSize(width: 320  , height: 120)
//                       }
//                       if UIDevice.current.userInterfaceIdiom == .phone{
//                           return CGSize(width: 250  , height: 120)
//                       }
//                       else{
//                           return CGSize(width: 250  , height: 120)
//                       }
//                   }
//        
//        
//                   else{
//                       
//                       let width = (self.view.frame.size.width) / 2.3 //some width
//                       let height = width * 3.5 //ratio
//                       
//                       print("type:::::",categoryDataArray[collectionView.tag].type)
//                       print("width:::::",width)
//                       if UIDevice.current.userInterfaceIdiom == .pad{
//                           return CGSize(width: 320, height: 120)
//                       }
//                       if UIDevice.current.userInterfaceIdiom == .phone{
//                           return CGSize(width:  250, height: 120)
//                       }
//                       else{
//                           return CGSize(width:  250  , height: 120)
//                       }
//                   }
//               
        
        let deviceType = UIDevice.current.userInterfaceIdiom
        let category = categoryDataArray[collectionView.tag]

        switch category.type {
        case "channel":
            if deviceType == .pad {
                return CGSize(width: 200, height: 100)
            } else if deviceType == .phone {
                return CGSize(width: 120, height: 80)
            }

        case "season":
            if category.menu_title == "continue watching" {
                if deviceType == .pad {
                    return CGSize(width: 250, height: 140)
                } else if deviceType == .phone {
                    return CGSize(width: 250, height: 120)
                }
            } else {
                if deviceType == .pad {
                    return CGSize(width: 200, height: 300)
                } else if deviceType == .phone {
                    return CGSize(width: 150, height: 250)
                }
            }

        case "promotion":
            if deviceType == .pad {
                return CGSize(width: 250, height: 140)
            } else if deviceType == .phone {
                return CGSize(width: 250, height: 120)
            }

        case "shorts":
            if deviceType == .pad {
                return CGSize(width: 250, height: 140)
            } else if deviceType == .phone {
                return CGSize(width: 250, height: 120)
            }

        case "free":
            if deviceType == .pad {
                return CGSize(width: 250, height: 140)
            } else if deviceType == .phone {
                return CGSize(width: 250, height: 120)
            }

        default:
            let width = (self.view.frame.size.width) / 2.3
            let height = width * 3.5
            print("type:::::", category.type)
            print("width:::::", width)
            if deviceType == .pad {
                return CGSize(width: 250, height: 140)
            } else if deviceType == .phone {
                return CGSize(width: 250, height: 120)
            }
        }

        // Fallback return to handle any unexpected cases
        return CGSize(width: 250, height: 120)


    }
    
    //MARK: - CollectionView Didselect
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if currentUser.result?.id == "163" {
//            let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
//            if sms == "1"{
//                let record = UserDefaults.standard.integer(forKey: "recorddata")
//                    print(record)
//
//                    if record == 1 {
//                    self.dismiss(animated: true) {
//                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "usersuggestionlogin") as! usersuggestionlogin
//                        if #available(iOS 15.0, *) {
//                            if let sheet = vc.sheetPresentationController {
//                                var customDetent: UISheetPresentationController.Detent?
//                                if #available(iOS 16.0, *) {
//                                    customDetent = UISheetPresentationController.Detent.custom { context in
//                                        return 450 // Replace with your desired height
//                                    }
//                                    sheet.detents = [customDetent!]
//                                    sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
//                                }
//                                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                                sheet.prefersGrabberVisible = true
//                                sheet.preferredCornerRadius = 24
//                            }
//                        }
//                        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//                    }
//                }
//                else {
//                    self.dismiss(animated: true) {
//                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "newloginpage") as! newloginpage
//                        if #available(iOS 15.0, *) {
//                            if let sheet = vc.sheetPresentationController {
//                                var customDetent: UISheetPresentationController.Detent?
//                                if #available(iOS 16.0, *) {
//                                    customDetent = UISheetPresentationController.Detent.custom { context in
//                                        return 450 // Replace with your desired height
//                                    }
//                                    sheet.detents = [customDetent!]
//                                    sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
//                                }
//                                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                                sheet.prefersGrabberVisible = true
//                                sheet.preferredCornerRadius = 24
//                            }
//                        }
//                        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//                    }
//                }
//            }else{
//                
//            }
//            
//            
//        }
//        else {
//            chTap = 0
//            let now = Date()
//            let dg = DateFormatter()
//            dg.dateFormat = "yyyy-MM-dd'T'"
//            let dateString = dg.string(from: now)
//            let current = Date()
//            let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
//            let dformat = DateFormatter()
//            dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            var dateform = dformat.string(from: oneHourAgo!)
//            dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
//            exact = exactTime()
//            print(dateform)
//            print(oneHourAgo as Any)
//            print(now) // 2016-12-19 21:52:04 +0000
//            print(dateString)
//            
//            
//            if (UserDefaults.standard.value(forKey: "postDataDeleted") != nil) == true{
//                //            TBYoutubeVideoVC.instance.post : videosResult()
//            }
//            //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
//            NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "didChangeChannel"))
//            TV_PlayerHelper.shared.mmPlayer.player?.pause()
//            TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
//            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
//            
//            TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
//            TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
//            let chanNo = UserDefaults.standard.value(forKey: "channelNumb") as? Int
//            
//            homePlayer.isHidden = true
//            self.isRadioSatsang = false
//            if categoryDataArray[collectionView.tag].type == "channel"{
//                
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TBHomePagerCollectionViewCell", for: indexPath) as! TBHomePagerCollectionViewCell
//                let po = categoryDataArray[collectionView.tag].channelList[indexPath.row]
//                if po.channel_url != ""{
//                    
//                    
//                    self.selectedIndex = indexPath.row
//                    
//                    //                selectedIndex = adIndex
//                    var nDataUrl = ""
//                    if let urlString = po.channel_url {
//                        nDataUrl = "\(urlString)?start=\(dateform)&end="
//                        //                    let url = URL(string: data)
//                    }
//                    //                let url = URL(string: po.channel_url ?? "")
//                    
//                    let url = URL(string: nDataUrl)
//                    if selectedIndex != chanNo {
//                        if chTap > 0 {
//                            
//                            if let playTime = UserDefaults.standard.value(forKey: "playTime") as? Int,
//                               let contentId = UserDefaults.standard.value(forKey: "contentID") as? String {
//                                let total = exact - playTime
//                                let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "3","media_id": contentId,"device_type":"2","video_status": "0","total_play": "\(total)"]
//                                hitPlayTime(playParm)
//                            }
//                            
//                        }else{
//                            chTap += 1
//                        }
//                    }
//                    UserDefaults.standard.set(exact, forKey: "playTime")
//                    UserDefaults.standard.set(po.id, forKey: "contentID")
//                    
//                    playerImage?.sd_setImage(with: URL(string: po.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
//                    playTBbtn.isHidden = true
//                    //|| po.id == "27"
//                    if po.id == "30" {
//                        UserDefaults.standard.setValue(indexPath.row, forKey: "channelPlaying")
//                        playTBbtn.isHidden = false
//                        
//                        homePlayer.isHidden = true
//                        self.isRadioSatsang = true
//                        self.radioChannel = po
//                    }else{
//                        UserDefaults.standard.setValue(indexPath.row, forKey: "channelPlaying")
//                        //       let param : Parameters = ["user_id": currentUser.result?.id ?? "163"]
//                        UserDefaults.standard.setValue(Int(selectedIndex), forKey: "channelNumb")
//                        self.channelUrl = url
//                        
//                        if adMediaArray.count > 0 {
//                            if selectedIndex >= adMediaArray.count {
//                                //        self.selectedIndex = 0
//                                adIndex = 0
//                                self.adURl = adMediaArray[adIndex]
//                                self.skipData = skipValue[adIndex]
//                                
//                            } else {
//                                self.adURl = adMediaArray[adIndex]
//                                self.skipData = skipValue[adIndex]
//                            }
//                            self.adDecreaseCounting(urlStr: adURl)
//                            //                    advertiseApi(param)
//                            
//                            homePlayer.isHidden = false
//                            
//                            
//                        }else{
//                            newTime.invalidate()
//                            homePlayer.isHidden = false
//                            //                                if currentUser.result?.id == "163" {
//                            //                                    let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
//                            //                                    if sms == "1"{
//                            //                                        self.dismiss(animated: true) {
//                            //                                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "newloginpage") as! newloginpage
//                            //                                            if #available(iOS 15.0, *) {
//                            //                                                if let sheet = vc.sheetPresentationController {
//                            //                                                    var customDetent: UISheetPresentationController.Detent?
//                            //                                                    if #available(iOS 16.0, *) {
//                            //                                                        customDetent = UISheetPresentationController.Detent.custom { context in
//                            //                                                            return 450 // Replace with your desired height
//                            //                                                        }
//                            //                                                        sheet.detents = [customDetent!]
//                            //                                                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
//                            //                                                    }
//                            //                                                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                            //                                                    sheet.prefersGrabberVisible = true
//                            //                                                    sheet.preferredCornerRadius = 24
//                            //                                                }
//                            //                                            }
//                            //                                            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//                            //                                        }
//                            //
//                            //                                    }else{
//                            //
//                            //                                    }
//                            //
//                            //                                    chTap = 0
//                            //                                }else{
//                            //                                    if nDataUrl != "" {
//                            //                                        self.playVideo(hlsUrl: nDataUrl)
//                            //                                    }else{
//                            //                                        AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
//                            //                                            if index == 1 {
//                            //                                                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
//                            //                                                self.navigationController?.pushViewController(vc, animated: true)
//                            //                                            }
//                            //                                        }
//                            //                                    }
//                            //
//                            //                                }
//                            
//                        }
//                        
//                    }
//                    post = categoryDataArray[collectionView.tag].channelList[indexPath.row]
//                    UserDefaults.standard.setValue(indexPath.row, forKey: "channelIndex")
//                    //                UserDefaults.standard.setValue(po.name, forKey: "channelName")
//                    
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
//                    
//                    collectionView.reloadData()
//                }else{
//                    AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
//                        if index == 1 {
//                            let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                }
//            }
//            else if categoryDataArray[collectionView.tag].type == "bhajan"{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                UserDefaults.standard.setValue(true, forKey: "bhajanCountBool")
//                let post = categoryDataArray[collectionView.tag].bhajanList[indexPath.row]
//                //                homeAllDataArray.bhajan![0].audio![indexPath.row]
//                MusicPlayerManager.shared.song_no = indexPath.row
//                MusicPlayerManager.shared.Bhajan_Track = categoryDataArray[collectionView.tag].bhajanList
//                MusicPlayerManager.shared.isDownloadedSong = false
//                MusicPlayerManager.shared.isPlayList = false
//                MusicPlayerManager.shared.isRadioSatsang = false
//                let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//                //            self.navigationController?.pushViewController(vc, animated: true)
//                self.present(vc, animated: true, completion: nil)
//                MusicPlayerManager.shared.PlayURl(url: post.media_file!)
//            }
//            else if categoryDataArray[collectionView.tag].type == "news"{
//                let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
//                NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
//                newsArray = categoryDataArray[collectionView.tag].newList[indexPath.row]
//                vc.dataToShow = newsArray
//                vc.delegate = self
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            else if categoryDataArray[collectionView.tag].type == "trending video"{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                let post = categoryDataArray[collectionView.tag].trendingVideoList[indexPath.row]
//                let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
//                videoType = 1 //Normal Video
//                if post.youtube_url != ""{
//                    recentViewHit(param)
//                    let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
//                    vc.songNo = indexPath.row
//                    //                vc.trendingString = "trending video"
//                    //                vc.videosArr =  categoryDataArray[collectionView.tag].trendingVideoList
//                    vc.menuMasterId = categoryDataArray[collectionView.tag].id
//                    vc.post = post
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }else{
//                    AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
//                        if index == 1 {
//                            let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                }
//            }
//            else if categoryDataArray[collectionView.tag].type == "trending bhajan"{
//                let post = categoryDataArray[collectionView.tag].trendingBhajanList[indexPath.row]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                UserDefaults.standard.setValue(true, forKey: "bhajanCountBool")
//                MusicPlayerManager.shared.song_no = indexPath.row
//                MusicPlayerManager.shared.trendingBhajanString = "trending bhajan"
//                MusicPlayerManager.shared.Bhajan_Track_Trending = categoryDataArray[collectionView.tag].trendingBhajanList
//                MusicPlayerManager.shared.isDownloadedSong = false
//                MusicPlayerManager.shared.isPlayList = false
//                MusicPlayerManager.shared.isRadioSatsang = false
//                let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//                //            self.navigationController?.pushViewController(vc, animated: true)
//                self.present(vc, animated: true, completion: nil)
//                
//                MusicPlayerManager.shared.PlayURl(url: post.media_file)
//            }
//            else if categoryDataArray[collectionView.tag].type == "video"{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                let post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
//                let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
//                videoType = 1 //Normal Video
//                
//                if post.youtube_url != ""{
//                    recentViewHit(param)
//                    let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
//                    vc.songNo = indexPath.row
//                    vc.menuMasterId = categoryDataArray[collectionView.tag].id
//                    //                vc.videosArr = categoryDataArray[collectionView.tag].videoList
//                    vc.post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
//                    
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                }else{
//                    AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
//                        if index == 1 {
//                            let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                }
//            }
//            else if categoryDataArray[collectionView.tag].type == "guru"{
//                let post = categoryDataArray[collectionView.tag].guruList[indexPath.row]
//                //                homeAllDataArray.guru![indexPath.row]
//                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KGRURDETAILVC) as! TBGuruDetailVC
//                vc.previoueData = post
//                vc.delegate = self
//                vc.menuMasterId = categoryDataArray[collectionView.tag].id
//                navigationController?.pushViewController(vc, animated: true)
//                
//                
//            }
//            else if categoryDataArray[collectionView.tag].type == "free"{
//                videoType = 2 //Premium Video
//                let post = categoryDataArray[collectionView.tag].freeList[indexPath.row]
//                //                homeAllDataArray.guru![indexPath.row]
//                let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//                
//                vc.selectedData = post
//                vc.selectedString = "free"
//                type = "free"
//                
//                //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//                //            vc.delegate = self
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            
//            else if categoryDataArray[collectionView.tag].type == "shorts"{
//                videoType = 2 //Premium Video
//                let post = categoryDataArray[collectionView.tag].shortslist[indexPath.row].id
//                //                homeAllDataArray.guru![indexPath.row]
//                let vc = storyBoard.instantiateViewController(withIdentifier: "TBshortsVC") as! TBshortsVC
//                
//                vc.deeplinkshortid = post
//                
//                
//                //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//                //            vc.delegate = self
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            
//            else if categoryDataArray[collectionView.tag].type == "promotion"{
//                videoType = 2 //Premium Video
//                
//                let post = categoryDataArray[collectionView.tag].promotionList[indexPath.row]
//                
//                let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//                vc.selectedData = post
//                vc.selectedString = "promotion"
//                type = "promotion"
//                
//                //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//                //            vc.delegate = self
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            
//            // comment by avi tyagi
//            //                else if categoryDataArray[collectionView.tag].type == "season"{
//            //                    videoType = 2 //Premium Video
//            //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//            //                    let post = categoryDataArray[collectionView.tag].seasonList[indexPath.row]
//            //                    let remove = categoryDataArray[collectionView.tag].seasonList.remove(at: indexPath.row)
//            //                    let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//            //                    vc.selectedData = post
//            //                    vc.selectedString = "season"
//            //                    type = "season"
//            //
//            //                    //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//            //                    //            vc.delegate = self
//            //                    navigationController?.pushViewController(vc, animated: true)
//            //                }
//            
//            else if categoryDataArray[collectionView.tag].type == "season" {
//                videoType = 2 // Premium Video
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                
//                let selectedIndexPath = indexPath
//                guard selectedIndexPath.row < categoryDataArray[collectionView.tag].seasonList.count else {
//                    // Handle the case where the index is out of range (e.g., show an error message)
//                    print("Index out of range")
//                    return
//                }
//                
//                let post = categoryDataArray[collectionView.tag].seasonList[selectedIndexPath.row]
//                categoryDataArray[collectionView.tag].seasonList.remove(at: selectedIndexPath.row)
//                
//                let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//                vc.selectedData = post
//                vc.selectedString = "season"
//                type = "season"
//                
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            
//            //
//            else if categoryDataArray[collectionView.tag].type == "author wise season"{
//                videoType = 2 //Premium Video
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                let post = categoryDataArray[collectionView.tag].authwise[indexPath.row]
//                let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//                vc.selectedData = post
//                vc.selectedString = "author wise season"
//                type = "author wise season"
//                
//                //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//                //            vc.delegate = self
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            else if categoryDataArray[collectionView.tag].type == "category wise season"{
//                videoType = 2 //Premium Video
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                let post = categoryDataArray[collectionView.tag].catwise[indexPath.row]
//                let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//                vc.selectedData = post
//                vc.selectedString = "category wise season"
//                type = "category wise season"
//                
//                //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//                //            vc.delegate = self
//                navigationController?.pushViewController(vc, animated: true)
//            }
//            
//            else if categoryDataArray[collectionView.tag].type == "continue watching"{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                //            videoType = 2 //Premium Video
//                //
//                //            let post = categoryDataArray[collectionView.tag].freeList[indexPath.row]
//                //            //                homeAllDataArray.guru![indexPath.row]
//                //            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPremiumDetailVC) as! TBPremiumDetailVc
//                //            vc.selectedData = post
//                //            vc.selectedString = "free"
//                //            type = "free"
//                //
//                ////            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//                //            //            vc.delegate = self
//                //            navigationController?.pushViewController(vc, animated: true)
//                
//                let post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
//                if post.type == "1"{ //Normal Video
//                    
//                    let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
//                    videoType = 1 //Normal Video
//                    
//                    if post.youtube_url != ""{
//                        recentViewHit(param)
//                        let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
//                        vc.songNo = indexPath.row
//                        //                    vc.videosArr = categoryDataArray[collectionView.tag].videoList
//                        vc.post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
//                        print(vc.post)
//                        self.navigationController?.pushViewController(vc, animated: true)
//                        
//                    }
//                }
//                else{
//                    videoType = 2 //Premium Video
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                    let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
//                    
//                    if post.yt_episode_url != ""{
//                        recentViewHit(param)
//                        let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
//                        vc.songNo = indexPath.row
//                        vc.videosArr = categoryDataArray[collectionView.tag].videoList
//                        //                    vc.post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
//                        self.navigationController?.pushViewController(vc, animated: true)
//                        
//                    }
//                    
//                }
//            }
//            else{
//                
//                
//                
//            }
//            
//            //            switch collectionView.tag {
//            
//            //
//            //            case 1://guru
//            //
//            //                let post = homeAllDataArray.guru![indexPath.row]
//            //                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KGRURDETAILVC) as! TBGuruDetailVC
//            //                vc.previoueData = post
//            //                vc.delegate = self
//            //                navigationController?.pushViewController(vc, animated: true)
//            //
//            //            case 2://bhajan
//            //
//            //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//            //
//            //                let post = homeAllDataArray.bhajan![0].audio![indexPath.row]
//            //                MusicPlayerManager.shared.song_no = indexPath.row
//            //                MusicPlayerManager.shared.Bhajan_Track = homeAllDataArray.bhajan![0].audio!
//            //                MusicPlayerManager.shared.isDownloadedSong = false
//            //                MusicPlayerManager.shared.isPlayList = false
//            //
//            //                let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//            //                self.navigationController?.pushViewController(vc, animated: true)
//            //
//            //                MusicPlayerManager.shared.PlayURl(url: post.media_file!)
//            //
//            //
//            //            case 3://newz
//            //                let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
//            //                NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
//            //                vc.dataToShow = homeAllDataArray.news![indexPath.row]
//            //                vc.delegate = self
//            //                navigationController?.pushViewController(vc, animated: true)
//            //
//            
//            //                return
//            //
//            //            default:
//            //                break
//            //            }
//            //
//            
//            
//        }
//        
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
                let now = Date()
                 let dg = DateFormatter()
                dg.dateFormat = "yyyy-MM-dd'T'"
                let dateString = dg.string(from: now)
                let current = Date()
                let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
                let dformat = DateFormatter()
                dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                var dateform = dformat.string(from: oneHourAgo!)
                dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                exact = exactTime()
                print(dateform)
                print(oneHourAgo as Any)
                print(now) // 2016-12-19 21:52:04 +0000
                print(dateString)
        
                
                if (UserDefaults.standard.value(forKey: "postDataDeleted") != nil) == true{
                    //            TBYoutubeVideoVC.instance.post : videosResult()
                }
                //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
                NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "didChangeChannel"))
                TV_PlayerHelper.shared.mmPlayer.player?.pause()
                TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
                TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)
        
                TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
                TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
                let chanNo = UserDefaults.standard.value(forKey: "channelNumb") as? Int
                
                homePlayer.isHidden = true
                self.isRadioSatsang = false
                if categoryDataArray[collectionView.tag].type == "channel"{
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TBHomePagerCollectionViewCell", for: indexPath) as! TBHomePagerCollectionViewCell
                    let po = categoryDataArray[collectionView.tag].channelList[indexPath.row]
                    
                    if po.channel_url != ""{
                        
                        
                        
                        self.selectedIndex = indexPath.row
                        
                        //                selectedIndex = adIndex
                        var nDataUrl = ""
                        if let urlString = po.channel_url {
                            nDataUrl = "\(urlString)?start=\(dateform)&end="
                            //                    let url = URL(string: data)
                        }
                        //                let url = URL(string: po.channel_url ?? "")
                        
                        let url = URL(string: nDataUrl)
                        if selectedIndex != chanNo {
                            if chTap > 0 {
                               
                                if let playTime = UserDefaults.standard.value(forKey: "playTime") as? Int,
                                   let contentId = UserDefaults.standard.value(forKey: "contentID") as? String {
                                    let total = exact - playTime
                                    let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "3","media_id": contentId,"device_type":"2","video_status": "0","total_play": "\(total)"]
                                    hitPlayTime(playParm)
                                }

                            }else{
                                chTap += 1
                            }
                        }
                        UserDefaults.standard.set(exact, forKey: "playTime")
                        UserDefaults.standard.set(po.id, forKey: "contentID")
                        
                        playerImage?.sd_setImage(with: URL(string: po.image ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                        playTBbtn.isHidden = true
                        //|| po.id == "27"
                        if po.id == "30" {
                            UserDefaults.standard.setValue(indexPath.row, forKey: "channelPlaying")
                            playTBbtn.isHidden = false
                            
                            homePlayer.isHidden = true
                            self.isRadioSatsang = true
                            self.radioChannel = po
                        }else{
                            UserDefaults.standard.setValue(indexPath.row, forKey: "channelPlaying")
                            //       let param : Parameters = ["user_id": currentUser.result?.id ?? "163"]
                            UserDefaults.standard.setValue(Int(selectedIndex), forKey: "channelNumb")
                            self.channelUrl = url
                            
                            if adMediaArray.count > 0 {
                                if selectedIndex >= adMediaArray.count {
                                    //        self.selectedIndex = 0
                                    adIndex = 0
                                    self.adURl = adMediaArray[adIndex]
                                    self.skipData = skipValue[adIndex]
                                    
                                } else {
                                    self.adURl = adMediaArray[adIndex]
                                    self.skipData = skipValue[adIndex]
                                }
                                self.adDecreaseCounting(urlStr: adURl)
                                //                    advertiseApi(param)
                                
                                homePlayer.isHidden = false
                                
                                
                            }else{
                                newTime.invalidate()
                                homePlayer.isHidden = false
                                if currentUser.result?.id == "163" {
                                    let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                                    if sms == "1" {
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
                                                    }

                                    
                                    else{
                                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                                        navigationController?.pushViewController(vc, animated: true)
                                    }
                                    
                                    chTap = 0
                                }
                                else{
                                    if nDataUrl != "" {
                                        self.playVideo(hlsUrl: nDataUrl)
                                    }else{
                                        AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                                            if index == 1 {
                                                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                        }
                                    }
                                    
                                }
                          
                            }
                      
                        }
                        post = categoryDataArray[collectionView.tag].channelList[indexPath.row]
                        UserDefaults.standard.setValue(indexPath.row, forKey: "channelIndex")
                        //                UserDefaults.standard.setValue(po.name, forKey: "channelName")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
                        
                        collectionView.reloadData()
                    }else{
                        AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                            if index == 1 {
                                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
                else if categoryDataArray[collectionView.tag].type == "bhajan"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    UserDefaults.standard.setValue(true, forKey: "bhajanCountBool")
                    let post = categoryDataArray[collectionView.tag].bhajanList[indexPath.row]
                    //                homeAllDataArray.bhajan![0].audio![indexPath.row]
                    MusicPlayerManager.shared.song_no = indexPath.row
                    MusicPlayerManager.shared.Bhajan_Track = categoryDataArray[collectionView.tag].bhajanList
                    MusicPlayerManager.shared.isDownloadedSong = false
                    MusicPlayerManager.shared.isPlayList = false
                    MusicPlayerManager.shared.isRadioSatsang = false
                    let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
                    //            self.navigationController?.pushViewController(vc, animated: true)
                    self.present(vc, animated: true, completion: nil)
                    MusicPlayerManager.shared.PlayURl(url: post.media_file!)
                }
                else if categoryDataArray[collectionView.tag].type == "news"{
                    let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
                    NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
                    newsArray = categoryDataArray[collectionView.tag].newList[indexPath.row]
                    vc.dataToShow = newsArray
                    vc.delegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
                else if categoryDataArray[collectionView.tag].type == "trending video"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    let post = categoryDataArray[collectionView.tag].trendingVideoList[indexPath.row]
                    let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
                    videoType = 1 //Normal Video
                    if post.youtube_url != ""{
                        recentViewHit(param)
                        let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                        vc.songNo = indexPath.row
                        //                vc.trendingString = "trending video"
                        //                vc.videosArr =  categoryDataArray[collectionView.tag].trendingVideoList
                        vc.menuMasterId = categoryDataArray[collectionView.tag].id
                        vc.post = post
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                            if index == 1 {
                                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
                else if categoryDataArray[collectionView.tag].type == "trending bhajan"{
                    let post = categoryDataArray[collectionView.tag].trendingBhajanList[indexPath.row]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    UserDefaults.standard.setValue(true, forKey: "bhajanCountBool")
                    MusicPlayerManager.shared.song_no = indexPath.row
                    MusicPlayerManager.shared.trendingBhajanString = "trending bhajan"
                    MusicPlayerManager.shared.Bhajan_Track_Trending = categoryDataArray[collectionView.tag].trendingBhajanList
                    MusicPlayerManager.shared.isDownloadedSong = false
                    MusicPlayerManager.shared.isPlayList = false
                    MusicPlayerManager.shared.isRadioSatsang = false
                    let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
                    //            self.navigationController?.pushViewController(vc, animated: true)
                    self.present(vc, animated: true, completion: nil)
                    
                    MusicPlayerManager.shared.PlayURl(url: post.media_file)
                }
                else if categoryDataArray[collectionView.tag].type == "video"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    let post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
                    let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
                    videoType = 1 //Normal Video
                    
                    if post.youtube_url != ""{
                        recentViewHit(param)
                        let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                        vc.songNo = indexPath.row
                        vc.menuMasterId = categoryDataArray[collectionView.tag].id
                        //                vc.videosArr = categoryDataArray[collectionView.tag].videoList
                        vc.post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        AlertController.alert(title: "Subscription", message: "Please purchase Premium to play video/Live TV", buttons: ["Cancel","Go Premium"]) { result, index in
                            if index == 1 {
                                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }else if categoryDataArray[collectionView.tag].type == "live darshan" {
                    if  categoryDataArray[collectionView.tag].liveDarshanList[indexPath.row].video_type == "0" {
                        

                    } else {
                        if let vc = storyBoardNew.instantiateViewController(withIdentifier: CONTROLLERNAMES.KLiveDarshanViewController) as? LiveDarshanViewController {
                            let post = categoryDataArray[collectionView.tag].liveDarshanList[indexPath.row].video_url
                            vc.darshanList = post ?? ""
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                else if categoryDataArray[collectionView.tag].type == "guru"{
                    let post = categoryDataArray[collectionView.tag].guruList[indexPath.row]
                    //                homeAllDataArray.guru![indexPath.row]
                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KGRURDETAILVC) as! TBGuruDetailVC
                    vc.previoueData = post
                    vc.delegate = self
                    vc.menuMasterId = categoryDataArray[collectionView.tag].id
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
                else if categoryDataArray[collectionView.tag].type == "free"{
                    videoType = 2 //Premium Video
                    let post = categoryDataArray[collectionView.tag].freeList[indexPath.row]
                    //                homeAllDataArray.guru![indexPath.row]
                    let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
                   
                    vc.selectedData = post
                    vc.selectedString = "free"
                    type = "free"
                    
                    //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
                    //            vc.delegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
        
        else if categoryDataArray[collectionView.tag].type == "shorts"{
            videoType = 2 //Premium Video
            let post = categoryDataArray[collectionView.tag].shortslist[indexPath.row].id
            //                homeAllDataArray.guru![indexPath.row]
            let vc = storyBoard.instantiateViewController(withIdentifier: "TBshortsVC") as! TBshortsVC
           
            vc.deeplinkshortid = post
            
            //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
            //            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
                
                else if categoryDataArray[collectionView.tag].type == "promotion"{
                    videoType = 2 //Premium Video
                    
                    let post = categoryDataArray[collectionView.tag].promotionList[indexPath.row]
                    
                    let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
                    vc.selectedData = post
                    vc.selectedString = "promotion"
                    type = "promotion"
                    
                    //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
                    //            vc.delegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
        
        // comment by avi tyagi
//                else if categoryDataArray[collectionView.tag].type == "season"{
//                    videoType = 2 //Premium Video
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
//                    let post = categoryDataArray[collectionView.tag].seasonList[indexPath.row]
//                    let remove = categoryDataArray[collectionView.tag].seasonList.remove(at: indexPath.row)
//                    let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//                    vc.selectedData = post
//                    vc.selectedString = "season"
//                    type = "season"
//
//                    //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
//                    //            vc.delegate = self
//                    navigationController?.pushViewController(vc, animated: true)
//                }
        
        else if categoryDataArray[collectionView.tag].type == "season" {
            
            
            if currentUser.result?.id == "163" {
                let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                if sms == "1" {
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
                                }

                else{
                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                    navigationController?.pushViewController(vc, animated: true)
                }
                
                chTap = 0
            }
            else {
                
                
                videoType = 2 // Premium Video
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                
                let selectedIndexPath = indexPath
                guard selectedIndexPath.row < categoryDataArray[collectionView.tag].seasonList.count else {
                    // Handle the case where the index is out of range (e.g., show an error message)
                    print("Index out of range")
                    return
                }
                
                let post = categoryDataArray[collectionView.tag].seasonList[selectedIndexPath.row]
                categoryDataArray[collectionView.tag].seasonList.remove(at: selectedIndexPath.row)
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
                vc.selectedData = post
                vc.selectedString = "season"
                type = "season"
                
                navigationController?.pushViewController(vc, animated: true)
            }
        }

//
                else if categoryDataArray[collectionView.tag].type == "author wise season"{
                    videoType = 2 //Premium Video
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    let post = categoryDataArray[collectionView.tag].authwise[indexPath.row]
                    let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
                    vc.selectedData = post
                    vc.selectedString = "author wise season"
                    type = "author wise season"
                    
                    //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
                    //            vc.delegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
                else if categoryDataArray[collectionView.tag].type == "category wise season"{
                    videoType = 2 //Premium Video
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    let post = categoryDataArray[collectionView.tag].catwise[indexPath.row]
                    let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
                    vc.selectedData = post
                    vc.selectedString = "category wise season"
                    type = "category wise season"
                    
                    //            vc.premiumData = categoryDataArray[collectionView.tag].freeList
                    //            vc.delegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
                
                else if categoryDataArray[collectionView.tag].type == "continue watching"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                    //            videoType = 2 //Premium Video
                    //
                    //            let post = categoryDataArray[collectionView.tag].freeList[indexPath.row]
                    //            //                homeAllDataArray.guru![indexPath.row]
                    //            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPremiumDetailVC) as! TBPremiumDetailVc
                    //            vc.selectedData = post
                    //            vc.selectedString = "free"
                    //            type = "free"
                    //
                    ////            vc.premiumData = categoryDataArray[collectionView.tag].freeList
                    //            //            vc.delegate = self
                    //            navigationController?.pushViewController(vc, animated: true)
                    
                    let post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
                    if post.type == "1"{ //Normal Video
                        
                        let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
                        videoType = 1 //Normal Video
                        
                        if post.youtube_url != ""{
                            recentViewHit(param)
                            let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                            vc.songNo = indexPath.row
                            //                    vc.videosArr = categoryDataArray[collectionView.tag].videoList
                            vc.post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
                            print(vc.post)
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                    else{
                        videoType = 2 //Premium Video
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                        let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
                        
                        if post.yt_episode_url != ""{
                            recentViewHit(param)
                            let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                            vc.songNo = indexPath.row
                            vc.videosArr = categoryDataArray[collectionView.tag].videoList
                            //                    vc.post = categoryDataArray[collectionView.tag].videoList[indexPath.row]
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                    }
                }
                else{
                    
                    
                    
                }
                
                //            switch collectionView.tag {
                
                //
                //            case 1://guru
                //
                //                let post = homeAllDataArray.guru![indexPath.row]
                //                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KGRURDETAILVC) as! TBGuruDetailVC
                //                vc.previoueData = post
                //                vc.delegate = self
                //                navigationController?.pushViewController(vc, animated: true)
                //
                //            case 2://bhajan
                //
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                //
                //                let post = homeAllDataArray.bhajan![0].audio![indexPath.row]
                //                MusicPlayerManager.shared.song_no = indexPath.row
                //                MusicPlayerManager.shared.Bhajan_Track = homeAllDataArray.bhajan![0].audio!
                //                MusicPlayerManager.shared.isDownloadedSong = false
                //                MusicPlayerManager.shared.isPlayList = false
                //
                //                let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
                //                self.navigationController?.pushViewController(vc, animated: true)
                //
                //                MusicPlayerManager.shared.PlayURl(url: post.media_file!)
                //
                //
                //            case 3://newz
                //                let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
                //                NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
                //                vc.dataToShow = homeAllDataArray.news![indexPath.row]
                //                vc.delegate = self
                //                navigationController?.pushViewController(vc, animated: true)
                //
                
                //                return
                //
                //            default:
                //                break
                //            }
                //
                
            
        
        
    }
    
    
}

//MARK:- UITableView DataSourse.
extension TBHomeVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  categoryDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberof rows hit")
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if categoryDataArray[indexPath.section].type == "bhajan"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "news"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "video"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }else if categoryDataArray[indexPath.section].type == "live darshan" {
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
        }
       
        else if categoryDataArray[indexPath.section].type == "guru"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "channel"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "channel", for: indexPath) as! TBHomeTableViewCell
            cell.channelCollectionView.tag = indexPath.section
            cell.channelCollectionView.delegate = self
            cell.channelCollectionView.dataSource = self
            cell.channelCollectionView.reloadData()
            cell.channelCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "season"{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCell", for: indexPath) as? TBHomeTableViewCell else{
                return UITableViewCell()
            }
            cell.premiumCollectionView.tag = indexPath.section
            cell.premiumCollectionView.delegate = self
            cell.premiumCollectionView.dataSource = self
            cell.premiumCollectionView.reloadData()
            cell.premiumCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        
        else if categoryDataArray[indexPath.section].type == "promotion"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCell", for: indexPath) as! TBHomeTableViewCell
            cell.premiumCollectionView.tag = indexPath.section
            cell.premiumCollectionView.delegate = self
            cell.premiumCollectionView.dataSource = self
            cell.premiumCollectionView.reloadData()
            cell.premiumCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "shorts"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "free"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
            
            
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCell", for: indexPath) as! TBHomeTableViewCell
            //            cell.premiumCollectionView.tag = indexPath.section
            //            cell.premiumCollectionView.delegate = self
            //            cell.premiumCollectionView.dataSource = self
            //            cell.premiumCollectionView.reloadData()
            //            cell.premiumCollectionView.collectionViewLayout.invalidateLayout()
            //            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "trending video"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "trending bhajan"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "continue watching"{
            let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBHomeTableViewCell
            cell.dataCollectionView.tag = indexPath.section
            cell.dataCollectionView.delegate = self
            cell.dataCollectionView.dataSource = self
            cell.dataCollectionView.reloadData()
            cell.dataCollectionView.collectionViewLayout.invalidateLayout()
            return cell
        }else if categoryDataArray[indexPath.section].type == "author wise season" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCell", for: indexPath) as! TBHomeTableViewCell
            cell.premiumCollectionView.tag = indexPath.section
            cell.premiumCollectionView.delegate = self
            cell.premiumCollectionView.dataSource = self
            cell.premiumCollectionView.reloadData()
            cell.premiumCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }else if categoryDataArray[indexPath.section].type == "category wise season" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCell", for: indexPath) as! TBHomeTableViewCell
            cell.premiumCollectionView.tag = indexPath.section
            cell.premiumCollectionView.delegate = self
            cell.premiumCollectionView.dataSource = self
            cell.premiumCollectionView.reloadData()
            cell.premiumCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else if categoryDataArray[indexPath.section].type == "More Eposide" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCell", for: indexPath) as! TBHomeTableViewCell
            cell.premiumCollectionView.tag = indexPath.section
            cell.premiumCollectionView.delegate = self
            cell.premiumCollectionView.dataSource = self
            cell.premiumCollectionView.reloadData()
            cell.premiumCollectionView.collectionViewLayout.invalidateLayout()
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dummyCell", for: indexPath)
            return cell
        }
    }
    
}

//MARK:- UITableView Delegates..
extension TBHomeVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if categoryDataArray[section].type == "guru" || categoryDataArray[section].type == "news"{
            return 50
        }
        else if categoryDataArray[section].type == "channel"{
            return 50
        }
        else{
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
        //        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL2) as! TBHeaderTableViewCell
        cell.headerBtn.tag = section
        let titleLbl = cell.viewWithTag(100) as! UILabel
        
        if categoryDataArray[section].type == "continue watching"{
            let seeMoreLbl = cell.viewWithTag(1) as! UILabel
            let seeMoreImg = cell.viewWithTag(2) as! UIImageView
            
            seeMoreLbl.isHidden = true
            seeMoreImg.isHidden = true
        }
        titleLbl.text = categoryDataArray[section].menu_title.capitalizingFirstLetter()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = categoryDataArray[indexPath.section].type
        let menutitle = categoryDataArray[indexPath.section].menu_title
        let deviceType = UIDevice.current.userInterfaceIdiom

        if type == "channel" {
            if deviceType == .pad {
                return 100
            } else if deviceType == .phone {
                return 80
            }
        }

        if type == "season" || type == "promotion" {
            if menutitle == "continue watching" {
                if deviceType == .pad {
                    return 150 // You can adjust this height for iPad if needed
                } else if deviceType == .phone {
                    return 126
                }
            } else {
                if deviceType == .pad {
                    return 300 // Adjust for iPad if necessary
                } else if deviceType == .phone {
                    return 250
                }
            }
        }

        // Default case to handle all other types
        if deviceType == .pad {
            return 150 // Adjust this default value for iPad if needed
        } else if deviceType == .phone {
            return 126
        }

        // Fallback return value
        return 126
    }

}

//MARK:- searchBar Delegate Methods.
extension TBHomeVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            searchBar.text = nil
            searchBar.endEditing(true)
            self.view.endEditing(true)
            searchClicked = false
            searchText = ""
            refresh()
            
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchClicked == true {
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
            searchClicked = false
            searchText = ""
            refresh()
        }else {
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchText = searchBar.text!
        let param : Parameters
        if searchBar.text != "" {
            param  = ["user_id": currentUser.result!.id! , "keyword":searchBar.text!]
            searchApiHome(param: param)
        }
        
    }
}

//MARK:- UITableView delegates Methods.
extension TBHomeVC : TBGuruDetailVCDelegates {
    func updateValue(_ data: guruData) {
        if let updateId = data.id {
            let tempArr = NSMutableArray(array : homeAllDataArray.guru!)
            
            if let replacedData = tempArr.filter({ (result) -> Bool in
                return ((result as! guruData).id == updateId)
            }).first {
                let index = tempArr.index(of: replacedData)
                tempArr.replaceObject(at: index, with: data)
                homeAllDataArray.guru = tempArr as? [guruData]
            }
            
        }
    }
}
//MARK:- updateData Delegate Methods.
extension TBHomeVC : TBNewsdeletilVCdelegates {
    func dataUpdate(_ data: News) {
        if let updateId = data.id {
            let tempArr = NSMutableArray(array : [newsArray])
            if  let replacedData = tempArr.filter({(result) -> Bool in
                return ((result as! News).id == updateId)
            }).first {
                let index = tempArr.index(of: replacedData)
                tempArr.replaceObject(at: index, with: data)
                //                categoryDataArray[2].newList = tempArr as? [News] ?? []
                //                self.dataCollectionView0.reloadData()
            }
        }
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
/*
 {
 
 
 //                    guard let web_view_bhajan = JSON["web_view_bhajan"],
 //                          let web_view_news = JSON["web_view_news"],
 //                          let web_view_video = JSON["web_view_video"]
 //                    else {return}
 //
 //                    UserDefaults.standard.setValue(web_view_bhajan, forKey: "web_view_bhajan")
 //                    UserDefaults.standard.setValue(web_view_news, forKey: "web_view_news")
 //                    UserDefaults.standard.setValue(web_view_video, forKey: "web_view_video")
 
 let data = JSON.ArrayofDict("data")
 
 _ = data.filter({ (dict) -> Bool in
 
 let list = dict.ArrayofDict("list")
 if list.count == 0{
 
 }else{
 self.categoryDataArray.append(CategoryModel(dict: dict))
 }
 return true
 })
 //                    self.tableView.reloadData()
 if self.pullToRefreshOn == true {
 self.pullToRefreshOn = false
 }
 self.tableView.reloadData()
 
 }
 */
extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""
    
    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)B"
        
    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)M"
        
    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)K"
        
    case 0...:
        return "\(n)"
        
    default:
        return "\(sign)\(n)"
    }
}
