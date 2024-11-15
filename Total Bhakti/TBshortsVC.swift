//
//  TBshortsVC.swift
//  Sanskar
//
//  Created by Surya on 14/07/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TBshortsVC: UIViewController,GADFullScreenContentDelegate {
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var shortstableview: UITableView!
    
    var ListData = [[String:Any]]()
    var premiumid = [String]()
    var currentIndex = 0
    var timer: Timer?
    var currentPlayingIndex: IndexPath?
    var deeplinkshortid = ""
    var status = Int ()
    var shortVideos = [ShortVideo]()
    var userLikeStatus: [String: Bool] = [:]
    let adUnitID = "ca-app-pub-1618767157139570/5766265057"
     var rewardedAd: GADRewardedAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideminiplayershorts"), object: nil)
        print(deeplinkshortid)
       
        self.shortstableview.contentInsetAdjustmentBehavior = .never
        
        shortstableview.delegate = self
        shortstableview.dataSource = self
        if deeplinkshortid != nil {
            let device_id = UserDefaults.standard.string(forKey: "device_id")
            let param: Parameters = ["shorts_id":deeplinkshortid,"user_id":currentUser.result!.id!,"device_id": "\(device_id ?? "")"]
                      
             hitshortsapi(param)
        }
        else {
            let device_id = UserDefaults.standard.string(forKey: "device_id")
            let param : Parameters = ["user_id": currentUser.result?.id ?? "163","device_id": "\(device_id ?? "")"]
             hitshortsapi(param)
        }
        self.showadsinios()
         
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

           // Pause the video when navigating away from the current page
        for cell in shortstableview.visibleCells {
            if let videoCell = cell as? Shortstablecell {
                // Check if the player is not nil before attempting to pause it
                if let player = videoCell.player {
                    player.pause()
                }
            }
        }
