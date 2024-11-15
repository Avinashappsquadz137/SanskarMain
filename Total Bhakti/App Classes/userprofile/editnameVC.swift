//
//  editnameVC.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 04/09/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class editnameVC: UIViewController {
    
    @IBOutlet weak var cancelbtn:UIButton!
    @IBOutlet weak var confirmbtn:UIButton!
    @IBOutlet weak var cancelview:UIView!
    @IBOutlet weak var canceltxt:UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelbtn.layer.cornerRadius = 10
        confirmbtn.layer.cornerRadius = 10
        cancelview.layer.cornerRadius = 10
        canceltxt.layer.cornerRadius = 10
    }
    
    @IBAction func cancelbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmbtn(_ sender: UIButton) {
        navigationTohomepage()
    }
    
}
