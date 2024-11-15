//
//  WallCollectionCell.swift
//  Sanskar
//
//  Created by Warln on 14/04/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

class WallCollectionCell: UICollectionViewCell {
    static let identifier = "WallCollectionCell"
    
    private let posterImg: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImg)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImg.frame = bounds
    }
    
    func setup() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
    }
    
    func configure(data: String) {
        guard let url = URL(string: data) else {return}
        posterImg.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "default_image"),
            options: .refreshCached,
            completed: nil
        )
    }
    
}
