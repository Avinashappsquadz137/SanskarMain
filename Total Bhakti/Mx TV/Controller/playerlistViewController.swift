//
//  playerlistViewController.swift
//  Sanskar
//
//  Created by Harish Singh on 21/12/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit



class playerlistViewController: UIViewController {
    
    fileprivate let application = UIApplication.shared
    @IBOutlet weak var dataview: UIView!
    
    @IBOutlet weak var playertableview: UITableView!
    
    var isHied = false
     var datarry = ["Play Now","Play Next","Add to Queue","Share","Add to Favourite","Add to Download"]
    var imgarry = ["play","next-button","playlist","share copy","favorite","download"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHied == true{
            dataview.isHidden = false

        }else{
            dataview.isHidden = true

        }
        view.isOpaque = false
        
        playertableview.delegate = self
        playertableview.dataSource = self
        
    
    }
    
}

extension playerlistViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datarry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playertableview.dequeueReusableCell(withIdentifier: "playerlistTableViewCell", for: indexPath) as! playerlistTableViewCell
        cell.label.text = datarry[indexPath.row]
        cell.imageview.image = UIImage(named: imgarry[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
