//
//  profileactivecollectioncell.swift
//  Sanskar
//
//  Created by Surya on 26/07/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class profileactivecollectioncell: UICollectionViewCell {
    @IBOutlet weak var userprofileimage: UIImageView!
    @IBOutlet weak var username:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        userprofileimage.layer.cornerRadius = userprofileimage.layer.bounds.width / 7
        userprofileimage.clipsToBounds = true
    }

}
