//
//  preContinueCell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 11/10/25.
//  Copyright © 2025 MAC MINI. All rights reserved.
//

import UIKit

class preContinueCell: UICollectionViewCell {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var imgheight: NSLayoutConstraint!
    @IBOutlet weak var imgThumblin: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgThumblin.layer.cornerRadius = 10
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imgWidth.constant = 300
            imgheight.constant = 150
        } else {
            imgheight.constant = 150
            imgWidth.constant = 250
        }
    }

}
