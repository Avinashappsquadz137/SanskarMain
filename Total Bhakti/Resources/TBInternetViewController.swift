//
//  constant.swift
//  Total Bhakti
//
//  Created by MAC MINI on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
    
class TBInternetViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector (reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    //MARK:- Methods
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            noInternet = false
            print("Reachable via WiFi or Cellular")
        case .none:
            showAlert()
            noInternet = true
            print("Network not reachable")
        }
    }
    func showAlert(){
        let alert = UIAlertController(title: "ERROR", message: "Sorry! Data connection is required to process the services. However, you can play offline songs", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
