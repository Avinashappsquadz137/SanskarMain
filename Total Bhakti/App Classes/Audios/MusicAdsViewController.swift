//
//  MusicAdsViewController.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 28/07/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class MusicAdsViewController: UIViewController {

    @IBOutlet weak var adImgView: UIImageView!
    @IBOutlet weak var cancelView: UIView!
    let param : Parameters = ["user_id": currentUser.result!.id!]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelView.layer.cornerRadius = cancelView.layer.bounds.width/2
        cancelView.clipsToBounds = true
        self.advertiseApi(param)
    }
    
    //MARK:- Advertise Api Method.
 private func advertiseApi(_ param : Parameters){
        
        self.uplaodData1(APIManager.sharedInstance.KAds, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    
                    let imgData = JSON.ArrayofDict("bhajan")
                    if imgData.count > 0{
                        if let media = imgData.randomElement(){
                            if let img = media["media"] as? String{
                                if let url = URL(string: img){
                                    self.adImgView.sd_setImage(with: url, completed: nil)
                                    
                                }
                                
                            }
                        }
                       
                    }
                    
                    
                }else {
                    
                }
            }else {
                self.addAlert(ALERTS.KERROR, message: ALERTS.KERROR.debugDescription, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    //MARK:- recentViewHit.
    func adViewApi(_ param: Parameters) {
        loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.KNEWSVIEWS, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
        
                    }
                }else {
                }
                
            }else {
            }
        }
    }
    
    @IBAction func cancelAdsBtnAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }


}


