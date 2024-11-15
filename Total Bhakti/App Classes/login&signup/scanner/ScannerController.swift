//
//  ScannerController.swift
//  Sanskar
//
//  Created by Warln on 29/09/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import AVFoundation
import CryptoSwift
import CommonCrypto
import Foundation

//struct AES {
//    
//    // MARK: - Value
//    // MARK: Private
//    private let key: Data
//    private let iv: Data
//    
//    // MARK: - Initialzier
//    init?(key: String, iv: String) {
//        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
//            debugPrint("Error: Failed to set a key.")
//            return nil
//        }
//        
//        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
//            debugPrint("Error: Failed to set an initial vector.")
//            return nil
//        }
//        
//        
//        self.key = keyData
//        self.iv  = ivData
//    }
//    
//    
//    // MARK: - Function
//    // MARK: Public
//    func encrypt(string: String) -> Data? {
//        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
//    }
//    func MYdecrypt(data: Data?) -> Data? {
//        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
//        return decryptedData
//    }
//    func decrypt(data: Data?) -> String? {
//        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
//        return String(bytes: decryptedData, encoding: .utf8)
//    }
//    //    func MD5(_ string: String) -> String {
//    //        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//    //        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
//    //        CC_MD5_Init(context)
//    //        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
//    //        CC_MD5_Final(&digest, context)
//    //       // context.deallocate(capacity: 1)
//    //        var hexString = ""
//    //        for byte in digest {
//    //            hexString += String(format:"%02x", byte)
//    //        }
//    //        return hexString
//    //    }
//    
//    func crypt(data: Data?, option: CCOperation) -> Data? {
//        guard let data = data else { return nil }
//        
//        let cryptLength = data.count + kCCBlockSizeAES128
//        var cryptData   = Data(count: cryptLength)
//        
//        let keyLength = key.count
//        _   = CCOptions(kCCOptionPKCS7Padding)
//        
//        var bytesLength = Int(0)
//        
//        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
//            data.withUnsafeBytes { dataBytes in
//                iv.withUnsafeBytes { ivBytes in
//                    key.withUnsafeBytes { keyBytes in
//                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), option, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
//                    }
//                }
//            }
//        }
//        
//        guard UInt32(status) == UInt32(kCCSuccess) else {
//            debugPrint("Error: Failed to crypt data. Status \(status)")
//            return nil
//        }
//        
//        cryptData.removeSubrange(bytesLength..<cryptData.count)
//        return cryptData
//    }
//}





class ScannerController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    
    private let supportCodeType = [AVMetadataObject.ObjectType.upce,
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
                                   AVMetadataObject.ObjectType.qr
    ]
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var qrLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getCameraFunc()
        
    }
    
    @IBAction func backBtnpressed(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCameraFunc(){
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Scanner is not working")
            return
        }
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            let captureMetaDataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetaDataOutput)
            
            captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetaDataOutput.metadataObjectTypes = supportCodeType
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            view.bringSubview(toFront: headerView)
            view.bringSubview(toFront: qrLbl)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView{
                qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        }catch{
            
            print(error)
            
        }
    }
    
    
    
}

extension ScannerController {
    func getScanData(with scanString: String) {
        
        //PVaG6l7PZBCVC2G625twoB8DiZLH5knZGo+s9rEfEzA=:MTIzNDU2Nzg5MDEyMzQ1Ng==key59949114850615699334
        let encryptedString = scanString//"2MuCQ64N8U5qTCniYgDCah1OxiphIQH8rRiV2brdrZk=:MTIzNDU2Nzg5MDEyMzQ1Ng==:36748264866196496181"
        let newReplaceString = encryptedString.replacingOccurrences(of: "key", with: ":")
        //        let newEncryptString = "\(newReplaceString.removeLast(4))"
        
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
        //        let responseDict = EncryptionHelper.convertToDictionary(text: decryptedDataNN ?? "")
        //        print(responseDict?.jsonStringRepresentation ?? "")
        //
        //        let message = (responseDict ?? [:]).validatedValue("message")
        print(decryptedDataNN as Any)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as! TBPremiumPaymentVC
        vc.userId = decryptedDataNN ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            qrLbl.text = "there is no url "
            return
        }
        
        let metaDataObjc = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportCodeType.contains(metaDataObjc.type){
            
            let barcodeObjc = videoPreviewLayer?.transformedMetadataObject(for: metaDataObjc)
            qrCodeFrameView?.frame = barcodeObjc!.bounds
            
            if metaDataObjc.stringValue != nil{
                let tvScan = metaDataObjc.stringValue ?? ""
                var model = tvScan.split(separator:";" )
                if model[0] == "1" {
                    let vc = storyboard?.instantiateViewController(withIdentifier: "TvPinVC") as! TvPinVC
                    vc.data = String(model.last ?? "")
                    navigationController?.pushViewController(vc, animated: true)
                }else{
                    getScanData(with: metaDataObjc.stringValue ?? "")
                }
                 
                
                
            }
        }
    }
    

}
