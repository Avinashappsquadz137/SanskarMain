//
//  NotificationViewController.swift
//  notificationContent
//
//  Created by mac on 21/10/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI


class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var title_label: UILabel?
    @IBOutlet var subTitle_label: UILabel?
    @IBOutlet var body_label: UILabel?
    @IBOutlet var imge_view: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        
        
        self.title_label?.text = notification.request.content.title
        self.subTitle_label?.text = notification.request.content.subtitle
        self.body_label?.text = notification.request.content.body
          
        let content = notification.request.content
        
        // 3
        guard
          let attachment = content.attachments.first,
          attachment.url.startAccessingSecurityScopedResource()
          else {
            return
        }
      
        
        // 4
        let fileURLString = attachment.url
        
        guard
          let imageData = try? Data(contentsOf: fileURLString),
          let image = UIImage(data: imageData)
          else {
            attachment.url.stopAccessingSecurityScopedResource()
            return
        }

        // 5
        imge_view?.image = image
        attachment.url.stopAccessingSecurityScopedResource()
        
    }

}
