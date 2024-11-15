//
//  managedeviceViewController.swift
//  Sanskar
//
//  Created by Harish Singh on 19/04/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class managedeviceViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet  var hideview: UIView!
    
    
    
    var refreshControl =  UIRefreshControl()
    var datalist  = [[String:Any]]()
    var selectedString = ""
    let colors = [
        UIColor.red,UIColor.yellow,UIColor.cyan,UIColor.orange,UIColor.purple]
    
    var login_id = [String]()
    //    var login_record_id = [""]
    var login_record_id = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideview.cornerRadius = 25
        hideview.isHidden = true
        
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        var param: Parameters = ["user_id":currentUser.result!.id!]
        hitKmanageapi(param)
        
    }
    
    @IBAction func cancelbtn(_ sender: UIButton) {
        hideview.isHidden = true
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func detachdevicebtn(_ sender: Any) {
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        print(device_id)
        
        print(login_record_id)
        
        hitKmanagelogoutapi()
        
        hideview.isHidden = true
    }
    
    
    func hitKmanageapi(_ param : Parameters){
        self.uplaodData(APIManager.sharedInstance.Kmanageapi , param) { [self] (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    for i in 0..<data.count{
                        let id = (data[i]["id"] as? String ?? "" )
                        print(id)
                        login_id.append(id)
                    }
                    print(login_id)
                    //                   let device_name = (data["device_name"] as? [String] ?? "")
                    self.datalist = data
                    
                    
                    DispatchQueue.main.async {
                        
                        self.collectionview.reloadData()
                    }
                    
                }
               
                
            }
        }
    }
    func hitKmanagelogoutapi() {
       

        let parameters = [
            ["key": "user_id", "value": currentUser.result!.id!, "type": "text"],
            ["key": "login_record_id", "value": [login_record_id], "type": "text"]
        ] as [[String: Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""

        for param in parameters {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition: form-data; name=\"\(paramName)\"\r\n"
            body += "\r\n\(param["value"]!)\r\n"
        }

        body += "--\(boundary)--\r\n"
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://app.sanskargroup.in/data_model/user/Login_record/device_logout")!, timeoutInterval: Double.infinity)
        request.addValue("ci_session=jv2t2fiko3dfqt9rnv01jpc8hncg97r4", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response here
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Data is nil.")
                return
            }

            print(String(data: data, encoding: .utf8)!)
            var param: Parameters = ["user_id":currentUser.result!.id!]
            self.hitKmanageapi(param)
        }
 
        task.resume()
        
    }

}

extension managedeviceViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datalist.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "manageCollectionViewCell", for: indexPath) as! manageCollectionViewCell
        let plabel = datalist[indexPath.row]["device_name"] as? String ?? ""
     //   let plabel = arryd[indexPath.row]
  
        cell.label!.text = plabel
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
//        let newid = login_id[indexPath.row]
      print(login_id)
//        login_record_id.append(newid)
        login_record_id = datalist[indexPath.row]["id"] as? String ?? ""
        print(login_record_id)
       
        hideview.isHidden = false
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        indexPath.section == 1
    }
    
}
extension managedeviceViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 150)
    }
    

}
