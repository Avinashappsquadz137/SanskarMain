//
//  TB_ChannelListCell.swift
//  Total Bhakti
//
//  Created by mac on 31/03/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit

class TB_ChannelListCell: UITableViewCell {

    @IBOutlet weak var img_channelImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lbl_channelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         shadowView.dropShadow()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
