//
//  playerlistTableViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 21/12/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class playerlistTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
