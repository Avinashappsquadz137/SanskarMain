//
//  Newpaymentvc.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 21/12/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit
import HyperSDK

class Newpaymentvc: UIViewController {
    
    var selected = ""
    var paymentData : [paymentModel] = []
    var paymentModelData : paymentModel?
    var userId : String = ""
    var selectedIndex : Int?
    var currcenyData = [Any]()
    public var completionHandler: ((Bool) -> Void)?
    let hyperInstance = HyperServices()
    var sdkPayloadjuspay : [String: Any]?
    var txnStatus: String?
    
    @IBOutlet weak var paymenttable:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("hidetabbar"), object: nil)
        paymenttable.register(UINib(nibName: "paymentTableViewCell", bundle: nil), forCellReuseIdentifier: "paymentTableViewCell")
        paymenttable.delegate = self
        paymenttable.dataSource = self
        let premium_is = UserDefaults.standard.string(forKey: "is_premium")
        print( premium_is)
        initializer()
        
        hyperInstance.initiate(
                    self,
                    payload: createInitiatePayload(),
                    callback: hyperCallbackHandler
                )
    }
    func initializer(){
        
        let param : Parameters = ["user_id": currentUser.result?.id ?? ""]
        getPaymentPlanApi(param)
    }
    func createInitiatePayload() -> [String: Any] {
            let innerPayload : [String: Any] = [
                "action": "initiate",
                "merchantId": "sanskarott",
                "clientId": "sanskarott",
                "environment": "production"
            ];
            let sdkPayload : [String: Any] = [
                "requestId": UUID().uuidString,
                "service": "in.juspay.hyperpay",
                "payload": innerPayload
            ]
            return sdkPayload
        }
    func getPaymentPlanApi(_ param : Parameters){
        let jwt:HTTPHeaders = ["jwt":"\(UserDefaults.standard.value(forKey: "jwt") ?? "")"]
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodData1(APIManager.sharedInstance.KPaymentPlanApi, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    self.currcenyData.append(JSON["data"] as? [Any] ?? [])
                    let data = JSON.ArrayofDict("data")
                    _ = data.filter({ (dict) -> Bool in
                         
                        self.paymentData.append(paymentModel(dict: dict))
                        return true
                    })
                    self.paymenttable.reloadData()
                }else {
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
            }
        }
    }
    
    @IBAction func backbtn(_sender:UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("showtabbar"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    func getPaymentPlanjuspay(_ param : Parameters){
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        for param in param {
            let paramName = param.key
            body += "--\(boundary)\r\n"
            body += "Content-Disposition: form-data; name=\"\(paramName)\"\r\n"
            body += "\r\n\(param.value)\r\n"
        }
        body += "--\(boundary)--\r\n"
        let postData = body.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://app.sanskargroup.in/api_doc/PaymentJusPay/createOrderSanskarPayment")!, timeoutInterval: Double.infinity)
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
            do {
                       if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let responseData = json["data"] as? [String: Any],
                          let payload = responseData["payload"] as? [String: Any],
                          let sdkPayload = payload["sdk_payload"] as? [String: Any] {
                           let preTransactionId = responseData["pre_transaction_id"] as? String
                             print(preTransactionId)
                           UserDefaults.standard.set(preTransactionId, forKey: "pre_transaction_id")
                           UserDefaults.standard.synchronize()
                           self.sdkPayloadjuspay = sdkPayload
                           print(self.sdkPayloadjuspay)
                           if self.hyperInstance.isInitialised() {
                               DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
                               DispatchQueue.main.async {
                                   self.hyperInstance.baseViewController = self
                                                 // Calling process on hyperService to open the Hypercheckout screen
                                                 // block:start:process-sdk
                                   self.hyperInstance.process(self.sdkPayloadjuspay)
                                                 // block:end:process-sdk
                               }
                                     
                                                 }
                       }
                   } catch {
                       print("Error parsing JSON: \(error)")
                   }                                                                                                                                     }
        task.resume()
    }
    func getPaymentsuccessjuspay(_ param : Parameters){
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""

        for param in param {
            let paramName = param.key
            body += "--\(boundary)\r\n"
            body += "Content-Disposition: form-data; name=\"\(paramName)\"\r\n"
            body += "\r\n\(param.value)\r\n"
        }
        body += "--\(boundary)--\r\n"
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://app.sanskargroup.in/api_doc/PaymentJusPay/handlePaymentReturn")!, timeoutInterval: Double.infinity)
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
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let responseData = json["data"] as? [String: Any]
                    print(responseData)
                }
                   } catch {
                       print("Error parsing JSON: \(error)")
                   }
        }
        task.resume()
    }
    func hyperCallbackHandler(response: [String: Any]?) {
        if let data = response, let event = data["event"] as? String {
            print(data)
            if event == "hide_loader" {
                // hide loader
            }
            else if event == "process_result" {
                let error = data["error"] as? Bool ?? false
                if let innerPayload = data["payload"] as? [String: Any] {
                    let status = innerPayload["status"] as? String
                    let pi = innerPayload["paymentInstrument"] as? String
                    let pig = innerPayload["paymentInstrumentGroup"] as? String
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if !error {
                        if  let data = response, var requestId = data["requestId"] as? String{
                            print(requestId)
                            if let preTransactionId = UserDefaults.standard.string(forKey: "pre_transaction_id")  {
                                print(preTransactionId)
                                let param: Parameters  = ["user_id":currentUser.result?.id ?? "","pre_transaction_id":preTransactionId,"post_transaction_id":requestId,"device_type":"2"]
                                print(param)
                                self.getPaymentsuccessjuspay(param)
                                performSegue(withIdentifier: "statusSegue", sender: status)
                            }
                        } else {
                            let errorCode = data["errorCode"] as? String
                            let errorMessage = data["errorMessage"] as? String
                            switch status {
                            case "backpressed":
                                // user back-pressed from PP without initiating any txn
                                let alertController = UIAlertController(title: "Payment Cancelled", message: "User clicked back button on Payment Page", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                present(alertController, animated: true, completion: nil)
                                break
                            case "user_aborted":
                                // user initiated a txn and pressed back
                                // poll order status
                                let alertController = UIAlertController(title: "Payment Aborted", message: "Transaction aborted by user", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                present(alertController, animated: true, completion: nil)
                                break
                            case "pending_vbv", "authorizing":
                                performSegue(withIdentifier: "statusSegue", sender: status)
                                // txn in pending state
                                // poll order status until backend says fail or success
                                break
                            case "authorization_failed", "authentication_failed", "api_failure":
                                performSegue(withIdentifier: "statusSegue", sender: status)
                                // txn failed
                                // poll orderStatus to verify (false negatives)
                                break
                            case "new":
                                performSegue(withIdentifier: "statusSegue", sender: status)
                                // order created but txn failed
                                // very rare for V2 (signature based)
                                // also failure
                                // poll order status
                                break
                            default:
                                performSegue(withIdentifier: "statusSegue", sender: status)
                                break
                            }
                        }
                    }
                }
                // block:end:handle-process-result
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statusSegue" {
            if let destinationVC = segue.destination as? JuapayStatusViewController {
                if let txnStatus = sender as? String {
                    print(txnStatus)
                    destinationVC.txnStatus = txnStatus
                }
            }
            if let txnStatus = sender as? String {
                print(txnStatus)
            }
        }
    }
}
extension Newpaymentvc: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return paymentData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentTableViewCell", for: indexPath) as! paymentTableViewCell
      cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        let planname = paymentData[indexPath.section].plan_name
        print(planname)
        cell.planname?.text = planname
        if paymentData[indexPath.row].currency == "INR"{
            cell.pricelbl?.text = "\(kCureencySymbol)\(paymentData[indexPath.section].amount ?? "")"
        }else{
            cell.pricelbl?.text = "$ \(paymentData[indexPath.section].amount ?? "")"
        }
        cell.buyplanbtn.tag = indexPath.section
        cell.buyplanbtn.addTarget(self, action: #selector(coupenpagebtn(_:)) , for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if #available(iOS 15.0, *) {
            view.backgroundColor = UIColor.systemOrange
        } else {
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymenttable.deselectRow(at: indexPath, animated: true)
       }
    @objc func coupenpagebtn(_ sender: UIButton) {
            let indexPath = IndexPath(row: 0, section: sender.tag)
            let amount = paymentData[indexPath.section].amount
            print(amount!)
        let validity = paymentData[indexPath.section].validity
        let planid = paymentData[indexPath.section].plan_id
        let currency = paymentData[indexPath.section].currency
        let param: Parameters  = ["user_id":currentUser.result?.id ?? "","amount":amount!,"pay_via":"0","validity":validity!,"plan_id":planid!,"currency":currency!,"device_type":"2"]
        print(param)
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.getPaymentPlanjuspay(param)
            }
        }
