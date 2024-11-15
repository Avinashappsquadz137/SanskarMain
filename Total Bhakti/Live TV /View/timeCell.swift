//
//  timeCell.swift
//  Sanskar
//
//  Created by Warln on 23/11/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class timeCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var liveBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.darkGray
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
    }

}
