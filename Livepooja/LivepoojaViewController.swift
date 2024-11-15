//
//  LivepoojaViewController.swift
//  Sanskar
//
//  Created by Harish Singh on 17/01/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit

class LivepoojaViewController: UIViewController {
    
    var refreshControl =  UIRefreshControl()
    var datalist  = [String:Any]()
    var godtempdata = [[String:Any]]()
    var templedata = [[String:Any]]()
    var goddata = [[String:Any]]()
    var godid = ""
    var position = 0
    var index = 0
   
    
    @IBOutlet weak var godcollectionview: UICollectionView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var stateview: UIView!
    
    @IBOutlet weak var statetableview: UITableView!
    
    @IBOutlet weak var godlabel: UILabel!
    
    var StateN:[String] = ["Andhra Pradesh",
                               "Assam","Bihar","Karnataka","Punjab","Chhattisgarh","Odisha","Madhya Pradesh","Haryana","Tamil Nadu","Maharashtra","Uttar Pradesh","Gujarat","Kerala","Rajasthan",
                               "Himachal Pradesh","Goa","Mizoram","West Bengal","Tripura","Sikkim","Arunachal Pradesh","Manipur","Nagaland","Jharkhand","Meghalaya","Uttarakhand","Telangana","Delhi", "Jammu & Kashmir"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statetableview.register(UINib(nibName: "godwiseTableViewCell", bundle: nil), forCellReuseIdentifier: "godwiseTableViewCell")
        godcollectionview.delegate = self
        godcollectionview.dataSource = self
        tableview.delegate = self
        tableview.dataSource = self
        statetableview.delegate = self
        statetableview.dataSource = self
        stateview.isHidden = true
        
        var param: Parameters = [:]
        hitlivepoojaapi(param)
       
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func statesbtn(_ sender: UIButton) {
    
    }

    func hitlivepoojaapi(_ params : Parameters){
        self.uplaodData(APIManager.sharedInstance.KLivepoojaapi , params) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                print(JSON)
                    let data = (JSON["data"] as? [String:Any] ?? [:])
                    print(data)
                    self.datalist = data
                    print(self.datalist)
                    self.goddata = (data["god_list"] as? [[String:Any]] ?? [])
                    print(self.goddata)
                    
                    self.templedata =  (data["temple_list_list"] as? [[String:Any]] ?? [])
                    print(self.templedata)
                
                }
              //  print(self.templedata)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.godcollectionview.reloadData()
                }
            }
        }
    }
    func hitlivepoojagodwiseaapi(_ param : Parameters){
        self.templedata.removeAll()
        self.uplaodData(APIManager.sharedInstance.Klivepoojagodwise , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                
                if JSON.value(forKey: "status") as? Bool == true {
                print(JSON)
                   
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    self.godtempdata = data
                    print(self.godtempdata)
                    self.templedata = self.godtempdata

                }
//                else
//                {
//                AlertController.alert(message: JSON["message"] as? String ?? "")
//                }
         
                DispatchQueue.main.async {
                    self.statetableview.reloadData()
                   
                }
            }
        }
    }
    
}
extension LivepoojaViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goddata.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = godcollectionview.dequeueReusableCell(withReuseIdentifier: "livepoojaCollectionViewCell", for: indexPath) as! livepoojaCollectionViewCell
        let gimage = goddata[indexPath.row]["image"] as? String ?? ""
        let gname = goddata[indexPath.row]["name"] as? String ?? ""
        cell.godnamelbl!.text = gname
        cell.godimage!.sd_setImage(with: URL(string: gimage))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let god_id = goddata[indexPath.row]["id"] as? String ?? ""
        godid = god_id
        var params: Parameters = ["user_id": currentUser.result?.id ?? "163","god_id": godid]
        hitlivepoojagodwiseaapi(params)
        stateview.isHidden = false

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension LivepoojaViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == statetableview) ? godtempdata.count : templedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == statetableview{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "godwiseTableViewCell", for: indexPath) as! godwiseTableViewCell
            cell1.namelabel.text = godtempdata[indexPath.row]["temple_name"] as? String ?? ""
            cell1.locationlabel.text =  godtempdata[indexPath.row]["address"] as? String ?? ""
            let tempimg = godtempdata[indexPath.row]["thumbnail"] as? String ?? ""
            cell1.templeimg.sd_setImage(with: URL(string: tempimg))
            return cell1
        }
        else 
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "templeTableViewCell", for: indexPath) as! templeTableViewCell
            print(templedata)
            let thumbnailP = templedata[indexPath.row]["thumbnail"] as? String ?? ""
            let named = templedata[indexPath.row]["temple_name"] as? String ?? ""
            let address = templedata[indexPath.row]["address"] as? String ?? ""
            cell.templeimage.sd_setImage(with: URL(string: thumbnailP))
            cell.templenamelbl.text = named
            cell.templeplacelbl.text = address
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView == statetableview) ? 280 : 270
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == statetableview {
            let controller = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KLIVEPOOJADETAIL) as! livepoojadetailViewController
            print(self.templedata)
            let post = templedata[indexPath.row]
            let temple_id = templedata[indexPath.row]["id"] as? String ?? ""
            print(temple_id)
            controller.templedataa = post
            controller.temple_id = temple_id
            print(controller.templedataa)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        else
        {
            let controller = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KLIVEPOOJADETAIL) as! livepoojadetailViewController
            print(self.templedata)
            let post = templedata[indexPath.row]
            let temple_id = templedata[indexPath.row]["id"] as? String ?? ""
            print(temple_id)
            controller.templedataa = post
            controller.temple_id = temple_id
            print(controller.templedataa)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
     
}
 



