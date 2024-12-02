//
//  TBLiveDetailCell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 30/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit

class TBLiveDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var imgMain: UIImageView!

    
  //  @IBOutlet weak var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    
    }
    func configureCell(imageURL: URL? = nil) {
        imgMain?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "landscape_placeholder"))
    }
}
