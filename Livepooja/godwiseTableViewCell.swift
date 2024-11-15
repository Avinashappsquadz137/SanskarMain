//
//  godwiseTableViewCell.swift
//  Sanskar
//
//  Created by Surya on 11/08/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class godwiseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var templeimg: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var locationlabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
