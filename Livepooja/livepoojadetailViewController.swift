//
//  livepoojadetailViewController.swift
//  Sanskar
//
//  Created by Harish Singh on 01/02/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit
import AVFoundation

class livepoojadetailViewController: UIViewController {

    var progressTimer:Timer?
    {
        willSet {
            progressTimer?.invalidate()
        }
    }
    var playerStream: AVPlayer?
    var playerItem: AVPlayerItem?
    var refreshControl =  UIRefreshControl()
    var isPlaying = false
    var isAlreadyPlaying = false
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var descrptionview: UIView!
    @IBOutlet weak var descriptionmorelbl: UILabel!
    

    var currentcellindex = 0
    var templedataa = [String:Any]()
    var sliderimg = ["temple1","temple2","temple3","temple4","temple5","temple6","temple7"]
    var timer:Timer?
    var handclabaudio = ""
    var player: AVPlayer!
    var UrlforHandBtn = String()
    var UrlforFlowerBtn = String()
    var UrlforArtiBtn = String()
    var UrlforPrashadBtn = String()
    var temple_id = ""
    var templedata = [[String:Any]]()
    var templelistdata = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        descrptionview.isHidden = true
        let moredetail  = templedataa["description"] as? String ?? ""
        print(moredetail)
        self.descriptionmorelbl.text = moredetail
        
        var param: Parameters = ["temple_id": temple_id]
        
        hitKLivetempleapi(param)
       
        tableview.delegate = self
        tableview.dataSource = self

        
      
       print(templedataa)
        print(temple_id)
        
        
        tableview.register(UINib(nibName: "mandirdetailTableViewCell", bundle: nil), forCellReuseIdentifier: "mandirdetailTableViewCell")
        tableview.register(UINib(nibName: "mainpoojaTableViewCell", bundle: nil), forCellReuseIdentifier: "mainpoojaTableViewCell")
        tableview.register(UINib(nibName: "poojamapsTableViewCell", bundle: nil), forCellReuseIdentifier: "poojamapsTableViewCell")
        tableview.register(UINib(nibName: "RelatedphotosTableViewCell", bundle: nil), forCellReuseIdentifier: "RelatedphotosTableViewCell")
//        configure()
    }
    
    func hitKLivetempleapi(_ param : Parameters){
        self.uplaodData(APIManager.sharedInstance.KLivetempleapi , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    
                    
                    for i in 0..<data.count{
                        let templelist = data[i]["thumbnail"] as? String ?? ""
                        
                        self.templelistdata.append(templelist)
                        
                    }
                    print(self.templelistdata)
                    
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                   
                }
            }
        }
    }

    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func cancelbtn(_ sender: Any) {
        self.descrptionview.isHidden = true
    }
    
    
}


