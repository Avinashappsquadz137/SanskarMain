//
//  shortscommentvc.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 15/05/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit

protocol ShortsCommentVCDelegate: AnyObject {
    func didUpdateCommentCount(for shortsID: String, newCount: Int)
}


class shortscommentvc: UIViewController {
    
    @IBOutlet weak var usercommenttable:UITableView!
    @IBOutlet weak var usercommentfield:UITextField!
    
    var comments: [Comment] = []
    var shorts_id = ""
    weak var delegate: ShortsCommentVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        usercommenttable.delegate = self
        usercommenttable.dataSource = self
        let param: Parameters = ["user_id": currentUser.result!.id!,"type":"shorts","type_id":shorts_id]
        hitshortscommentapi(param)
       
        
    }
    
    func hitshortscommentapi(_ param: Parameters) {
        self.uplaodData(APIManager.sharedInstance.Kshortscommentapi, param) { (response) in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
               
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) else {
                    print("Error converting JSON response to data")
                    return
                }
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from: jsonData)
                    self.comments = response.data
                    print(self.comments)
                    // Now you can update your table view with the comments data if needed
                    self.usercommenttable.reloadData()
                    self.delegate?.didUpdateCommentCount(for: self.shorts_id, newCount: self.comments.count)
                                    } catch {
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
    }
    func hitshortsusercommentapi(_ param : Parameters){
        self.uplaodData(APIManager.sharedInstance.Kshortsusercommentapi , param) { (response) in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON.value(forKey: "status") as? Bool == true {
                    let data = (JSON["data"] as? [String:Any] ?? [:])
                    print(data)
                    let param: Parameters = ["user_id": currentUser.result!.id!,"type":"shorts","type_id":self.shorts_id]
                    self.hitshortscommentapi(param)

                }
            }
        }
    }

    @IBAction func sendbtn(_ sender: UIButton) {
        
        let param: Parameters = ["user_id": currentUser.result!.id!,"type":"shorts","type_id":shorts_id,"comments":usercommentfield.text,"status":"0"]
        hitshortsusercommentapi(param)
        self.usercommentfield.text = ""

    }
    
}

extension shortscommentvc: UITableViewDelegate,UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usercommenttable.dequeueReusableCell(withIdentifier: "commenttableviewcell", for: indexPath) as! commenttableviewcell
        let username = comments[indexPath.section].userMobile
        let usercomment = comments[indexPath.section].comments
        cell.usernamelbl.text = usercomment
        cell.usercommentlbl.text = username
        let datetime = comments[indexPath.section].creationTime
        cell.datetimelbl.text =  "\(changeDate(with:datetime))"
        return cell
        
        func changeDate(with data: String) -> String {
            var dataWithLong = LONG_LONG_MAX
            dataWithLong = Int64(data) ?? 0
            let formatedData = Date(timeIntervalSince1970: (TimeInterval(dataWithLong / 1000)))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: formatedData)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if #available(iOS 15.0, *) {
            view.backgroundColor = UIColor.white
        } else {
        }
        return view
    }
    
}
