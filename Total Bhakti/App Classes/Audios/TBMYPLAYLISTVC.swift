//
//  TBMYPLAYLISTVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 01/05/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
var isPlayList = false
class TBMYPLAYLISTVC: TBInternetViewController {
    
    
    
    
    lazy var mmPlayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    
    
    //MARK:- IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emptyMessageLbl: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notifCountLabel: UILabel!
    var bhajanList : [trendingBhajanModel] = []
    //MARK: - Variables.
    var bhajanSongs = [Bhajan]()
    var bhajanSongs2 = [Bhajan]()
    var tempDict = NSDictionary()
    var songImageUrl  = [String]()
    
    
    var playListArray = Array<Any>()
    //MARK:- life Cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let param : Parameters = ["user_id": currentUser.result?.id ?? ""]
        getPlaylist(param)
       
       
        
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0
        
//
//        if let getArr = TBSharedPreference.sharedIntance.getplaylist() {
//            playListArray = getArr as! [Any]
////            bhajanSongs = Bhajan.modelsFromDictionaryArray(array: getArr)
////            bhajanSongs2 = Bhajan.modelsFromDictionaryArray(array: getArr)
//        }
//        if bhajanSongs.count == 0 {
//            emptyMessageLbl.isHidden = false
//            tableView.isHidden = true
//        }else {
//            tableView.isHidden = false
//            emptyMessageLbl.isHidden = true
//        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Topbar Button action.
    @IBAction func shareBtnAction (_ sender : UIButton) {
        let text = "https://sanskargroup.page.link/"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func notificationBtnAction (_ sender : UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuBtnAction (_ sender : UIButton) {
        slideMenuController()?.openLeft()
    }
}

//MARK:- UITableView DataSource Methods.
extension TBMYPLAYLISTVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bhajanList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath)
        let post = bhajanList[indexPath.row]
        let bhajanImageView = cell.viewWithTag(100) as! UIImageView
        let nameLbl = cell.viewWithTag(110) as! UILabel
        let descriptionLbl = cell.viewWithTag(120) as! UILabel
        let mainView = cell.viewWithTag(130)
        let btn = cell.viewWithTag(122) as? UIButton
        mainView?.layer.cornerRadius = 5.0
        mainView?.dropShadow()
        bhajanImageView.layer.cornerRadius = 5.0
        bhajanImageView.clipsToBounds = true
        
        btn?.tag = indexPath.row
        btn?.addTarget(self, action: #selector(deletePlayList), for: .touchUpInside)
        
        nameLbl.text = post.title
        descriptionLbl.text = post.description?.html2String
        if post.image != ""  {
            bhajanImageView.sd_setShowActivityIndicatorView(true)
            bhajanImageView.sd_setIndicatorStyle(.gray)
            bhajanImageView.sd_setImage(with: URL(string: post.image), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            
        }
        return cell
    }
    @objc func deletePlayList(_ sender:UIButton){
        
//        if let getArr = TBSharedPreference.sharedIntance.getplaylist() {
//            getArr
//        }

        var param : Parameters
        param = ["user_id":currentUser.result?.id ?? "", "type":"2", "bhajan_id":bhajanList[sender.tag].id]

        deletePlaylist(param)
//        bhajanSongs.remove(at: sender.tag)
//        playListArray.remove(at: sender.tag)
//
//        TBSharedPreference.sharedIntance.setUserPlaylist(playListArray as NSArray)
        
    }
    
}

//MARK:- UITableView Delegate Methods.
extension TBMYPLAYLISTVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = bhajanList[indexPath.row]
        MusicPlayerManager.shared.song_no = indexPath.row
        MusicPlayerManager.shared.Bhajan_Track_Trending = bhajanList
        MusicPlayerManager.shared.isDownloadedSong = false
        MusicPlayerManager.shared.isPlayList = true
        MusicPlayerManager.shared.isRadioSatsang = false
        MusicPlayerManager.shared.trendingBhajanString = "trending bhajan"
        MusicPlayerManager.shared.isRadioSatsang = false
        let vc:TBMusicPlayerVC = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    
        
        MusicPlayerManager.shared.PlayURl(url: post.media_file)
        
    }
}

extension TBMYPLAYLISTVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
        
    }
}




//MARK:- searchBar Delegate Methods.
extension TBMYPLAYLISTVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
        if searchBar.text == "" {
            searchBar.text = nil
            searchBar.endEditing(true)
            self.view.endEditing(true)
            
             bhajanSongs = bhajanSongs2
             tableView.reloadData()
 
        }else{
            
            bhajanSongs = bhajanSongs2.filter { (audio) -> Bool in
                let stringMatch = audio.title?.lowercased().range(of: Text.lowercased())
                let str = audio.artist_name?.lowercased().range(of: Text.lowercased())
                
                return stringMatch != nil || str != nil ? true : false
            }
             
            if bhajanSongs.count == 0{
                bhajanSongs = bhajanSongs2
            }
              
            tableView.reloadData()
            
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        bhajanSongs = bhajanSongs2
        searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        bhajanSongs = bhajanSongs2.filter { (audio) -> Bool in
            let stringMatch = audio.title?.lowercased().range(of: searchBar.text!.lowercased())
            let str = audio.artist_name?.lowercased().range(of: searchBar.text!.lowercased())
            
            return stringMatch != nil || str != nil ? true : false
        }
         
        if bhajanSongs.count == 0{
            bhajanSongs = bhajanSongs2
        }
        
        searchBar.resignFirstResponder()
 
        
    }
}

// MARK:- Add playlist

extension TBMYPLAYLISTVC {
    func getPlaylist(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KGetPlaylist , param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if (JSON["data"] as! NSArray).count > 0{
                    let bhajanArray = (((JSON["data"] as! NSArray)[0] as! NSDictionary)["bhajan"] as! NSArray)
                    self.bhajanList.removeAll()
                    let data = bhajanArray
                    
                    _ = data.filter({ dict -> Bool in
                        
                        self.bhajanList.append(trendingBhajanModel(dict: dict as! Dictionary<String, Any>))
                        
                        return true
                    })

                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.emptyMessageLbl.isHidden = true
                }
                else{
                    self.emptyMessageLbl.isHidden = false
                    self.tableView.isHidden = true
                }

            }
            else{
            }
        }
    }
}

// MARK:- Delete playlist

extension TBMYPLAYLISTVC {
    func deletePlaylist(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KAddRemovePlaylist , param) { (response) in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                AlertController.alert(message: "Song Remove Your Play List")
                let param : Parameters = ["user_id": currentUser.result?.id ?? ""]
                self.getPlaylist(param)
            }
            else{
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
}
