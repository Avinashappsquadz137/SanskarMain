//
//  programCell.swift
//  Sanskar
//
//  Created by Warln on 23/11/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class programCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var scheduleLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!

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
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configureWith(program: Program) {
        let viewModel = EpProgramViewModel(program: program)
        titleLbl.text = viewModel.titleSting
        scheduleLbl.text = "\(viewModel.startTimeString) - \(viewModel.endTimeString)"
        durationLbl.text = "\(viewModel.durationString)"
        
        scheduleLbl.textColor = .lightGray
        durationLbl.textColor = .lightGray
        
    }
}
