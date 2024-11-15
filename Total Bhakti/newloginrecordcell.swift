//
//  newloginrecordcell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 11/07/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit

class newloginrecordcell: UITableViewCell {
    
    @IBOutlet weak var usernamelbl:UILabel!
    @IBOutlet weak var userimageview:UIImageView!
    @IBOutlet weak var activemsg:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
