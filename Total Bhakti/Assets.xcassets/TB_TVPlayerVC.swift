//
//  TB_TVPlayerVC.swift
//  Sanskar
//
//  Created by mac on 01/07/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit
import Firebase

class TB_TVPlayerVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var messageArray : [messageModel] = []
    var completionBlock:vCB?
    var completionBlock2:vCB2?
    
    var index = 0
    var chatKey = ""
    
    var isTrue = true
    
    
    @IBOutlet weak var TVPlayer:UIView!
    @IBOutlet weak var channelCollection: UICollectionView!
    
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var textFiledView : UIView!
    @IBOutlet weak var txtViewChat: GrowingTextView!
    @IBOutlet weak var prifile_img   : UIImageView!
    @IBOutlet weak var notifCountLabel: UILabel!
    
    @IBOutlet weak var bottomViewConstraints   : NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prifile_img.sd_setImage(with: URL(string: currentUser.result?.profile_picture ?? ""), placeholderImage:  UIImage(named: "profile"), options: .refreshCached, completed: nil)
        
        MyTableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        MyTableView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.MyTableView.delegate = self
        self.MyTableView.dataSource = self
        

        
        channelCollection.dataSource = self
        channelCollection.delegate = self
        
        if TV_PlayerHelper.shared.mmPlayer.playUrl != nil{
            TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
            TV_PlayerHelper.shared.mmPlayer.player?.play()
            
        }else{
            if channelTableArr.count != 0{
                if channelTableArr[0].channel_url != ""{
                    let urlStr = channelTableArr[0].channel_url
                    let url = URL(string: urlStr)
                    
                    post = channelTableArr[0]
                    TV_PlayerHelper.shared.mmPlayer.set(url: url)
                    TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
                    TV_PlayerHelper.shared.mmPlayer.resume()
                    TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
                    TV_PlayerHelper.shared.mmPlayer.player?.play()
                }
            }
            
        }
        channelDidChanged()
        if post != nil{
            observeMessage()
        }
        observeMessage()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
        MusicPlayerManager.shared.myPlayer.pause()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeYoutubePlayer"), object: nil)
        
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as? String ?? "0"
        notifCountLabel.text = notification_counter
    }
    
    
    func channelDidChanged(){
        if post == nil{
            return
        }
        if post.id == "19"{
            FirebaseChannel = "sanskarTV"
        }
        else if post.id == "Sanskar UK"{
            FirebaseChannel = "sanskarUK"
        }
        else if post.id == "26"{
            FirebaseChannel = "sanskarUSA"
        }
        else if post.id == "23"{
            FirebaseChannel = "SanskarWebTV"
        }
        else if post.id == "20"{
            FirebaseChannel = "satsangTV"
        }
        else if post.id == "24"{
            FirebaseChannel = "satsangWebTV"
        }
        else if post.id == "22"{
            FirebaseChannel = "SubhCinemaTV"
        }
        else if post.id == "27"{
            FirebaseChannel = "SanskarTvRadio"
        }
        else {
            FirebaseChannel = "shubhTV"
        }
        
    }
    
    @IBAction func backActionBtn(_ sender:UIButton){
        
        TV_PlayerHelper.shared.mmPlayer.setOrientation(.protrait)
        TV_PlayerHelper.shared.mmPlayer.playView = nil
        guard let cb = self.completionBlock else {return}
        cb()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        
        TV_PlayerHelper.shared.mmPlayer.playView = nil
        guard let cb = self.completionBlock else {return}
        cb()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func ShareAction(_ sender: UIButton) {
        let text = "https://apps.apple.com/in/app/sanskar-tv-app/id1497508487 \n https://play.google.com/store/apps/details?id=com.sanskar.tv"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    @IBAction func notificationButton(_ sender: UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func SendMesssageAction (_ sender : UIButton) {
        
        let str = txtViewChat.text.replacingOccurrences(of: " ", with: "")
        let str2 = str.replacingOccurrences(of: "\n", with: "")
        
        if str2 == ""{
            return
        }
        
        if currentUser.result!.id! == "163"{
            TV_PlayerHelper.shared.mmPlayer.playView = nil
            guard let cb = self.completionBlock2 else {return}
            self.dismiss(animated: true, completion: {
                cb()
            })
        }
        else{
            composeMessage()
        }
        
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            //   txtFieldViewBottomConstraint?.constant = isKeyboardShowing ? keyboardHeight : 0
            if isKeyboardShowing{
                if UIScreen.main.nativeBounds.height > 1920{
                    bottomViewConstraints?.constant = keyboardHeight-15
                }else{
                    bottomViewConstraints?.constant = keyboardHeight-3
                }
            }
            else{
                bottomViewConstraints?.constant = 0
            }
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if self.messageArray.count-1 > 0{
                    let indexPath = NSIndexPath(item: self.messageArray.count-1, section: 0)
                    self.MyTableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelTableArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TBHomePagerCollectionViewCell", for: indexPath) as! TBHomePagerCollectionViewCell
        
        let onePost = channelTableArr[indexPath.row]

        cell.pagerImage.sd_setShowActivityIndicatorView(true)
         cell.pagerImage.sd_setIndicatorStyle(.gray)
         cell.pagerImage.sd_setImage(with: URL(string: onePost.image), placeholderImage:  UIImage(named: "landscape_placeholder"), options: .refreshCached, completed: nil)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let po = channelTableArr[indexPath.row]
        if po.channel_url != "" {
            
            let url = URL(string: po.channel_url)!
            TV_PlayerHelper.shared.mmPlayer.set(url: url)
            TV_PlayerHelper.shared.mmPlayer.playView = TVPlayer
            TV_PlayerHelper.shared.mmPlayer.resume()
            TV_PlayerHelper.shared.mmPlayer.player?.play()
            post = channelTableArr[indexPath.row]
            channelDidChanged()
            observeMessage()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
            UserDefaults.standard.setValue(indexPath.row, forKey: "channelIndex")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80 , height: 60)
        
        
    }
}


extension TB_TVPlayerVC{
    
    func composeMessage()  {
        
        let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel)
        
        print(ref)
        let childRef = ref.childByAutoId()
        
        let currentTimeStamp = Date().toMillis()
        
        if currentUser.result!.id != nil && currentUser.result!.id != "" && currentUser.result!.username != nil && currentUser.result!.username != ""{
            
            let values = [ "from" : currentUser.result!.id!,
                           "img" : currentUser.result!.profile_picture ?? "",
                           "message" : "\(txtViewChat.text!)",
                "name" : currentUser.result!.username!,
                "seen" : false,
                "status":"1",
                "time":currentTimeStamp as Any,
                "type":"text"] as [String : Any]
            
            childRef.updateChildValues(values)
            txtViewChat.text = ""
            Toast.show(message: "Your comment posted successfully", controller: self)
            
        }else{
            AlertController.alert(title: "Username not found", message: "Please Update your profile to continue live chat")
            
            TV_PlayerHelper.shared.mmPlayer.player?.pause()
            
        }
    }
}


extension TB_TVPlayerVC{
    func observeMessage()
    {
        self.messageArray.removeAll()
        self.MyTableView.reloadData()
        
        let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel).queryLimited(toLast: 50)
        ref.removeAllObservers()
        ref.observe(.childAdded, with: { (snapshot) in
            var dic = snapshot.value as? [String: AnyObject]
            
            if self.isTrue == false{
                self.isTrue = true
                return
            }
            
            if dic != nil{
                dic?["key"] = "\(snapshot.key)" as AnyObject
                self.messageArray.append(messageModel(dict: dic!))
                self.MyTableView.reloadData()
                if self.messageArray.count != 0 && self.messageArray.count>=2{
                    let indexPath = NSIndexPath(item: self.messageArray.count-1, section: 0)
                    self.MyTableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
        })
    }
}


// MARK:- Table View Delegate.
extension TB_TVPlayerVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReciever = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
        
        
        cellReciever.reportButton.tag = indexPath.row
        cellReciever.reportButton.addTarget(self, action: #selector(reportActionBtn), for: .touchUpInside)
        let urlString = messageArray[indexPath.row].img
        
        cellReciever.ProfilePic.sd_setIndicatorStyle(.gray)
        cellReciever.ProfilePic.sd_setShowActivityIndicatorView(true)
        cellReciever.ProfilePic.layer.cornerRadius = 25.0
        cellReciever.ProfilePic.clipsToBounds = true
        cellReciever.ProfilePic.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "profile"), options: .refreshCached, completed: nil)
        
        let timeStamp = messageArray[indexPath.row].time
        
        let date = Date(timeIntervalSince1970: Double(Int(timeStamp)!/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate : String = dateFormatter.string(from: date)
        let datenow = dateFormatter.date(from: localDate)
        let timeValue = (datenow)!.getElapsedInterval()
        
        
        cellReciever.TimeLabel.text = timeValue
        cellReciever.messageLabel.text = messageArray[indexPath.row].message
        cellReciever.NameLabel.text = messageArray[indexPath.row].name
        
        return cellReciever
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func reportActionBtn(_ sender:UIButton){
        
        index = sender.tag
        
        if currentUser.result?.id == messageArray[self.index].from{
            let alert = UIAlertController.init(title: "Take Action", message: "", preferredStyle: .actionSheet)
            let Delete = UIAlertAction.init(title: "Delete", style: .default) { (action) in
                print("Delete")
                self.chatKey = self.messageArray[self.index].key
                self.DeleteMessage()
                self.messageArray.remove(at: self.index)
                self.MyTableView.reloadData()
            }
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                print("Cancel")
            }
            alert.addAction(Delete)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        else{
            
            let alert = UIAlertController.init(title: "Take Action", message: "", preferredStyle: .actionSheet)
            let Report = UIAlertAction.init(title: "Report", style: .default) { (action) in
                
                let chat_node = self.messageArray[self.index].key
                let reported_to = self.messageArray[self.index].from
                let message = self.messageArray[self.index].message
                let reported_by = currentUser.result?.id!
                
                var param : Parameters
                param = ["reported_by":reported_by as Any,"reported_to":reported_to,"channel_id":post.id,"node_id":chat_node,"message":message,"fb_channel_id":FirebaseChannel]
                
                self.reportAPI(param: param)
            }
            
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                print("Cancel")
            }
            alert.addAction(Report)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func reportAPI(param : Parameters){
        
        let url = APIManager.sharedInstance.chat_report
        
        self.uplaodData1(url, param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    Toast.show(message: JSON.value(forKey: "message") as? String ?? "reported", controller: self)
                }
            }
        }
    }
    
    func deleteChatAPI(param : Parameters){
        let url = APIManager.sharedInstance.delete_chat_report
        
        self.uplaodData1(url, param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    
                }
            }
        }
    }
    
}

extension TB_TVPlayerVC{
    
    func DeleteMessage()  {
        
        var param : Parameters
        param = ["node_id":chatKey]
        deleteChatAPI(param: param)
        
        isTrue = false
        let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel).child(chatKey)
        ref.removeValue()
        
    }
}


class messageModel:NSObject{
    
    var from = ""
    var img = ""
    var message = ""
    var name = ""
    var seen = ""
    var status = ""
    var time = ""
    var type = ""
    var key = ""
    
    init(dict: [String: AnyObject]) {
         
        self.from    = dict.validatedValue("from")
        self.img     = dict.validatedValue("img")
        self.message = dict.validatedValue("message")
        self.name    = dict.validatedValue("name")
        self.seen    = dict.validatedValue("seen")
        self.status  = dict.validatedValue("status")
        self.time    = dict.validatedValue("time")
        self.type    = dict.validatedValue("type")
        self.key     = dict.validatedValue("key")
        
        
    }
    
}

