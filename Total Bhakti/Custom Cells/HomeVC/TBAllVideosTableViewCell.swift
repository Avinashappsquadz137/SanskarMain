//
//  TBAllVideosTableViewCell.swift
//  Total Bhakti
//
//  Created by MAC MINI on 06/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBAllVideosTableViewCell: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoNameLbl: UILabel!
    @IBOutlet weak var videoDescriptionLbl: UILabel!
    @IBOutlet weak var numberOfViewsLbl: UILabel!
    @IBOutlet weak var videoDateAndTimeLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
