//
//  preCell.swift
//  Sanskar
//
//  Created by Warln on 16/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class preCell: UICollectionViewCell {
    
    @IBOutlet weak var dataImg : UIImageView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var imageweightsize: NSLayoutConstraint!
    @IBOutlet weak var imageheightsize: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        dataImg.layer.cornerRadius = 10
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageweightsize.constant = 200
            imageheightsize.constant = 300
               } else {
                   imageheightsize.constant = 250
                   imageweightsize.constant = 150
               }
    }
}
