//
//  statedataTableViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 07/02/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class statedataTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var statelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
