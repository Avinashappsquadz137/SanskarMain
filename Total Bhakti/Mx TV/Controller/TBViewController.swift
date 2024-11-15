//
//  TBViewController.swift
//  Sanskar
//
//  Created by Harish Singh on 19/12/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftUI
                                            
class TBViewController: UIViewController {
    
    
    var refreshControl = UIRefreshControl()
    var sesionlist = [String]()
    var premiumlistdata = [String]()
    var videolistdata = [String]()
    var musiclistdata = [String]()
    var musicimage = [String]()
    var videoList = [String]()
    var premiumid = [String]()
    var premium = [[String:Any]]()
    
    var headerarry = ["Top Premium Search","Top Videos Search","Top Musics Search"]
    var ListData = [[String:Any]]()
    var trendbhajanList = [String]()
    let bannercourseid = String()
    var types = ""
    var searching = false
    var searchTxt = ""
    var userSearched = 0
    var index = 0
    var searchClicked = 0
    var searchResults:[String] = []
    var api_response = [[String:Any]]()
    var videosArr : [videosResult] = []
    
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        searchbar.delegate = self

        let param: Parameters = ["user_id": currentUser.result?.id ?? "163",
                                             "search":"bage"]
        hitsearchpageapi(param)
        searchApiCall()

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        
    }
    
    func searchApiCall() {
        if searchbar.text?.isEmpty == true {
            searchClicked = 0
            searchbar.resignFirstResponder()
            let param: Parameters = ["user_id": currentUser.result?.id ?? "163",
                                                        "search":"bage"]
            print(param)
            hitsearchpageapi(param)
            
        }else {
            searchClicked = 1
            searchbar.resignFirstResponder()
            let param: Parameters = ["user_id": currentUser.result?.id ?? "163",
                                                        "search":searchTxt]
            print(param)
            hitsearchpageapi(param)
        }
    }
    
    // MARK: - Navigation
    @IBAction func backbtn(_  sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
      
    func hitsearchpageapi(_ param : Parameters) {
        self.uplaodData(APIManager.sharedInstance.KSerachApi , param) { (response) in
            self.sesionlist.removeAll()
            self.videoList.removeAll()
            self.trendbhajanList.removeAll()
            self.videolistdata.removeAll()
            self.mainTable.reloadData()
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            DispatchQueue.main.async(execute: { self.refreshControl.endRefreshing()})
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == false {
                    self.headerarry.removeAll()
                    self.mainTable.reloadData()
                    self.showAlert(message: "This type data is not found.")
                   
                } else {
                    let data = (JSON["data"] as? [String:Any] ?? [:])
                    print(data)
                    let ListData = data
                    print(ListData)
                   
                    self.premium = (data["premium"] as? [[String:Any]] ?? [])
                    print(self.premium)
                    for i in 0..<self.premium.count{
                        let season_thumbnails = self.premium[i]["season_thumbnail"] as? String ?? ""
                        self.sesionlist.append(season_thumbnails)
                        
                    }
                    for i in 0..<self.premium.count{
                        let id = self.premium[i]["id"] as? String ?? ""
                        
                        self.premiumid.append(id)
                        
                    }
                    for i in 0..<self.premium.count{
                        let custom_promo_video = self.premium[i]["custom_promo_video"] as? String ?? ""
                        
                        self.premiumlistdata.append(custom_promo_video)
                        
                    }
                        let music = (data["musics"] as? [[String:Any]] ?? [])
                        print(music)
                        
                    for i in 0..<music.count{
                        let image = music[i]["image"] as? String ?? ""
                        self.trendbhajanList.append(image)
                    }
                    for i in 0..<music.count{
                        let media_file = music[i]["media_file"] as? String ?? ""
                        
                        self.musiclistdata.append(media_file)
                    }
                    for i in 0..<music.count{
                        let musicimage = music[i]["image"] as? String ?? ""
                        
                        self.musicimage.append(musicimage)

                    }
                            let video = (data["videos"] as? [[String:Any]] ?? [])
                            print(video)
            
                    for i in 0..<video.count{
                        let thumbnail_url = video[i]["thumbnail_url"] as? String ?? ""
                        self.videoList.append(thumbnail_url)
                    }
                    for i in 0..<video.count{
                        let custom_video_url = video[i]["id"] as? String ?? ""
                        self.videolistdata.append(custom_video_url)
                    }
                    
                                print(self.sesionlist)
                                print(self.musicimage)
                                print(self.videoList)
                                print(self.trendbhajanList)
                                print(self.premiumlistdata)
                                print(self.musiclistdata)
                                print(self.videolistdata)
                                print(self.premiumid)
                                self.mainTable.reloadData()
                }
               
            }
            
        }
    }
}
extension TBViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return headerarry.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTable.dequeueReusableCell(withIdentifier: "searchimageTableViewCell", for: indexPath) as! searchimageTableViewCell
        //            if headerarry[indexPath.row] == "Top Premium Search"
        //                        {
        cell.premium = premium
        cell.premiumlistdata = premiumlistdata
        cell.videolistdata = videolistdata
        print(cell.videolistdata)
        cell.musiclistdata = musiclistdata
        cell.seasonList = sesionlist
        cell.trendbhajanList = trendbhajanList
        cell.premiumid = premiumid
        cell.musicimagedata = musiclistdata
        
        let sectionIndex = indexPath.section
        if sectionIndex < headerarry.count {
            // Use headerarry[sectionIndex] safely
            cell.configuration(seasonlist: sesionlist, videoList: videoList, trendbhajanList: trendbhajanList, name: headerarry[sectionIndex])
        } else {
            // Handle the case when the index is out of range
            print("Index out of range for headerarry")
        }

        cell.collecView.reloadData()
        cell.callsController = { (tappedUrl,idpass,GoingTo) in
            if GoingTo == "Top Premium Search"{
                
                
                if currentUser.result?.id == "163" {
                    let sms = UserDefaults.standard.value(forKey: "sms") as? String ?? ""
                    if sms == "1" {
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
                    }
                    
                    
                    else{
                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KMOBILEVARIFICATION)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                }
                else {
                    
                    
                    print("newPremiumvc")
                    print(tappedUrl)
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "newPreDetails") as? newPreDetails else{ return }
                    // print(index)
                    //                vc.season_id = "74"
                    vc.season_id = tappedUrl
                    //     vc.videoUrl = tappedUrl
                    
                    //         vc.videocome = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            else if GoingTo == "Top Videos Search"
            {
                print("TBVideoListVC")
                print(tappedUrl)
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBsearchviedeoViewController") as? TBsearchviedeoViewController else{ return }
//                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBYoutubeVideoVC") as? TBYoutubeVideoVC else{ return }
                
                vc.videodata = tappedUrl

                // print(index)
                self.navigationController?.pushViewController(vc, animated: true)
  //              self.present(vc, animated: true)
            }
            else if GoingTo == "Top Musics Search"{
                
                print(tappedUrl)
                print(idpass)
//                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBMusicPlayerVC") as? TBMusicPlayerVC else{ return }
//            //    vc.musicurl = tappedUrl
//                MusicPlayerManager.shared.PlayURl(url: tappedUrl)
//                self.present(vc, animated: true, completion: nil)
            }
            
        }
        //        cell.callsid = { (idpass,GoingTo) in
        //            if GoingTo == "Top Premium Search"{
        //                print("newPremiumvc")
        //                print(idpass)
        //                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "newPreDetails") as? newPreDetails else{ return }
        //
        //            }
    
    
    return cell
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell1 = mainTable.dequeueReusableCell(withIdentifier: "searchheaderTableViewCell") as! searchheaderTableViewCell
        
        let sectionIndex = section
        if sectionIndex < headerarry.count {
            cell1.labelname.text = headerarry[sectionIndex]
        } else {
            print("Index out of range for headerarry")
        }

        return cell1
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


extension TBViewController: UISearchBarDelegate {
    // ... (your existing code)

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        userSearched = 1
        searchClicked = 1

        guard let searchInput = searchBar.text else {
            // Handle the case where the text is nil
            return
        }

        if containsSpecialCharactersExcludingNumbers(searchInput) {
            // Show an alert for special characters
           // searchBar.text = ""
            showAlert(message: "This type data is not found.")
            return
        }

        // Assuming this is Swift code

        // Assuming `hitsearchpageapi` is a function that makes the API request

        let searchTxt = searchInput.trimmingCharacters(in: .whitespacesAndNewlines)
 
        if !searchTxt.isEmpty {
            let param: Parameters = ["user_id": currentUser.result?.id ?? "163", "search": searchTxt]
          
            hitsearchpageapi(param)
        } else {
          
            print("Search text is empty. API not called.")
        }

    }

    // Function to check if a string contains special characters excluding numbers
    func containsSpecialCharactersExcludingNumbers(_ string: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return !string.unicodeScalars.allSatisfy { allowedCharacterSet.contains($0) }
    }

    // Function to show an alert with a given message
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}



  
//extension TBViewController : UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
//        if searchBar.text == "" {
//            searchTxt = ""
//        }
//    }
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//        if searchBar.text == "" {
//            searchBar.endEditing(true)
//            searchBar.setShowsCancelButton(false, animated: true)
//           let param : Parameters
//            if index == 0 {
//            param = ["user_id": currentUser.result?.id ?? "163",
//                                                 "search":"bage"]
//            }else {
//            param = ["user_id": currentUser.result?.id ?? "163",
//                                                 "search":searchTxt]
//            }
//            hitsearchpageapi(param)
//
//        }
//
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        userSearched = 1
//        searchClicked = 1
//        searchTxt = searchBar.text!
//        let param : Parameters
//        param = ["user_id": currentUser.result?.id ?? "163",
//                                         "search":searchTxt]
//        searchBar.text = ""
//        hitsearchpageapi(param)
//
//
//    }
//
//}










