//
//  scanViewControllertest.swift
//  Sanskar
//
//  Created by Harish Singh on 13/03/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class scanViewControllertest: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var mode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "\(mode)"
    }
   
}
