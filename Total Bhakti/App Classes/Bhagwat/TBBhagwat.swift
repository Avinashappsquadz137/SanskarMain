//
//  TBBhagwat.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 08/01/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit

class TBBhagwat: UIViewController {

    @IBOutlet weak var colltnView: UICollectionView!
    @IBOutlet weak var bckBtn: UIButton!
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let numberOfItemsPerRow: CGFloat = 4
    let spacingBetweenCells: CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()

        colltnView.delegate = self
        colltnView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func bckBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TBBhagwat: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        let padding: CGFloat =  50
                let collectionViewSize = colltnView.frame.size.width - padding
        print("width: \(collectionViewSize/2), height: \(collectionViewSize/2)")
                return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)

     }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return spacingBetweenCells
        }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
//                let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
//                let size:CGFloat = (colltnView.frame.size.width - space) / 2.0
//                return CGSize(width: size, height: size)
//        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KEYS.KCELL, for: indexPath) as! TBBhagwatCell
        cell.title.text = "Krishna Bhagwat"
        cell.seasonLbl.text = "Season 1"
        cell.img.image = UIImage(named: "artist_img")
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0

        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        /*cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
 */
        return cell
    }
    
    
    
}
