//
//  TBLiveDarshanListVC.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 30/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

class TBLiveDarshanListVC : TBInternetViewController {

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var tableViewmain: UITableView!
 
    var relatedVidos = [DataModel]()
    var headingSting : String?
    var menuMasterId = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIupdate()

    }
    
    
     
//    MARK: HEADER Controller
    @IBAction func shareBtn (_ sender : UIButton) {
        let text = "https://sanskargroup.page.link/"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }

    @IBAction func notificationBtn (_ sender : UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func UIupdate() {
        headerTitle.text = headingSting
        tableViewmain.register(UINib(nibName: "TBLiveDetailCell", bundle: nil), forCellReuseIdentifier: "cell")
        let param: Parameters = ["user_id": currentUser.result?.id ?? "163"]
        getMoreForAarti(param)
    }

}
//MARK: API CALLING
extension TBLiveDarshanListVC {
  
    func getMoreForAarti(_ param: Parameters) {
        DispatchQueue.main.async {
            loader.shareInstance.showLoading(self.view)
        }
        self.uplaodData1(APIManager.sharedInstance.KviewMoreForAarti, param) { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        self.relatedVidos = DataModel.modelsFromDictionaryArray(array: result)
                        if self.relatedVidos.count != 0 {
                            self.tableViewmain.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
}

//MARK: Collection View
@available(iOS 13.0, *)
extension TBLiveDarshanListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedVidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TBLiveDetailCell else {
            return UITableViewCell()}
        
        let video = relatedVidos[indexPath.row]
        if let thumbnailURL = URL(string: video.thumbnail ?? "") {
            cell.configureCell(imageURL: thumbnailURL)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = relatedVidos[indexPath.row]
        if  video.video_type == "0" {
            if  let vc = storyBoardNew.instantiateViewController(withIdentifier: CONTROLLERNAMES.KLiveYouTubeViewController) as? LiveYouTubeViewController {
                vc.videodata = video.video_url
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = storyBoardNew.instantiateViewController(withIdentifier: CONTROLLERNAMES.KLiveDarshanViewController) as? LiveDarshanViewController {
                let post = video.video_url
                vc.darshanList = post ?? ""
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
