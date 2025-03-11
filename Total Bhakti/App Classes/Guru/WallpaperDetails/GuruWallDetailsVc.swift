//
//  GuruWallDetailsVc.swift
//  Sanskar
//
//  Created by Warln on 15/04/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class GuruWallDetailsVc: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var category: String?
    var wallDeatils: WallDetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWallpaper()
        configureUI()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureUI() {
        collectionView.register(
            UINib(nibName: "GuruWallDetailCell", bundle: nil),
            forCellWithReuseIdentifier: "GuruWallDetailCell"
        )
        let margin: CGFloat = 5
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func getWallpaper() {
        var dict = Dictionary<String,Any>()
        dict["user_id"] = currentUser.result?.id ?? "163"
        dict["category_id"] = category ?? ""
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        HttpHelper.apiCallWithout(
            postData: dict as NSDictionary, url: "wallpaper/wallpaper/get_wallpaper_by_category",
            identifier: ""
        ) { result, response, error, data in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            guard let data = data , error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(WallDetailResponse.self, from: data)
                self.wallDeatils = result
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
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

extension GuruWallDetailsVc: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallDeatils?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuruWallDetailCell", for: indexPath) as? GuruWallDetailCell else {
            return UICollectionViewCell()
        }
        guard let data = wallDeatils?.data[indexPath.row].wallpaper else {
            return UICollectionViewCell()
        }
        cell.configure(with: data)
        return cell
    }
    
}

extension GuruWallDetailsVc: UICollectionViewDelegate {
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _ in
            let download = UIAction(title: "Download", image: UIImage(systemName: "arrow.down.to.line"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                guard let wall = URL(string: self?.wallDeatils?.data[indexPath.row].wallpaper ?? "") else {return}
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

extension GuruWallDetailsVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
}


