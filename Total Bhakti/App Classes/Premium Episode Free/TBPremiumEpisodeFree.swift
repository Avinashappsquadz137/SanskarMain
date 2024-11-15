//
//  TBPremiumEpisodeFree.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 28/01/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
protocol dataDelegate: class {
    func passData(_ dict: freeModel)
}
class TBPremiumEpisodeFree: TBInternetViewController {
    
    
    @IBOutlet weak var colltnView: UICollectionView!
    @IBOutlet weak var bckBtn: UIButton!
    var premiumData : [freeModel] = []
    var premiumSeasonData : [seasonModel] = []
    weak var delegate: dataDelegate?
    var param : Parameters = [:]
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0)
    let numberOfItemsPerRow: CGFloat = 4
    let spacingBetweenCells: CGFloat = 10
    var refreshControl: UIRefreshControl!
    var pullToRefreshOn = false
    var selectedString = ""
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var categoryHeading: UILabel!
    var headingSting : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(param)
        

        colltnView.delegate = self
        colltnView.dataSource = self
        
        if  isComeFrom == 2{
    
            getSeasonsListByMenuMasterApi(param)
            categoryHeading.text = headingSting
        }
        else{
            
                    seeMoreApi(param)
            categoryHeading.text = headingSting
        }

        pullToRefresh()
    }
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh), for: .valueChanged)
        colltnView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        pullToRefreshOn = true
        if  isComeFrom == 2{
      //      seeMoreApi(param)
            getSeasonsListByMenuMasterApi(param)
        }
        else{
            getSeasonsListByMenuMasterApi(param)
        }

    }

    //MARK:- See more api method.
    func seeMoreApi(_ param : Parameters){
        
        self.uplaodData1(APIManager.sharedInstance.KSeasonBYCategory, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})

            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Bool == true {
                    self.premiumData.removeAll()
                    let data = JSON.ArrayofDict("data")
                    
                    _ = data.filter({ (dict) -> Bool in
                        
                        self.premiumData.append(freeModel(dict: dict))
                        
                        return true
                    })
                    self.colltnView.reloadData()
                    
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    self.colltnView.reloadData()
                    
                }else {
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    
                    
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
    
    @IBAction func bckBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnAction (_ sender : UIButton) {
       
            self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func logoBtnAction(_ sender: UIButton) {
      self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Api Method.
    func getSeasonsListByMenuMasterApi(_ param : Parameters){
        //        if  self.searchClicked == true {
        //            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        //        }
        self.uplaodData1(APIManager.sharedInstance.KMENUMASTERSEASONLIST, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})

            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Bool == true {
                    self.premiumData.removeAll()
                    let data = JSON.ArrayofDict("data")
                    
                    _ = data.filter({ (dict) -> Bool in
                        
                        self.premiumData.append(freeModel(dict: dict))
//                        let list = dict.ArrayofDict("")
//                        if list.count == 0{
//
//                        }else{
//                            self.premiumData.append(seeMoreModel(dict: dict))
//                        }
                        
                        
                        return true
                    })
//                    self.pagerViewUIsetup()
                    self.colltnView.reloadData()
                    
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
                    self.colltnView.reloadData()
                    
                }else {
                    if self.pullToRefreshOn == true {
                        self.pullToRefreshOn = false
                    }
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
}

extension TBPremiumEpisodeFree: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return premiumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  30
        let collectionViewSize = colltnView.frame.size.width - padding
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: 370, height: 193)
        }
        else{
            return CGSize(width: 370, height: 193)
        }


    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL, for: indexPath) as! TBPremiumEpisodeCell
        
        let post = premiumData[indexPath.row]
        cell.title.isHidden = true

        cell.lockImg?.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        if post.is_locked! == "0"{
            cell.lockImg?.isHidden = true
            cell.isUserInteractionEnabled = true
        }
        else{
            if isComeFromHome == 1{
                cell.lockImg?.isHidden = true
                cell.isUserInteractionEnabled = true
                isComeFromHome = 0
            }
            else{
                cell.lockImg?.isHidden = true
                cell.isUserInteractionEnabled = true
            }

        }

        print("is_locked:::",post.is_locked ?? "")
        if post.episode_title != ""{
            cell.title.text = post.episode_title
            cell.title.isHidden = true
        //    cell.img.sd_setImage(with: URL(string: post.thumbnail_url ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            cell.img.sd_setImage(with: URL(string: post.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        else{
            cell.title.text = post.season_title
            cell.img.sd_setImage(with: URL(string: post.season_thumbnail ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "didChangeChannel"))
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)

        TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        let chanNo = UserDefaults.standard.value(forKey: "channelNumb") as? Int
//        if  isComeFrom == 0{
////            isComeFrom = 0
//
//            let post = premiumData[indexPath.row]
//
//            let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//            vc.selectedData = post
//            vc.selectedString = type
//
//            vc.premiumData = premiumData
//            print(vc.premiumData)
//            //            vc.delegate = self
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//       else{
        print("indexPath.row:::",indexPath.row)
       
            let post = premiumData[indexPath.row]

            let vc = storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
            vc.selectedData = post
            vc.selectedString = "premiumSeeMore"
            type = "premiumDetail"
        //    vc.premiumData = premiumData
            //            vc.delegate = self

            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//            delegate?.passData(premiumData[indexPath.row])
//            self.navigationController?.popViewController(animated: true)
//        }
//       }
    }
    
}
/*
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int 
 */
