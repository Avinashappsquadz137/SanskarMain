//
//  MXVc.swift
//  Sanskar
//
//  Created by Warln on 07/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import MarqueeLabel
import FittedSheets
import SDWebImage
import CoreData



class MXVc: UIViewController {
    //MARK: - IBoutlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var programCollectionView: UICollectionView!
    @IBOutlet weak var channelCollectionView: UICollectionView!
    @IBOutlet weak var programName: MarqueeLabel!
    @IBOutlet weak var dateName: UILabel!
    @IBOutlet weak var chImage: UIImageView!
    
    //Variable
    let flowLayout = ZoonAndSnapLayout()
    let cLayout = ChannelFlowLayout()
    var mxModel : MxModel?
    var mxDays: Observable<[MXDays]> = Observable([])
    var mxEvent: Observable<[MxEvents]> = Observable([])
    var timer = Timer()
    var current: Int?
    var index: Int?
    var sDate: String?
    var nDay: Int?
    var cStatus: Bool = false
    var extact: Int = 0
    var timeIndex: Int = 0
    var bandwidthArray = [String]()
    var resolutionArray = [String]()
    var videoDict : [String : Any] = [:]
    var from: String = ""
    var collect:Bool = false
    var change: Bool = false
    var completionBlock:vCB?
    var completionBlock2:vCB2?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProgram()
        getChannel()
        hitData()
        chImage.isHidden = true
        epgPlay = true
        
