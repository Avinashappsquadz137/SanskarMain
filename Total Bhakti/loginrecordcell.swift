//
//  loginrecordcell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 08/12/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class loginrecordcell: UITableViewCell {
    
    @IBOutlet weak var mobilelbl: UILabel!
    @IBOutlet weak var daysremainlbl: UILabel!
    @IBOutlet weak var crownimg:UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
