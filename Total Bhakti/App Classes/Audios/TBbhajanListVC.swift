//
//  TBbhajanListVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 23/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBbhajanListVC: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    
    //MARK:- Variables.
    var dataToShow = [Bhajan]()
    var allBhajan : BhajanData!
    var artistData : Bhajan!
    var searchText = String()
    var noDatafoundLbl = UILabel()
    var header : TBHeaderViewController?
    var isAudioPlaying : Bool!
    var current_Bhanjan : Bhajan!
    let screenSize = UIScreen.main.bounds
    var isLoadingList : Bool = false
    
    var page = 0
    var IsGod = false
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    //MARK:-LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        getHeaderView()
        header?.delegate = self
        
        
        if isComeFromHomeScreenToBhajanList == false && IsGod == false{
            if searchText.isEmpty == true {
                if artistData != nil {
                    headerLbl.text = artistData.artist_name?.uppercased()
                    let param : Parameters = ["user_id": currentUser.result!.id! , "artist_id" : artistData.artist_id!,"artist_name" : artistData.artist_name!,"limit":"15"]
                    relatedArtis(param,APIManager.sharedInstance.KARTISALBUMAPI)
                    
                }else {
                    headerLbl.text = allBhajan.category_name?.uppercased()
                }
            }else {
                headerLbl.text = "Search"
                let param : Parameters = ["user_id": currentUser.result!.id! , "search_content" : searchText]
                relatedArtis(param,APIManager.sharedInstance.KBhajanSearchApi)
            }
        }else {
            headerLbl.text = "Search"
        }
        noDatafoundLbl = self.noDataLabelCall(controllerType: self, tableReference: tableView)
        
        if IsGod{
            headerLbl.text = artistData.god_name?.uppercased()
            let param : Parameters = ["user_id": currentUser.result!.id! , "artist_id" : artistData.artist_id!,"god_name" : artistData.god_name!,"limit":"15"]
            relatedArtis(param,APIManager.sharedInstance.get_bhajanBy_god)
            
        }
        
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            if dataToShow.count == 0 || dataToShow.count < 10{
                return
            }
            
            if artistData != nil {
                self.isLoadingList = true
                self.tableView.tableFooterView?.isHidden = false
                spinner.startAnimating()
                
                let param : Parameters
                if IsGod{
                    param  = ["user_id": currentUser.result!.id! ,"artist_id" : artistData.artist_id!,"artist_name" : artistData.artist_name!,"limit":"15","page_no":"\(page)","god_name" : artistData.god_name!]
                    relatedArtis(param,APIManager.sharedInstance.get_bhajanBy_god)
                    
                }else{
                    param  = ["user_id": currentUser.result!.id! ,"artist_id" : artistData.artist_id!,"artist_name" : artistData.artist_name!,"limit":"15","page_no":"\(page)"]
                    relatedArtis(param, APIManager.sharedInstance.KARTISALBUMAPI)
                }
            }
        }
    }
    
    //MARK:- screenBtnAction
    @IBAction func screenBtnAction (_ sender : UIButton) {
        switch sender.tag {
        case 10:
            if isComeFromHomeScreenToBhajanList == true {
                isComeFromHomeScreenToBhajanList = false
            }
            _ = navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    @IBAction func threedotbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "playerlistViewController") as! playerlistViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- headerView
    func getHeaderView()  {
        header = TBHeaderViewController.getHeaderView() as? TBHeaderViewController
        //  header?.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width+50, height: 44)
        
        if AppConstant.KSCREENSIZE.height == 568.0{
            header?.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width+50, height: 60)
        }
            
        else{
            header?.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width, height: 60)
            
        }
        
        header?.menuBarBtn.setImage(UIImage(named: "back"), for: .normal)
        if let header = self.header {
            header.mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            self.headerView.addSubview(header)
            self.headerView.bringSubview(toFront: header)
        }
    }
    
    
    //MARK:- related Album api
    func relatedArtis(_ param : Parameters, _ apiName : String) {
        self.uplaodData(apiName, param) { (response) in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            print(response as Any)
            
            if self.isLoadingList{
                self.isLoadingList = false
            }
            
            self.tableView.tableFooterView?.isHidden = true
            self.spinner.stopAnimating()
            
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        self.dataToShow = self.dataToShow + Bhajan.modelsFromDictionaryArray(array: result)
                        
                        self.tableView.reloadData()
                        
                        self.page = self.page+1
                        
                        if self.dataToShow.count == 0 {
                            self.noDatafoundLbl.isHidden = false
                            self.tableView.isHidden = true
                        } else {
                            self.noDatafoundLbl.isHidden = true
                            self.tableView.isHidden = false
                        }
                    }
                }else {
                    
                    // self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
            }else {
                
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
}

