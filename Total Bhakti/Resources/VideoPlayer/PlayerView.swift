

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
}

import UIKit
import AVFoundation
import MMPlayerView
import CoreData
import CircleProgressView
import GoogleCast
import Firebase
import SDWebImage



class PlayerView: UIView,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,GCKRequestDelegate,UITextViewDelegate {
    
    //MARK: IBOutlets
    var tapGesture: UITapGestureRecognizer!
    var offsetObservation: NSKeyValueObservation?
    
    var mmPlayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var tableView                      : UITableView!
    @IBOutlet weak var minimizeButton                 : UIButton!
    @IBOutlet weak var player                         : UIView!
    @IBOutlet weak var channelInfoView                : UIView!
    @IBOutlet weak var textFiledView                  : UIView!
    @IBOutlet weak var txtViewChat                    : GrowingTextView!
    @IBOutlet weak var txtFieldViewBottomConstraint   : NSLayoutConstraint!
    
    @IBOutlet weak var prifile_img   : UIImageView!
    
    
    var messageArray : [messageModel] = []
 
    //MARK:- ALL Variable.
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    var videoPlayer = AVPlayer()
    var viewcontroller = UIViewController()
    var relatedVidos = [videosResult]()
    var arrChannel = [ChannelsData]()
    var dataToShow : videosResult!
    var isLike = ""
    var totalLikes = Int()
    var videoId = String()
    var originalSize: CGSize!
    var originalPlayerSize: CGRect!
    var isDowloadingInQueue : Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrDownloadVideos = [TBVideos]()
    
    var isselected = Bool()
    