        mxDays.bind { [weak self] safeData in
            
            DispatchQueue.main.async {

                if (safeData?.count ?? 0) != 0 {
                    self?.playCurrent()
                }
                self?.channelCollectionView.reloadData()
                self?.programCollectionView.reloadData()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            //self.setDataWithTime()
            self.programCollectionView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5.0) {
            if currentUser.result?.id == "163" {
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
                    }else{
//                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }

            }else{
                
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
        epgPlay = false
        liveTap = "tap"
        
    }
    
    //MARK: - collectionview attachment
    func getProgram() {
        
        programCollectionView.dataSource = self
        if #available(iOS 13.0, *) {
            programCollectionView.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        programCollectionView.collectionViewLayout = flowLayout
        programCollectionView.contentInsetAdjustmentBehavior = .always
        programCollectionView.register(UINib(nibName: "MxProgramCell", bundle: nil), forCellWithReuseIdentifier: "MxProgramCell")
        extact = exactTime()
        let number = UserDefaults.standard.value(forKey: "channelNumb") as? Int
        if let numb = number {
            current = numb
        }else{
            current = 0
        }
        
        programName.type = .continuous
        programName.animationCurve = .easeOut
        programName.holdScrolling = false
        programName.unpauseLabel()
    }
    
    func getChannel() {
        
        channelCollectionView.dataSource = self
        channelCollectionView.delegate = self
        if #available(iOS 13.0, *) {
            channelCollectionView.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        channelCollectionView.collectionViewLayout = cLayout
        channelCollectionView.register(UINib(nibName: "MxChannelCell", bundle: nil), forCellWithReuseIdentifier: "MxChannelCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.MxReceivedNotification(notification:)), name: Notification.Name("epgPixelSheet"), object: nil)
        
    }
    
    func startTimer(_ tIndex: Int) {
        //MARK: TIMER EXECUTION  just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer.invalidate()
        var numb = tIndex
        guard let end = mxEvent.value?[numb].end_time_milliseconds else { return }
        guard let total = mxEvent.value?[numb].duration_milliseconds else { return }
        let ePoint = end / 1000
        let sPoint = total / 1000
        var duration = 3600
        if ePoint > extact {
            duration =  (ePoint -  extact)
            
        }else{
            duration = sPoint
        }
        timer = Timer.scheduledTimer(withTimeInterval: Double(duration), repeats: true) { [weak self] _ in
            // do something here
            numb = numb + 1
            if self?.from == "cell"{
                self?.index = numb
                self?.timeIndex = numb
            }else if self?.from == "load"{
                self?.timeIndex = numb
            }
            print("TIME CROSSED : \(self?.timer.timeInterval)")
            self?.programCollectionView.reloadData()
            guard let newTime = self?.mxEvent.value?[numb].start_time_milliseconds else {return}
            self?.extact = (newTime / 1000)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self?.programCollectionView.scrollToItem(at: IndexPath(row: numb, section: 0), at: .centeredHorizontally, animated: true)
            }
            
        }
    }
    
    //MARK: - HTTP Request to get data
    func hitData() {
        
        var dict = Dictionary<String,Any>()
        dict["user_id"] = currentUser.result?.id ?? "163"
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        HttpHelper.apiCallWithout(postData: dict as NSDictionary,
                                  url: APIManager.sharedInstance.tvGuide,
                                  identifire: "") { result, response, error, data in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            if let Json = data,(response?["status"] as? Bool == true), response != nil {
                print(Json)
                let decoder = JSONDecoder()
                do{
                    let safeData = try decoder.decode(MxModel.self, from: Json)
                    self.mxModel = safeData
                    print(self.mxModel)
                    self.setdata(safeData)
                    print(self.setdata(safeData))
                    
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func hitPlayTime(_ parm: Parameters) {
        
        uplaodData1(APIManager.sharedInstance.playTime, parm) { response in
            if let Json = response as? NSDictionary {
                if Json["status"] as? Bool == true {
                    print(Json["status"] as Any)
                }
            }
        }
        
    }
    
    
    
    func setdata(_ model: MxModel?) {
        nDay = 6
        if (model?.days?[nDay ?? 6].count)! > current! {
            print(current!)
        }else{
            current = 0
        }
        mxDays.value?.append(contentsOf: model?.days?[nDay ?? 6] ?? [])
        mxEvent.value?.append(contentsOf: model?.days?[nDay ?? 6][current ?? 0].events ?? [])
        dateName.text = formattedDate(from:model?.days?[nDay ?? 6][0].release_date)
        sDate = model?.days?[nDay ?? 6][0].release_date
        currentStatus()
    }
    
    //MARK: - IBAction Button Pressed
    
    @IBAction func nxtBtnPressed(_ sender: UIButton) {
        guard let data = mxModel?.days else { return }
        if sender.tag == 20 {
            if nDay!  < data.count - 1 {
                nDay! += 1
            }else{
                if nDay! != 6 {
                    nDay! -= 1
                }
            }
            
        }
        if sender.tag == 30 {
            if (nDay! - 1) < data.count - 1 {
                if nDay! != 0 {
                    nDay! -= 1
                }
            }
        }
        collect = false
        change = true
        mxEvent.value?.removeAll()
        mxEvent.value?.append(contentsOf: mxModel?.days?[nDay ?? 6][current ?? 0].events ?? [])
        dateName.text = formattedDate(from:mxModel?.days?[nDay ?? 6][current ?? 0].release_date)
        sDate = mxModel?.days?[nDay ?? 6][current ?? 0].release_date
        programCollectionView.reloadData()
        playChannel(with: current ?? 0)
        
    }
    
    @IBAction func headerBtnPressed(_ sender: UIButton) {
        // Notification
        if sender.tag == 40 {
            let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
            navigationController?.pushViewController(vc, animated: true)
        }// Share
         if sender.tag == 50 {
             let text = "https://sanskargroup.page.link/"
             let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
             present(activity, animated: true, completion: nil)
        }// Barcode
         if sender.tag == 60 {
            
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
//                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannerControl") as! ScannerControl
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }
         if sender.tag == 70 {
            TV_PlayerHelper.shared.mmPlayer.setOrientation(.protrait)
            TV_PlayerHelper.shared.mmPlayer.playView = nil
            guard let cb = self.completionBlock else {return}
            cb()
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reminder!", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - CollectionView DataSource

extension MXVc: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == programCollectionView {
            return mxEvent.value?.count ?? 0
        }else if collectionView == channelCollectionView {
          //  return mxDays.value?.count ?? 0
            return min(mxDays.value?.count ?? 0, 5)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == programCollectionView {
            guard let cell = programCollectionView.dequeueReusableCell(withReuseIdentifier: "MxProgramCell", for: indexPath) as? MxProgramCell else {
                return UICollectionViewCell()
            }
            let cIndex = indexPath.row
            let event = mxEvent.value?[cIndex]
           //  cell.name.text = event?.program_title
            cell.totalLbl.text = "\(event?.start_time ?? "") - \(event?.end_time ?? "" )"
            if let image = event?.thumbnail {
               let images = image.replacingOccurrences(of: " ", with: "%20")
//
//                print(images)
//                cell.image.sd_setImage(with: URL(string: image),
//              placeholderImage: UIImage(named: "thumbnail"),
//            options: .refreshCached, completed: nil)
                cell.configureImg(model: images)
            }
           // cell.image.sd_setImage(with: URL(string: event?.thumbnail[indexPath.row]))
            let getdate = dateSub()
            if getdate == sDate {
                if cIndex == timeIndex {
                    cell.play.text = "Live"
                    cell.play.textColor = .white
                    cell.play.backgroundColor = .red
                }else{
                    cell.play.text = "Play Now"
                    cell.play.textColor = .red
                    cell.play.backgroundColor = .white
                }
            }
            
            if cIndex == index {
                cell.play.text = "Now Playing"
                cell.play.backgroundColor = .red
                cell.play.textColor = .white
            }
            cell.progBtn.tag = indexPath.row
            cell.progBtn.addTarget(self, action: #selector(MXVc.onClickedProgram(_:)), for: .touchUpInside)
            return cell
        }else if collectionView == channelCollectionView {
            guard let cell = channelCollectionView.dequeueReusableCell(withReuseIdentifier: "MxChannelCell", for: indexPath) as? MxChannelCell else {
                return UICollectionViewCell()
            }
            let index = indexPath.row
            let data = mxDays.value?[index]
            
            if let image = data?.image {
                cell.img.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
            if index == current {
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = UIColor.red.cgColor
            }else{
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = UIColor.white.cgColor
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    
    
}

//MARK: - CollectionView Delegate

extension MXVc: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView == channelCollectionView {
            current = indexPath.row
            channelCollectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.channelCollectionView.scrollToItem(at: IndexPath(row: self.current ?? 0, section: 0), at: .centeredHorizontally, animated: true)
                self.collect = true
                self.change = false
                self.playChannel(with: self.current ?? 0)
                self.programCollectionView.reloadData()
            }
        }
    }
    
}

//MARK: - Extra funcationality

extension MXVc {
    
    //MARK: - Sender tag
    @objc func onClickedProgram(_ sender: UIButton) {
        
        print(sender.tag)
        index = sender.tag
        if self.timeIndex < self.index ?? 0 {
            self.showAlert(message: "You can't play future videos.")
            return
        }
        timer.invalidate()
        programCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.programCollectionView.scrollToItem(at: IndexPath(row: self.index ?? 0, section: 0), at: .centeredHorizontally, animated: true)
            self.videoTime(with: self.index ?? 0)
            self.startTimer(self.index ?? 0)
            self.from = "cell"
        }
        
    }
    
    func playChannel(with index: Int) {
        
        let data = mxDays.value?[index]
        var url = ""
        let img = data?.image ?? ""
        let getDate = dateSub()
        if change != true {
            url = "\(data?.channel_url ?? "")?start=\(getDate )T00:00:00+05:30&end="
            nDay = 6
            sDate = getDate
            dateName.text = formattedDate(from:getDate)
        }else{
            url = "\(data?.channel_url ?? "")?start=\(sDate ?? "")T00:00:00+05:30&end=\(sDate ?? "")T24:00:00+05:30"
        }
        
        if currentUser.result?.id == "163" {
            chImage.isHidden = false
            chImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
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
                }else{
//                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            quality(hlsUrl: url)
            chImage.isHidden = true
        }
        if collect == true {
            // mark by avi tyagi
            mxEvent.value?.removeAll()
//            mxEvent.value?.append(contentsOf: mxModel?.days?[nDay ?? 6][current ?? 0].events ?? [])
            if let model = mxModel,
               let days = model.days,
               let nDay = nDay,
               nDay < days.count,
               let currentDay = days[nDay] as? [MXDays] ,
               let current = current,
               current < currentDay.count {

                mxEvent.value?.append(contentsOf: currentDay[current].events ?? [])
            } else {
                print("Indices are out of range.")
            }

   
        }
        loadProgram()
        exact = exactTime()
        guard let playTime = UserDefaults.standard.value(forKey: "playTime") as? Int else {return}
        guard let contentId = UserDefaults.standard.value(forKey: "contentID") as? String else {return}
        let total = exact - playTime
        let playParm : Parameters = ["user_id": currentUser.result!.id!, "media_type": "1","media_id": contentId,"device_type":"2","video_status": "0","total_play": "\(total)"]
        hitPlayTime(playParm)
        UserDefaults.standard.set(exact, forKey: "playTime")
        
    }
    
    func videoTime(with Numb: Int) {
        if let program = mxEvent.value?[Numb] {
            let newTime = program.start_time!.secondFromString
            programName.text = program.program_title
            TV_PlayerHelper.shared.mmPlayer.player?.seek(to: CMTimeMake(Int64(newTime), 1))
        }
    }
    
    
    // comment by avi tyagi
//    func setDataWithTime(){
//
//        guard let pro = mxModel?.days?[nDay ?? 6][current ?? 0].events else {return}
//        for no in 0..<pro.count {
//            if let start = pro[no].start_time_milliseconds,let end = pro[no].end_time_milliseconds{
//                let sPoint = start / 1000
//                let ePoint = end / 1000
//                for i in sPoint..<ePoint{
//                    if extact == i {
//                        timeIndex = no
//                        break
//                    }
//                }
//            }
//
//        }
//
//
//    }
    
    func setDataWithTime() {
        guard let pro = mxModel?.days?[nDay ?? 6][current ?? 0].events else { return }
        for no in 0..<pro.count {
            if let start = pro[no].start_time_milliseconds, let end = pro[no].end_time_milliseconds {
                let sPoint = start / 1000
                let ePoint = end / 1000
                let rangeStart = min(sPoint, ePoint)
                let rangeEnd = max(sPoint, ePoint)
                
                for i in rangeStart..<rangeEnd {
                    if extact == i {
                        timeIndex = no
                        break
                    }
                }
            }
        }
    }

    
    func playCurrent() {
        guard let data = mxDays.value?[current ?? 0] else { return }
        var url = ""
        let img = data.image ?? ""
        let getDate = dateSub()
        if change != true {
            url = "\(data.channel_url ?? "")?start=\(sDate ?? "")T00:00:00+05:30&end="
            nDay = 6
        }else{
            url = "\(data.channel_url ?? "")?start=\(sDate ?? "")T00:00:00+05:30&end=\(sDate ?? "")T24:00:00+05:30"
        }
        if currentUser.result?.id == "163" {
            chImage.isHidden = false
            chImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }else{
            quality(hlsUrl: url )
            chImage.isHidden = true
        }
        
        mxEvent.value?.removeAll()
        mxEvent.value?.append(contentsOf: mxDays.value?[current ?? 0].events ?? [])
        DispatchQueue.main.async {
            self.setDataWithTime()
            self.loadProgram()
        }

    }
    
    func loadProgram () {
        let getDate = dateSub()
        if getDate == sDate {
            if timeIndex < mxEvent.value?.count ?? 0 {
                timer.invalidate()
                programName.text = mxEvent.value?[timeIndex].program_title
                programCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.programCollectionView.scrollToItem(at: IndexPath(row: self.timeIndex, section: 0), at: .centeredHorizontally, animated: true)
                    self.channelCollectionView.scrollToItem(at: IndexPath(row: self.current ?? 0, section: 0), at: .centeredHorizontally, animated: true)
                    self.from = "load"
                }
            }else{
                self.programName.text = mxDays.value?[current ?? 0].name
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.channelCollectionView.scrollToItem(at: IndexPath(row: self.current ?? 0, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }else{
            programName.text = mxModel?.days?[nDay ?? 6][current ?? 0].name
        }
        
        
    }
    
    func formattedDate(from dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            return formattedDate(date)
        } else {
            return nil
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX") 
        return formatter.string(from: date).uppercased() // Converts month to uppercase
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
    
    func dateSub() -> String {
        let current = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: 0, to: current)
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var dateform = dformat.string(from: oneHourAgo!)
        dateform.insert(":", at: dateform.index(dateform.endIndex, offsetBy: -2))
        let newDate = dateform.subString(from: 0, to: 10)
        return newDate
    }
    
}

//MARK: - Get Quality Details

extension MXVc: GetVideoQualityList {
    
    func quality(hlsUrl : String ){
        DispatchQueue.main.async {
            guard let content = URL(string: hlsUrl) else {return}
            _ = self.getUrl(urlStrin: hlsUrl)
            _ = AVURLAsset(url: content)
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
    
    @objc func MxReceivedNotification(notification: Notification)
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
