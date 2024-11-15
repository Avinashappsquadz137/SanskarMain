//
//  mainpoojaTableViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 01/02/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class mainpoojaTableViewCell: UITableViewCell {
    
   
    
    
    @IBOutlet weak var mainpoojaimage: UIImageView!
    
    @IBOutlet weak var btnstackview: UIStackView!
    
    @IBOutlet weak var handbtn: UIButton!
    
    @IBOutlet weak var flowerbtn: UIButton!
    
    @IBOutlet weak var bellbtn: UIButton!
    
    @IBOutlet weak var thalibtn: UIButton!
    
    @IBOutlet weak var laddubtn: UIButton!
    
    var templedatab = [String:Any]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
        print(templedatab)
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        
//    }
    
    
}
