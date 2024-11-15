//
//  seasonData.swift
//  Sanskar
//
//  Created by Warln on 18/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class seasonData: UICollectionViewCell {
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var lockImg: UIImageView!
    @IBOutlet weak var seasonView: UIView!
    @IBOutlet weak var playView: UIView!
    
    @IBOutlet weak var imageweight: NSLayoutConstraint!
    @IBOutlet weak var imageheight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageweight.constant = 250
            imageheight.constant = 150
        } else {
            imageheight.constant = 120
            imageweight.constant = 200
        }
    }
    
}
