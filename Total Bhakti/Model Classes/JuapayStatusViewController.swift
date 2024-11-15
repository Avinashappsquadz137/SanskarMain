//
//  JuapayStatusViewController.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 01/03/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit

class JuapayStatusViewController: UIViewController {
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var statusMessage: UILabel!
    
    var txnStatus: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        
        if txnStatus == "charged" {
            if #available(iOS 13.0, *) {
                statusImage.image = UIImage.init(systemName: "checkmark.seal.fill")
            } else {
                // Fallback on earlier versions
            }
            statusImage.tintColor = UIColor.systemBlue
            statusMessage.text = "Payment Successfull!"
            statusMessage.textColor = UIColor.systemBlue
            
        } else if txnStatus == "pending_vbv" || txnStatus == "authorizing" {
            if #available(iOS 13.0, *) {
                statusImage.image = UIImage.init(systemName: "clock.badge.exclamationmark.fill")
                if #available(iOS 13.0, *) {
                    statusImage.image = UIImage.init(systemName: "exclamationmark.triangle.fill")
                } else {
                    // Fallback on earlier versions
                }
                // Fallback on earlier versions
            }
            statusImage.tintColor = UIColor.systemOrange
            statusMessage.text = "Payment Pending..."
            statusMessage.textColor = UIColor.systemOrange

        } else {
            if #available(iOS 13.0, *) {
                statusImage.image = UIImage.init(systemName: "exclamationmark.triangle.fill")
            } else {
                // Fallback on earlier versions
            }
            statusImage.tintColor = UIColor.red
            statusMessage.text = "Payment Failed."
            statusMessage.textColor = UIColor.red
        }

    }
    


}
