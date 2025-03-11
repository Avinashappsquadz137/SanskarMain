//
//  GuruWallpaperVC.swift
//  Sanskar
//
//  Created by Warln on 14/04/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class GuruWallpaperVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wallpaperResp: WallpaperResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWallpaper()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func getWallpaper() {
        var dict = Dictionary<String,Any>()
        dict["user_id"] = currentUser.result?.id ?? "163"
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        HttpHelper.apiCallWithout(postData: dict as NSDictionary,
                                  url: "wallpaper/wallpaper/get_wallpaper_menu?",
                                  identifier: "") { result, response, error, data in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(WallpaperResponse.self, from: data)
                self.wallpaperResp = result
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    func onClickedProgram(_ sender: UIButton) {
        print(sender.tag)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GuruWallDetailsVc") as! GuruWallDetailsVc
        vc.category = wallpaperResp?.data[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension GuruWallpaperVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return wallpaperResp?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "guruCell", for: indexPath) as? GuruWallCell else {
            return UITableViewCell()
        }
        guard let indexData = wallpaperResp?.data[indexPath.section].wallpaper else {return UITableViewCell()}
        cell.configure(with: indexData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! wallHeaderCell
        cell.titleLbl.text = wallpaperResp?.data[section].category_name.capitalizingFirstLetter()
        cell.headerBtn.tag = section
        cell.headerBtn.addTarget(self, action: #selector(onClickedProgram(_:)), for: .touchUpInside)
        return cell
    }
}

extension GuruWallpaperVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
