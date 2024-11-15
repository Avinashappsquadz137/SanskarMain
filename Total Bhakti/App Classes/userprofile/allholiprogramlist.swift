//
//  profileuservc.swift
//  Sanskar
//
//  Created by Surya on 26/07/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class allholiprogramlist: UIViewController {
    
    @IBOutlet weak var tableview:UITableView!
    
    var festivals: [Festival] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "holiprogramlistcell", bundle: nil), forCellReuseIdentifier: "holiprogramlistcell")
        tableview.dataSource = self
        tableview.delegate = self
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163"]
        getholideatilapi(param)
        
    }
    
    func getholideatilapi(_ param: Parameters) {
        DispatchQueue.main.async {
            loader.shareInstance.showLoading(self.view)
        }
        
        // Assuming `uplaodData1` is a function that makes an API request and calls the completion handler with the response
        self.uplaodData1(APIManager.sharedInstance.Kholiprogramdetailapi, param) { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }
            
            if let JSON = response as? NSDictionary,
               let data = JSON["data"] as? [[String: Any]] {
                
                // Parse festival data
                do {
                    let decoder = JSONDecoder()
                    let festivals = try decoder.decode([Festival].self, from: try JSONSerialization.data(withJSONObject: data))
                    
                    // Update festivals array and reload table view
                    self.festivals = festivals
                    print(festivals)
                    self.tableview.reloadData()
                    
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
      navigationTohomepage()
    }
    
}

extension allholiprogramlist:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.festivals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "holiprogramlistcell", for: indexPath) as! holiprogramlistcell
        cell.gurunamelbl.text = festivals[indexPath.row].guruName
        cell.titlelbl.text = festivals[indexPath.row].title
        cell.programdetaillbl.text = festivals[indexPath.row].description
        cell.guruimg.sd_setImage(with: URL(string: festivals[indexPath.row].guruProfile))
        cell.invitationbtn.tag = indexPath.row
        cell.invitationbtn.addTarget(self, action: #selector(userinvitatiobtn(_:)) , for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)

       }
    @objc func userinvitatiobtn(_ sender: UIButton) {
        let row = sender.tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "holishowdetail") as! holishowdetail
        vc.titledata = festivals[row].title
        vc.detaildata = festivals[row].description
        vc.guruimgdata = festivals[row].guruProfile
        vc.gurunamedata = festivals[row].guruName
        vc.locationdata = festivals[row].location
        vc.usercodedata = festivals[row].invitationCode

        navigationController?.pushViewController(vc, animated: true)
    }
}
