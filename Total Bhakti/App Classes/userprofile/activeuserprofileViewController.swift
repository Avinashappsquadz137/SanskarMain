//
//  activeuserprofileViewController.swift
//  Sanskar
//
//  Created by Harish Singh on 13/06/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class activeuserprofileViewController: UIViewController {
    
    
    @IBOutlet weak var mainview:UIView!
    @IBOutlet weak var bannerimg:UIImageView!
    @IBOutlet weak var acceptbtn:UIButton!
    @IBOutlet weak var skipbtn:UIButton!
    @IBOutlet weak var okaybtn:UIButton!
    @IBOutlet weak var okview:UIView!
    @IBOutlet weak var backgroundview:UIView!
    @IBOutlet weak var aceeptlbl:UILabel!
    
    
    var guruid = ""
    var festivals: [Festival] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   NotificationCenter.default.post(name: NSNotification.Name("hidetabbar"), object: nil)
        okview.isHidden = true
        backgroundview.isHidden = true
                 mainview.layer.cornerRadius = 10
                bannerimg.layer.cornerRadius = 10
                acceptbtn.layer.cornerRadius = 10
                skipbtn.layer.cornerRadius = 10
                okaybtn.layer.cornerRadius = 10
          okview.layer.cornerRadius = 10
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","guru_id":guruid ]
        getholiguruapi(param)
    }
    
    func getholiguruapi(_ param: Parameters) {
 
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        //        }
        let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
        print(sesiondata)
        self.uplaodData1(APIManager.sharedInstance.Kholigurudetailapi, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary,
               let data = JSON["data"] as? NSDictionary {
                print(data)
               let thumbnail = data["thumbnail"] as? String ?? ""
                print(thumbnail)
                self.bannerimg.sd_setImage(with: URL(string: thumbnail))
               
            }
        }
    }
    func getholiguruacceptapi(_ param: Parameters) {
 
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        //        }
        let sesiondata = UserDefaults.standard.string(forKey: "season_Id")
        print(sesiondata)
        self.uplaodData1(APIManager.sharedInstance.Kholiprogramdetailapi, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                let message = JSON["message"] as? String ?? ""
                print(message)
                if message == "You have already accepted this invitation." {
                    self.aceeptlbl.font = UIFont.boldSystemFont(ofSize: 17)
                    self.aceeptlbl.text = message
                } else {
                    self.aceeptlbl.font = UIFont.boldSystemFont(ofSize: 27)
                    self.aceeptlbl.text = message
                }
            }
        }
    }
    
    @IBAction func Acceptntm(_ sender: UIButton) {
        okview.isHidden = false
        backgroundview.isHidden = false
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","guru_id":guruid,"accept":"1"]
        getholiguruacceptapi(param)
    }
    
    @IBAction func skipbtn(_ sender: UIButton) {
        let vc =  storyBoard.instantiateViewController(withIdentifier: "editnameVC") as! editnameVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func okbtn(_ sender: UIButton) {
        okview.isHidden = true
        backgroundview.isHidden = true
        let vc =  storyBoard.instantiateViewController(withIdentifier: "allholiprogramlist") as! allholiprogramlist
        navigationController?.pushViewController(vc, animated: true)
    }
}
