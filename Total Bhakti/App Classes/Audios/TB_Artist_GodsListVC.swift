    //
    //  TB_Artist_GodsListVC.swift
    //  Sanskar
    //
    //  Created by mac on 20/07/20.
    //  Copyright © 2020 MAC MINI. All rights reserved.
    //
    
    import UIKit
    
    class TB_Artist_GodsListVC: UIViewController {
        
        @IBOutlet weak var MyCollectionView: UICollectionView!
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var notifCountLabel: UILabel!
        @IBOutlet weak var searchViewHolder: UIView!
        @IBOutlet weak var searchBtn: UIButton!
        @IBOutlet weak var qrCode: UIButton!
        
        var godOrArtist = ""
        var bhajanList = Array<Bhajan>()
        var Search_bhajanList = Array<Bhajan>()
        var isSearchTrue = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            searchBar.delegate = self
            searchBar.backgroundImage = UIImage()
            searchBar.backgroundColor = UIColor.clear
            searchBar.dropShadow()
            searchViewHolder.isHidden = true
            searchViewHolder.backgroundColor = .clear
            
            MyCollectionView.dataSource = self
            MyCollectionView.delegate = self
        }
        override func viewWillAppear(_ animated: Bool) {
            let notification_counter = UserDefaults.standard.value(forKey: "notification_counter") as! Int
            notifCountLabel.text = String(notification_counter)
        }
        
        @IBAction func BackActionBtn(_ sender:UIButton){
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        @IBAction func notificationActionBtn(_ sender:UIButton){
            
            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KNOTIFICATIONVC)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        @IBAction func logoBtnAction(_ sender: UIButton) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
        @IBAction func searchCancelBtn(_ sender: UIButton){
            searchViewHolder.isHidden = true
            searchViewHolder.backgroundColor = .clear
            
            
        }
        

        
        @IBAction func searchBarBtnPressed(_ sender: UIButton){
            searchViewHolder.isHidden = true
            searchViewHolder.backgroundColor = .white
            
        }
        
        
        
    }
    

    //MARK:- UICollection View DataSource.
    extension TB_Artist_GodsListVC : UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if isSearchTrue{
                return Search_bhajanList.count
            }else{
                return bhajanList.count
            }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellArtist", for: indexPath)
            shadow(cell)
            
            let categoryImageView = cell.viewWithTag(200) as! UIImageView
            let categoryNameLbl = cell.viewWithTag(210) as! UILabel
            
            if isSearchTrue {
                
                if godOrArtist == "Artist"{
                    categoryNameLbl.text = Search_bhajanList[indexPath.row].artist_name
                    if let urlString = Search_bhajanList[indexPath.row].artist_image {
                        categoryImageView.contentMode = .scaleToFill
                        categoryImageView.sd_setShowActivityIndicatorView(true)
                        categoryImageView.sd_setIndicatorStyle(.gray)
                        categoryImageView.clipsToBounds = true
                        categoryImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                    }
                    
                }else{
                    categoryNameLbl.text = Search_bhajanList[indexPath.row].god_name
                    if let urlString = Search_bhajanList[indexPath.row].god_image {
                        categoryImageView.contentMode = .scaleToFill
                        categoryImageView.sd_setShowActivityIndicatorView(true)
                        categoryImageView.sd_setIndicatorStyle(.gray)
                        categoryImageView.clipsToBounds = true
                        categoryImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                    }
                }
            }
            else{
                if godOrArtist == "Artist"{
                    categoryNameLbl.text = bhajanList[indexPath.row].artist_name
                    if let urlString = bhajanList[indexPath.row].artist_image {
                        categoryImageView.contentMode = .scaleToFill
                        categoryImageView.sd_setShowActivityIndicatorView(true)
                        categoryImageView.sd_setIndicatorStyle(.gray)
                        categoryImageView.clipsToBounds = true
                        categoryImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                    }
                    
                }else{
                    categoryNameLbl.text = bhajanList[indexPath.row].god_name
                    if let urlString = bhajanList[indexPath.row].god_image {
                        categoryImageView.contentMode = .scaleToFill
                        categoryImageView.sd_setShowActivityIndicatorView(true)
                        categoryImageView.sd_setIndicatorStyle(.gray)
                        categoryImageView.clipsToBounds = true
                        categoryImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
                        
                    }
                }
            }
            return cell
        }
    }
    
    //MARK:- UIColection View Delegates Methods.
    extension TB_Artist_GodsListVC : UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let size = CGSize(width: collectionView.frame.width/2-15, height: 180)
            return size
            
        }
    }
    //MARK: - UICollection View delegates.
    extension TB_Artist_GodsListVC : UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: CONTROLLERNAMES.KBHAJANLISTVC) as! TBbhajanListVC
            
            if godOrArtist == "God"{
                vc.IsGod = true
            }
            if isSearchTrue{
                vc.artistData = Search_bhajanList[indexPath.row]
            }else{
                vc.artistData = bhajanList[indexPath.row]
            }
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
        //MARK:- searchBar Delegate Methods.
    extension TB_Artist_GodsListVC : UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange Text: String) {
            if searchBar.text == "" {
                searchBar.text = nil
                searchBar.endEditing(true)
                self.view.endEditing(true)
                isSearchTrue = false
                MyCollectionView.reloadData()
                
            }else{
                if godOrArtist == "God"{
                    Search_bhajanList = bhajanList.filter({$0.god_name!.lowercased().hasPrefix(searchBar.text!.lowercased())})
                    MyCollectionView.reloadData()
                    
                }else{
                    Search_bhajanList = bhajanList.filter({$0.artist_name!.lowercased().hasPrefix(searchBar.text!.lowercased())})
                    MyCollectionView.reloadData()
                }
            }
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
            isSearchTrue = true
            MyCollectionView.reloadData()
            
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
            isSearchTrue = false
            self.view.endEditing(true)
            MyCollectionView.reloadData()
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            self.view.endEditing(true)
            MyCollectionView.reloadData()
            
        }
    }
