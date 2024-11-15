//
//  paymentTableViewCell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 21/12/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class paymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var planname:UILabel!
    @IBOutlet weak var pricelbl:UILabel!
    @IBOutlet weak var mainview:UIView!
    @IBOutlet weak var coupenbtn:UIButton!
    @IBOutlet weak var buyplanbtn:UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        buyplanbtn.layer.cornerRadius = 10
        mainview.layer.cornerRadius = 10
       
    }
    

    
}
