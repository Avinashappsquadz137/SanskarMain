//
//  epsiodeDetailVc.swift
//  Sanskar
//
//  Created by Warln on 19/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit


class epsiodeDetailVc: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var premiumData : [freeModel] = []
    var delegate: EpisodeDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUi()
        
        
    }
    
    func updateUi(){
        
        collectionView.reloadData()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    


}

//MARK: CollectionViewDatasource
extension epsiodeDetailVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return premiumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCollectCell", for: indexPath) as? episodeCollectCell else {
            return UICollectionViewCell()
        }
        let imageUrl = (premiumData[indexPath.row].thumbnail_url)
        let posts = premiumData[indexPath.row]
        if posts.is_locked == "0" {
            cell.lockImg.isHidden = true
        }else{
            cell.lockImg.isHidden = false
        }
        cell.cellView.layer.cornerRadius = 5.0
        cell.image.sd_setImage(with: URL(string: imageUrl ), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        shadow(cell)
        return cell
    }
    
}
//MARK: Collectionview Delegate
extension epsiodeDetailVc: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = premiumData[indexPath.row]
        let url = post.yt_episode_url
        let id = post.episode_id
        
        if post.is_locked == "0"{
            delegate?.didSelect(url, id)
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: appName, message: ALERTS.KSubscribe, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Go Premium", style: .default, handler: { (action: UIAlertAction) in
                let vc =  storyBoard.instantiateViewController(withIdentifier: "TBPremiumPaymentVC")
                self.navigationController?.pushViewController(vc, animated: true)

            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
}

//MARK: CollectionView Flowlayout Delegate
extension epsiodeDetailVc: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 133)
    }
    
}
