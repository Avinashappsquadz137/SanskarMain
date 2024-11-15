//
//  editprofilevc.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 04/09/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit
import CoreImage

class holishowdetail: UIViewController {
    
    @IBOutlet weak var guruimg:UIImageView!
    @IBOutlet weak var gurunamelbl:UILabel!
    @IBOutlet weak var programdetaillbl:UILabel!
    @IBOutlet weak var titlelbl:UILabel!
    @IBOutlet weak var venuelbl:UILabel!
    @IBOutlet weak var locationlbl:UILabel!
    @IBOutlet weak var qrcodeimg:UIImageView!
    
    
    var titledata:String?
    var venuedata:String?
    var detaildata:String?
    var guruimgdata:String?
    var gurunamedata:String?
    var usercodedata:String?
    var locationdata:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guruimg.layer.cornerRadius = 10
        let captialguruname = gurunamedata
        let guruname = captialguruname?.capitalized
        gurunamelbl.text = guruname
        
        if let components = detaildata?.components(separatedBy: "on"), let dateAndTime = components.last?.trimmingCharacters(in: .whitespacesAndNewlines) {
            // Assign the string directly to programdetaillbl.text
            programdetaillbl.text = dateAndTime
        } else {
            print("Date and time not found")
        }
        guruimg.sd_setImage(with: URL(string: guruimgdata ?? ""))
        titlelbl.text = titledata
        locationlbl.text = locationdata
        if let qrCodeImage = generateQRCode(from: usercodedata ?? "") {
                  qrcodeimg.image = qrCodeImage
              } else {
                  print("Failed to generate QR code")
              }
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
           let data = string.data(using: String.Encoding.ascii)
           if let filter = CIFilter(name: "CIQRCodeGenerator") {
               filter.setValue(data, forKey: "inputMessage")
               let transform = CGAffineTransform(scaleX: 10, y: 10) // Adjust the scale as needed
               if let output = filter.outputImage?.transformed(by: transform) {
                   return UIImage(ciImage: output)
               }
           }
           return nil
       }
}
