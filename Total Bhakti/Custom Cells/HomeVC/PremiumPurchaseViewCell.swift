//
//  PremiumPurchaseViewCell.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 09/10/25.
//  Copyright © 2025 MAC MINI. All rights reserved.
//

import UIKit

class PremiumPurchaseViewCell: UITableViewCell {

    @IBOutlet weak var logoSanskar: UIImageView!
    @IBOutlet weak var lblSubNow: UILabel!
    
    @IBOutlet weak var btnSubscribe: UIButton!
    
   
    private var buttonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSubscribe.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureButton(action: @escaping () -> Void) {
            buttonAction = action
        }

        @objc private func buttonTapped() {
            buttonAction?()
        }
}
