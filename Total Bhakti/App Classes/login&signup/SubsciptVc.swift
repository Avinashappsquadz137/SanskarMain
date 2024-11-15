//
//  SubsciptVc.swift
//  Sanskar
//
//  Created by Warln on 18/07/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class SubsciptVc: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var expireTime: UILabel!
    @IBOutlet weak var upgradeplanbtn:UIButton!
    
    var subData: subData?
    var paymentm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","device_type":"2"]
        hitcheckpaymentapi(param)
        upgradeplanbtn.layer.cornerRadius = 10
        upgradeplanbtn.isHidden = true

        holderView.layer.cornerRadius = 10
        holderView.clipsToBounds = true
        getPremium()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = gradientBackground()
        layer.frame = holderView.bounds
        holderView.clipsToBounds = true
        holderView.layer.insertSublayer(layer, at: 0)
    }
    
    func hitcheckpaymentapi(_ param : Parameters){
        self.uplaodData1(APIManager.sharedInstance.Kcheckpaymentstatusapi, param) { (response) in
       //     DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                    let dataArray = JSON["data"] as? [String: Any] ?? [:]
                    print(dataArray)
                let payment = JSON["payment_method"] as? String ?? ""
                print(payment)
                self.paymentm = payment
                print(self.paymentm)
                
                        
                    }
                }
            }
    
    @IBAction func backBtnPressed(_ sender: UIButton ) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func upgradeplanbtn(_ sender: UIButton) {
        if paymentm == "0" {
            // Present Newpaymentvc
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Newpaymentvc") as! Newpaymentvc
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Present TBPremiumPaymentVC
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as! TBPremiumPaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func getPremium() {
        var dict = Dictionary<String,Any>()
        dict["user_id"] = currentUser.result?.id ?? "163"
        HttpHelper.apiCallWithout(postData: dict as NSDictionary, url: "user/user_meta/get_user_premium_plan_details", identifire: "") { result, response, error, data in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(SubResponse.self, from: data)
                DispatchQueue.main.async {
                    self.setDteails(model: result.data)
                }
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
    
    func setDteails(model: subData) {
        if model.currency == "USD"{
            detailsLbl.text = "$\(model.amount)"
        }else{
            detailsLbl.text = "₹\(model.amount)"
        }
        durationLbl.text = "Pack Duration: \(model.plan_name)"
        expireTime.text = "Pack Expire on: \(changeDate(with: model.expire_date))"
        let expiredata = model.day_remains
        print(expiredata)
        if let expireInt = Int(expiredata), expireInt <= 10 {
            upgradeplanbtn.isHidden = false
        }
        
    }
    
    func changeDate(with data: String) -> String {
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(data) ?? 0
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: formatedData)
    }
}


struct SubResponse: Decodable {
    let data: subData
}

struct subData: Decodable {
    let id: String
    let plan_name: String
    let currency: String
    let amount: String
    let validity: String
    let purchase_date: String
    let expire_date: String
    let day_remains: String
}
