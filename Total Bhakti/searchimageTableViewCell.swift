//
//  searchimageTableViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 19/12/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class searchimageTableViewCell: UITableViewCell {

   // @IBOutlet weak var imagecollectionview: UICollectionView!
    

    var callsController: ((_ tappedUrl: String, _ idpass: String,_ GoingTo: String) -> Void)?
  //  var callsid:((_ idpass: String,_ GoingTo: String) -> Void)?
    var menuTitles = [String]()
    var seasonList = [String]()
    var freeList = [String]()
    var videoList = [String]()
    var trendbhajanList = [String]()
    
    var allImageList = [String]()
    var types = ""
    var image1 = [String]()
    var counts = 0
    var videosectionName = ""
    var premiumid = [String]()
    var premium = [[String:Any]]()
    var callback:((String)->())? = nil
    var premiumlistdata = [String]()
    var videolistdata = [String]()
    var musiclistdata = [String]()
    var musicimagedata = [String]()
    let bannercourseid = String()
    var ListData = [String:Any]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(premium)
        print(image1)
        collecView.delegate = self
        collecView.dataSource = self
        print(self.types)
    }
    func configuration(seasonlist: [String],videoList:[String],trendbhajanList:[String],name:String)
    {
        self.seasonList = seasonlist
        self.trendbhajanList = trendbhajanList
        self.videoList = videoList
        self.types = name
        print(name)
        collecView.reloadData()
        print(seasonlist)
        print(self.seasonList)
        
       
        
    }

    @IBOutlet weak var collecView: UICollectionView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
extension searchimageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if types == "Top Premium Search"
        {
            return self.seasonList.count
        }
        
        else if types == "Top Videos Search"
        {
            return self.videoList.count
        }
        else if types == "Top Musics Search"
        {
            return self.trendbhajanList.count
        }
        
        return 0
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionViewCell", for: indexPath) as! searchCollectionViewCell
        
        print(self.seasonList)
        
        if types == "Top Premium Search"
        {
            cell.imageView.sd_setImage(with: URL(string: self.seasonList[indexPath.row]))
        }
        
        else if types == "Top Videos Search"
        {
            cell.imageView.sd_setImage(with: URL(string: self.videoList[indexPath.row]))
        }
        else if types == "Top Musics Search"
        {
            cell.imageView.sd_setImage(with: URL(string: self.trendbhajanList[indexPath.row]))
        }
        return cell
    }
    

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if types == "Top Premium Search"
            {
                print(premiumlistdata)
                print(premium)
               // let bannercourseid = self.premium[indexPath.row]["custom_promo_video"] as? String ?? ""
                let premiumid = self.premium[indexPath.row]["id"] as? String ?? ""
              //  print(bannercourseid)
                print(premiumid)
                
                callsController?((premiumid ?? ""), types, types)
//                callsController?((premiumid ?? ""),types)
                // callback?(bannercourseid)
            }
           
            else if types == "Top Videos Search"
            {
                let videodataid = videolistdata[indexPath.item]
                
                print(videodataid)
                
                callsController?((videodataid ?? ""), types, types)
                // callback?(videodataid)
            }
            else if types == "Top Musics Search"
                        
            {
                let musicdataid = musiclistdata[indexPath.item]
                let musicimage = musicimagedata[indexPath.row]
                print(musicdataid)
                callsController?((musicdataid ?? ""),(musicimage ?? ""), types)
                //   callback?(musicdataid)
            }
        }
        
    
}
extension searchimageTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 140)
    }
}
