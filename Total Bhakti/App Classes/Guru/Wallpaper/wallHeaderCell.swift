//
//  wallHeaderCell.swift
//  Sanskar
//
//  Created by Warln on 14/04/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class wallHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
