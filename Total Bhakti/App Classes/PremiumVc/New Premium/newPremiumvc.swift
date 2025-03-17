//
//  newPremiumvc.swift
//  Sanskar
//
//  Created by Warln on 04/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import MMPlayerView
import YoutubePlayer_in_WKWebView
import GoogleMobileAds

class newPremiumvc: TBInternetViewController, WKYTPlayerViewDelegate,FullScreenContentDelegate {
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var sliderCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pagerView: UIPageControl!
    @IBOutlet weak var searchHolder: UIView!
    @IBOutlet weak var barCodeBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notificationLbl: UILabel!
    
    @IBOutlet weak var premiumbannerheight: NSLayoutConstraint!
    @IBOutlet weak var pagerviewheight: NSLayoutConstraint!
    
    //MARK: Variable
    var videoArr = [[String:Any]]()
    var sliderImgData: [String] = []
    var sliderimgid:[[String:Any]] = [[:]]
    var premiumDataArr: [[String:Any]] = [[:]]
    var refreshControl: UIRefreshControl!
    var pullToRefreshOn = false
    let adUnitID = "ca-app-pub-1618767157139570/5766265057"
    var rewardedAd: RewardedAd?
   
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            premiumbannerheight.constant = 300
            pagerviewheight.constant = 200
               } else {
                   premiumbannerheight.constant = 200
               }
        
        
        notificationLbl.layer.cornerRadius = notificationLbl.frame.size.width / 2
        notificationLbl.clipsToBounds = true
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notificationLbl.text = String(notification_counter)
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","device_id": "\(device_id ?? "")"]
        hitPremiumData(param)
//        searchHolder.isHidden = true
//        notificationLbl.layer.cornerRadius = notificationLbl.layer.bounds.width/2
//        notificationLbl.clipsToBounds = true
        prePum = "premium"
//        if qrStatus == "0"{
//            if #available(iOS 13.0, *) {
//                barCodeBtn.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
//            } else {
//                // Fallback on earlier versions
//            }
//            searchBtn.isHidden = true
//        }else{
//            searchBtn.isHidden = false
//        }
        self.showadsinios()
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successfullPayment(notification:)), name: Notification.Name("paymentDone"), object: nil)
        liveTap = ""
//        prePum = "premium"
    }
    
    
    
    
    func loadAndShowRewardedAd() {
        RewardedAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
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
               ad.present(from: self) {
                   let reward = ad.adReward
                   print("User earned reward of \(reward.amount) \(reward.type).")
               }
           } else {
               print("Ad wasn't ready.")
               loadAndShowRewardedAd()
           }
       }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
           print("Ad did fail to present full screen content with error: \(error.localizedDescription)")
           loadAndShowRewardedAd()
       }