//        let param: Parameters = ["channelID":"19"]
//                hitshortsapi(param)
       }
    
    
    func loadAndShowRewardedAd() {
           GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
               if let error = error {
                   print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                   return
               }
               self?.rewardedAd = ad
               self?.rewardedAd?.fullScreenContentDelegate = self
               print("Rewarded ad loaded.")
               self?.showRewardedAd()
           }
       }
    func showRewardedAd() {
           if let ad = rewardedAd {
               ad.present(fromRootViewController: self) {
                   let reward = ad.adReward
                   print("User earned reward of \(reward.amount) \(reward.type).")
               }
           } else {
               print("Ad wasn't ready.")
               loadAndShowRewardedAd()
           }
       }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
           print("Ad did fail to present full screen content with error: \(error.localizedDescription)")
           loadAndShowRewardedAd()
       }

       func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
           print("Ad did present full screen content.")
       }

       func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
           print("Ad did dismiss full screen content.")
          presentAlert()
       }
    
    func presentAlert() {
            let alert = UIAlertController(title: "", message: "To Continue Enjoying Ads-free Subscribe to Premium", preferredStyle: .alert)
            
        let goPremiumAction = UIAlertAction(title: "Subscribe", style: .default, handler: { action in
            // This will navigate to the premium page
            self.showPremiumPage()
        })
            let notNowAction = UIAlertAction(title: "Not Now", style: .cancel, handler: { action in
                // This will dismiss the alert
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(goPremiumAction)
            alert.addAction(notNowAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        func showPremiumPage() {
            // Assuming "PremiumViewController" is the identifier for your premium page view controller in the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let premiumVC = storyboard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as? TBPremiumPaymentVC {
                self.navigationController?.pushViewController(premiumVC, animated: true)
            }
        }
    
    func showadsinios() {
        let adskey = UserDefaults.standard.value(forKey: "iosads") as? String ?? ""
        if adskey == "1"{
            let value = UserDefaults.standard.value(forKey: "prim") as? Int ?? 0
            print(value)
            if value == 0 {
                
                loadAndShowRewardedAd()
            }
            else {
                print("no ads")
            }
            
            }else {
    //                   presentAlert()
                
            }
            
            
            
        
    }
    
    func hitshortsapi(_ param : Parameters){
        self.uplaodData(APIManager.sharedInstance.Kshortvideo , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            guard let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) else {
                print("Error converting JSON response to data")
                return
            }
            do {
                    let response = try JSONDecoder().decode(ShortVideoResponse.self, from: jsonData)
                    self.shortVideos = response.data
                    print(self.shortVideos)
                    // Reload table view
                    DispatchQueue.main.async {
                        self.shortstableview.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
          }
        }
    }

}
extension TBshortsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shortVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Shortstablecell", for: indexPath) as! Shortstablecell
   
        let video = shortVideos[indexPath.row]
        
        // Reset the cell's state
        cell.resetPlayer()
    //    cell.userlikebtn.setImage(UIImage(named: "handprayshorts"), for: .normal)
     
     //   HANDEMOJI
        let videourl = video.video_url
        let likecount = video.total_like
        let sharecount = video.total_share
        let likekey = video.is_liked
        let totlcomment = video.total_comments
        
        self.status = Int(likekey) ?? 0
        
        cell.likecount.text = likecount
        cell.sharecount.text = sharecount
        cell.commentcount.text = totlcomment
        cell.configureCell(with: videourl)
 
        // Check if this cell should play
        if indexPath == currentPlayingIndex {
            cell.player?.play()
        } else {
            cell.player?.pause()
        }
        // Set the like button image based on the like status
        if self.status == 0 {
            cell.userlikebtn.setImage(UIImage(named: "shortsredlike"), for: .normal)
        } else {
            cell.userlikebtn.setImage(UIImage(named: "shortswhitelike"), for: .normal)
        }
        // Set up button actions
        cell.sharebtn.tag = indexPath.row
        cell.sharebtn.addTarget(self, action: #selector(sharebtnaction(_:)), for: .touchUpInside)
        cell.userlikebtn.tag = indexPath.row
        cell.userlikebtn.addTarget(self, action: #selector(userlikeBtnAction(_:)), for: .touchUpInside)
        cell.usercommentbtn.tag = indexPath.row
        cell.usercommentbtn.addTarget(self, action: #selector(usercommentbtnaction(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func sharebtnaction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = shortstableview.cellForRow(at: indexPath) as? Shortstablecell else { return }
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        let shareid = shortVideos[indexPath.row].id
        let param: Parameters = ["shorts_id": shareid]
        hitshortsshareapi(param)
        var sharecount = Int(cell.sharecount.text ?? "0") ?? 0
        sharecount += 1
        cell.sharecount.text = "\(sharecount)"
        
    }
    func hitshortsshareapi(_ param : Parameters){
        self.uplaodData(APIManager.sharedInstance.kshortsshareapi , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    let data = (JSON["data"] as? [String:Any] ?? [:])
                    print(data)
                    let shortLink = (data["shortLink"] as? String ?? "")
                            let text = shortLink
                            let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                    self.present(activity, animated: true, completion: nil)
                }
            }
        }
    }
    @objc func usercommentbtnaction(_ sender: UIButton) {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let vc = storyBoard.instantiateViewController(withIdentifier: "shortscommentvc") as! shortscommentvc
            vc.shorts_id = shortVideos[indexPath.row].id
            vc.delegate = self
            
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 24
                    sheet.largestUndimmedDetentIdentifier = .medium
                }
            }
            self.present(vc, animated: true)
        }
    
    @objc func userlikeBtnAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = shortstableview.cellForRow(at: indexPath) as? Shortstablecell else { return }
        
        let shareid = shortVideos[indexPath.row].id
        let postId = shareid // Assuming type_id is post id
        let userId = currentUser.result!.id!
        let key = "\(userId)_\(postId)"
        if userLikeStatus[key] == nil {
            userLikeStatus[key] = false
        }
        if userLikeStatus[key] == false {
            // User likes the post
            let param: Parameters = ["user_id": userId, "type_id": postId, "type": "shorts", "status": "0"]
            print(param)
            hitshortslikeapi(param, sender: sender)
            var likeCount = Int(cell.likecount.text ?? "0") ?? 0
            likeCount += 1
            cell.likecount.text = "\(likeCount)"
            shortVideos[indexPath.row].total_like = "\(likeCount)"
            userLikeStatus[key] = true
            
        } else {
            // User dislikes the post
            let param: Parameters = ["user_id": userId, "type_id": postId, "type": "shorts", "status": "1"]
            print(param)
            hitshortsdislikeapi(param, sender: sender)
            // Update the like count
            var likeCount = Int(cell.likecount.text ?? "0") ?? 0
            likeCount -= 1
            cell.likecount.text = "\(likeCount)"
            shortVideos[indexPath.row].total_like = "\(likeCount)"
            userLikeStatus[key] = false
        }
    }
    func hitshortslikeapi(_ param: Parameters, sender: UIButton) {
        self.uplaodData(APIManager.sharedInstance.Kshortslikeapi, param) { (response) in
            DispatchQueue.main.async { loader.shareInstance.hideLoading() }
            print(response as Any)
            DispatchQueue.main.async { self.refreshControl.endRefreshing() }
            if let JSON = response as? [String: Any] { // Use Swift Dictionary instead of NSDictionary
                print(JSON)
                
                let data = JSON["data"] as! Int // Access dictionary values correctly
                print(data)
            //    label.text = data
                if let status = JSON["status"] as? Bool, status == true { // Access status correctly
                    DispatchQueue.main.async {
                        sender.setImage(UIImage(named: "shortsredlike"), for: .normal)
                    }
                }
            }
        }
    }
    func hitshortsdislikeapi(_ param : Parameters, sender: UIButton) {
                self.uplaodData(APIManager.sharedInstance.Kshortslikeapi , param) { (response) in
                    DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                    print(response as Any)
                    DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
                    if let JSON = response as? NSDictionary {
                        print(JSON)
                        if JSON.value(forKey: "status") as? Bool == true {
                            DispatchQueue.main.async {
                                sender.setImage(UIImage(named: "shortswhitelike"), for: .normal)
                        }
                      }
                    }
                }
            }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if let videoCell = cell as? Shortstablecell {
                videoCell.player?.play()
                currentPlayingIndex = indexPath
            }
        }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if let videoCell = cell as? Shortstablecell {
                videoCell.player?.pause()
                videoCell.playPauseButton.setImage(UIImage(named: ""), for: .normal)
            }
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return shortstableview.bounds.size.height
      //   return 750

    }
}
extension TBshortsVC: ShortsCommentVCDelegate {
    func didUpdateCommentCount(for shortsID: String, newCount: Int) {
        if let index = shortVideos.firstIndex(where: { $0.id == shortsID }) {
            shortVideos[index].total_comments = "\(newCount)"
            if let cell = shortstableview.cellForRow(at: IndexPath(row: index, section: 0)) as? Shortstablecell {
                cell.updateCommentCount("\(newCount)")
            }
        }
    }

