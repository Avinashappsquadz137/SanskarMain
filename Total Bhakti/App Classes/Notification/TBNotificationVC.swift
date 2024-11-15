//
//  TBNotificationVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 13/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBNotificationVC: TBInternetViewController {
    //MARK:- IBOutlets.
    
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editBtn: UIButton!
    
    var markAll = true
    
    
    
    
    //MARK:- variables.
    var notificationArr = [notification]()
    var noDataLbl = UILabel()
    var postType = String()
    var header : TBHeaderViewController?
    var indexNo = 0
    
    //MARK:- lifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomConstraint.constant = -100.0
        
        // self.tabelView.allowsMultipleSelection = true
        // self.tabelView.allowsMultipleSelectionDuringEditing = true
        let notification_status = UserDefaults.standard.value(forKey: "notification_status") as? String ?? "0"
        
        if notification_status == "0"{
            noDataLbl = self.noDataLabelCall(controllerType: self, tableReference: tabelView)
            noDataLbl.text = "You don’t have any notification "
            notificationApi()
        }else{
            self.noDataLbl.isHidden = false
            noDataLbl.numberOfLines = 0
            noDataLbl.text = "You have desabled your notification\n Please enable notification"
            noDataLbl.frame = CGRect(x: 0, y: 0, width: tabelView.frame.size.width, height: tabelView.frame.size.height)
            noDataLbl.textAlignment = .center
            noDataLbl.textColor = .darkGray
            tabelView.backgroundView = noDataLbl
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let button = UIButton()
        button.tag = 7
        TBHomeTabBar.currentInstance?.TabBarActionButton(button)
        tabelView.reloadData()
    }

    //MARK:- screenBtn Action.
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if sender.tag == 12{
            self.navigationController?.popToRootViewController(animated: true)
            return
            
        }
        
        UserDefaults.standard.removeObject(forKey: "fromPush")
        _ = navigationController?.popViewController(animated: true)
    }
    

    @IBAction func editAction(_ sender: UIButton) {
        
      
        if notificationArr.count == 0{
            return
        }
        
        
        UIView.animate(withDuration: 0.3) {
            if sender.titleLabel?.text == "Edit"{
                self.tabelView.isEditing = true
                self.selectAll(select: false)
                self.bottomConstraint.constant = 0.0
                sender.setTitle("Done", for: .normal)
                self.view.layoutIfNeeded()
            }else{
                 self.markAll = true
                self.selectAll(select: false)
                self.tabelView.isEditing = false
                self.bottomConstraint.constant = -100.0
                sender.setTitle("Edit", for: .normal)
                self.view.layoutIfNeeded()
                
            }
            
        }
        
    }
    
    
    @IBAction func markAllAction(_ sender: UIButton) {
        
        
        if markAll{
            selectAll(select: true)
            markAll = false
            sender.setTitle("Unmark All", for: .normal)
        }else{
            selectAll(select: false)
            markAll = true
            sender.setTitle("Mark All", for: .normal)
        }
        
    }
    @IBAction func removeAction(_ sender: UIButton) {
        var notification_ids = ""
        let selectedRows = self.tabelView.indexPathsForSelectedRows
        if selectedRows != nil {
            for var selectionIndex in selectedRows! {
                while selectionIndex.item >= notificationArr.count {
                    selectionIndex.item -= 1
                }
                notification_ids.append(notificationArr[selectionIndex.row].id! + ",")
                tableView(tabelView, commit: .delete, forRowAt: selectionIndex)
            }
            
            notification_ids.removeLast()
            let parameter : Parameters = ["user_id" : currentUser.result!.id!,"notification_id":notification_ids,"type":"1"]
            clearNotificationApi(param: parameter)
            UIView.animate(withDuration: 0.3) {
                self.selectAll(select: false)
                self.tabelView.isEditing = false
                self.bottomConstraint.constant = -100.0
                self.editBtn.setTitle("Edit", for: .normal)
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func hyperActionAction() {
        UserDefaults.standard.removeObject(forKey: "fromPush")
        TBHomeTabBar.currentInstance?.selectedIndex = 0
        self.navigationController?.popToViewController((TBHomeTabBar.currentInstance?.selectedViewController)!, animated: true)
        
    }
    
    //MARK:- call Api.
    func notificationApi(){
        let param : Parameters = ["user_id" : currentUser.result!.id!,"device_type":"2"]
        
        
        loader.shareInstance.showLoading(self.view)
        self.uplaodData(APIManager.sharedInstance.KNOTIFICATIONAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        self.notificationArr = notification.modelsFromDictionaryArray(array: result)
                        self.tabelView.reloadData()
                        if self.notificationArr.count == 0 {
                            self.tabelView.isHidden = true
                            self.noDataLbl.isHidden = false
                        }else{
                            self.noDataLbl.isHidden = true
                            self.tabelView.isHidden = false
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
    
    //MARK:- NOtificationDetail Api.
    func notificationDetailApi(_ param : Parameters){
        loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.KGETNOTIFICATIONDETAIL, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSDictionary {
                        print(result)
                        if self.postType == "bhajan" {
                            let bhajanData1 = Bhajan.init(dictionary: result)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
                            let post = bhajanData1
                            let bhajanArr = [post]
                            MusicPlayerManager.shared.song_no = 0
                            MusicPlayerManager.shared.Bhajan_Track = bhajanArr as! [Bhajan]
                            MusicPlayerManager.shared.isDownloadedSong = false
                            MusicPlayerManager.shared.isPlayList = false
                            MusicPlayerManager.shared.isRadioSatsang = false
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//                            self.navigationController?.pushViewController(vc, animated: true)
                            self.present(vc, animated: true, completion: nil)
                            
                            MusicPlayerManager.shared.PlayURl(url: post?.media_file! ?? "")
                            
                        }else if self.postType == "news" {
                            let newsData = News.init(dictionary: result)
                            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
                            vc.dataToShow = newsData
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else if self.postType == "video" {
                            
                            let post = videosResult.init(dictionary: result)
                            
                            let url = post!.video_url
                            let param : Parameters = ["user_id": currentUser.result!.id! , "type": "2" , "media_id" : post?.id ?? ""]
                           
                                if post?.youtube_url != ""{
                                    self.recentViewHit(param)
                                    let vc : TBYoutubeVideoVC = storyBoard.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as! TBYoutubeVideoVC
                              
                                    vc.songNo = 0
//                                    vc.videosArr = homeAllDataArray.videos![0].videos!
                                    vc.post = post

                        
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
                                }
                           
                        }
                    }
                }else {
                  //  self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
              //  self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}

extension TBNotificationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath)
        
        let post = notificationArr[indexPath.row]
        let imageVeiw = cell.viewWithTag(100) as? UIImageView
        let nameLbl = cell.viewWithTag(200) as? UILabel
        let descriptionLbl = cell.viewWithTag(300) as? UILabel
        let dateLbl = cell.viewWithTag(400) as? UILabel
        let mainView = cell.viewWithTag(500)
        mainView?.layer.cornerRadius = 5.0
        mainView?.dropShadow()
        imageVeiw?.layer.cornerRadius = 5.0
        imageVeiw?.clipsToBounds = true
        
        if notificationArr[indexPath.row].is_view == "0"{
            mainView?.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0.06252675514)
        }else{
            mainView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if post.post_type == "video"{
            nameLbl?.text = "Video"
        }else if post.post_type == "news"{
            nameLbl?.text = "News"
        }else if post.post_type == "bhajan"{
            nameLbl?.text = "Bhajan"
        }else{
            nameLbl?.text = "General"
            
            if let urlString = post.notification_thumbnail {
                print(urlString)
                      imageVeiw?.sd_setShowActivityIndicatorView(true)
                      imageVeiw?.sd_setIndicatorStyle(.gray)
                  //    imageVeiw?.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                imageVeiw?.sd_setImage(with: URL(string: urlString))
                  }
            
        }
        descriptionLbl?.text = post.text
        
        if let urlString = post.image {
            print(urlString)
            imageVeiw?.sd_setShowActivityIndicatorView(true)
            imageVeiw?.sd_setIndicatorStyle(.gray)
//            imageVeiw?.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            imageVeiw?.sd_setImage(with: URL(string: urlString))
        }
        
        dateLbl?.text = post.created_on
        
        
        return cell
    }
}

//MARK:- UITableView delagates.
extension TBNotificationVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tabelView.isEditing == true{
            return
        }
        
        let post = notificationArr[indexPath.row]
        postType = post.post_type!
        let param : Parameters = ["user_id": currentUser.result!.id!, "post_id": post.post_id!, "post_type" : post.post_type!]
        
        if  post.post_type == "" || post.post_type == "URL" || post.post_type == "GENERAL"{
            let notificationID = post.id ?? "0"
            ViewNotificationApi(notification_id:notificationID)
//            self.navigationController?.popViewController(animated: true)
            return
        }
        
        indexNo = indexPath.row
        
        if post.is_view == "0"{
            let notificationID = post.id ?? "0"
            ViewNotificationApi(notification_id:notificationID)
            
        }
        
        notificationDetailApi(param)
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let notifi_Id = self.self.notificationArr[indexPath.row].id
            let parameter : Parameters = ["user_id" : currentUser.result!.id!,"type":"1","notification_id":notifi_Id as Any]
            
            self.clearNotificationApi(param: parameter)
            
            self.self.notificationArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            
        }
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
        return [delete]
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            notificationArr.remove(at: indexPath.row)
            tabelView.reloadData()
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tabelView.setEditing(editing, animated: true)
    }
    
    
    private func selectAll(select: Bool) {
        let numSections = self.tabelView.numberOfSections
        for numSection in  0 ..< numSections{
            let numItems = self.tabelView.numberOfRows(inSection: numSection)
            for numItem in 0 ..< numItems {
                selectCell(indexPath: NSIndexPath(row: numItem, section: numSection), select: select)
                
            }
        }
    }
    
    private func selectCell(indexPath : NSIndexPath, select: Bool) {
        if self.tabelView.cellForRow(at: indexPath as IndexPath) != nil {
            let cell = self.tabelView.cellForRow(at: indexPath as IndexPath)!
            if select{
                cell.setSelected(select, animated: true)
                self.tabelView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .top)
            }else{
                cell.setSelected(select, animated: true)
                self.tabelView.deselectRow(at: indexPath as IndexPath, animated: true)
                
            }
        }
    }
    
}


extension TBNotificationVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
    }
}

extension TBNotificationVC{
    //MARK:- call Api.
    func ViewNotificationApi(notification_id:String){
        
        let param : Parameters = ["user_id" : currentUser.result!.id!,"notification_id":notification_id]
        self.uplaodData(APIManager.sharedInstance.view_notification, param) { (response) in
            
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    
                    self.notificationArr[self.indexNo].is_view = "1"
                    
                    let data = JSON["data"] as? NSDictionary
                    if data != nil{
                        let notification_counter = "\(data!["notification_counter"]!)"
               //         UserDefaults.standard.setValue(notification_counter, forKey: "notification_counter")
                    }
                }else {
                  //  self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
             //   self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}

extension TBNotificationVC{
    //MARK:- call Api.
    func clearNotificationApi(param:Parameters){
        self.uplaodData(APIManager.sharedInstance.clear_notification, param) { (response) in
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    UserDefaults.standard.setValue("\(self.notificationArr.count)", forKey: "notification_counter")
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}




