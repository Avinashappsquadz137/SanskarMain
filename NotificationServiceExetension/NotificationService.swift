//
//  NotificationService.swift
//  NotificationServiceExetension
//
//  Created by mac on 21/10/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import UserNotifications
import UIKit
import Foundation


 class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
       
        if let bestAttemptContent = bestAttemptContent {
            if let urlString = (request.content.userInfo["aps"] as! NSDictionary).value(forKey: "image_url") as? String, let fileUrl = URL(string: urlString) {
                 // Modify the notification content here...
                
                if bestAttemptContent.title == "URL"{
                     bestAttemptContent.title = "General"
                }else{
                     bestAttemptContent.title = "\(bestAttemptContent.title)"
                }
                bestAttemptContent.subtitle = "\(bestAttemptContent.subtitle)"
                bestAttemptContent.body = "\(bestAttemptContent.body)"
                
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                        // Move temporary file to remove .tmp extension
                            let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file:".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        try? FileManager.default.moveItem(at: location, to: tmpUrl)
                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: fileUrl.lastPathComponent, url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }}
                    // Serve the notification content
                    contentHandler(self.bestAttemptContent!)
                    }.resume()
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func saveImageAttachment( image: UIImage, forIdentifier identifier: String ) -> URL? {
        // 1
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        // 2
        let directoryPath = tempDirectory.appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString,isDirectory: true)
        do {
            // 3
            try FileManager.default.createDirectory(at: directoryPath,withIntermediateDirectories: true,attributes: nil)
            // 4
            let fileURL = directoryPath.appendingPathComponent(identifier)
            // 5
            guard let imageData = image.pngData() else {
                return nil
            }
            // 6
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
    
    private func getMediaAttachment(for urlString: String,completion: @escaping (UIImage?) -> Void) {
        // 1
        guard let url = URL(string: urlString) else { completion(nil)
            return
        }
        // 2
        ImageDownloader.shared.downloadImage(forURL: url) { result in
            // 3
            guard let image = try? result.get() else {
                completion(nil)
                return
            }
            // 4
            completion(image)
        }
    }
}



public class ImageDownloader {
    public static let shared = ImageDownloader()
    
    private init () { }
    
    public func downloadImage(forURL url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(DownloadError.emptyData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(DownloadError.invalidImage))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
}




public enum DownloadError: Error {
    case emptyData
    case invalidImage
}








