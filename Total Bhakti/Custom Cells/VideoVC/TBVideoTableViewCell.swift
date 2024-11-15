//
//  TBVideoTableViewCell.swift
//  Total Bhakti
//
//  Created by MAC MINI on 13/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBVideoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
