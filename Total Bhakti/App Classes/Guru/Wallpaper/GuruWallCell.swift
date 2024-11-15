//
//  GuruWallCell.swift
//  Sanskar
//
//  Created by Warln on 14/04/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

class GuruWallCell: UITableViewCell {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 200, height: 150)
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.showsHorizontalScrollIndicator = false
        c.register(WallCollectionCell.self, forCellWithReuseIdentifier: WallCollectionCell.identifier)
        return c
    }()
    
    var wallData: [WallData] = [WallData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with data: [WallData]) {
        self.wallData = data
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                if let data = UIImage(data: data){
                    self?.writeImage(image: data)
                }
                
            }
        }
    }
    
    func writeImage(image: UIImage) {
//        guard let selectedImage = image else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        AlertController.alert(title: title, message: message)
    }

}

extension GuruWallCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallCollectionCell.identifier, for: indexPath) as? WallCollectionCell else {
            return UICollectionViewCell()
        }
        let index = wallData[indexPath.row].wallpaper
        cell.configure(data: index)
        return cell
    }
    
}

extension GuruWallCell: UICollectionViewDelegate {
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _ in
            let download = UIAction(title: "Download", image: UIImage(systemName: "arrow.down.to.line"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                guard let wall = URL(string:self?.wallData[indexPath.row].wallpaper ?? "") else {return}
                self?.downloadImage(from: wall)
            }
            
            if #available(iOS 15.0, *) {
                return UIMenu(title: "", subtitle: "", image: nil, identifier: nil, options: .displayInline, children: [download])
            } else {
                return UIMenu()
            }
        }
        return config
    }
}