    @objc func showOptions(){
        optionsView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.optionsView.isHidden = true
        }
        
    }
    
    @IBAction func ShareAction(_ sender:UIButton){
        
        let text = "https://apps.apple.com/in/app/sanskar-tv-app/id1497508487"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(activity, animated: true, completion: nil)
        }
    }
    
    @objc func didPlayHome()
    {
        self.mmPlayer.player?.pause()
    }
    
    func customization() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("open"), object: nil)
        
        // Exit player view
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapExitPlayView), name: NSNotification.Name("ExitVideoView"), object: nil)
        
        
        self.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.player.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        originalSize = self.frame.size
        originalPlayerSize = self.player.frame
        
        
    }
    
    // When Player View Exit
    
    @objc func tapExitPlayView()  {
        self.delegate?.didEndedSwipe(toState: stateOfVC.hidden)
        mmPlayer.player?.replaceCurrentItem(with: nil)
        mmPlayer.isHidden = true
    }
    
    @objc func tapPlayView(notification: NSNotification){
        
        if let profileUrl = currentUser.result!.profile_picture, profileUrl != ""{
            prifile_img.contentMode = .scaleAspectFill
            prifile_img.sd_setShowActivityIndicatorView(true)
            prifile_img.sd_setIndicatorStyle(.gray)
            prifile_img.sd_setImage(with: URL(string: profileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, placeholderImage: UIImage(named: "profile"), options: .refreshCached, completed: nil)
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
        MusicPlayerManager.shared.isPaused = true
        MusicPlayerManager.shared.myPlayer.pause()
        
        if let dic = notification.userInfo?["sucess"] as? Channel
        {
            
            relatedVidos = []
            arrChannel = []
            
            let url = URL.init(string: dic.channel_url!)!
            
            UserDefaults.standard.setValue(dic.channel_url!, forKey: "channel")
            mmPlayer.isHidden = false
            mmPlayer.set(url: url)
            mmPlayer.playView = player
            mmPlayer.resume()
            mmPlayer.player?.play()
            channelInfoView.isHidden = false
            textFiledView.isHidden = false
            self.state = .fullScreen
            self.delegate?.didmaximize()
            
        }
    }
    
    @objc func tapPlayViewReconizer()  {
        channelInfoView.isHidden = false
        textFiledView.isHidden = false
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.minimizeButton.alpha =  1
        self.tapGesture = nil
    }
    
    @IBAction func minimize(_ sender: UIButton) {
        channelInfoView.isHidden = true
        textFiledView.isHidden = true
        self.tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayViewReconizer))
        self.mmPlayer.playView?.addGestureRecognizer(self.tapGesture)
        self.state = .minimized
        self.delegate?.didMinimize()
        self.minimizeButton.alpha =  0
    }
    
    func minimizeWhenGOtoLoginOrUpdateProfile(){
        channelInfoView.isHidden = true
        textFiledView.isHidden = true
        self.tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayViewReconizer))
        self.mmPlayer.playView?.addGestureRecognizer(self.tapGesture)
        self.state = .minimized
        self.delegate?.didMinimize()
        self.minimizeButton.alpha =  0
        
        
        
    }
    
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        self.endEditing(true)
        
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
                channelInfoView.isHidden = false
                textFiledView.isHidden = false
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
            channelInfoView.isHidden = true
            textFiledView.isHidden = true
            self.minimizeButton.alpha =  1
            self.tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayViewReconizer))
            self.mmPlayer.playView?.addGestureRecognizer(self.tapGesture)
            
            
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
                channelInfoView.isHidden = false
                textFiledView.isHidden = false
                self.mmPlayer.playView?.removeGestureRecognizer(self.tapGesture)
                
                
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            
            self.delegate?.didEndedSwipe(toState: self.state)
            self.minimizeButton.alpha = 0
            if self.state == .hidden {
                mmPlayer.player?.replaceCurrentItem(with: nil)
            }
        }
    }
    @IBAction func TVChannelList (_ sender : UIButton) {
        
        let alert = UIAlertController.init(title: "ALL CHANNEL", message: "", preferredStyle: .actionSheet)
        for i in 0...channelTableArr.count-1{
            
            let channelName = channelTableArr[i].name ?? "Sanskar"
            
            let AlertAction = UIAlertAction.init(title: channelName, style: .default) { (action) in
                let index = alert.actions.index(of: action) ?? 0
                
                let url = channelTableArr[index].channel_url
                guard let UrlStr = url else{ return }
                UserDefaults.standard.setValue(UrlStr, forKey: "channel")
                
                let url2 = URL(string: UrlStr)!
                self.observeNewChannel()
                
                self.mmPlayer.player?.pause()
                self.mmPlayer.set(url: url2)
                self.mmPlayer.resume()
                self.mmPlayer.player?.play()
                
            }
            
            
            alert.addAction(AlertAction)
            
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
            
        }
        
        alert.addAction(cancel)
        
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    //MARK:- relatedViewHit.
    func relatedVideosHit(_ param : Parameters) {
        loader.shareInstance.hideLoading()
        viewcontroller.uplaodData(APIManager.sharedInstance.KRELATEDVIDEOINVIDEOAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        self.relatedVidos = videosResult.modelsFromDictionaryArray(array: result)
                        if self.relatedVidos.count != 0 {
                            self.tableView.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- getAllChannelAPI.
    func getAllChannel(_ param : Parameters)
    {
        loader.shareInstance.hideLoading()
        viewcontroller.uplaodData(APIManager.sharedInstance.kAllTVCHANNELAPI, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "channel") as? NSArray {
                        print(result)
                        self.arrChannel = ChannelsData.modelsFromDictionaryArray(array: result)
                    }
                }
            }
        }
    }
    
    
    
    //MARK:- Download all audio data.
    func downloadVideo()
    {
        if self.isDowloadingInQueue == true
        {
            //   self.downloadBtn.isUserInteractionEnabled = false
            _ = SweetAlert().showAlert("", subTitle: "video is already added on Queue", style: AlertStyle.error)
            return
        }
        let tempData = dataToShow
        
        let context = appDelegate.persistentContainer.viewContext
        if let tempVideo = try? context.fetch(TBVideos.fetchRequest()) as? [TBVideos] {
            
            if let theVideo = tempVideo {
                
                let tempVideourl = dataToShow.video_url?.components(separatedBy: ".com")
                let source = "http://52.204.183.54:1935/vods3/"+"_definst_/mp4:amazons3/bhaktiappproduction" + (tempVideourl?[1])! + "/playlist.m3u8"
                
                if let VideoUrl = URL(string: source) {
                    // then lets create your document folder url
                    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    // lets create your destination file url
                    let destinationUrl = documentsDirectoryURL.appendingPathComponent(VideoUrl.lastPathComponent)
                    print(destinationUrl)
                    
                    for dic in tempVideo!
                    {
                        if dic.id == dataToShow.id
                        {
                            //                            self.downloadBtn.isUserInteractionEnabled = true
                            _ = SweetAlert().showAlert("", subTitle: "This Video Already Downloaded", style: AlertStyle.success)
                            return
                            
                        }
                    }
                    
                    // to check if it exists before downloading it
                    if FileManager.default.fileExists(atPath: destinationUrl.path) {
                        print("The file already exists at path")
                        //                        self.downloadBtn.isUserInteractionEnabled = true
                        
                        _ = SweetAlert().showAlert("", subTitle: "This Video Already Downloaded", style: AlertStyle.success)
                    }
                    else
                    {
                        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
                        Alamofire.download(dataToShow.video_url as! URLConvertible , method: .get, parameters: nil,encoding: JSONEncoding.default,headers: nil,to: destination).downloadProgress(closure: { (progress) in
                            
                            self.isDowloadingInQueue = true
                            //                            self.downloadBtn.isUserInteractionEnabled = true
                            
                            if tempData?.id == self.dataToShow.id
                            {
                                //                                self.downloadProgress.isHidden = false
                                //                                self.downloadProgress.progress = Double(progress.fractionCompleted)
                            }
                            //    self.downloadBtn.isUserInteractionEnabled = false
                            //progress closure
                            print(progress)
                        }).response(completionHandler: { (DefaultDownloadResponse) in
                            //here you able to access the DefaultDownloadResponse
                            //result closure
                            
                            if self.isDowloadingInQueue == true
                            {
                                self.isDowloadingInQueue = false
                            }
                            
                            if DefaultDownloadResponse.error != nil
                            {
                                //                                self.downloadProgress.progress = 0.00
                                return
                            }
                            //                            self.downloadProgress.progress = 0.00
                            
                            let userEntity = NSEntityDescription.entity(forEntityName: "TBVideos", in: context)!
                            let video = NSManagedObject(entity: userEntity, insertInto: context)
                            
                            video.setValue(tempData!.id, forKeyPath: "id")
                            video.setValue(tempData!.video_title, forKey: "video_title")
                            let urlString: String =  (DefaultDownloadResponse.destinationURL?.path)!
                            video.setValue(urlString, forKey: "video_url")
                            
                            print(urlString)
                            
                            video.setValue(tempData!.author_name, forKey: "author_name")
                            video.setValue(tempData!.thumbnail_url, forKey: "thumbnail_url")
                            video.setValue(tempData!.video_desc, forKey: "video_desc")
                            
                            if self.dataToShow.id == tempData?.id
                            {
                                //                                self.downloadBtn.setImage(UIImage(named: "download_complete.png"), for: .normal)
                            }
                        })
                    }
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                    
                }
            }
            
        }
        
    }
    
    
    func shareData() {
        var image = UIImage()
        let textToShare = NSMutableArray(array: [dataToShow.video_title,dataToShow.video_desc])
        if let imageUrl = dataToShow.thumbnail_url {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!)
            image = UIImage(data: data!)!
            textToShare.add(image)
            let activityControler  = UIActivityViewController(activityItems: textToShare as! [Any], applicationActivities: nil)
            //     activityControler.popoverPresentationController?.sourceView = self.view //so that iPads won't crash
            // exclude some activity types from the list (optional)
            activityControler.excludedActivityTypes = [ UIActivityType.airDrop ,UIActivityType.postToFacebook , UIActivityType.mail, UIActivityType.message , UIActivityType.postToTwitter]
            //            present(activityControler, animated: true, completion: nil).
            
            if let window = UIApplication.shared.keyWindow {
                
                window.rootViewController?.present(activityControler, animated: true, completion: nil)
            }
            
            
        }else  {
            let activityControler  = UIActivityViewController(activityItems: textToShare as! [Any], applicationActivities: nil)
            activityControler.popoverPresentationController?.sourceView = self //so that iPads won't crash
            // exclude some activity types from the list (optional)
            activityControler.excludedActivityTypes = [ UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo ]
            //self.present(activityControler, animated: true, completion: nil)
            if let window = UIApplication.shared.keyWindow {
                window.rootViewController?.present(activityControler, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func SendMesssageAction (_ sender : UIButton) {
        
        let str = txtViewChat.text.replacingOccurrences(of: " ", with: "")
        let str2 = txtViewChat.text.replacingOccurrences(of: "\n", with: "")
        
        if currentUser.result!.id! == "163"{
            self.mmPlayer.player?.pause()
            minimizeWhenGOtoLoginOrUpdateProfile()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openVC"), object: nil)
        }
        else{
            if str != "" && str2 != ""{
                composeMessage()
            }
        }
        
    }
    
    
    //MARK: View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
        
        optionsView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(showOptions))
        
        mmPlayer.coverView?.addGestureRecognizer(tapGesture)
        
        
        
        FirebaseChannel = "sanskarTV"
        
        tableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tableView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(observeNewChannel), name: NSNotification.Name("ObserveNewChannel"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
    }
    @objc func observeNewChannel(){
        observeMessage()
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            //   txtFieldViewBottomConstraint?.constant = isKeyboardShowing ? keyboardHeight : 0
            if isKeyboardShowing{
                if UIScreen.main.nativeBounds.height > 1920{
                    txtFieldViewBottomConstraint?.constant = keyboardHeight-15
                }else{
                    txtFieldViewBottomConstraint?.constant = keyboardHeight-3
                }
            }
            else{
                txtFieldViewBottomConstraint?.constant = 0
            }
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: { (completed) in
                if self.messageArray.count-1 > 0{
                    let indexPath = NSIndexPath(item: self.messageArray.count-1, section: 0)
                    self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            })
        }
    }
}


//MARK:- update data with delegate.
extension PlayerView : commentVCDelegate {
    func updateCommnetValue(_ string: String) {
        
        if string == "" {
            //            self.commentsCount.text = "No comment yet.."
        }else if string == "1"{
            //            self.commentsCount.text = "View \(string) comment"
        }else {
            //            self.commentsCount.text = "View all \(string) comments"
        }
        
    }
}

// MARK:- Table View Delegate.
extension PlayerView{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReciever = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
        
        let urlString = messageArray[indexPath.row].img
        
        cellReciever.ProfilePic.sd_setIndicatorStyle(.gray)
        cellReciever.ProfilePic.sd_setShowActivityIndicatorView(true)
        cellReciever.ProfilePic.layer.cornerRadius = 15.0
        cellReciever.ProfilePic.clipsToBounds = true
        cellReciever.ProfilePic.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "profile-1"), options: .refreshCached, completed: nil)
        
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
    
}

