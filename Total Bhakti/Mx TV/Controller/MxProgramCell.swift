//
//  MxProgramCell.swift
//  Sanskar
//
//  Created by Warln on 07/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

class MxProgramCell: UICollectionViewCell {
    
    @IBOutlet weak var lView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var play: UILabel!
    @IBOutlet weak var progBtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.size.height / 5
        self.play.layer.cornerRadius = play.frame.size.height / 5
        self.play.layer.borderWidth = 0.5
        self.play.layer.borderColor = UIColor.red.cgColor
        self.play.clipsToBounds = true
    }
    
    func configureImg(model: String ) {
        print(model.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        guard let url = URL(string: model) else {return}
        image.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"))
        
    }

}
