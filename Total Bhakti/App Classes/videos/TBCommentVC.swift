//
//  TBCommentVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 04/04/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

protocol commentVCDelegate {
    func updateCommnetValue(_ string : String)
}

class TBCommentVC: TBInternetViewController {

    //MARK:- IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //MARK:- variables.
    var commentArr = [Comments]()
    var refreshControl = UIRefreshControl()
    var noDataLbl = UILabel()
    var previousData : videosResult!
    var delegate : commentVCDelegate?
    var commentsValue = String()
    var dataEnd = 0
    var lastComment : Comments!
    var firstTimeLoadData = 0
    var lastCommentId = String()
    var tempArr = NSMutableArray()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var header : TBHeaderViewController?
    
    //MARK:- LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let param : Parameters = ["user_id": currentUser.result!.id!, "video_id": previousData.id, "last_comment_id" : ""]
        viewCommentHit(param)
      
        noDataLbl = noDataLabelCall(controllerType: self, tableReference: tableView)
        commentTextView.text = "Add a comment..."
        commentTextView.textContainer.maximumNumberOfLines = 5
        commentTextView.textColor = UIColor.lightGray
        commentView.layer.cornerRadius = 20.0
        commentView.layer.borderWidth = 0.5
        commentView.layer.borderColor = UIColor.gray.cgColor
        commentTextView.delegate = self
        shadowEffectOnImageView(profileImageView)
        profileImageView.layer.cornerRadius = 16.5
        profileImageView.clipsToBounds = true
        postBtn.titleLabel?.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 0.50)
         getHeaderView()
         header?.delegate = self

        header?.menuBarBtn.setImage(UIImage(named : "back"), for: .normal)
        if let profileUrl = currentUser.result!.profile_picture ,profileUrl != "" {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.sd_setShowActivityIndicatorView(true)
            profileImageView.sd_setIndicatorStyle(.gray)
            profileImageView.sd_setImage(with: URL(string: profileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, placeholderImage: UIImage(named: "profile"), options: .refreshCached, completed: nil)
        }else {
            profileImageView.image = UIImage(named : "profile")
        }
    
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
    
    
   
    
    //MARK:- screenBtn Action.
    @IBAction func screenBtnAction(_ sender : UIButton)  {
        switch sender.tag {
        case 10:
            _ = navigationController?.popViewController(animated: true)
        case 20:
            if commentTextView.text.isEmpty  {
                commentTextView.text = "Add a comment..."
                commentTextView.textColor = UIColor.lightGray
                postBtn.titleLabel?.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 1.0)
            }else {
                if commentTextView.text != "Add a comment..." {
                    let param : Parameters = ["user_id" : currentUser.result!.id!, "video_id" : previousData.id, "comment" : commentTextView.text!]
                    addComments(param)
                    commentTextView.text = "Add a comment..."
                    commentTextView.textColor = UIColor.lightGray
                    postBtn.titleLabel?.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 0.50)
                }
            }
            commentTextView.resignFirstResponder()
        default:
            break
        }
    }
    
    
    
    //MARK:- viewCommentApi hit.
    func viewCommentHit(_ param : Parameters)  {
            if commentArr.count == 0 && firstTimeLoadData == 0{
                DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
            }else {
                DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            }
            self.uplaodData1(APIManager.sharedInstance.KVIEWCOMMENT , param) { (response) in
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
                                if self.lastCommentId == "" {
                                    self.tempArr.removeAllObjects()
                                    self.commentArr.removeAll()
                                    self.tempArr.addObjects(from: NSMutableArray(array: result) as! [Any])
                                    self.commentArr = Comments.modelsFromDictionaryArray(array: self.tempArr)
                                }else {
                                    self.tempArr.addObjects(from: NSMutableArray(array: result) as! [Any])
                                    self.commentArr = Comments.modelsFromDictionaryArray(array: self.tempArr)
                                }
                            }
                            self.tableView.reloadData()
                        }
                        if self.commentArr.count == 0 {
                            self.noDataLabel.isHidden = false
                        }else {
                            self.noDataLabel.isHidden = true
                            self.tableView.bringSubview(toFront: self.noDataLbl)
                        }
                        self.tableView.reloadData()
                    }
                    
                }else {
//                    self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
    
    //MARK:- commentAdd Api hit.
    func addComments(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KADDCOMMENT, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    self.commentsValue = "\((NSString(string : self.previousData.comments!).integerValue)+1)"
                    self.previousData.comments = "\((NSString(string : self.previousData.comments!).integerValue)+1)"
                    self.delegate?.updateCommnetValue(self.commentsValue)
                    let param : Parameters = ["user_id": currentUser.result!.id!, "video_id": self.previousData.id, "last_comment_id" : self.lastCommentId]
                    self.viewCommentHit(param)
                }else {
                self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
   

    func timeConverter(_ value: String) -> String
    {
        var returnValue: String! = ""
        dateFormatterForWholeApp.dateFormat = KTIMEFORMATE
        
        let date1 = dateFormatterForWholeApp.date(from: value)

        if date1 != nil
        {
            dateFormatterForWholeApp.dateFormat = KTIMEFORMATE
            dateFormatterForWholeApp.timeZone = TimeZone.autoupdatingCurrent
            let stringNewDate = dateFormatterForWholeApp.string(from: date1!)
            let date = dateFormatterForWholeApp.date(from: stringNewDate)
            let stringValue = Date().offsetFrom(date!)
            let intValue = (Date().offsetFrom(date!) as NSString).integerValue

            if stringValue.contains(KDAYS)
            {
                if intValue > 5
                {
                    returnValue = "few days ago"
                }
                else if intValue == 1
                {
                    returnValue = "Yesterday"
                }
                else
                {
                    returnValue = "\(intValue) days ago"
                }
            }
            else if stringValue.contains(KSECONDS) || stringValue == ""
            {
                returnValue = "just now"
            }
            else if stringValue.contains(KMONTHS) || stringValue.contains(KYEARS) || stringValue.contains(KWEEKS)
            {
                returnValue = "few days ago"
            }
            else if stringValue.contains(KMINUTES)
            {
                if intValue == 1
                {
                    returnValue = "a min ago"
                }
                else
                {
                    returnValue = "\(intValue) mins ago"
                }
            }
            else if stringValue.contains(KHOURS)
            {
                if intValue == 1
                {
                    returnValue = "an hour ago"
                }
                else
                {
                    returnValue = "\(intValue) hours ago"
                }
            }
            else
            {
                returnValue = "few days ago"
            }
        }
        return returnValue
    }
    
}

//MARK:- UITableView DataSources Methods.
extension TBCommentVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath) as! TBCommentTableCell
        let post = commentArr[indexPath.row]
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
        if post.profile_picture?.isEmpty == false {
            if let urlString = post.profile_picture {
                cell.profileImageView.sd_setShowActivityIndicatorView(true)
                cell.profileImageView.sd_setIndicatorStyle(.gray)
                cell.profileImageView.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: nil, options: .refreshCached, completed: nil)
            }
        }else {
           cell.profileImageView.image = UIImage(named : "profile")
        }
        
        cell.profileImageView.clipsToBounds = true
        if post.name == ""{
            cell.heightConstraintForNameLbl.constant = 0.0
        }else {
            cell.heightConstraintForNameLbl.constant = 21.0
        }
        cell.nameLbl.text = post.name
        cell.commentLbl.text = post.comment
        cell.mainView.dropShadow()
      //cell.commentLbl.sizeToFit()
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(post.time!)!
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        print(formatedData)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = KTIMEFORMATE
        cell.timeLbl.text = timeConverter(dateFormatter.string(from: formatedData))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == commentArr.count - 1  && dataEnd == 0 {
            spinner.startAnimating()
            self.tableView.tableFooterView?.isHidden = false
            firstTimeLoadData = 1
            lastComment = commentArr[indexPath.row]
            lastCommentId = lastComment.id!
            let param : Parameters = ["user_id": currentUser.result!.id!, "video_id": previousData.id, "last_comment_id" : lastComment.id!]
            viewCommentHit(param)
            
        }else {
            spinner.stopAnimating()
        }
    }
}

//MARK:- TableView Delegates Methods.
extension TBCommentVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

//MARK:- UITextView Delegates.
extension TBCommentVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.text == "Add a comment..." {
            commentTextView.text = nil
        }
        commentTextView.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 1.0)
        commentTextView.becomeFirstResponder()
       postBtn.titleLabel?.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 1.0)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.isEmpty {
            commentTextView.text = "Add a comment..."
              postBtn.titleLabel?.textColor = UIColor(red: 236/255.0, green: 90/255.0, blue: 110/255.0, alpha: 0.50)
            commentTextView.textColor = UIColor.lightGray
        }
        commentTextView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (commentTextView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
}

//MARK:- headerView Delegates
extension TBCommentVC : TBHeaderDelegates {
    func menuBarBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10:
          _ = navigationController?.popViewController(animated: true)
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

extension TBCommentVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
        
    }
}