//MARK:- UITableView DataSource Methods.
extension TBbhajanListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath)
        let post = dataToShow[indexPath.row]
        let bhajanImageView = cell.viewWithTag(100) as! UIImageView
        let nameLbl = cell.viewWithTag(110) as! UILabel
        let descriptionLbl = cell.viewWithTag(120) as! UILabel
        let mainView = cell.viewWithTag(130)
        mainView?.layer.cornerRadius = 5.0
        mainView?.dropShadow()
        bhajanImageView.layer.cornerRadius = 5.0
        bhajanImageView.clipsToBounds = true
        bhajanImageView.contentMode = .scaleToFill
        cell.dropShadow()
        if headerLbl.text == "Artist" {
            nameLbl.text = post.artist_name
            descriptionLbl.text = post.description?.html2String
            if let urlString = post.artist_image {
                bhajanImageView.sd_setShowActivityIndicatorView(true)
                bhajanImageView.sd_setIndicatorStyle(.gray)
                bhajanImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, options: .refreshCached, completed: nil)
            }
        }else {
            nameLbl.text = post.title
            descriptionLbl.text = post.description?.html2String
            if let urlString = post.image {
                bhajanImageView.sd_setShowActivityIndicatorView(true)
                bhajanImageView.sd_setIndicatorStyle(.gray)
                bhajanImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
            }
        }
        
        
        return cell
    }
}

//MARK:- UITableView Delegates.
extension TBbhajanListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bhajanData1 = dataToShow[indexPath.row]
        if headerLbl.text == "Artist" {
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KBHAJANLISTVC) as! TBbhajanListVC
            vc.artistData = bhajanData
            navigationController?.pushViewController(vc, animated: true)
        }else {
            
            //            indexNo = indexPath.row
            //            relatedBhajanArr2 = dataToShow
            //            playSelectedAudio(seletedData: bhajanData1)
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideOrizine"), object: nil)
            
            let post = dataToShow[indexPath.row]
            MusicPlayerManager.shared.song_no = indexPath.row
            MusicPlayerManager.shared.Bhajan_Track = dataToShow
            MusicPlayerManager.shared.isDownloadedSong = false
            MusicPlayerManager.shared.isPlayList = false
            MusicPlayerManager.shared.isRadioSatsang = false
            let vc = storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as! TBMusicPlayerVC
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            MusicPlayerManager.shared.PlayURl(url: post.media_file!)
            
            
        }
    }
    
}




//MARK:- headerView Delegates
extension TBbhajanListVC : TBHeaderDelegates {
    func menuBarBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            if isComeFromHomeScreenToBhajanList == true {
                isComeFromHomeScreenToBhajanList = false
            }
            _ = navigationController?.popViewController(animated: true)
        case 20:
            let SC = TBchannelTableView()
            SC.delegate = self
            SC.modalPresentationStyle = .overCurrentContext
            present(SC, animated: false, completion: nil)
        case 30:
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
            navigationController?.pushViewController(vc, animated: true)
        case 40:
            if currentUser.result!.id! == "163"{
                let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                if sms == "1"{
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

extension TBbhajanListVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
        
    }
}



