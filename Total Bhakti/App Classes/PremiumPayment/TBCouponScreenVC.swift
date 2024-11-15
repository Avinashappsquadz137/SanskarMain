//
//  TBCouponScreenVC.swift
//  Sanskar
//
//  Created by MAC on 12/03/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import Razorpay
import StoreKit



class TBCouponScreenVC: UIViewController, RazorpayPaymentCompletionProtocol, selectedCoupon {    
    
    @IBOutlet weak var planBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var watchBtn: UIButton!
    var paymentData : paymentModel?
    var preTranstionId = String()
    var userID : String = ""
    var qrscan : Bool = false
    @IBOutlet weak var amountlbl: UILabel!
    @IBOutlet weak var totalAmountlbl: UILabel!
 //   @IBOutlet weak var applyCouponlbl: UILabel!
    
    var staticProductIDs: [String]? = ["com.sanskartvapp1","com.sanskartvapp2","com.sanskartvapp3"]
    var productToPurchage : SKProduct?
    var idWillBe = "" 
     
    var productId: String?
//    var inAppservice :  inAppPurchaseService!

    //razor pay
    let razorpay_test_key = "rzp_test_wlwMtEPTnFcCm2"//"rzp_test_wlwMtEPTnFcCm2"
    
    //        "rzp_test_pbt0rolvX65Z40"
    var razorpay: RazorpayCheckout!
    var razorepay_payement_ID = ""
    var mobileNumber = ""
    // let razorpay_Live_key = "rzp_live_v8rGFBJCHefNtx" //AAA_academy //old
    let razorpay_Live_key  = "rzp_live_9lHJC7JIX9kLtr"

    var couponID : String?
    var promocode_applied : String?
    var promocode : String?
    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var payLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializer()
       
        }
    
    func initializer(){
        planLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        payLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

    planBtn.cornerRadius = planBtn.frame.size.height/2
    payBtn.cornerRadius = payBtn.frame.size.height/2
    
    watchBtn.cornerRadius = watchBtn.frame.size.height/2
    watchBtn.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
    watchBtn.borderWidth = 2
    
    planBtn.clipsToBounds = true
    payBtn.clipsToBounds = true
    watchBtn.clipsToBounds = true
        razorpay = RazorpayCheckout.initWithKey(razorpay_Live_key, andDelegate: self)
        
        let adskey = UserDefaults.standard.value(forKey: "iosads") as? String ?? ""
        if adskey == "1"{
            self.amountlbl.text = paymentData?.amount ?? ""
            self.totalAmountlbl.text = paymentData?.amount ?? ""
        }
        else {
            self.amountlbl.text = paymentData?.ios_amount ?? ""
            self.totalAmountlbl.text = paymentData?.ios_amount ?? ""
        }
        
        
        self.idWillBe = paymentData?.apple_pay_id ?? ""
        print(idWillBe)
    }
    
   
    func dataPass(couponModel: couponListModel?) {
        print("couponModel::::",couponModel)
        
        let adskey = UserDefaults.standard.value(forKey: "iosads") as? String ?? ""
        if adskey == "1"{
            self.couponID = (couponModel?.id ?? "")

            if couponModel?.coupon_type == "2"{ //Percentile
                let percentValue = Float((couponModel?.coupon_value)!)!/100 * Float(paymentData!.amount! )!
                let totalAmount = Int(paymentData!.amount!)! - Int(percentValue)
            //    self.applyCouponlbl?.text = "Applied \(couponModel?.coupon_value ?? "")% off"
                self.totalAmountlbl.text = "\(totalAmount)"
            }
            else{ //Flat
                let totalAmount = Int(paymentData!.amount! )! - Int((couponModel?.coupon_value)!)!
                self.totalAmountlbl.text = "\(totalAmount)"
            //    self.applyCouponlbl?.text = "Applied FLAT \(couponModel?.coupon_value ?? "") Rs off"
            }
        }
        
        else
        {
            self.couponID = (couponModel?.id ?? "")

            if couponModel?.coupon_type == "2"{ //Percentile
                let percentValue = Float((couponModel?.coupon_value)!)!/100 * Float(paymentData!.ios_amount! )!
                let totalAmount = Int(paymentData!.ios_amount!)! - Int(percentValue)
            //    self.applyCouponlbl?.text = "Applied \(couponModel?.coupon_value ?? "")% off"
                self.totalAmountlbl.text = "\(totalAmount)"
            }
            else{ //Flat
                let totalAmount = Int(paymentData!.ios_amount! )! - Int((couponModel?.coupon_value)!)!
                self.totalAmountlbl.text = "\(totalAmount)"
            //    self.applyCouponlbl?.text = "Applied FLAT \(couponModel?.coupon_value ?? "") Rs off"
            }
        }
        
      
    }
    
    //MARK:- Api Method.
    func initializePaymentApi(_ param : Parameters){

        self.uplaodData1(APIManager.sharedInstance.KInitializePaymentApi, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})

            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Bool == true {
                    self.preTranstionId = ((JSON["data"] as! NSDictionary)["pre_transaction_id"] as! String)
                    DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })

