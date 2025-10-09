//
//  AllListTableCell.swift
//  Sanskar
//
//  Created by Warln on 15/07/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

protocol AllListTableCellDelegate {
    func didTapCollection(_ cell: AllListTableCell, data: MoreLikeThis)
}


class AllListTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allDataList: [MoreLikeThis] = []
    var delegate: AllListTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: [MoreLikeThis]) {
            allDataList = model
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

}

extension AllListTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllListData", for: indexPath) as? AllListData else {
              return UICollectionViewCell()
          }

          let model = allDataList[indexPath.item]
          if let banner = model.vertical_banner, let url = URL(string: banner) {
              cell.posterImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
          }
          return cell
      }
    
}

extension AllListTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          let model = allDataList[indexPath.item]
          delegate?.didTapCollection(self, data: model)
      }
}

extension AllListTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 220)
        
        
    }
}
