//
//  holiprogramlistcell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 07/03/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit

class holiprogramlistcell: UITableViewCell {
    
    @IBOutlet weak var guruimg:UIImageView!
    @IBOutlet weak var gurunamelbl:UILabel!
    @IBOutlet weak var programdetaillbl:UILabel!
    @IBOutlet weak var invitationbtn:UIButton!
    @IBOutlet weak var mainview:UIView!
    @IBOutlet weak var titlelbl:UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        guruimg.layer.cornerRadius = guruimg.layer.bounds.width / 2
        invitationbtn.layer.cornerRadius = 10
        mainview.layer.cornerRadius = 10
        
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
