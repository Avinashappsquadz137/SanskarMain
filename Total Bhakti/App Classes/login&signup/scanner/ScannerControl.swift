//
//  ScannerControl.swift
//  Sanskar
//
//  Created by Warln on 07/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import CommonCrypto
import CryptoSwift

class ScannerControl: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    @IBOutlet var topBar: UIView!
    var dict = Dictionary<String,Any>()
    var arr: Parameters?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session
            captureSession.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)

            // Start video capture
            captureSession.startRunning()

            // Move the message label and top bar to the front
//            view.bringSubviewToFront(messageLabel)
            view.bringSubview(toFront: topBar)


            // Initialize QR Code Frame to highlight the QR Code
            qrCodeFrameView = UIView()

            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubview(toFront: qrcodeFrameView)
            }

        } catch {
            // If any error occurs, simply print it out and don't continue anymore
            print(error)
            return
        }
    }
    
    
    @IBAction func backBTBPressed(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setup() {
        
    }

}

extension ScannerControl : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No QR code is detected"
            print("No QR code is Detected")
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
//                messageLabel.text = metadataObj.stringValue
                print(metadataObj.stringValue as Any)
                captureSession.stopRunning()
                let dataString = metadataObj.stringValue ?? ""
                let model = dataString.split(separator: ";")
                
                if model[0] == "1" {
                    let param = ["device_qr_key": String(model[1]),"device_type":String(model[2]),"device_id": String(model[3]), "device_model": String(model[5]), "user_id":currentUser.result?.id ?? "163" ,"device_token": String(model[4]) ]
                arr = param
//                    extractData(arr: param)
                    hitTv()
                }else {
                    getScanData(with: metadataObj.stringValue ?? "")
                }
            }
        }
    }
}

extension ScannerControl {
    func getScanData(with scanString: String) {
        
        //PVaG6l7PZBCVC2G625twoB8DiZLH5knZGo+s9rEfEzA=:MTIzNDU2Nzg5MDEyMzQ1Ng==key59949114850615699334
        
        let encryptedString = scanString//"2MuCQ64N8U5qTCniYgDCah1OxiphIQH8rRiV2brdrZk=:MTIzNDU2Nzg5MDEyMzQ1Ng==:36748264866196496181"
        let newReplaceString = encryptedString.replacingOccurrences(of: "key", with: ":")
        let endIndex = newReplaceString.index(newReplaceString.endIndex, offsetBy: -4)
        let newEncryptString = newReplaceString.substring(to: endIndex)
        
        
        var genretedAesKey: Array<Character> = Array()
        var genretedVi: Array<Character> = Array()
        let file_url = newEncryptString.split(separator:":" ) // Pass your encryption key here
        
        genretedAesKey = []
        genretedVi = []
        for char in file_url[2]{
            genretedAesKey.append(EncryptionHelper.getAesKey(char: char))
            genretedVi.append(EncryptionHelper.getVI(char: char))
        }
        let aesKey = String(genretedAesKey)
        let VI = String(genretedVi)
        let encrypedUrlArray = newEncryptString.components(separatedBy: ":")
        let aes128N = AES(key: aesKey, iv: VI)
        print(encrypedUrlArray[0])
        print(file_url[0])
        let decodedData = NSData(base64Encoded: (encrypedUrlArray[0]), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decryptedDataNN = aes128N?.decrypt(data: decodedData as Data?)
        print(decryptedDataNN as Any)
        let removeS =  decryptedDataNN?.components(separatedBy: ":")

        let vc = storyboard?.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as! TBPremiumPaymentVC
        vc.userId = (removeS?[1])!
        iscoming = "FromScan"
        vc.completionHandler = { [weak self] (success) in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }   
    
    func extractData(arr: Parameters) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "scanViewControllertest") as! scanViewControllertest
//        vc.mode = arr
////        vc.completionHandler = { [weak self] (success) in
////            DispatchQueue.main.async {
////                self?.navigationController?.popViewController(animated: false)
////            }
////        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hitTv() {
        
        arr?.updateValue("1234", forKey: "pin")
        let device_id = UserDefaults.standard.string(forKey: "device_id") ?? ""
        let jwt:HTTPHeaders = ["jwt":"\(UserDefaults.standard.value(forKey: "jwt") ?? "")","Deviceid": device_id]
        DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
        self.uplaodDataHeader("user/qr_login/get_user_data", arr ?? [:]  , header: jwt) { response in
            DispatchQueue.main.async(execute: {loader.shareInstance.hideLoading()})
            DispatchQueue.main.async {
                if let json = response as? [String: Any] {
                    if json["status"] as? Bool == true {
                        AlertController.alert(message: json["message"] as? String ?? "")
                        self.navigationController?.popToRootViewController(animated: false)
                    }else{
                        AlertController.alert(message: json["message"] as? String ?? "")
                    }
                }
            }

        }
    }
}



struct AES {
    
    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data
    
    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
        
        
        self.key = keyData
        self.iv  = ivData
    }
    
    
    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    func MYdecrypt(data: Data?) -> Data? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return decryptedData
    }
    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = key.count
        _   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), option, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
