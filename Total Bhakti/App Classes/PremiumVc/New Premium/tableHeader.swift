//
//  tableHeader.swift
//  Sanskar
//
//  Created by Warln on 16/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class tableHeader: UITableViewCell {
    
    @IBOutlet weak var headerBTn: UIButton!
    @IBOutlet weak var headerlbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
