//
//  channelCell.swift
//  Sanskar
//
//  Created by Warln on 23/11/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class channelCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

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
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configureWith(epChannel: EpChannel) {
        let viewModel = EpChannelViewModel(epChannel: epChannel)
        if let _ = viewModel.Url {
            imageView.sd_setImage(with: viewModel.Url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
    }

}
