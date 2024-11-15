//
//  TBGuruTableCell.swift
//  Total Bhakti
//
//  Created by Viru on 30/12/19.
//  Copyright © 2019 MAC MINI. All rights reserved.
//

import UIKit

class TBGuruTableCell: UITableViewCell {
  
    @IBOutlet weak var CollectionViewGuru: UICollectionView!
    
    @IBOutlet var heightConstant: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
