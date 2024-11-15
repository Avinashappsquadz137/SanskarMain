//
//  templeTableViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 17/01/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class templeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var templeimage: UIImageView!
    
    @IBOutlet weak var templenamelbl: UILabel!
    
    
    @IBOutlet weak var templeplacelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
