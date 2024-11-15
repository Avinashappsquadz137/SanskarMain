//
//  VideoControlVc.swift
//  Sanskar
//
//  Created by Warln on 09/09/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit


protocol GetVideoQualityList {
    func getBitRateList(data : NSArray, selectionTye : Int)
    func getSeletedBitRate(bitrate : Int)
    func getSeletedSpeedRate(playBackSpeed : String)

}

class VideoControlVc: UIViewController {
    
    @IBOutlet weak var playBackSpeedView : UIView!
    
    var delegate: GetVideoQualityList?
    var videoDict : [String : Any] = [:]
    var shareurl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(shareurl)

        if videoDict["is_live"] as? String == "1"
        {
            playBackSpeedView.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonAction(_ sender : UIButton)
    {
        if sender.tag == 10
        {
            self.dismiss(animated: true, completion:nil)
            self.delegate?.getBitRateList(data: [], selectionTye: 1)
        }
        else if sender.tag == 20
        {
            self.dismiss(animated: true, completion:nil)
            self.delegate?.getBitRateList(data: [], selectionTye: 2)
            
        }else if sender.tag == 30
        {
            self.dismiss(animated: true, completion:nil)
        }else if sender.tag == 40
        {
            if shareurl != nil {
                let text = shareurl
                let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                present(activity, animated: true, completion: nil)
            } else {
                let text = "https://apps.apple.com/in/app/sanskar-tv-app/id1497508487 \n https://play.google.com/store/apps/details?id=com.sanskar.tv"
                let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                present(activity, animated: true, completion: nil)
            }
        }
    }

}
