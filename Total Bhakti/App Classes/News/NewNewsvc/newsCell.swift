//
//  newsCell.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 24/08/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class newsCell: UICollectionViewCell {
    
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var MoreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
    }

}
