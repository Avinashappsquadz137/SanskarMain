//
//  TBSankitranVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 06/04/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
var isComeFromSankitran = false
class TBSankitranVC: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
     @IBOutlet weak var notifCountLabel: UILabel!

    
    //MARK:- variables.
    var refreshControl: UIRefreshControl!
    var lbl = UILabel()
    var searchText = ""
    var searchClicked = 0
    var tableSection = Int()
    var videosArr = [homeCategory]()
    var collectionViewObject : UICollectionView!
    var pullToRefreshOn = false
   
    
    //MARK:- Life Cycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        comeFromHomeScreen = 2
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        lbl = noDataLabelCall(controllerType: self, tableReference: tableView)
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        pullToRefresh()

        let param : Parameters = ["user_id" : currentUser.result!.id!]
        getDataApi(param)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        
        super.viewWillAppear(true)
        if searchClicked == 1 {
            searchClicked = 0
            searchBar.text = nil
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
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
    

    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        let param : Parameters = ["user_id": currentUser.result!.id!]
        pullToRefreshOn = true
        getDataApi(param)
    }

    //MARK:- Api Method.
    func getDataApi(_ param : Parameters) {
        if videosArr.count == 0 && self.pullToRefreshOn == false {
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        }else {
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
        }
        self.uplaodData1(APIManager.sharedInstance.KSANKITRAN, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        if  self.pullToRefreshOn == true {
                            self.pullToRefreshOn = false
                        }
                        self.videosArr = homeCategory.modelsFromDictionaryArray(array: result)
                        self.tableView.reloadData()
                        
                        if result.count == 0 {
                            self.tableView.isHidden = true
                            self.lbl.isHidden = false
                        }else {
                            self.tableView.isHidden = false
                            self.lbl.isHidden = true
                        }
                    }
                }else {
                    self.tableView.isHidden = true
                    self.lbl.isHidden = false
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
}

//MARK:- UITableView DataSourse.
extension TBSankitranVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBSankirtanTableCell
        collectionViewObject = cell.collectionView
        return cell
    }
}

//MARK:- UITableView Delegates..
extension TBSankitranVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if videosArr.count != 0 {
                if videosArr[section].videos?.count != 0 {
                    return 35
                }else {
                    return CGFloat.leastNormalMagnitude
                }
            }else {
                return CGFloat.leastNormalMagnitude
            }
        }else {
            if section == 1 {
                if videosArr.count != 0 {
                    if  videosArr[section].videos?.count == 0  {
                        return CGFloat.leastNormalMagnitude
                    }else {
                        return 35
                    }
                }
            }
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        collectionViewObject.tag = indexPath.section
        collectionViewObject.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL2)
        let titleLbl = cell?.viewWithTag(100) as! UILabel
        let headerBtn = cell?.viewWithTag(10000)as! UIButton
        headerBtn.tag = section
        if section == 0{
            titleLbl.text = "All Sankirtan"
        }else {
            titleLbl.text = "Recently View"
        }
        return cell
    }
    
}

//MARK:- UICollection View.
extension TBSankitranVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videosArr.count > 0 {
            return videosArr[section].videos!.count
        }else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL, for: indexPath)
        let image = cell.viewWithTag(100) as? UIImageView
        let lbl = cell.viewWithTag(200) as? UILabel
        let mainView = cell.viewWithTag(300)
        shadow(cell)
        mainView?.layer.cornerRadius = 5.0
        
        let posts = videosArr[indexPath.section].videos![indexPath.row]
        lbl?.text = posts.video_title
        
        image?.clipsToBounds = true
        image?.sd_setIndicatorStyle(.gray)
        image?.sd_setShowActivityIndicatorView(true)
        image?.layer.cornerRadius = 5.0
        image?.clipsToBounds = true
        image?.sd_setImage(with: URL(string: posts.thumbnail_url!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

//MARK:- UIColection View Delegates Methods.


extension TBSankitranVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 140, height: 120)
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
        
        tableSection = indexPath.section
        let post = videosArr[indexPath.section].videos![indexPath.row]
        let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post.id ?? ""]
        recentViewHit(param)

            if post.youtube_url != ""{
                let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                vc.songNo = indexPath.row
                vc.post = videosArr[indexPath.section].videos![indexPath.row]
                vc.videosArr = videosArr[indexPath.section].videos!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
    }
    
}

//MARK:- searchBar Delegate Methods.
extension TBSankitranVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            searchText = ""
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchText = searchBar.text!
        isComeFromSankitran = true
        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KALLVIDEOS) as! TBAllVideos
        vc.searchContentFromSankitran = searchBar.text!
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




extension TBSankitranVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
    }
}
