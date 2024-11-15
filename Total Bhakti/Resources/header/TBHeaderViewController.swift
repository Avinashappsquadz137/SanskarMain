//
//  TBHeaderViewController.swift
//  Total Bhakti
//
//  Created by MAC MINI on 06/09/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import GoogleCast

protocol TBHeaderDelegates {
    func menuBarBtnTapped(_ sender : UIButton)
}

class TBHeaderViewController: UIView {
   
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var menuBarBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var castButton: GCKUICastButton!
    
    var delegate : TBHeaderDelegates?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        mainView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        mainView.layer.shadowOpacity = 0.4
        mainView.layer.masksToBounds = false
        mainView.layer.shadowRadius = 0.0
        castButton.tintColor = UIColor.black
    }
 
    @IBAction func headerBtnActions(_ sender : UIButton) {
          delegate?.menuBarBtnTapped(sender)
    }
    
    class func getHeaderView() -> UIView {
        let headerView = UINib(nibName: "TBHeaderViewController", bundle: nil).instantiate(withOwner: self, options: nil) [0] as! TBHeaderViewController
        return headerView
    }
}
