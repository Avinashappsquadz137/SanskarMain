//
//  EPGTVVc.swift
//  Sanskar
//
//  Created by Warln on 10/12/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import DropDown
import FittedSheets
import CLTypingLabel

class EPGTVVc: UIViewController {
    
    //MARK: - IBoutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var barcodeBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var notifiLbl: UILabel!
    @IBOutlet weak var programLbl: CLTypingLabel!
    
    //MARK: - Variable
    
    var completionBlock:vCB?
    var completionBlock2:vCB2?
    let dropDown = DropDown()
    var epChannels: [EpChannel]?
    var days : [Any] = []
    var channelIndex : Int?
    var programIndex : Int?
    var didiselect : Bool = false
    var sDate: String = ""
    var timeIndex: Int = 0
    var start: Int64 = 0
    var end: Int64 = 0
    var extact: Int64 = 0
    var cStatus: Bool = false
    var bandwidthArray = [String]()
    var resolutionArray = [String]()
    var videoDict : [String : Any] = [:]
    var dateUpdate: Bool = false
    var extDate : String = ""
    var timeIntervals: [String] {
        return [
            "", "00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
            "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "24:00"
        ]
    }
    var timedata: [String] {
        return [
            "00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
            "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "24:00",""
        ]
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let epgNib = UINib(nibName: "epgCell", bundle: Bundle.main)
        collectionView.register(epgNib, forCellWithReuseIdentifier: "epgCell")
        
        let timeNib = UINib(nibName: "timeCell", bundle: Bundle.main)
        collectionView.register(timeNib, forCellWithReuseIdentifier: "timeCell")
        
        let channelNib = UINib(nibName: "channelCell", bundle: Bundle.main)
        collectionView.register(channelNib, forCellWithReuseIdentifier: "channelCell")
        
        let programNib = UINib(nibName: "programCell", bundle: Bundle.main)
        collectionView.register(programNib, forCellWithReuseIdentifier: "programCell")
        
        let param: Parameters = ["user_id":currentUser.result!.id!]
        getData(param)
        epgPlay = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.epgReceivedNotification(notification:)), name: Notification.Name("epgPixelSheet"), object: nil)
        
        
    }
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifiLbl.layer.cornerRadius = notifiLbl.frame.size.width / 2
        notifiLbl.clipsToBounds = true
        dropDownBtn.backgroundColor = UIColor.clear
        dropDownBtn.layer.cornerRadius = dropDown.layer.frame.height / 5
        dropDownBtn.clipsToBounds = true
        
    }
    
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if days.count > 0 {
            let numb = UserDefaults.standard.integer(forKey: "channelNumb")
            let chUrl = (days[6] as? [[String:Any]] ?? [[:]])[numb]["channel_url"] as? String ?? ""
            let chImg = (days[6] as? [[String:Any]] ?? [[:]])[numb]["image"] as? String ?? ""
            extDate = (days[6] as? [[String:Any]] ?? [[:]])[numb]["release_date"] as? String ?? ""
            sDate = extDate
            dropDownBtn.setTitle(sDate, for: .normal)
            addPlayer(for: chUrl, image: chImg)
        }
        extact = Int64(exactTime())
        currentStatus()
        getLive()
        let index = IndexPath(row: timeIndex, section: 0)
        collectionView.reloadData()
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - IBAction Button Pressed
    
    @IBAction func barcodeBtnPressed(_ sender: UIButton) {
        if qrStatus == "1"{
            if currentUser.result!.id! == "163"{
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannerControl") as! ScannerControl
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            
        }
        
        
    }
    
    @IBAction func notificationBtn( _ sender: UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        let text = "https://sanskargroup.page.link/"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonActionPressed(_ sender: UIButton) {
        
        TV_PlayerHelper.shared.mmPlayer.setOrientation(.protrait)
        TV_PlayerHelper.shared.mmPlayer.playView = nil
        guard let cb = self.completionBlock else {return}
        cb()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func dropDowmButtonPressed(_ sender: UIButton) {
        
        var dayData : [String] = []
        for index in 0..<days.count {
            dayData.append((days[index] as? [[String:Any]] ?? [[:]])[0]["release_date"] as? String ?? "")
            
        }
        
        dropDown.dataSource = dayData
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height / 2)
        dropDown.show()
        self.epChannels?.removeAll()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.epgUpdate(index)
            sender.setTitle(item, for: .normal) //9
            //            DispatchQueue.main.async {
            //                let layout = EPGColletionViewFlowLayout()
            //                layout.epChannels = self?.epChannels
            //                self?.collectionView.setCollectionViewLayout(layout, animated: false)
            //            }
            self!.sDate = item
            self!.currentStatus()
            if self!.cStatus {
                let index = IndexPath(row: self!.timeIndex, section: 0)
                self!.collectionView.reloadData()
                self!.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }else{
                let index = IndexPath(row: 0, section: 0)
                self!.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self!.collectionView.reloadData()
            }
            
        }
        
    }
    
    func updateUI() {
        collectionView.backgroundColor = UIColor.lightGray
        let layout = EPGColletionViewFlowLayout()
        layout.epChannels = self.epChannels
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    //MARK: - Get Data from Api
    
    func getData(_ param: Parameters) {
        
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodData1(APIManager.sharedInstance.tvGuide, param) { response in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            print(response as Any)
            self.days.removeAll()
            if let Json = response as? [String:Any] {
                print(Json)
                if Json["status"] as? Bool == true {
                    self.days = Json["Days"] as? [Any] ?? []
                    if self.days.count > 0 {
                        if let channelArr = self.days[0] as? [[String:Any]] {
                            self.epChannels = [EpChannel]()
                            for channelItem in channelArr {
                                print(channelItem)
                                let id = channelItem["id"] as? String ?? ""
                                let name = channelItem["name"] as? String ?? ""
                                let channlUrl = channelItem["channel_url"] as? String ?? ""
                                let image = channelItem["image"] as? String ?? ""
                                let channel = EpChannel(id: id, name: name, channelUrl: channlUrl, imageUrl: image)
                                self.epChannels?.append(channel)
                                if let programData = channelItem["Events"] as? [[String: Any]] {
                                    channel.programs = [Program]()
                                    for item in programData {
                                        print(item)
                                        let title = item["program_title"] as? String ?? ""
                                        let start = (item["start_time_milliseconds"] as? Int ?? 0) / 1000
                                        let end = (item["end_time_milliseconds"] as? Int ?? 0) / 1000
                                        let program = Program(title: title, schedule: Schedule(start: TimeInterval(start), end: TimeInterval(end)))
                                        channel.programs?.append(program)
                                    }
                                }
                            }
                        }else{
                            if let _ = self.epChannels {
                                print(self.epChannels as Any)
                            }
                        }
                    }
                    
                }else{
                    print(Error.self)
                }
            }
            self.updateUI()
            self.collectionView.reloadData()
            
            //            let index = IndexPath(row: 25, section: 0)
            //            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            
        }
        
    }
    
    //MARK: - Play video
    
    func epgUpdate(_ index: Int) {
        
        if let channelArr = self.days[index] as? [[String:Any]] {
            self.epChannels = [EpChannel]()
            for channelItem in channelArr {
                print(channelItem)
                let id = channelItem["id"] as? String ?? ""
                let name = channelItem["name"] as? String ?? ""
                let channlUrl = channelItem["channel_url"] as? String ?? ""
                let image = channelItem["image"] as? String ?? ""
                let channel = EpChannel(id: id, name: name, channelUrl: channlUrl, imageUrl: image)
                self.epChannels?.append(channel)
                if let programData = channelItem["Events"] as? [[String: Any]] {
                    channel.programs = [Program]()
                    for item in programData {
                        print(item)
                        let title = item["program_title"] as? String ?? ""
                        let start = (item["start_time_milliseconds"] as? Int ?? 0) / 1000
                        let end = (item["end_time_milliseconds"] as? Int ?? 0) / 1000
                        let program = Program(title: title, schedule: Schedule(start: TimeInterval(start), end: TimeInterval(end)))
                        channel.programs?.append(program)
                    }
                }
            }
            
        }else{
            if let _ = self.epChannels {
                print(self.epChannels as Any)
            }
        }
        
        
    }
    
    func addPlayer(for url: String,image: String) {
        
        let current = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -12, to: current)
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var dateform = dformat.string(from: oneHourAgo!)
        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
        print(dateform)
        let urlString =  "\(url)?start=\(dateform)&end="
        quality(hlsUrl: urlString, image: image)
        
    }
    
    func playVideo(index: Int ) {
        
        if let channel = epChannels?[index] {
            let current = Date()
            let oneHourAgo = Calendar.current.date(byAdding: .hour, value: 0, to: current)
            let dformat = DateFormatter()
            dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            var dateform = dformat.string(from: oneHourAgo!)
            dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
            let dateSub = dateform.subString(from: 0, to: 10)
            let imgUrl = channel.imageUrl
            var urlString: String = ""
            if dateSub == sDate {
                urlString = "\(channel.channelUrl)?start=\(sDate)T00:00:00+05:30&end="
                epgLive = true
            }else{
                urlString = "\(channel.channelUrl)?start=\(sDate)T00:00:00+05:30&end=\(sDate)T24:00:00+05:30"
            }
            quality(hlsUrl: urlString, image: imgUrl)
            
        }
        
    }
    
    
    func videoTime (section: Int, row: Int) {
        
        if section == channelIndex {
            if let channel = self.epChannels?[section] {
                if extDate == sDate {
                    if let program = channel.programs?[row] {
                        let progTime = "\(program.startDate)"
                        let cutTime = progTime.subString(from: 11, to: 19)
                        let newTime = cutTime.secondFromString
                        programLbl.text = program.title
                        TV_PlayerHelper.shared.mmPlayer.player?.seek(to: CMTimeMake(Int64(newTime), 1))
                    }
                }else{
                    let current = Date()
                    let oneHourAgo = Calendar.current.date(byAdding: .hour, value: 0, to: current)
                    let dformat = DateFormatter()
                    dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    var dateform = dformat.string(from: oneHourAgo!)
                    dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                    let dateSub = dateform.subString(from: 0, to: 10)
                    let imgUrl = channel.imageUrl
                    var urlString: String = ""
                    if dateSub == sDate {
                        urlString = "\(channel.channelUrl)?start=\(sDate)T00:00:00+05:30&end="
                        epgLive = true
                    }else{
                        urlString = "\(channel.channelUrl)?start=\(sDate)T00:00:00+05:30&end=\(sDate)T24:00:00+05:30"
                    }
                    quality(hlsUrl: urlString, image: imgUrl)
                    channelIndex = section
                    sDate = extDate
                }
                
            }
        }else{
            if let channel = self.epChannels?[section]{
                if let program = channel.programs?[row] {
                    let progTime = "\(program.startDate)"
                    let cutTime = progTime.subString(from: 11, to: 19)
                    let newTime = cutTime.secondFromString
                    
                    let current = Date()
                    let oneHourAgo = Calendar.current.date(byAdding: .hour, value: 0, to: current)
                    let dformat = DateFormatter()
                    dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    var dateform = dformat.string(from: oneHourAgo!)
                    dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
                    let dateSub = dateform.subString(from: 0, to: 10)
                    let imgUrl = channel.imageUrl
                    var urlString: String = ""
                    if dateSub == sDate {
                        urlString = "\(channel.channelUrl)?start=\(sDate)T00:00:00+05:30&end="
                        epgLive = true
                    }else{
                        urlString = "\(channel.channelUrl)?start=\(sDate)T00:00:00+05:30&end=\(sDate)T24:00:00+05:30"
                    }
                    quality(hlsUrl: urlString, image: imgUrl)
                    channelIndex = section
                }
            }
        }
        
    }
    
    
}

