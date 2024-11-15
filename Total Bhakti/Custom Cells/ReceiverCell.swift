//
//  ReceiverCell.swift
//  sanskar
//
//  Created by Viru on 29/01/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit
import PaddingLabel

class ReceiverCell: UITableViewCell {
   
    @IBOutlet weak var messageLabel : PaddingLabel!
    @IBOutlet weak var NameLabel  : UILabel!
    @IBOutlet weak var TimeLabel  : UILabel!
    @IBOutlet weak var ProfilePic : UIImageView!
    @IBOutlet weak var reportButton : UIButton!
    
  

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
