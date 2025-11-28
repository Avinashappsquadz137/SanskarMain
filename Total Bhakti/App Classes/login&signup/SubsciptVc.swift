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
    @IBOutlet weak var subscribeBtn: UIButton!
    
    var subData: subData?
    var paymentm = ""
    var subscriptionid = ""
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
    
    @IBAction func btnScripation(_ sender: UIButton) {
        if subscriptionid.isEmpty {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as! TBPremiumPaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showFirstConfirmation()
        }
    }
    
    func showFirstConfirmation() {
        let alert = UIAlertController(
            title: "Cancel Subscription",
            message: "Are you sure you want to cancel your subscription?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.showSecondConfirmation()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func showSecondConfirmation() {
        let alert = UIAlertController(
            title: "Confirm Again",
            message: "Are you really sure you want to cancel? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            self.cancelSubscription()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func cancelSubscription() {
        subscriptionCancelled()
    }

    func subscriptionCancelled() {
        var dict = Dictionary<String,Any>()
        dict["user_id"] = currentUser.result?.id ?? "163"
        dict["subscription_id"] = subscriptionid
        HttpHelper.apiCallWithout(postData: dict as NSDictionary, url: "transaction/cancel_subscription",identifier: "") { result, response, error, data in
            if let error = error {
                        print("Cancel Error:", error.localizedDescription)
                        return
                    }

                    print("Cancel Response:", response ?? "")

                    let message = (response as? [String: Any])?["message"] as? String ?? "Something went wrong"

                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Subscription",
                            message: message,
                            preferredStyle: .alert
                        )

                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            if message.lowercased().contains("success") {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }))

                        self.present(alert, animated: true, completion: nil)
                    }
        }
    }
    func getPremium() {
        var dict = Dictionary<String,Any>()
        dict["user_id"] = currentUser.result?.id ?? "163"
        HttpHelper.apiCallWithout(postData: dict as NSDictionary, url: "user/user_meta/get_user_premium_plan_details",identifier: "") { result, response, error, data in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(SubResponse.self, from: data)
                DispatchQueue.main.async {
                    self.setDteails(model: result.data)
                    self.subscriptionid = result.data.subscription_id ?? ""
                    self.subScripationPlan()
                }
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
    
    func subScripationPlan() {
        if subscriptionid.isEmpty {
            subscribeBtn.setTitle("SUBSCRIBE NOW", for: .normal)
        }else {
            subscribeBtn.setTitle("CANCEL SUBSCRIPTION", for: .normal)
        }
    }
    func setDteails(model: subData) {

        if model.subscription_id?.isEmpty ?? true {
            subscribeBtn.setTitle("SUBSCRIBE NOW", for: .normal)
            detailsLbl.text = ""
            durationLbl.text = "Pack Duration: \(model.plan_name ?? "")"
            expireTime.text = "Pack Expire on: \(changeDate(with: "\(model.expire_date ?? "")"))"
            upgradeplanbtn.isHidden = true
            return
        }

        detailsLbl.text = "\(model.currency ?? "") \(model.amount ?? "")"
        durationLbl.text = "Pack Duration: \(model.plan_name ?? "")"

        if let expire = model.expire_date {
            expireTime.text = "Pack Expire on: \(changeDate(with: expire))"
        }

        if let remains = model.day_remains,
           let days = Int(remains),
           days <= 10 {
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
    let id: String?
    let plan_name: String?
    let currency: String?
    let amount: String?
    let validity: String?
    let purchase_date: String?
    let expire_date: String?
    let day_remains: String?
    let subscription_id: String?
}