//MARK: - Quality controller
extension EPGTVVc : GetVideoQualityList{
    
    func quality(hlsUrl : String, image: String){
        DispatchQueue.main.async {
            guard let content = URL(string: hlsUrl) else {return}
            _ = self.getUrl(urlStrin: hlsUrl)
            let urlAsset = AVURLAsset(url: content)
            TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
            TV_PlayerHelper.shared.mmPlayer.player?.seek(to: kCMTimeZero)
            TV_PlayerHelper.shared.mmPlayer.set(url: content)
            TV_PlayerHelper.shared.mmPlayer.playView = self.playerView
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredMaximumResolution = CGSize(width: 1280, height: 720)
            TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = 0
            TV_PlayerHelper.shared.mmPlayer.resume()
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
            TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
            TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
            TV_PlayerHelper.shared.mmPlayer.player?.play()
            let url = URL(string: image)!
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    TV_PlayerHelper.shared.mmPlayer.thumbImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func getUrl(urlStrin:String) -> [String]{
        let subUrl = [String](repeating: "", count: 4)
        if let url = URL(string: urlStrin) {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                
                var resolution = contents.components(separatedBy: "RESOLUTION=")
                
                resolution.remove(at: 0)
                
                for dic in resolution {
                    let str = dic.components(separatedBy: ",")
                    resolutionArray.append(str[0])
                }
                
                var bandwith = contents.components(separatedBy: "AVERAGE-BANDWIDTH=")
                bandwith.remove(at: 0)
                
                
                for dic in bandwith {
                    let str = dic.components(separatedBy: ",")
                    self.bandwidthArray.append(str[0])
                }
                return subUrl
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        return subUrl
    }
    
    @objc func epgReceivedNotification(notification: Notification)
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
        TV_PlayerHelper.shared.mmPlayer.player?.currentItem?.preferredPeakBitRate = Double(self.bandwidthArray[bitrate])!
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
}

extension EPGTVVc: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let count = epChannels?.count {
            return count + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return timeIntervals.count
        }else{
            if let count = epChannels?[section - 1].programs?.count {
                return count + 1
            }
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "epgCell", for: indexPath) as? epgCell else {
            return UICollectionViewCell()
        }
        cell.titleLbl.text = ""
        
        if indexPath.section == 0 {
            guard let timeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as? timeCell else {
                return UICollectionViewCell()
            }
            let index = indexPath.row
            let time = timeIntervals[indexPath.row]
            if cStatus {
                if index == timeIndex && index != 0{
                    timeCell.liveLbl.text = "Live"
                    timeCell.liveBtn.tag = indexPath.row
                }else{
                    timeCell.liveLbl.text?.removeAll()
                }
            }else{
                timeCell.liveLbl.text?.removeAll()
            }
            
            timeCell.timeLbl.text = time
            timeCell.liveBtn.addTarget(self, action: #selector(EPGTVVc.onClickedMapButton(_:)), for: .touchUpInside)
            return timeCell
        }else{
            if indexPath.row == 0 {
                guard let channelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath) as? channelCell else{
                    return UICollectionViewCell()
                }
                if let channel = self.epChannels?[indexPath.section - 1 ] {
                    channelCell.configureWith(epChannel: channel)
                }
                return channelCell
            }else{
                if let channel = self.epChannels?[indexPath.section - 1] {
                    if let program = channel.programs?[indexPath.row - 1] {
                        guard let programCell = collectionView.dequeueReusableCell(withReuseIdentifier: "programCell", for: indexPath) as? programCell else {
                            return UICollectionViewCell()
                        }
                        programCell.configureWith(program: program)
                        return programCell
                    }
                }
            }
            
        }
        
        return cell
        
    }
    
}

//MARK: - CollectionView Delagte

extension EPGTVVc: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        }else if indexPath.row == 0 {
            channelIndex = indexPath.section - 1
            playVideo(index: channelIndex!)
            
        }else{
            let secIndex = indexPath.section - 1
            programIndex = indexPath.row - 1
            videoTime(section: secIndex, row: programIndex!)
            
        }
        
    }
    
}

//MARK: - Extra functionallity

extension EPGTVVc {
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag != 0 {
            
        }
        
    }
    
    func currentTimeInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970)
    }
    
    
    func currentTimeInMilisec(_ cDate: Date) -> Int {
        let currentDate = cDate
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970)
    }
    

    
    func getLive () {
        
        for index in 0..<timeIntervals.count {
            let time = timeIntervals[index]
            if time == "" {
                start = 0
                end = 0
            }else if time == "24:00"{
                start = 0
                end = 0
            }else{
                start = Int64(time.timeFromString)
                end = Int64(timedata[index].timeFromString)
                for i in start..<end{
                    if extact == i {
                        timeIndex = index
                        break
                    }
                }
            }
            
        }
        
    }
    
    func currentDate() -> String {
        let current = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: 0, to: current)
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateform = dformat.string(from: oneHourAgo!)
        return dateform
    }
    
    func currentStatus () {
        let now = Date()
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd"
        let dateform = dformat.string(from: now)
        if dateform == sDate {
            cStatus = true
        }else{
            cStatus = false
        }
    }
}

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
}


