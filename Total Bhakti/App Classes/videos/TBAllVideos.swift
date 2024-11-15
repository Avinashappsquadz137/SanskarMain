//
//  TBAllVideos.swift
//  Total Bhakti
//
//  Created by MAC MINI on 06/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBAllVideos: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    //MARK:- variables.
    var dataToShow = NSMutableArray()
    var refreshControl = UIRefreshControl()
    var allVideoArr = [videosResult]()
    var pullToRefreshClicked = 0
    var lastVideo : videosResult!
    var dataEnd = 0
    var firstTimeLoadData = 0
    var index = Int()
    var noDataLbl = UILabel()
    var categoryId = String()
    var searchContentFromSankitran = String()
    var categoryName = String()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var header : TBHeaderViewController?
    
    //MARK:- LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
         pullToRefresh()
        if isComeFromSankitran == true {
            let param : Parameters = ["user_id" : currentUser.result!.id!  , "video_category" : "" , "last_video_id" : "","search_content": searchContentFromSankitran]
            getAllVideos(param)
           
         headerLbl.text = "Search"
        }else{
            if categoryId.isEmpty != true {
                headerLbl.text = categoryName
                let param : Parameters = ["user_id" : currentUser.result!.id!  , "video_category" : categoryId , "total_received_count" : "0"]
                getAllVideos(param)
            }else {
                 headerLbl.text = "Search"
            }
           
        }
        getHeaderView()
        header?.delegate = self
        header?.menuBarBtn.setImage(UIImage(named : "back"), for: .normal)
        noDataLbl = noDataLabelCall(controllerType: self, tableReference: tableView)
        tableView.tableFooterView?.isHidden = true
        tableView.contentInset = UIEdgeInsets.zero
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
   
    
  
    @IBAction func sceenBtnAction (_ sender : UIButton) {
        switch sender.tag {
        case 10://backBtn
            if isComeFromSankitran == true {
                isComeFromSankitran = false
            }
         _ =  navigationController?.popViewController(animated: true)
            
        default:
            break
        }
    }
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
    }
    
    //MARK:- headerView
    func getHeaderView()  {
        header = TBHeaderViewController.getHeaderView() as? TBHeaderViewController
        header?.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width, height: 60)
        if let header = self.header {
            header.mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            self.headerView.addSubview(header)
            self.headerView.bringSubview(toFront: header)
        }
    }
    
    
    @objc func refresh(sender:AnyObject) {
        if isComeFromSankitran == false {
            pullToRefreshClicked = 1
            let param : Parameters  = ["user_id" : currentUser.result!.id!  , "video_category" : categoryId, "total_received_count" : "0"]
            getAllVideos(param)
        }else {
            self.dataToShow.removeAllObjects()
            self.allVideoArr.removeAll()
              let param : Parameters = ["user_id" : currentUser.result!.id!  , "video_category" : "" , "last_video_id" : "","search_content": searchContentFromSankitran]
            getAllVideos(param)
        }
       
    }
    
    //MARK:- ALL VIDEOS API.
    func getAllVideos(_ param : Parameters) {
        if dataToShow.count == 0 && firstTimeLoadData == 0 && pullToRefreshClicked == 0{
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        }else {
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
        }
        let apiName : String!
        if comeFromHomeScreen == 1 {//home
          apiName = APIManager.sharedInstance.KALLVIDEOAPI
        }else if isComeFromSankitran == true{//sankitran
            apiName = APIManager.sharedInstance.KSANKITRANSEARCHAPI
        }else {
            apiName = APIManager.sharedInstance.KSANKITRANVIEWALL
        }
        uplaodData1(apiName, param) { (response) in 
             DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                if let result = JSON.value(forKey: "data") as? NSDictionary {
                    if let videoArr = result.value(forKey: "videos") as? NSArray {
                        if videoArr.count == 0 {
                            self.dataEnd = 1
                        } else {
                            self.dataEnd = 0
                            if self.pullToRefreshClicked == 1 {
                                self.dataToShow.removeAllObjects()
                                self.allVideoArr.removeAll()
                                self.dataToShow.addObjects(from: NSMutableArray(array : videoArr) as! [Any])
                                self.allVideoArr = videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                                self.pullToRefreshClicked = 0
                            } else {
                                self.dataToShow.addObjects(from: NSMutableArray(array : videoArr) as! [Any])
                                self.allVideoArr = videosResult.modelsFromDictionaryArray(array: self.dataToShow)
                            }
                        }
                        self.tableView.reloadData()
                        if self.allVideoArr.count == 0 {
                            self.tableView.isHidden = true
                            self.noDataLbl.isHidden = false
                            
                        }else {
                            self.tableView.isHidden = false
                            self.noDataLbl.isHidden = true
                        }
                    }
                    }
                    
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
            
        }
    }
    

}

//MARK:- UITbaleView DataSourse.
extension TBAllVideos : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVideoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let posts = allVideoArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBAllVideosTableViewCell
        cell.videoNameLbl.text = posts.video_title
//        cell.videoDescriptionLbl.text = posts.video_desc?.html2String
        cell.mainView.layer.cornerRadius = 5.0
        cell.mainView.dropShadow()
        
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
        print(formatedData)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
        print(dateFormatter.string(from: formatedData))
        cell.videoDateAndTimeLbl.text = dateFormatter.string(from: formatedData)
        if let urlString = posts.thumbnail_url {
            cell.videoImageView?.sd_setShowActivityIndicatorView(true)
            cell.videoImageView?.sd_setIndicatorStyle(.gray)
            cell.videoImageView.layer.cornerRadius = 5.0
            cell.videoImageView.clipsToBounds = true
            cell.videoImageView?.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if allVideoArr.count >= 8 {
            if isComeFromSankitran == false {
            if indexPath.row == allVideoArr.count - 1  && dataEnd == 0 {
               
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
                //  firstTimeData = 1
                index = indexPath.row + 1
                lastVideo = allVideoArr[indexPath.row]
                
                firstTimeLoadData = 1
                let param : Parameters  = ["user_id" : currentUser.result!.id! , "video_category" : categoryId , "total_received_count" : "\(allVideoArr.count)"]
                getAllVideos(param)
                
            }else {
                self.tableView.tableFooterView?.isHidden = true
            }
        }else {
             self.tableView.tableFooterView?.isHidden = true
            }
        }else{
             self.tableView.tableFooterView?.isHidden = true
        }
        
    }
    
}



//MARK:- headerView Delegates
extension TBAllVideos : TBHeaderDelegates {
    func menuBarBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            if isComeFromSankitran == true {
                isComeFromSankitran = false
            }
            _ =  navigationController?.popViewController(animated: true)
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

extension TBAllVideos : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
        
    }
}

