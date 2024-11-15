//
//  MxChannelCell.swift
//  Sanskar
//
//  Created by Warln on 07/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class MxChannelCell: UICollectionViewCell {
    
    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
    }
    

    

    
    
}
