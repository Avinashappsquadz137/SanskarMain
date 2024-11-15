//
//  TBGuruListTableViewCell.swift
//  Total Bhakti
//
//  Created by Sudeep  on 2/8/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBGuruListTableViewCell: UITableViewCell {

    @IBOutlet weak var guruImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
