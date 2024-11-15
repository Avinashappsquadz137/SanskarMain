//
//  TBchannelTableView.swift
//  Total Bhakti
//
//  Created by MAC MINI on 07/09/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
protocol TBchannelTableDelegate {
    func hideTableAction()
}

class TBchannelTableView : UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate : TBchannelTableDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 5.0
        tableView.register(UINib(nibName: "TBTableViewCell", bundle: nil), forCellReuseIdentifier: "KCELL2")
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func hideTableAction(_ sender: UIButton) {
         delegate?.hideTableAction()
    }
    
}


//MARK:- UITableView DataSource Methods
extension TBchannelTableView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if channelTableArr.count != 0 {
                    return channelTableArr.count
            }else  {
                return 0
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL2, for: indexPath) as! TBTableViewCell
        let channelObject = channelTableArr[indexPath.row]
        
        cell.lbl.text = channelObject.name
        cell.channelImageView.layer.cornerRadius = cell.channelImageView.frame.width / 2
        if let urlString = channelObject.image , urlString.isEmpty == false {
            cell.channelImageView.clipsToBounds = true
            cell.channelImageView.sd_setIndicatorStyle(.gray)
            cell.channelImageView.contentMode = .scaleAspectFit
            cell.channelImageView.sd_setShowActivityIndicatorView(true)
            cell.channelImageView.clipsToBounds = true
            cell.channelImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        return cell
    }
    }


//MARK:- UITableView Delegates Methods
extension TBchannelTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KCOMINGSOONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
}

