//
//  TBNewsDetailVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 26/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
protocol TBNewsdeletilVCdelegates {
    func dataUpdate(_ data : News)
    
}
class TBNewsDetailVC: TBInternetViewController,UIScrollViewDelegate {
    //MARK:- IBOutlets.
    
//    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagerView: FSPagerView!
    {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero


        }
    }
   
    //MARK:- variables.
    var dataToShow : News!
    var delegate : TBNewsdeletilVCdelegates?
    var header : TBHeaderViewController?
    var allNewsDataArr = [News]()

    //MARK:- lifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        getHeaderView()
        newsViewHit()
        let param : Parameters = ["user_id": currentUser.result!.id!  , "last_news_id": dataToShow.id ?? "" ]
        self.NewsApiHit(param)
      //  pagerViewUIsetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == pagerView{
//            print("collectionViewDidScroll")
//        }else{
//            print("scrollViewDidScroll")
//        }
    }

    //MARK:- ScreenBtn Actions.
    @IBAction func screenBtnAction (_ sender : UIButton) {
        let web_view_news = UserDefaults.standard.value(forKey: "web_view_news")

        let id  = dataToShow!.id ?? ""
        let text = "\(web_view_news ?? "")\(id)"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)

    }

    
    // MARK:- confirm protocol of pagerView and cell size and animation(pagerView.transformer) type of pagerview
    func pagerViewUIsetup(){
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.transformer = FSPagerViewTransformer(type: .zoomOut)
        pagerView.transformer = FSPagerViewTransformer(type: .zoomOut)
        pagerView.isInfinite = false
        pagerView.contentMode = .scaleAspectFit
        pagerView.scrollDirection = .horizontal

        pagerView.itemSize = CGSize(width: self.view.frame.size.width, height: 300)
        pagerView.interitemSpacing = 10
        pagerView.isScrollEnabled = true

    }
    
    
//MARK:- News Api hit
    
    func NewsApiHit(_ param : Parameters){
        
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodData1(APIManager.sharedInstance.KNEWSAPI , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray{
                        if result.count == 0 {
                            
                        }else {
                                self.allNewsDataArr = News.modelsFromDictionaryArray(array: result)
                        }
                    }
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }

    }
//MARK:- recentViewHit.
    func newsViewHit() {
        let param : Parameters = ["user_id" : currentUser.result!.id! , "news_id": dataToShow.id!]
        loader.shareInstance.hideLoading()
        self.uplaodData(APIManager.sharedInstance.KNEWSVIEWS, param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray {
                        print(result)
                        self.dataToShow.views_count = NSString(string : "\(Int(self.dataToShow.views_count!)!+1)") as String
                    }
                }else {
                }
                
            }else {
            }
        }
    }
    
    @IBAction func backAction (_ sender : UIButton) {
       
        self.delegate?.dataUpdate(dataToShow)
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- headerView
    func getHeaderView()  {
        header = TBHeaderViewController.getHeaderView() as? TBHeaderViewController
        header?.delegate = self
       // header?.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width+50, height: 44)
        if AppConstant.KSCREENSIZE.height == 568.0{
            header?.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width+50, height: 60)
        }
            
        else{
            header?.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width, height: 60)
            
        }
        
        header?.menuBarBtn.setImage(UIImage(named : "back"), for: .normal)
        if let header = self.header {
//            header.mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//            self.headerView.addSubview(header)
//            self.headerView.bringSubview(toFront: header)
        }
    }
    
    //MARK:- Data To Show.
    func showData() {
        titleLbl.text = dataToShow.title
        textView.text  = dataToShow.description?.html2String
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(dataToShow.published_date!)!
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        print(formatedData)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
        print(dateFormatter.string(from: formatedData))
        dateLbl.text = dateFormatter.string(from: formatedData)
       
       if let urlString = dataToShow.image {
            newsImageView.sd_setIndicatorStyle(.gray)
            newsImageView.sd_setShowActivityIndicatorView(true)
        newsImageView.sd_setImage(with: URL(string : urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
    }
}


//MARK:- headerView Delegates
extension TBNewsDetailVC : TBHeaderDelegates {
    func menuBarBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            self.delegate?.dataUpdate(dataToShow)
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

extension TBNewsDetailVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
        
    }
}

 //MARK:- PagerView Delegates.
 extension TBNewsDetailVC : FSPagerViewDelegate {
     
     func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
         return true
     }
     
     func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
         
     }
     
     func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool{
         return true
     }
     
     
     func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int){
         
         
         
     }
     
     func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int){
         
     }
     
     func pagerViewWillBeginDragging(_ pagerView: FSPagerView){
         
         
     }
     
     func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int){
         
         //        guard targetIndex >= 0 else {
         //            return
         //        }
         
         //        if MusicPlayerManager.shared.isDownloadedSong{
         //            song_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[targetIndex].title
         //            artist_Lbl.text = MusicPlayerManager.shared.ArrDownloadedSongs[targetIndex].artist_name
         //        }else{
         //            song_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[targetIndex].title
         //            artist_Lbl.text = MusicPlayerManager.shared.Bhajan_Track[targetIndex].artist_name
         //        }
     }
     
     func pagerViewDidScroll(_ pagerView: FSPagerView){
         
     }
     
     func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView){
         
     }
     
     func pagerViewDidEndDecelerating(_ pagerView: FSPagerView){
         
     }
     
 }
//MARK:-  pagerView dataSource
extension TBNewsDetailVC : FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return allNewsDataArr.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        
        let imageArray = allNewsDataArr[index].image
        let lbl = allNewsDataArr[index].title
        let shortDesc = allNewsDataArr[index].shortDesc

        if let url = URL(string: imageArray ?? "") {
            cell.imageView?.contentMode = .scaleToFill
            cell.textLabel?.text =  shortDesc
            
            // cell.imageView?.layer.cornerRadius = 12.0
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setIndicatorStyle(.gray)
            cell.imageView?.clipsToBounds = true
            cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        return cell
    }
}


