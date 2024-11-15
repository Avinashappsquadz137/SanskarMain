//
//  customPop.swift
//  Sanskar
//
//  Created by Warln on 02/03/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

class customPop: UIViewController {
    
    @IBOutlet weak var preImage: UIImageView!
    @IBOutlet weak var holder: UIView!
    var img: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.holder.addSubview(blurEffectView)
        preImage.sd_setImage(with: URL(string: img ?? ""), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

}
