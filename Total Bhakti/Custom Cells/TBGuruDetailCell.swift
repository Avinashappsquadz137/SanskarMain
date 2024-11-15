//
//  TBGuruDetailCell.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 12/02/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class TBGuruDetailCell: UITableViewCell {

    @IBOutlet weak var imageVeiw: UIImageView!
    @IBOutlet weak var imageVeiw2: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var numberOFViews: UILabel!
    @IBOutlet weak var mp3ImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var downloadBtn: UIButton!

//    let mainView = cell.viewWithTag(150)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
/*
 let imageVeiw = cell.viewWithTag(100) as! UIImageView
 let imageVeiw2 = cell.viewWithTag(220) as! UIImageView
 let nameLbl = cell.viewWithTag(110) as! UILabel
 let descriptionLbl = cell.viewWithTag(120) as! UILabel
 let dateLbl = cell.viewWithTag(130) as! UILabel
 let mainView = cell.viewWithTag(150)
 let numberOFViews = cell.viewWithTag(140) as! UILabel
 let mp3ImageView = cell.viewWithTag(200) as! UIImageView
 */