extension PlayerView{
    
    func composeMessage()  {
        
        let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel)
        
        print(ref)
        let childRef = ref.childByAutoId()
        
        let currentTimeStamp = Date().toMillis()
        
        if currentUser.result!.id != nil && currentUser.result!.id != "" && currentUser.result!.username != nil && currentUser.result!.username != ""{
            
            let values = [ "from" : currentUser.result?.id ?? "",
                           "img" : currentUser.result!.profile_picture ?? "",
                           "message" : "\(txtViewChat.text!)",
                "name" : currentUser.result!.username!,
                "seen" : false,
                "status":"1",
                "time":currentTimeStamp as Any,
                "type":"text"] as [String : Any]
            
            childRef.updateChildValues(values)
            txtViewChat.text = ""
            
        }else{
            AlertController.alert(title: "Username not found", message: "Please Update your profile to continue live chat")
             minimizeWhenGOtoLoginOrUpdateProfile()
            self.mmPlayer.player?.pause()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openVC"), object: nil)
            
        }
    }
}
extension PlayerView{
    func observeMessage()
    {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ObserveNewChannel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observeNewChannel), name: NSNotification.Name("ObserveNewChannel"), object: nil)
        
        self.messageArray.removeAll()
        self.tableView.reloadData()
        
        let ref = FIRDatabase.database().reference().child("sanskarliveChannels").child(FirebaseChannel).queryLimited(toLast: 100)
        ref.removeAllObservers()
        ref.observe(.childAdded, with: { (snapshot) in
            let dic = snapshot.value as? [String: AnyObject]
            
            if dic != nil{
                self.messageArray.append(messageModel(dict: dic!))
                self.tableView.reloadData()
                if self.messageArray.count != 0 && self.messageArray.count>=2{
                    let indexPath = NSIndexPath(item: self.messageArray.count-1, section: 0)
                    self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
        })
    }
}




extension UIViewController{
    
    func notificationForChatDecision(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginOrProfileVC), name: NSNotification.Name("openVC"), object: nil)
    }
    
    @objc func loginOrProfileVC(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("openVC"), object: nil)
        
        let NavVc = navigationController?.topViewController
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
//                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                NavVc?.navigationController?.pushViewController(vc, animated: true)
//                NavVc?.view.endEditing(true)
            }
            
        }else{
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPROFILEVC)
            NavVc?.navigationController?.pushViewController(vc, animated: true)
            NavVc?.view.endEditing(true)
            
        }
        notificationForChatDecision()
    }
}

