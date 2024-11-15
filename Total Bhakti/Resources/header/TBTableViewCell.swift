//
//  TBTableViewCell.swift
//  Total Bhakti
//
//  Created by MAC MINI on 10/09/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var channelImageView: UIImageView!
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
