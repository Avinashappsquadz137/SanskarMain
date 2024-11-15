////
////  liveTvVC.swift
////  Sanskar
////
////  Created by Warln on 20/11/21.
////  Copyright © 2021 MAC MINI. All rights reserved.
////
//
import UIKit

class liveTvVC: UIViewController {
    //MARK: - IBOultet
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    //MARK: - Variable
    var completionBlock:vCB?
    var completionBlock2:vCB2?
    var epChannels: [EpChannel]?
    var channeLDays = [[String:Any]]()
    var timeIntervals: [String] {
        return [
            "", "00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
            "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"
        ]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let epgNib = UINib(nibName: "epgCell", bundle: Bundle.main)
        collectionView2.register(epgNib, forCellWithReuseIdentifier: "epgCell")
        
        let timeNib = UINib(nibName: "timeCell", bundle: Bundle.main)
        collectionView2.register(timeNib, forCellWithReuseIdentifier: "timeCell")
        
        let channelNib = UINib(nibName: "channelCell", bundle: Bundle.main)
        collectionView2.register(channelNib, forCellWithReuseIdentifier: "channelCell")
        
        let programNib = UINib(nibName: "programCell", bundle: Bundle.main)
        collectionView2.register(programNib, forCellWithReuseIdentifier: "programCell")
        
        let param: Parameters = ["user_id":currentUser.result!.id!]
        getData(param)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func updateUi() {
        collectionView2.backgroundColor = UIColor.lightGray
        let layout = EPGColletionViewFlowLayout()
        layout.epChannels = self.epChannels
        collectionView2.setCollectionViewLayout(layout, animated: false)
        collectionView2.dataSource = self
        collectionView2.delegate = self
        collectionView1.delegate = self
        collectionView1.dataSource = self
        
    }
    
    

    func getData(_ param: Parameters) {
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodData1(APIManager.sharedInstance.tvGuide, param) { response in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
//            self.epChannels?.removeAll()
            if let Json = response as? [String:Any] {
                print(Json)
                if Json["status"] as? Bool == true {
                    if let channlArr = Json["Channels"] as? [[String:Any]] {
                        self.epChannels = [EpChannel]()
                        for channelItem in channlArr {
                            print(channelItem)
                            let id = channelItem["id"] as? String ?? ""
                            let name = channelItem["name"] as? String ?? ""
                            let channelurl = channelItem["channel_url"] as? String ?? ""
                            let imageUrl = channelItem["image"] as? String ?? ""
                            let channel = EpChannel(id: id, name: name, channelUrl: channelurl, imageUrl: imageUrl)
                            self.epChannels?.append(channel)
                            if let daysData = channelItem["days"] as? [[String: Any]] {
                                for index in 0..<daysData.count {
                                    let day = daysData[index] as [String:Any]
                                    self.channeLDays.append(day)
                                }
                                for dayItem in daysData {
                                    if dayItem["day_6"] != nil {
                                        if let program = dayItem["day_6"] as? [[String:Any]] {
                                            channel.programs = [Program]()
                                            for item in program {
                                                let title = item["program_title"] as? String ?? ""
                                                print(title)
                                                let start = (item["start_time_milliseconds"] as? Int ?? 0) / 1000
                                                let end = (item["end_time_milliseconds"] as? Int ?? 0) / 1000
                                                let prog = Program(title: title, schedule: Schedule(start: TimeInterval(start), end: TimeInterval(end)))
                                                channel.programs?.append(prog)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    if let _ = self.epChannels {
                        print(self.epChannels!)
                    }
                }else {
                    print(Error.self)
                }
            }
            self.updateUi()
            self.collectionView1.reloadData()
            self.collectionView2.reloadData()
        }
        
    }
    

}

extension liveTvVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let count = epChannels?.count {
            return count + 1 // Number of channels + Time headers
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return channeLDays.count
        }else {
            
            if section == 0 {
                return timeIntervals.count
            } else {
                if let count = self.epChannels?[section - 1].programs?.count {
                    return count + 1
                }
            }
            return 0
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            guard let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCell else {
                return UICollectionViewCell()
            }
            cell.dateLbl.text = channeLDays[indexPath.row]["release_date"] as? String ?? ""
            return cell
        }
        else {
            
            let cell: epgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "epgCell", for: indexPath) as! epgCell
            cell.titleLbl.text = ""
            if indexPath.section == 0 { // Time
                let timeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! timeCell
                let time = self.timeIntervals[indexPath.row]
                timeCell.timeLbl.text = time
                return timeCell
            }
            else if indexPath.row == 0 { // Channels
                let channelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath) as! channelCell
                if let channel = self.epChannels?[indexPath.section - 1] {
                    channelCell.configureWith(epChannel: channel)
                    return channelCell
                }
            }
            else {
                if let channel = self.epChannels?[indexPath.section - 1] {
                    if let program = channel.programs?[indexPath.row - 1] {
                        let programCell = collectionView.dequeueReusableCell(withReuseIdentifier: "programCell", for: indexPath) as! programCell
                        programCell.configureWith(program: program)
                        return programCell
                    }
                }
            }
            return cell
            
        }
    }
}

extension liveTvVC: UICollectionViewDelegate {
    
}