extension livepoojadetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
            
        }
        else if section == 1 {
            return 1
        }
        else if section == 2
        {
            //return templelist.count
            return 1
        }
        else
        {
            return templelistdata.count
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mandirdetailTableViewCell", for: indexPath) as! mandirdetailTableViewCell
            let thumbnailP = templedataa["thumbnail"] as? String ?? ""
            let name       = templedataa["temple_name"] as? String ?? ""
            let place      = templedataa["address"] as? String ?? ""
            let detail     = templedataa["description"] as? String ?? ""
            
            cell.sliderimg.sd_setImage(with: URL(string: thumbnailP))
            cell.templenamelbl.text = name
            cell.templeplacelbl.text = place
            cell.decscrptiondetaillbl.text = detail
            cell.morebtn.addTarget(self, action: #selector(morebtnpressed), for: .touchUpInside)
            cell.templedatavalue = templedataa
            cell.tempdata = templelistdata
            print(cell.tempdata)
            return cell
          
        }
       
        else if indexPath.section == 1
        {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainpoojaTableViewCell", for: indexPath) as! mainpoojaTableViewCell
            
            let thumbnailP = templedataa["thumbnail"] as? String ?? ""
            cell.mainpoojaimage.sd_setImage(with: URL(string: thumbnailP))
            print(templedataa)
             UrlforHandBtn = templedataa["clapping_audio"] as? String ?? ""
            print(UrlforHandBtn)
            UrlforArtiBtn = templedataa["arti_audio"] as? String ?? ""
            print(UrlforArtiBtn)
            UrlforFlowerBtn = templedataa["flower_audio"] as? String ?? ""
            print(UrlforFlowerBtn)
            UrlforPrashadBtn = templedataa["prasad_audio"] as? String ?? ""
            print(UrlforPrashadBtn)
            cell.flowerbtn.addTarget(self, action: #selector(pressedForFlowerBtn), for: .touchUpInside)
            cell.handbtn.addTarget(self, action: #selector(pressedForHandBtn), for: .touchUpInside)
            cell.bellbtn.addTarget(self, action: #selector(pressedForbellBtn), for: .touchUpInside)
            cell.thalibtn.addTarget(self, action: #selector(pressedForThaliBtn), for: .touchUpInside)
            cell.laddubtn.addTarget(self, action: #selector(pressedForPrashadBtn), for: .touchUpInside)
            
            return cell
        }
//        @objc func handbtn(sender: UIButton) {
//
//        }
        else if indexPath.section == 2
        {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "poojamapsTableViewCell", for: indexPath) as! poojamapsTableViewCell
           
            return cell2
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedphotosTableViewCell", for: indexPath) as! RelatedphotosTableViewCell
            let thumbnaild = templelistdata[indexPath.row] as? String ?? ""
            print(thumbnaild)
            cell.photoimg.sd_setImage(with: URL(string: thumbnaild))
            return cell
        }
        
    }
    
    @objc func pressedForHandBtn() {
        print("pressedForHandBtn")
        print(UrlforHandBtn)

        print("pressedForPrashadBtn")
        print(UrlforHandBtn)
        let url = URL.init(string: UrlforPrashadBtn)
        if url == nil{
           let data = URL.init(string: "https://bageshwardham.co.in/wp-content/uploads/2023/01/bageshwardhambhajan.mp3")
            player = AVPlayer.init(url:data!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
        else
        {
            let url = URL.init(string: UrlforPrashadBtn)
                           player = AVPlayer.init(url: url!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
    }
    @objc func pressedForThaliBtn() {

//        if isAlreadyPlaying == true && isPlaying == false{
//            player.pause()
//            let url = URL.init(string: UrlforArtiBtn)
//               player = AVPlayer.init(url: url!)
//               player.play()
//           isPlaying = true
//           isAlreadyPlaying = true
//        }else if isAlreadyPlaying == true && isPlaying == false{
//            player.pause()}
//        else{
//            let url = URL.init(string: UrlforArtiBtn)
//               player = AVPlayer.init(url: url!)
//               player.play()
//           isPlaying = true
//           isAlreadyPlaying = true
//        }
        let url = URL.init(string: UrlforArtiBtn)
        if url == nil{
           let data = URL.init(string: "https://bageshwardham.co.in/wp-content/uploads/2022/12/balaji.mp3")
            player = AVPlayer.init(url:data!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
        else
        {
            let url = URL.init(string: UrlforArtiBtn)
                           player = AVPlayer.init(url: url!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }

    }
    @objc func pressedForPrashadBtn() {
        print("pressedForPrashadBtn")
        print(UrlforHandBtn)
        let url = URL.init(string: UrlforPrashadBtn)
        if url == nil{
           let data = URL.init(string: "https://bageshwardham.co.in/wp-content/uploads/2023/01/laddu-bhog.mp3")
            player = AVPlayer.init(url:data!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
        else
        {
            let url = URL.init(string: UrlforPrashadBtn)
                           player = AVPlayer.init(url: url!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }

    }
    

    @objc func pressedForFlowerBtn(){
        let url = URL.init(string: UrlforFlowerBtn)
        if url == nil{
           let data = URL.init(string: "https://bageshwardham.co.in/wp-content/uploads/2023/01/flawer-pooja.mp3")
            player = AVPlayer.init(url:data!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
        else
        {
            let url = URL.init(string: UrlforFlowerBtn)
                           player = AVPlayer.init(url: url!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
    }
    @objc func pressedForbellBtn(){
        let url = URL.init(string: UrlforPrashadBtn)
        if url == nil{
           let data = URL.init(string: "https://res.cloudinary.com/chartman4/video/upload/v1499897861/BellSound_csbr1a.mp3")
            player = AVPlayer.init(url:data!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
        else
        {
            let url = URL.init(string: UrlforPrashadBtn)
                           player = AVPlayer.init(url: url!)
                         player.play()
                      isPlaying = true
            isAlreadyPlaying = true
        }
    }
    @objc func morebtnpressed(){
        self.descrptionview.isHidden = false
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    if indexPath.section == 2 && indexPath.row == 2 {
        if indexPath.section == 2 {
                return 50 // set the height to 50 points
            } else {
                return 300 // set a default height of 44 points for other cells
            }
//     return 300
    }
    
   
}
    
    






// mark avi tyagi

//@objc func pressedForbellBtn(){
//    //        if isAlreadyPlaying == true{
//    //            player.pause()
//    //        }else{
//    //            if isPlaying == false {
//    //                let url = URL.init(string: "https://res.cloudinary.com/chartman4/video/upload/v1499897861/BellSound_csbr1a.mp3")
//    //                player = AVPlayer.init(url: url!)
//    //                player.play()
//    //                isPlaying = true
//    //                isAlreadyPlaying = true
//    //            }
//    //            else if isPlaying == true {
//    //                player.pause()
//    //                isPlaying = false
//    //                isAlreadyPlaying = false
//    //            }
//    //        }
//}




//@objc func pressedForPrashadBtn() {
//    print("pressedForPrashadBtn")
//    print(UrlforHandBtn)
//    let url = URL.init(string: UrlforPrashadBtn)
//    if url == nil{
//       let data = URL.init(string: "https://bageshwardham.co.in/wp-content/uploads/2023/01/laddu-bhog.mp3")
//        player = AVPlayer.init(url:data!)
//                     player.play()
//                  isPlaying = true
//        isAlreadyPlaying = true
//    }
//    else
//    {
//        let url = URL.init(string: UrlforPrashadBtn)
//                       player = AVPlayer.init(url: url!)
//                     player.play()
//                  isPlaying = true
//        isAlreadyPlaying = true
//    }
//
////        if isAlreadyPlaying == true && isPlaying == false{
////            player.pause()
////            let url = URL.init(string: UrlforPrashadBtn)
////               player = AVPlayer.init(url: url!)
////               player.play()
////           isPlaying = true
////           isAlreadyPlaying = true
////        }else if isAlreadyPlaying == true && isPlaying == false{
////            player.pause()}
////        else{
////            let url = URL.init(string: UrlforPrashadBtn)
////               player = AVPlayer.init(url: url!)
////               player.play()
////           isPlaying = true
////           isAlreadyPlaying = true
////        }
//}





//    @objc func pressedForFlowerBtn() {
//        print("pressedForHandBtn")
//        print(UrlforFlowerBtn)
//
//        if isAlreadyPlaying == true && isPlaying == false{
//            player.pause()
//            let url = URL.init(string: UrlforFlowerBtn)
//            player = AVPlayer.init(url: url!)
//            player.play()
//            isPlaying = true
//            isAlreadyPlaying = true
//        }else if isAlreadyPlaying == true && isPlaying == false{
//            player.pause()}
//        else{
//            let url = URL.init(string: UrlforFlowerBtn)
//            player = AVPlayer.init(url: url!)
//            player.play()
//            isPlaying = true
//            isAlreadyPlaying = true
//        }
//    }
