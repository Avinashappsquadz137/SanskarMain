//
//  TBVideoTableCell2.swift
//  Total Bhakti
//
//  Created by MAC MINI on 13/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBVideoTableCell2: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dercriptionLbl: UILabel!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var numberOfViewsLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var videoImageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
                   videoImageViewHeightConstraint.constant = 300
               } else {
                   videoImageViewHeightConstraint.constant = 200
               }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