//    func adDidPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
//            print("Ad is presented.")
//        }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
            print("Ad dismissed. Reloading new ad...")
          //  loadRewardedAd() // Reload new ad after dismissal
            DispatchQueue.main.async {
                self.presentAlert()
            }
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
        
        func showPremiumPage() {
            // Assuming "PremiumViewController" is the identifier for your premium page view controller in the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let premiumVC = storyboard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as? TBPremiumPaymentVC {
                self.navigationController?.pushViewController(premiumVC, animated: true)
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
    
//MARK: Api Method.
    
    func hitPremiumData(_ param : Parameters){
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodData1(APIManager.sharedInstance.KPREMIUMAPI, param) { response in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            self.sliderImgData.removeAll()
            self.videoArr.removeAll()
            self.premiumDataArr.removeAll()
            if let JSON = response as?  [String: Any]{
                print(JSON)
                if JSON["status"] as? Bool == true {
                    self.sliderImgData.append(contentsOf: JSON["season_thumbnails"] as? [String] ?? [])
                    if let promoIds = JSON["season_promo_id"] as? [[String: Any]] {
                        print(promoIds)
                        self.sliderimgid = promoIds
                        print(self.sliderimgid)
                        // Accessing each dictionary in the array
//                        for promoId in promoIds {
//                            // Accessing the value of "season_id" key for each dictionary
//                            if let seasonId = promoId["season_id"] as? String {
//                                print(seasonId)
//
//                            }
//                        }
                    } else {
                        print("Warning: JSON['season_promo_id'] is nil or not of type [String: Any], defaulting to an empty dictionary")
                    }
                    self.videoArr.append(contentsOf: JSON["season_promo_videos"] as? [[String:Any]] ?? [[:]])
                    self.premiumDataArr.append(contentsOf: JSON["data"] as? [[String:Any]] ?? [[:]])
                }else{
                    self.addAlert(ALERTS.KERROR, message: ALERTS.KERROR.debugDescription, buttonTitle: ALERTS.kAlertOK)
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    self.sliderCollection.reloadData()
                    self.tableView.reloadData()
                }
                self.sliderCollection.reloadData()
                if self.pullToRefreshOn == true {
                    self.pullToRefreshOn = false
                }
                self.sliderCollection.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    
//MARK: IBAction for button
    
    @objc func successfullPayment(notification: Notification) {
        if ((notification.userInfo?["Bool"]) != nil) == true{
            print("payment Done")
            let params = ["user_id":currentUser.result!.id!]
            hitPremiumData(params)
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBViewController") as! TBViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func barCodeBtnPressed(_ sender: UIButton){
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
                searchHolder.isHidden = false
                searchHolder.backgroundColor = .white
            }
        }
    }
    
    @IBAction func sharebtn(_ sender: UIButton) {
        let text = "https://sanskargroup.page.link/"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func sideBarBtn(_ sender: UIButton){
        slideMenuController()?.openLeft()
    }
    
    @IBAction func notificationBtn(_ sender: UIButton){
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tableheader(_ sender: UIButton){
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
            print("sender.tag::::\(sender.tag)\((premiumDataArr[sender.tag] as [String:Any] )["cat_name"] as? String ?? "")")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumEpisodeFree") as! TBPremiumEpisodeFree
            isComeFrom = 1
            let heading = ((premiumDataArr[sender.tag] as [String:Any] )["cat_name"] as? String ?? "")
            vc.headingSting = heading.capitalizingFirstLetter()
            let season_id = ((premiumDataArr[sender.tag] as [String:Any] )["id"] as? String ?? "")
            let param: Parameters  = ["user_id":currentUser.result?.id ?? "","season_id":season_id ,"episode_id":"","page_no":"1","limit":"50","category_id":season_id ]
            vc.param = param
            vc.selectedString = "seeAll"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- CollectionView Cell

extension newPremiumvc: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sliderCollection{
            pagerView.numberOfPages = sliderImgData.count
            print(sliderImgData.count)
            return sliderImgData.count
        }
        else{
            return (((premiumDataArr[collectionView.tag] as [String:Any])["season_details"] as? [[String:Any]] ?? [[:]]).count)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderCollection{
            guard let cell = sliderCollection.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as? sliderCell else {
                return UICollectionViewCell()
            }
            if sliderImgData.count > 0 {
                cell.silderImg.sd_setIndicatorStyle(.gray)
                cell.silderImg.sd_setShowActivityIndicatorView(true)
                if sliderImgData.count > indexPath.row {
                    let image = sliderImgData[indexPath.row]
                    cell.silderImg.sd_setImage(with: URL(string: image ), placeholderImage: UIImage(named: ""), options: .refreshCached, completed: nil)
                    // Use the image...
                } else {
                    // Handle the situation where indexPath.row is out of bounds.
                    print("Index out of range for sliderImgData")
                  
                }
            }
            return cell
        }else{
            print(((premiumDataArr[collectionView.tag] as [String:Any])["season_details"] as? [[String:Any]] ?? [[:]])[indexPath.row])
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preCell", for: indexPath) as? preCell else {
                return UICollectionViewCell()
            }
            let data = (((premiumDataArr[collectionView.tag] as [String:Any])["season_details"] as? [[String:Any]] ?? [[:]])[indexPath.row]["vertical_banner"] as? String ?? "")
            
            let datas = (((premiumDataArr[collectionView.tag] as [String:Any])["season_details"] as? [[String:Any]] ?? [[:]])[indexPath.row]["newly_released"] as? String ?? "")
            
            if let imagelatest = cell.viewWithTag(201) as? UIImageView {
                if datas == "1" {
                    imagelatest.isHidden = false
                    imagelatest.image = UIImage(named: "newlyReleased")
                }else {
                    imagelatest.isHidden = true
                }
            }
            
            cell.dataImg.sd_setImage(with: URL(string: data), placeholderImage: UIImage(named: ""), options: .refreshCached, completed: nil)
//            cell.dataView.layer.cornerRadius = 5.0
//            cell.dataView.clipsToBounds = true
//            shadow(cell)
            return cell
        }
    }
}

//MARK: UICollectionView Delegate
extension newPremiumvc: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        else
        {
            
            if collectionView != sliderCollection {
                
                if currentUser.result?.id != "163" {
                    
                    let data = ((premiumDataArr[collectionView.tag] as [String:Any])["season_details"] as? [[String:Any]] ?? [[:]])[indexPath.row]
                    isComeFrom = 1
                    let vc = storyboard?.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
                    var model = ((premiumDataArr[collectionView.tag] as [String:Any])["season_details"] as? [[String:Any]] ?? [[:]])
                    model.remove(at: indexPath.row)
                    vc.data = data
                    vc.allListData = model
                    vc.selectedString = "premiumSeeMore"
                    //             vc.season_id = selectedSeasonID
                    type = ""
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
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
                        } else {
                            //                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                            //                        self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            } else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
                guard indexPath.row < self.sliderimgid.count else {
                    print("Index out of range for season_promo_id")
                    return
                }
                guard let seasonId = self.sliderimgid[indexPath.row]["season_id"] as? String else {
                    print("Unable to retrieve season_id")
                    return
                }
                // Now you have the season_id, you can use it as needed
                print("Selected season_id: \(seasonId)")
                vc.season_id = seasonId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagerView?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pagerView?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
//MARK: UICollectionView Delegate FlowLayout

extension newPremiumvc: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sliderCollection{
            return CGSize(width: self.sliderCollection.frame.width, height: self.sliderCollection.frame.height)
        }else{
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: 200 , height: 300)
                   } else {
                       return CGSize(width: 150 , height: 250)
                   }
            
            
           
        }
    }
 }

//MARK: UITableView Datasource

extension newPremiumvc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "premiumDataCell", for: indexPath) as? premiumDataCell else {
            return UITableViewCell()
        }
        cell.premiumCollection.tag = indexPath.section
        cell.premiumCollection.delegate = self
        cell.premiumCollection.dataSource = self
        cell.premiumCollection.reloadData()
        cell.premiumCollection.collectionViewLayout.invalidateLayout()
        
        return cell
    }
}
//MARK: TableView Delegate
extension newPremiumvc : UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return premiumDataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 300
               } else {
                   return 250
               }
        
     
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableHeader") as? tableHeader else {
            return UITableViewCell()
        }
        cell.headerBTn.tag = section
        cell.headerlbl.text = ((premiumDataArr[section] as [String:Any] )["cat_name"] as? String ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
