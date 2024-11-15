//
//  TBHomeCollectionTableCell.swift
//  Total Bhakti
//
//  Created by MAC MINI on 05/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBHomeCollectionTableCell: UICollectionViewCell {

   
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var tvMainView: AAPlayer!
    
    @IBOutlet weak var image : UIImageView!
    @IBOutlet weak var threeDotBtn : UIButton!
    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var descriptionLbl : UILabel!
    @IBOutlet weak var playIcon : UIImageView!

    
    //            let image = cell.viewWithTag(100) as? UIImageView
    //            let threeDotBtn = cell.viewWithTag(201) as? UIButton
    //            threeDotBtn?.isHidden = true
    //            let lbl = cell.viewWithTag(200) as? UILabel
    //            let mainView = cell.viewWithTag(300)
    //            let descriptionLbl = cell.viewWithTag(400) as! UILabel
    //            let playIcon = cell.viewWithTag(500) as! UIImageView

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
