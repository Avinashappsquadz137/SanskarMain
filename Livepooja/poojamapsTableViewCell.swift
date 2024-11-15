//
//  poojamapsTableViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 01/02/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class poojamapsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationlabel: UILabel!
    
    @IBOutlet weak var mapimageview: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