    // Other methods and configurations
}







//    @objc func userlikeBtnAction(_ sender:UIButton){
//            if status == 0 {
//                let param: Parameters = ["user_id":currentUser.result!.id!,"type_id":"12","type":"shorts","status":"\(status)"]
//                print(param)
//                hitshortslikeapi(param, sender: sender)
//            } else {
//                let param: Parameters = ["user_id":currentUser.result!.id!,"type_id":"12","type":"shorts","status":"\(status)"]
//                print(param)
//                hitshortsdislikeapi(param, sender: sender)
//            }
//            // Toggle status between 0 and 1
//            status = (status + 1) % 2
//        }
          
//    @objc func userlikeBtnAction(_ sender: UIButton) {
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        guard let cell = shortstableview.cellForRow(at: indexPath) as? Shortstablecell else { return }
//
//        if status == 0 {
//            let param: Parameters = ["user_id": currentUser.result!.id!, "type_id": "12", "type": "shorts", "status": "\(status)"]
//            print(param)
//            hitshortslikeapi(param, sender: sender)
//
//            // Update the like count
//            var likeCount = Int(cell.likecount.text ?? "0") ?? 0
//            likeCount += 1
//            cell.likecount.text = "\(likeCount)"
//
//            // Update the data model
//            shortVideos[indexPath.row].total_like = "\(likeCount)"
//
//        } else {
//            let param: Parameters = ["user_id": currentUser.result!.id!, "type_id": "12", "type": "shorts", "status": "\(status)"]
//            print(param)
//            hitshortsdislikeapi(param, sender: sender)
//
//            // Update the like count
//            var likeCount = Int(cell.likecount.text ?? "0") ?? 0
//            likeCount -= 1
//            cell.likecount.text = "\(likeCount)"
//
//            // Update the data model
//            shortVideos[indexPath.row].total_like = "\(likeCount)"
//        }
//
//        // Toggle status between 0 and 1
//        status = (status + 1) % 2
//    }
