//
//  livepoojaCollectionViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 17/01/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class livepoojaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var godimage: UIImageView!
    
    @IBOutlet weak var godnamelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        godimage.layer.cornerRadius = godimage.layer.bounds.width / 2
        godimage.clipsToBounds = true
    }

}
