//
//  commenttableviewcell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 15/05/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit

class commenttableviewcell: UITableViewCell {
    
    
    @IBOutlet weak var userimg:UIImage!
    @IBOutlet weak var usernamelbl:UILabel!
    @IBOutlet weak var usercommentlbl:UILabel!
    @IBOutlet weak var datetimelbl:UILabel!
    @IBOutlet weak var view:UIView!
   
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
