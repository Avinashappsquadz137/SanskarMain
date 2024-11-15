//
//  TBCommentTableCell.swift
//  Total Bhakti
//
//  Created by MAC MINI on 04/04/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBCommentTableCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var viewForImage: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var heightConstraintForNameLbl: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