//                    print("pre_transaction_id:::::",self.pre_transaction_id)
                    let adskey = UserDefaults.standard.value(forKey: "iosads") as? String ?? ""
                    if adskey == "1"{
                        let amount = "\(self.paymentData?.amount ?? "")00"
                        self.showPaymentForm(order_id: self.preTranstionId, amount:amount, contact:currentUser.result?.mobile ?? "", email: currentUser.result?.email ?? "")
                    }
                    else
                    {
                        let amount = "\(self.paymentData?.ios_amount ?? "")00"
                        self.showPaymentForm(order_id: self.preTranstionId, amount:amount, contact:currentUser.result?.mobile ?? "", email: currentUser.result?.email ?? "")
                    }
                    
                }else {
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
            }
        }
    }
    
    func showPaymentForm(order_id : String,amount :String, contact: String, email: String ){

        let options: [String:Any] = [
//            "amount": amount, //This is in currency subunits. 100 = 100 paise= INR 1.
            "amount": amount, //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": paymentData?.currency as Any,//We support more that 92 international currencies.
            "description":"",
            "order_id":order_id,
            "image": UIImage(named:"AppIcon") ,
            "name": currentUser.result?.name ?? "",
            "prefill": [
                "contact": contact,
                "email": email
            ],
            "theme": [
                "color": "#1DA1F2"
            ]
        ]
        DispatchQueue.main.async {
            loader.shareInstance.hideLoading()
            self.razorpay.open(options, displayController: self)
            
        }
        
    }
    func paymentSuccesApi(_ param : Parameters){

        self.uplaodData1(APIManager.sharedInstance.KPaymentSuccessApi, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)

                if JSON.value(forKey: "status") as? Bool == true {
                    self.addAlert(ALERTS.KSUCCESS, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    let paymentDone = ["Bool":true]
                    NotificationCenter.default.post(name: Notification.Name("paymentDone"), object: nil, userInfo:paymentDone)
//                    self.navigationController?.popToRootViewController(animated: true)
                    let vc =  storyBoard.instantiateViewController(withIdentifier: "TBHomeVC") as! TBHomeVC
                    self.navigationController?.pushViewController(vc, animated: true)

                }else {
                    
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
            }
        }
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
          print("Payment failed with code: \(code), msg: \(str)")
//        let vc =  storyBoard.instantiateViewController(withIdentifier: "newPreDetails") as! newPreDetails
//        self.navigationController?.pushViewController(vc, animated: true)
      }
      
      func onPaymentSuccess(_ payment_id: String) {
          print(payment_id)
          self.razorepay_payement_ID = "\(payment_id)"
        
          if qrscan == true {
              
              let params: Parameters = ["user_id":userID ,"pre_transaction_id":preTranstionId,"post_transaction_id":razorepay_payement_ID,"plan_id":paymentData?.plan_id ?? ""]
              DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                paymentSuccesApi(params)
              
          }else{
              let params: Parameters = ["user_id":currentUser.result?.id ?? "","pre_transaction_id":preTranstionId,"post_transaction_id":razorepay_payement_ID,"plan_id":paymentData?.plan_id ?? ""]
              DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                paymentSuccesApi(params)
          }
        
        /*
           user_id:13256
           pre_transaction_id:order_GlLnCGHaVv3JMr
           post_transaction_id:order_GlLnCGHaVv3JMr
           plan_id:3
           */

      }
    func showadsinios() {
        let adskey = UserDefaults.standard.value(forKey: "iosads") as? String ?? ""
        if adskey == "1"{
            
            if qrscan == true {
                DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })

                let param: Parameters = ["user_id": userID,"plan_id":paymentData?.plan_id ?? "","amount":self.totalAmountlbl.text ?? "","pay_via":"0","device_type":"2","validity":paymentData?.validity ?? "","currency":paymentData?.currency, "coupon_applied": couponID ?? "", "promocode_applied":promocode_applied ?? "", "promocode":promocode ?? ""]
                initializePaymentApi(param)

                
            }else{
                DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })

                let param: Parameters = ["user_id": currentUser.result?.id ?? "","plan_id":paymentData?.plan_id ?? "","amount":self.totalAmountlbl.text ?? "","pay_via":"0","device_type":"2","validity":paymentData?.validity ?? "","currency":paymentData?.currency, "coupon_applied": couponID ?? "", "promocode_applied":promocode_applied ?? "", "promocode":promocode ?? ""]
                initializePaymentApi(param)
            }
            
            }else {
                
                self.initializeCourseTransaction()
            }
            
            
            
        
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payBtn(_ sender:UIButton) {
        
        self.showadsinios()
        
       


    }

