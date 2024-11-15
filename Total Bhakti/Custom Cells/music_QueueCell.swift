//
//  music_QueueCell.swift
//  Sanskar
//
//  Created by mac on 18/05/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit

class music_QueueCell: UITableViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var songName_lbl:UILabel!
    @IBOutlet weak var songDesc_lbl:UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
