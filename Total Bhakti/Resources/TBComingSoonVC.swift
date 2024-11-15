//
//  TBComingSoonVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 18/04/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBComingSoonVC: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    //MARK:- LifeCycle MEthods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    
    
    //MARK:- Screen Btn Actions.
    @IBAction func screenBtnAction (_ sender : UIButton) {
        switch sender.tag {
        case 10:
            _ = navigationController?.popViewController(animated: true)
        default:
            break
        }
        
    }
}
