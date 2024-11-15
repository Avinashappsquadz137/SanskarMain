//
//  qualityVc.swift
//  Sanskar
//
//  Created by Warln on 09/09/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class qualityVc: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fotterView: UIView!
    
    var resolutionArray = [String]()
    var playBackSpeed : [Double] = [1.0,1.25,1.50,1.75,2.0]
    var delegate: GetVideoQualityList?
    var currentPlayBackSpeed : Float =  1.0
    static var seletedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resolutionArray = resolutionArray.removeDuplicates()
        self.tableView.tableFooterView = self.fotterView
    }
    
    @IBAction func buttonAction(_ Sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}


extension qualityVc:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resolutionArray.count != 0
        {
            return resolutionArray.count
        }
        else
        {
           return playBackSpeed.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let lblTitle : UILabel = cell.contentView.viewWithTag(10) as! UILabel
        let imgCheckMark : UIImageView = cell.contentView.viewWithTag(11) as! UIImageView
        
        if qualityVc.seletedIndex == indexPath.row
        {
            if #available(iOS 13.0, *) {
                imgCheckMark.image = UIImage(systemName: "checkmark")
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            imgCheckMark.image = nil
        }
        
        if resolutionArray.count == 0
        {
            if indexPath.row == 0
            {
                lblTitle.text = "Normal"
            }
            else
            {
                lblTitle.text = "\(playBackSpeed[indexPath.row])x"
            }
            if playBackSpeed[indexPath.row] == Double(currentPlayBackSpeed)
            {
                imgCheckMark.image = #imageLiteral(resourceName: "torch_on_button")

            }
            else
            {
                imgCheckMark.image = nil
            }
        }
        else
        {
            lblTitle.text = resolutionArray[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if resolutionArray.count != 0
        {
            qualityVc.seletedIndex = indexPath.row
            self.delegate?.getSeletedBitRate(bitrate: indexPath.row)
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.delegate?.getSeletedSpeedRate(playBackSpeed: "\(playBackSpeed[indexPath.row])")
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    
}
