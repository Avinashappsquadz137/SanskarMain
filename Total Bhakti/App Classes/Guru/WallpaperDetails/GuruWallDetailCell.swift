//
//  GuruWallDetailCell.swift
//  Sanskar
//
//  Created by Warln on 15/04/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

class GuruWallDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with data: String) {
        guard let url = URL(string: data) else {return}
        posterImg.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "default_image"),
            options: .refreshCached,
            completed: nil
        )
    }

}
