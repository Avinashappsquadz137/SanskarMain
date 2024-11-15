//
//  TBNewsVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 21/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import ExpandableLabel
class TBNewsVC: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var notifCountLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
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
    //MARK:-LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        //searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.dropShadow()
        
        scrollView.isPagingEnabled = true
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 0.0
        
        if isComeFromHomeScreenToNewsList == false {
            headerLbl.text = "News"
            let param : Parameters = ["user_id": currentUser.result!.id! ,"last_news_id": "" ]
            NewsApiHit(param)
            pullToRefresh()
        }else {
            headerLbl.text = "Search"
        }
        //spinner for table footer loading.
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
        notifCountLabel.text = String(notification_counter)
        
        UserDefaults.standard.setValue(5, forKey: "SideMneuIndexValue")
    }
    
    
    //MARK:- Topbar Button action.
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
    
    
    //MARK:- PullToRefresh.
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector (refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        let param : Parameters = ["user_id": currentUser.result!.id!  , "last_news_id": "" ]
        pullToRefreshClicked = 1
        NewsApiHit(param)
    }
    
    
    //MARK:- NewsApiMethods.
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
                        self.tableView.reloadData()
                    }
                }else {
                    self.addAlert(ALERTS.KERROR, message: (JSON.value(forKey: "message") as? String)!, buttonTitle: ALERTS.kAlertOK)
                }
                
            }else {
//                self.addAlert(ALERTS.KERROR, message: ALERTS.KSOMETHINGWRONG, buttonTitle: ALERTS.kAlertOK)
            }
        }
    }
    
    func setupSlideScrollView(slides : [NewsDragable]) {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * CGFloat(slides.count))
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            let news = self.newsDataArr[i]
            slides[i].descriptionLbl.text = news.description
            if let urlStr = news.image{
                if let url = URL(string: urlStr){
                    slides[i].imgView.sd_setImage(with: url, completed: nil)
                }
            }
            slides[i].titleLbl.text = news.title
            slides[i].dateTimeLbl.text = news.published_date
            slides[i].totalViewsLbl.text = news.views_count
            slides[i].frame = CGRect(x: 0, y: view.frame.height * CGFloat(i), width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.y
//
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
    }
    
}

//MARK:- UITableView DataSource Methods.
extension TBNewsVC : UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KEYS.KCELL, for: indexPath)
        let dataToShow = newsDataArr[indexPath.row]
        let newsImageView = cell.viewWithTag(100) as? UIImageView
        let newsNameLbl = cell.viewWithTag(110) as? UILabel
        let newsDescriptionLbl = cell.viewWithTag(120) as? ExpandableLabel
        let dateAndTimeLbl = cell.viewWithTag(130) as? UILabel
        let mainView = cell.viewWithTag(140)
        let viewCountLbl = cell.viewWithTag(150) as? UILabel
        mainView?.dropShadow()
        newsNameLbl?.text = dataToShow.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        newsDescriptionLbl?.text = dataToShow.description?.trimmingCharacters(in: .whitespacesAndNewlines).html2String
        
        let btn = cell.contentView.viewWithTag(143) as? UIButton
        btn?.addTarget(self, action: #selector(ReadMore), for: .touchUpInside)
       
        cell.tag = indexPath.row
        
        var dataWithLong = LONG_LONG_MAX
        dataWithLong = Int64(dataToShow.published_date!)!
        let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
        print(formatedData)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc dd MMM, yyyy hh:mm a"
        print(dateFormatter.string(from: formatedData))
        dateAndTimeLbl?.text = dateFormatter.string(from: formatedData)
        if dataToShow.views_count == "0" {
            viewCountLbl?.text = "No view"
        }else if dataToShow.views_count == "1" {
            viewCountLbl?.text = "\(dataToShow.views_count!) View"
        }else {
            viewCountLbl?.text = "\(dataToShow.views_count!) Views"
        }
        
        if let urlString = dataToShow.image {
            newsImageView?.sd_setShowActivityIndicatorView(true)
            newsImageView?.sd_setIndicatorStyle(.gray)
            newsImageView?.contentMode = .scaleToFill
            newsImageView?.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        if isComeFromHomeScreenToNewsList == false {
            if indexPath.row == newsDataArr.count - 1  && dataEnd == 0 {
                spinner.startAnimating()
                self.tableView.tableFooterView?.isHidden = false
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
    
    @objc func ReadMore(_ sender:UIButton){
        
        guard let cell = sender.superview?.superview as? UITableViewCell else { return }
        let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
        vc.dataToShow = newsDataArr[cell.tag]
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "TBNewsPagerListViewController") as! TBNewsPagerListViewController
//        vc.dataToShow = newsDataArr[cell.tag]
//        vc.allNewsDataArr = newsDataArr
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- UITableView Delegates Methods.
extension TBNewsVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNEWSDETAILSVC) as! TBNewsDetailVC
        vc.dataToShow = newsDataArr[indexPath.row]
        vc.allNewsDataArr = newsDataArr
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
}

//MARK:- updateData Delegate Methods.
extension TBNewsVC : TBNewsdeletilVCdelegates {
    func dataUpdate(_ data: News) {
        if let updateId = data.id {
            let tempArr = NSMutableArray(array : newsDataArr)
            if  let replacedData = tempArr.filter({(result) -> Bool in
                return ((result as! News).id == updateId)
            }).first {
                let index = tempArr.index(of: replacedData)
                tempArr.replaceObject(at: index, with: data)
                newsDataArr = tempArr as! [News]
                self.tableView.reloadData()
            }
        }
    }
    
    
}


extension TBNewsVC : TBchannelTableDelegate {
    func hideTableAction() {
        self.dismiss(animated: false, completion: nil)
    }
}


