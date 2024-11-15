//
//  mandirdetailTableViewCell.swift
//  Sanskar
//
//  Created by Harish Singh on 01/02/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit


class mandirdetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var templenamelbl: UILabel!
    @IBOutlet weak var templeplacelbl: UILabel!
    @IBOutlet weak var morebtn: UIButton!
    @IBOutlet weak var  sliderimg: UIImageView!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var decscrptiondetaillbl: UILabel!
    
    
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    // var sliderimg = ["temple1","temple2","temple3","temple4","temple5","temple6","temple7"]
    var templedatavalue = [String:Any]()
    var currentcellindex = 0
    var timer:Timer?
    var tempdata = [String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
//        print(tempdata)
//        
//        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SlideToNext), userInfo: nil, repeats: true)
//   //     pagecontrol.numberOfPages = sliderimg.count
//        slidercollectionview.delegate = self
//        slidercollectionview.dataSource = self
//        
//        slidercollectionview.register(UINib(nibName: "sliderpoojaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sliderpoojaCollectionViewCell")
//        
//    print(templedatavalue)
//    }
//        @objc func SlideToNext()
//        {
//            if currentcellindex < sliderimg.count - 1
//            {
//              currentcellindex = currentcellindex + 1
//            }
//            else
//            {
//                currentcellindex = 0
//            }
//    
//            pagecontrol.currentPage = currentcellindex
//    
//            slidercollectionview.scrollToItem(at: IndexPath(item: currentcellindex, section: 0), at: .right, animated: true)
//        }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }
//    
//}
//
//extension mandirdetailTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return sliderimg.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = slidercollectionview.dequeueReusableCell(withReuseIdentifier: "sliderpoojaCollectionViewCell", for: indexPath) as! sliderpoojaCollectionViewCell
//        cell.sliderimageview.image = UIImage(named: sliderimg[indexPath.row])
//        return cell
//    }
//}
//extension mandirdetailTableViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: slidercollectionview.frame.width, height: slidercollectionview.frame.height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 10
//        }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return .leastNonzeroMagnitude
//        }
//}