//    @IBAction func couponBtn(_ sender:UIButton) {
//        print("Coupon button clicked")
//        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBCouponListVC) as? TBCouponListVC
//        vc?.delegate = self
//        navigationController?.pushViewController(vc!, animated: true)
//
//    }
}



 
extension TBCouponScreenVC {
    func initializeCourseTransaction() {
        let param: Parameters = [
            "user_id": currentUser.result?.id ?? "163",
            "plan_id": paymentData?.plan_id ?? "",
            "amount": self.totalAmountlbl.text ?? "",
            "pay_via": "0",
            "device_type": "2",
            "validity": paymentData?.validity ?? "",
            "currency": paymentData?.currency ?? "",
            "coupon_applied": couponID ?? "",
            "promocode_applied": promocode_applied ?? "",
            "promocode": promocode ?? ""
        ]
        
        DispatchQueue.main.async {
            loader.shareInstance.showLoading(self.view)
        }
        
        self.uplaodData1(APIManager.sharedInstance.KInitializePaymentApi, param) { response in
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                
                if JSON.value(forKey: "status") as? Bool == true {
                    self.preTranstionId = ((JSON["data"] as! NSDictionary)["pre_transaction_id"] as! String)
                    self.initializeIAP()
                } else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    DispatchQueue.main.async {
                        loader.shareInstance.hideLoading()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    loader.shareInstance.hideLoading()
                }
            }
        }
    }

    private func initializeIAP() {
        DispatchQueue.main.async {
            loader.shareInstance.showLoading(self.view)
        }
        
        PKIAPHandler.shared.setProductIds(ids: [idWillBe])
        fetchAvailableProducts {
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }
            self.purchageProduct()
        }
    }

    private func fetchAvailableProducts(completion: @escaping () -> Void) {
        PKIAPHandler.shared.fetchAvailableProducts { products in
            self.productToPurchage = self.getProductID(products: products)
            completion()
        }
    }

    private func purchageProduct() {
        guard let product = self.productToPurchage else {
            return
        }
        
        PKIAPHandler.shared.purchase(product: product) { alertType, purchasedProduct, transaction in
            if let purchasedProductId = purchasedProduct?.productIdentifier {
                print("Purchased Product ID: \(purchasedProductId)")
                self.completePaymentApi()
            } else {
                print("Handle the case where the product couldn't be retrieved")
            }
        }
    }

    private func getProductID(products: [SKProduct]) -> SKProduct? {
        for product in products {
            let selectedProduct = "\(idWillBe)"
            if product.productIdentifier == selectedProduct {
                return product
            }
        }
        return nil
    }

    
    func completePaymentApi() {
        let postTransactionId = UUID().uuidString
        let params: Parameters = [
            "user_id": currentUser.result?.id ?? "163",
            "pre_transaction_id": preTranstionId,
            "post_transaction_id": postTransactionId,
            "plan_id": paymentData?.plan_id ?? "",
            "isInApp": "1"
        ]
        
        DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
        
        self.uplaodData1(APIManager.sharedInstance.KPaymentSuccessApi, params) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading() })
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    self.addAlert(ALERTS.KSUCCESS, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                    let paymentDone = ["Bool": true]
                    NotificationCenter.default.post(name: Notification.Name("paymentDone"), object: nil, userInfo: paymentDone)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "TBHomeVC") as! TBHomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
    }

}

