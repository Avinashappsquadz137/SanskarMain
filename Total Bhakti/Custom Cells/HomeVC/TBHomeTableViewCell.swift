//
//  TBHomeTableViewCell.swift
//  Total Bhakti
//
//  Created by MAC MINI on 05/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBHomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dataCollectionView: UICollectionView!
    @IBOutlet weak var premiumCollectionView: UICollectionView!

    @IBOutlet weak var channelCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
