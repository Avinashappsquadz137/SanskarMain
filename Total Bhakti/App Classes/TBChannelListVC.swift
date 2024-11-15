//
//  TBChannelListVC.swift
//  Total Bhakti
//
//  Created by mac on 31/03/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit
import SDWebImage

class TBChannelListVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    var channelList : [channelModel] = []
    var simpleClosure:(Int) -> () = {_ in }
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let button = UIButton()
        button.tag = 7
        TBHomeTabBar.currentInstance?.TabBarActionButton(button)
    }

    
    @IBAction func backAction(_ sender: UIButton) {
        let button = UIButton()
        button.tag = 0
        TBHomeTabBar.currentInstance?.TabBarActionButton(button)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TB_ChannelListCell") as! TB_ChannelListCell
        
        
        let posts = channelList[indexPath.row]
        
        print("....................  \(posts.name)  ..................")
        
        cell.lbl_channelName.text = posts.name
        if let urlString = posts.image , urlString.isEmpty == false {
            cell.img_channelImageView.sd_setIndicatorStyle(.gray)
            cell.img_channelImageView.sd_setShowActivityIndicatorView(true)
            cell.img_channelImageView.layer.cornerRadius = 5.0
            cell.img_channelImageView.clipsToBounds = true
            cell.img_channelImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "default_image"), options: .refreshCached, completed: nil)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let button = UIButton()
        button.tag = 7

        let po = channelTableArr[indexPath.row]
        if let urlStr = po.channel_url{
            let url = URL(string: urlStr)!

            TV_PlayerHelper.shared.mmPlayer.set(url: url)
            TV_PlayerHelper.shared.mmPlayer.resume()
            TV_PlayerHelper.shared.mmPlayer.player?.play()
            
            TBHomeTabBar.currentInstance?.MiniTVView.alpha = 1.0
            TV_PlayerHelper.shared.mmPlayer.playView = TBHomeTabBar.currentInstance?.MiniTVPlayer
            TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: false)

            post = channelTableArr[indexPath.row]
            TBHomeTabBar.currentInstance?.TabBarActionButton(button)
            UserDefaults.standard.setValue(indexPath.row, forKey: "channelIndex")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeChannel"), object: nil)
            
        }
    }
}
