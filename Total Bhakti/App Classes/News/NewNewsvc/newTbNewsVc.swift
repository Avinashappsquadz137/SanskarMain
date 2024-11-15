//
//  newTbNewsVc.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 23/08/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import VerticalCardSwiper



class newTbNewsVc: TBInternetViewController,UIGestureRecognizerDelegate{
    

    //MARK:- IBOutlet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var searchBarHolder: UIView!
    @IBOutlet weak var searchBTn: UIButton!
    @IBOutlet weak var qrCode: UIButton!
    
    
    
    
    
    //MARK:- Variables.
    var newsDataArr = [News]()
    var refreshControl = UIRefreshControl()
    var dataToShow = NSMutableArray()
    var dataEnd = 0
    var lastVideo : News!
    var firstTimeLoadData = 0
    var pullToRefreshClicked = 0
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var headerLbl = UILabel()
    var slides:[NewsDragable] = [];

//MARK:- Override View Did loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectioViewUi()
        headerUiUpdate()
        notificationLbl.layer.cornerRadius = notificationLbl.layer.bounds.width/2
        notificationLbl.clipsToBounds = true
        searchBarHolder.isHidden = true
        searchBarHolder.backgroundColor = .clear
        
        if isComeFromHomeScreenToNewsList == false {
            headerLbl.text = "News"
            let param : Parameters = ["user_id": currentUser.result!.id! ,"last_news_id": "" ]
            NewsApiHit(param)
            pullToRefresh()
        }else {
            headerLbl.text = "Search"
        }
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: collectionView.bounds.width, height: CGFloat(44))
    }
    
//MARK:- Override View will appear
    
    override func viewWillAppear(_ animated: Bool) {
        
        if qrStatus == "0"{
            if #available(iOS 13.0, *) {
                qrCode.setImage(UIImage(systemName: ""), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            searchBTn.isHidden = true
        }else{
            
            searchBTn.isHidden = false
        }
        
        self.collectionView.reloadData()
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notificationLbl.text = String(notification_counter)
       
        
        UserDefaults.standard.setValue(5, forKey: "SideMneuIndexValue")
    }
    
    func collectioViewUi(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.register(UINib(nibName: "newsCell", bundle: nil), forCellWithReuseIdentifier: "newsCell")
        


    }
    
    func headerUiUpdate(){
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0
    }
    
//MARK:- Pull to request
    
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        let param : Parameters = ["user_id": currentUser.result!.id!  , "last_news_id": "" ]
        pullToRefreshClicked = 1
        NewsApiHit(param)
    }

//MARK:- Date conversion
    func dateConversion(timestamp:String)->String{
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(timestamp) ?? 0
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy "
        
        return dateFormatter.string(from: formatedData)
    }

//MARK:- @IBAction
    
    @IBAction func menuBtnPressed(_ sender: UIButton){
        slideMenuController()?.openLeft()
    }
    
    @IBAction func sharebtnPressed(_ sender: UIButton){
        
        let text = "https://sanskargroup.page.link/"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func notificationBtnPressed(_ sender: UIButton){
        
        let vc =  storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchCancelBtn(_ sender: UIButton){
        searchBar.text = ""
        searchBarHolder.isHidden = true
        searchBarHolder.backgroundColor = .clear
        
    }
    
    
    @IBAction func searchBtnPressed(_ sender: UIButton){
        
        searchBarHolder.isHidden = false
        searchBarHolder.backgroundColor = .white
        
    }
    

    
    
//MARK:- Hit API
    
    func NewsApiHit(_ param : Parameters){
        if newsDataArr.count == 0 && firstTimeLoadData == 0 && self.pullToRefreshClicked != 1{
            DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        }else {
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
        }
        
        self.uplaodData1(APIManager.sharedInstance.KNEWSAPI , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    if let result = JSON.value(forKey: "data") as? NSArray{
                        if result.count == 0 {
                            self.dataEnd = 1
                        }else {
                            self.dataEnd = 0
                            if self.pullToRefreshClicked == 1 {
                                self.pullToRefreshClicked = 0
                                self.dataToShow.removeAllObjects()
                                self.newsDataArr.removeAll()
                                self.dataToShow.addObjects(from: NSMutableArray(array: result) as! [Any])
                                self.newsDataArr = News.modelsFromDictionaryArray(array: self.dataToShow)
                                
//                                for newsData in self.newsDataArr {
//                                    let newsDrag = NewsDragable(frame: <#T##CGRect#>)
//                                    self.slides.append(<#T##newElement: NewsDragable##NewsDragable#>)
//                                }
                               // self.setupSlideScrollView(slides: <#T##[NewsDragable]#>)
                                
                            }else {
                                self.dataToShow.addObjects(from: NSMutableArray(array: result) as! [Any])
                                self.newsDataArr = News.modelsFromDictionaryArray(array: self.dataToShow)
                            }
                        }
                        self.collectionView.reloadData()
                    }
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
}

extension newTbNewsVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as? newsCell else {
            return UICollectionViewCell()
        }
        let dataToShow = newsDataArr[indexPath.row]
        let newsImageView = cell.viewWithTag(500) as? UIImageView
        let viewCountLbl = cell.viewWithTag(501) as? UILabel
        cell.headline.text = dataToShow.title
        cell.dataLbl.text = dataToShow.description
        cell.dateTime.text = dateConversion(timestamp: dataToShow.published_date!)
        if let urlString = dataToShow.image {
            newsImageView?.sd_setShowActivityIndicatorView(true)
            newsImageView?.sd_setIndicatorStyle(.gray)
            newsImageView?.contentMode = .scaleAspectFill
            newsImageView?.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        cell.MoreBtn.tag = indexPath.row
        cell.MoreBtn.addTarget(self, action: #selector(newTbNewsVc.moreBtnPressed(_:)), for: .touchUpInside)
        

        if dataToShow.views_count == "0" {
            viewCountLbl?.text = "No view"
        }else if dataToShow.views_count == "1" {
            viewCountLbl?.text = "\(dataToShow.views_count!) View"
        }else {
            viewCountLbl?.text = "\(dataToShow.views_count!) Views"
        }
        
        if isComeFromHomeScreenToNewsList == false {
            if indexPath.row == newsDataArr.count - 1  && dataEnd == 0 {
                spinner.startAnimating()
                firstTimeLoadData = 1
                lastVideo = newsDataArr[indexPath.row]
                let param : Parameters = ["user_id": currentUser.result!.id!, "last_news_id" : lastVideo.id!]
                NewsApiHit(param)
            }else {
                spinner.stopAnimating()
            }
        }else {
            spinner.stopAnimating()
        }
        return cell
    }
    
    
    @objc func moreBtnPressed(_ sender: UIButton) {
        
        print(sender.tag)
        let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
        vc.dataToShow = newsDataArr[sender.tag]
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension newTbNewsVc: UICollectionViewDelegate {
    
}

extension newTbNewsVc : TBNewsdeletilVCdelegates {
    func dataUpdate(_ data: News) {
        if let updateId = data.id {
            let tempArr = NSMutableArray(array : newsDataArr)
            if  let replacedData = tempArr.filter({(result) -> Bool in
                return ((result as! News).id == updateId)
            }).first {
                let index = tempArr.index(of: replacedData)
                tempArr.replaceObject(at: index, with: data)
                newsDataArr = tempArr as! [News]
                self.collectionView.reloadData()
            }
        }
    }
    
    
}

