//
//  demoFileVc.swift
//  Sanskar
//
//  Created by Warln on 01/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class demoFileVc: UIViewController {
    
    @IBOutlet weak var demoId: UILabel!
    
    var userId:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demoId.text = "\(String(describing: userId))"

        
    }
    



}
