//
//  TBTermsAndConditions.swift
//  Total Bhakti
//
//  Created by MAC MINI on 29/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBTermsAndConditions: TBInternetViewController , UIWebViewDelegate {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var notifCountLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK:- Variables.
    var conditionStr = String()
    var header : TBHeaderViewController?
    
    //MARK:- LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar.delegate = self
        
        
        
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0
        
        
        webView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        
        if termsAndCondition == 2 {
            headerLbl.text = "Privacy & Policy"
            conditionStr = "settings/Settings/get_privacy_policy"
        }else if termsAndCondition == 1 {
            headerLbl.text = "Terms And Conditions"
            conditionStr = "settings/Settings/get_terms_conditions"
        }else {
            headerLbl.text = "Terms And Conditions"
            conditionStr = "settings/Settings/get_terms_conditions"
        }
        apiForSting(conditionStr)
        
        header?.delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
    }
    
    //MARK:- Topbar Button action.
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
      self.navigationController?.popToRootViewController(animated: true)
    }
    
     @IBAction func shareBtnAction (_ sender : UIButton) {
         let text = "https://sanskargroup.page.link/"
         let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
         present(activity, animated: true, completion: nil)
     }
     
     @IBAction func notificationBtnAction (_ sender : UIButton) {
         let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
         navigationController?.pushViewController(vc, animated: true)
     }
     
     @IBAction func menuBtnAction (_ sender : UIButton) {
         slideMenuController()?.openLeft()
     }
    
    
    
    //MARK:- Call Api
    func apiForSting(_ urlString : String)  {
        self.uplaodData(urlString, [:]) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    let data = JSON.value(forKey: "data") as? NSDictionary
                    let urlStr = data!.value(forKey: "url") as? String
                    if reachability.connection == .none {
                        self.addAlert(appName, message: ALERTS.kNoInterNetConnection, buttonTitle: ALERTS.kAlertOK)
                    }else {
                        //self.webView.loadHTMLString(urlStr!, baseURL: nil)
                        let url = URL (string: urlStr ?? "")
                        let requestObj = URLRequest(url: url!)
                        self.webView.loadRequest(requestObj)
                    }
                    self.webView.scrollView.bounces = false
                    
                }
            }
        }
    }
    
    
    
    
    //MARK:- Web View Delegates Methods.
    func webViewDidStartLoad(_ webView: UIWebView) {
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loader.shareInstance.hideLoading()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        addAlert(appName, message: error.localizedDescription, buttonTitle: ALERTS.kAlertOK)
    }
    
    
    //MARK:- Screen Btn action.
    @IBAction func screentBtnAction (_ sender : UIButton) {
        if sender.tag == 10 {
            if termsAndCondition == 0 {
                _ = navigationController?.popViewController(animated: true)
            }else {
                slideMenuController()?.openLeft()
            }
            
        }
    }
}

//MARK:- headerView Delegates
extension TBTermsAndConditions : TBHeaderDelegates {
    func menuBarBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            if termsAndCondition == 0 {
                _ = navigationController?.popViewController(animated: true)
            }else {
                slideMenuController()?.openLeft()
            }
        case 30:
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
            navigationController?.pushViewController(vc, animated: true)
        case 40:
            if currentUser.result!.id! == "163"{
                let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                if sms == "1"{
                    let record = UserDefaults.standard.integer(forKey: "recorddata")
                        print(record)

                        if record == 1 {
                        self.dismiss(animated: true) {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "usersuggestionlogin") as! usersuggestionlogin
                            if #available(iOS 15.0, *) {
                                if let sheet = vc.sheetPresentationController {
                                    var customDetent: UISheetPresentationController.Detent?
                                    if #available(iOS 16.0, *) {
                                        customDetent = UISheetPresentationController.Detent.custom { context in
                                            return 450 // Replace with your desired height
                                        }
                                        sheet.detents = [customDetent!]
                                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                                    }
                                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                                    sheet.prefersGrabberVisible = true
                                    sheet.preferredCornerRadius = 24
                                }
                            }
                            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                        }
                    }
                    else {
                        self.dismiss(animated: true) {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "newloginpage") as! newloginpage
                            if #available(iOS 15.0, *) {
                                if let sheet = vc.sheetPresentationController {
                                    var customDetent: UISheetPresentationController.Detent?
                                    if #available(iOS 16.0, *) {
                                        customDetent = UISheetPresentationController.Detent.custom { context in
                                            return 450 // Replace with your desired height
                                        }
                                        sheet.detents = [customDetent!]
                                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                                    }
                                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                                    sheet.prefersGrabberVisible = true
                                    sheet.preferredCornerRadius = 24
                                }
                            }
                            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                        }
                    }
                }else{
//                    let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
            else{
                let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KPROFILEVC)
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
}


