//
//  TBProfileVC.swift
//  Total Bhakti
//
//  Created by MAC MINI on 24/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBProfileVC: TBInternetViewController {
    
    //MARK:- IBOutlets.
    @IBOutlet weak var profileBgView: UIView!
    @IBOutlet weak var maleRadioImage: UIImageView!
    @IBOutlet weak var femaleRadioImage: UIImageView!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
//    @IBOutlet weak var aboutTV: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadImageBtn: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var subscriptBtn: UIButton!
    @IBOutlet weak var managedevicebtn:UIButton!
    @IBOutlet weak var deleteaccountbtn:UIButton!
    
    var isPresent = false
    
    //MARK:- variables.
    var edit = 0
    var maleFemale = 0
    var isImage = 0
    var updateImage = UIImage()
    var devicet = String()
    var paymentmethod = ""
    var param1 : Parameters = [:]
    var UDID: String!
    
    var id: String?
   
    
    //MARK:- LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        if currentUser.result?.id == "256196" || currentUser.result?.id == "163" {
//            subscriptBtn.isHidden = true
//        }

            
        UserDefaults.standard.removeObject(forKey: "hiderotation")
        let param : Parameters = ["user_id": currentUser.result?.id ?? "163","device_type":"2"]
        hitcheckpaymentapi(param)
       
        nameTf.delegate = self
        emailTF.delegate = self
        mobileTF.delegate = self
   //     aboutTV.delegate = self
        
        subscriptBtn.layer.cornerRadius = 10
        managedevicebtn.layer.cornerRadius = 10
        deleteaccountbtn.layer.cornerRadius = 10
        deleteaccountbtn.layer.cornerRadius = 10
      //  subscriptBtn.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileBgView.layer.borderWidth = 1.0
        profileBgView.layer.borderColor = UIColor.gray.cgColor
        maleRadioImage.image = UIImage(named: "radio_inactive")
        femaleRadioImage.image = UIImage(named : "radio_inactive")
//        aboutTV.layer.cornerRadius = 5.0
//        aboutTV.layer.borderWidth = 0.5
//        aboutTV.layer.borderColor = UIColor.lightGray.cgColor
        logoutBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        
        
      
        let value = UserDefaults.standard.value(forKey: "prim") as? Int ?? 0
        if value == 0 {
          //  subscriptBtn.isHidden = true
            subscriptBtn.setTitle( "Go Premium", for: .normal)
        }else {
           // subscriptBtn.isHidden = false
            subscriptBtn.setTitle("Manage Subscrption", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isImage == 1 {
            
        }else {
            if currentUser != nil {
                if currentUser.result?.username != "" {
                    nameTf.text = currentUser.result?.username
                }
                if currentUser.result?.email != "" {
                    emailTF.text = currentUser.result?.email
                }
                if currentUser.result?.mobile != "" {
                    mobileTF.text = currentUser.result!.mobile
                }
//                if currentUser.result?.about != "" {
//                    aboutTV.text = currentUser.result?.about
//                }
                if let profileUrl = currentUser.result!.profile_picture, profileUrl != "" && isImage == 0   {
                    profileImageView.contentMode = .scaleAspectFill
                    profileImageView.sd_setShowActivityIndicatorView(true)
                    profileImageView.sd_setIndicatorStyle(.gray)
                    profileImageView.sd_setImage(with: URL(string: profileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, placeholderImage: UIImage(named: "Profile_img"), options: .refreshCached, completed: nil)
                } else {
                    
                }
                if currentUser.result?.gender == "" {
                    maleRadioImage.image = UIImage(named : "radio_active")
                }else if currentUser.result?.gender == "0"{
                    femaleRadioImage.image = UIImage(named : "radio_active")
                } else if  currentUser.result?.gender == "1" {
                    maleRadioImage.image = UIImage(named : "radio_active")
                }
            }
        }
    }
    
    @IBAction func logoBtnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
       }
    
    @IBAction func managedevicebtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "managedeviceViewController") as! managedeviceViewController
//        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func ActiveSubBtn(_ sender: UIButton ) {
        let value = UserDefaults.standard.value(forKey: "prim") as? Int ?? 0
        if value == 0 {
            if paymentmethod == "0" {
                // Present Newpaymentvc
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Newpaymentvc") as! Newpaymentvc
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Present TBPremiumPaymentVC
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBPremiumPaymentVC") as! TBPremiumPaymentVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            // Present SubsciptVc
            let vc = storyboard?.instantiateViewController(withIdentifier: "SubsciptVc") as! SubsciptVc
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    //MARK: - ScreenBtn action.
    @IBAction func screenBtnAction (_ sender : UIButton) {
        if sender.tag == 10 {//backBtn
            if isPresent{
                navigationController?.popViewController(animated: true)
            }else{
               _ = navigationController?.popViewController(animated: true)
            }
        }else if sender.tag == 20 { // Edit
            editBtn.setTitle("SAVE", for: .normal)
            
            if edit == 0 {
                nameTf.isUserInteractionEnabled = true
                maleBtn.isUserInteractionEnabled = true
                cameraImageView.isHidden = false
                femaleBtn.isUserInteractionEnabled = true
          //      aboutTV.isUserInteractionEnabled = true
                uploadImageBtn.isUserInteractionEnabled = true

                // Check if mobileTF is not nil, then disable user interaction
                if let mobile = currentUser.result?.mobile, !mobile.isEmpty {
                            mobileTF.text = mobile
                            mobileTF.isUserInteractionEnabled = false
                        } else {
                            mobileTF.isUserInteractionEnabled = true
                        }
                        if let email = currentUser.result?.email, !email.isEmpty {
                            emailTF.text = email
                           emailTF.isUserInteractionEnabled = false
                        } else {
                            emailTF.isUserInteractionEnabled = true
                        }

                edit = 1
            } else {
                nameTf.isUserInteractionEnabled = false
                maleBtn.isUserInteractionEnabled = false
                cameraImageView.isHidden = true
                femaleBtn.isUserInteractionEnabled = false
         //       aboutTV.isUserInteractionEnabled = false
                checks()
                edit = 0
                editBtn.setTitle("Edit", for: .normal)
                uploadImageBtn.isUserInteractionEnabled = false
            }
        }
        else if sender.tag == 30 {//male
            maleRadioImage.image = UIImage(named: "radio_active")
            femaleRadioImage.image = UIImage(named : "radio_inactive")
            maleFemale = 1
        }else if sender.tag == 40 {//female
            maleRadioImage.image = UIImage(named: "radio_inactive")
            femaleRadioImage.image = UIImage(named : "radio_active")
            maleFemale = 0
        }else if sender.tag == 50 {//uploadImage
            ActionSheet()
        }else if sender.tag == 60 {//logoutBtn
            let alert =  UIAlertController(title: appName, message: ALERTS.KLogout, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ALERTS.kAlertYes, style: .default, handler: { (action: UIAlertAction!) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)

                DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                self.logoutApi()
            }))
            alert.addAction(UIAlertAction(title: ALERTS.kAlertNo, style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if sender.tag == 70 {
            let alert =  UIAlertController(title: "Are You Sure?", message: "Deleting your account permanently cancels your premium membership, even upon re-login. ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ALERTS.kAlertYes, style: .default, handler: { (action: UIAlertAction!) in
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExitVideoView"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("exitAudioPlayer"), object: nil)

                DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                let param : Parameters = ["user_id": currentUser.result?.id ?? "163"]
                print(param)
                
                self.hitdeleteaccountapi(param)
            }))
            alert.addAction(UIAlertAction(title: ALERTS.kAlertNo, style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func hitcheckpaymentapi(_ param : Parameters){
        self.uplaodData1(APIManager.sharedInstance.Kcheckpaymentstatusapi, param) { (response) in
       //     DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                    let dataArray = JSON["data"] as? [String: Any] ?? [:]
                    print(dataArray)
                let payment = JSON["payment_method"] as? String ?? ""
                print(payment)
                self.paymentmethod = payment
                print(self.paymentmethod)
                
                        
                    }
                }
            }

    
    func hitdeleteaccountapi(_ param : Parameters){
        self.uplaodData(APIManager.sharedInstance.Kdeleteaccountapi, param) { (response) in
            //     DispatchQueue.main.async(execute: {loader.shareInstance.showLoading(self.view)})
            print(response as Any)
            if let JSON = response as? NSDictionary {
                print(JSON)
                if JSON["status"] as? Bool == true {
       //             DispatchQueue.main.async(execute: { loader.shareInstance.showLoading(self.view) })
                    self.logoutApi()
                }
            }
        }
    }
    
    //MARK:- LogoutApi.
    func logoutApi() {
        
        var UDID = ""
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            UDID = uid
        }
        
        let device_id = UserDefaults.standard.string(forKey: "device_id")
        let param : Parameters = ["user_id" : currentUser.result?.id ?? "", "device_id": "\(device_id ?? "")","current_version": "\(UIApplication.release)"]

            
            self.uplaodData(APIManager.sharedInstance.KLOGOUTAPI, param, { response in
                DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                if let response = response as? NSDictionary {
                    if response.value(forKey: "status") as? Bool == true {
                        self.devicet = UserDefaults.standard.value(forKey: "device_tokken") as? String ?? ""
                        
                        TBSharedPreference.sharedIntance.clearAllPreference()
                        print(self.devicet)
                        
                        //UserDefaults.standard.setValue(device_id, forKey: "device_id")
                        // Storing a string value to UserDefaults
                        UserDefaults.standard.set(self.id, forKey: "devicet")

                        self.signInApi()
                        

                    }
                    else{
                        self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)

                    }
                }
            })
        }
 
    
    func signInApi(){

    //    param1 = ["mobile": "9811792554", "login_type" : "0" , "country_code" : "+91"]

        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            self.UDID = uid
            print(self.UDID)
        }

        param1 = ["mobile": "9811792554"]

        self.uplaodData(APIManager.sharedInstance.KGUESTLOGINAPI, param1) { response in
            DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
            print(response as Any)
            if response != nil {
                if (response as! NSDictionary).value(forKey: "status") as! Bool == true {
                    if let result = response as? NSDictionary {
                        print(result)

                        currentUser = User.init(dictionary: result)
                        if currentUser.status! {
                           TBSharedPreference.sharedIntance.setUserData(currentUser)
    //                        let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
    //                        vc.parameter = self.param1
    //                        self.navigationController?.pushViewController(vc, animated: true)

                            self.VerifyOtp()

                        }else {
                            self.addAlert(appName, message: currentUser.message!, buttonTitle: ALERTS.kAlertOK)
                        }
                    }

                } else {
                    self.addAlert(appName, message: (response as! NSDictionary).value(forKey: "message") as! String, buttonTitle: ALERTS.kAlertOK)
                }
            }
        }
    }
    
    func VerifyOtp() {
        let otp  = "0000"
        
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
            print(uid)
            self.UDID = uid
            UserDefaults.standard.setValue(self.UDID, forKey: "device_id")
        }
        
        let device_id = UserDefaults.standard.string(forKey: "device_id")

        let param : Parameters = ["mobile" : "9811792554","otp_verification" : "\(otp)", "device_id":device_id]

            
            self.uplaodData(APIManager.sharedInstance.KOTPAPI, param, { response in
                DispatchQueue.main.async(execute: { loader.shareInstance.hideLoading()})
                if let response = response as? NSDictionary {
    //                currentUser = User.init(dictionary: result)
    //                if currentUser.status! {
    //                       TBSharedPreference.sharedIntance.setUserData(currentUser)

                    if response.value(forKey: "status") as? Bool == true {
                        TBSharedPreference.sharedIntance.setLoginStatus(true)
    //
    //                    let vc =  storyBoard.instantiateViewController(withIdentifier: "Loginviewcontroller") as! Loginviewcontroller
    //                    self.navigationController?.pushViewController(vc, animated: true)
                        
                        self.navigationTohomepage()
                    }
                    else{
                        self.addAlert(appName, message: ALERTS.KOTPDoesnotVArify, buttonTitle: ALERTS.kAlertOK)

                    }
                }
            })
        }
    
    
    //MARK:- see all vaild areas.
    func checks()  {
//        if nameTf.text == ""{
//            addAlert(appName, message: "Please enter Name", buttonTitle: ALERTS.kAlertOK)
//        }
//        else if mobileTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
//            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
//        }
//        else if !isValidPhone(value: mobileTF.text!) {
//            addAlert(appName, message: ALERTS.KPleaseEnterVaildMbileNumber, buttonTitle: ALERTS.kAlertOK)
//        }
//        else if emailTF.text == "" || !isValidEmail(testStr: emailTF.text!) {
//            addAlert(appName, message: ALERTS.KEmailVerify, buttonTitle: ALERTS.kAlertOK)
//        }
//        else if nameTf.text == ""{
//            addAlert(appName, message: "Please enter Name", buttonTitle: ALERTS.kAlertOK)
//        }
//        else {
            updateUserApi()
      //  }
    }
    
    //MARK:- Action Sheet For imagePicking .
    func ActionSheet()  {
        let alertController = UIAlertController(title: appName, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (UIAlertAction) in
            self.PhotoFormCamera()
        }))
        alertController.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (UIAlertAction) in
            self.PhotoFromPhotoAlbum()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- UpdateUserApi.
    func updateUserApi() {
        var param: Parameters = [
            "id": currentUser.result?.id ?? "",
            "mobile": mobileTF.text ?? "",
            "email": emailTF.text ?? "",
            "username": nameTf.text ?? "",
            "gender": "\(maleFemale)",
            "country_code": currentUser.result?.country_code ?? ""
        ]

        if isImage == 1, let updateImage = updateImage as? UIImage {
            param["profile_picture"] = updateImage
        }

        let url = APIManager.sharedInstance.KBASEURL + APIManager.sharedInstance.KUPDATEUSER
        DispatchQueue.main.async { loader.shareInstance.showLoading(self.view) }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                if key == "profile_picture", let image = value as? UIImage {
                    if let imageData = UIImagePNGRepresentation(image) {
                        let milliseconds = Int64(Date().timeIntervalSince1970 * 1000.0)
                        let filename = "\(milliseconds).png"
                        multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: "image/png")
                    } else {
                        print("Error: Failed to convert UIImage to PNG data.")
                    }
                }

            }
        }, to: url, method: .post)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            DispatchQueue.main.async {
                loader.shareInstance.hideLoading()
            }

            switch response.result {
            case .success(let jsonResponse):
                guard let resultDict = jsonResponse as? [String: Any], let status = resultDict["status"] as? Bool else {
                    print("Invalid response format")
                    return
                }

                if status {
                    self.isImage = 0
                    if currentUser.result?.mobile != self.mobileTF.text {
                        isComeFromProfile = 1
                        if let result = resultDict["data"] as? Parameters {
                            let vc = storyBoard.instantiateViewController(withIdentifier: CONTROLLERNAMES.KTBOTPVC) as! TBOTPVC
                            vc.dict = result
                            DispatchQueue.main.async {
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    } else {
                        currentUser = User(dictionary: resultDict as NSDictionary)
                        TBSharedPreference.sharedIntance.setUserData(currentUser)
                        DispatchQueue.main.async {
                            self.addAlert(appName, message: ALERTS.KProfileUpdate, buttonTitle: ALERTS.kAlertOK)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    let message = resultDict["message"] as? String ?? "Error updating profile"
                    DispatchQueue.main.async {
                        self.addAlert(appName, message: message, buttonTitle: ALERTS.kAlertOK)
                    }
                }

            case .failure(let error):
                print("Upload failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        if urlError.code == .notConnectedToInternet {
                            self.addAlert(appName, message: ALERTS.kNoInterNetConnection, buttonTitle: ALERTS.kAlertOK)
                        } else if urlError.code == .timedOut {
                            self.addAlert(appName, message: "Connection timed out", buttonTitle: ALERTS.kAlertOK)
                        }
                    }
                }
            }
        }
    }

}

//MARK:- UITextField Delegates.
extension TBProfileVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTf {
            emailTF.becomeFirstResponder()
        }else if textField == emailTF {
            mobileTF.becomeFirstResponder()
        }else if textField == mobileTF {
            textField.resignFirstResponder()
        }else {
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == mobileTF {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 10
        }else {
            return true
        }
    }
}

//MARK:- UITextView Delegates.
extension TBProfileVC : UITextViewDelegate {
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (aboutTV.text as NSString).replacingCharacters(in: range, with: text)
//        let numberOfChars = newText.count
//        return numberOfChars < 200
//    }
}

//MARK:- UIImagePicker Delegates.
extension TBProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    func PhotoFormCamera()  {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.allowsEditing = true
            controller.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? [String]()
            controller.delegate = self
            if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
                OperationQueue.main.addOperation({() -> Void in
                    self.present(controller, animated: true)
                })
            }else {
                present(controller, animated: true)
            }
        } 
    }
    
    //MARK:- Picking image Form PhotoLibrary.
    func PhotoFromPhotoAlbum()  {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let controller = UIImagePickerController()
            controller.sourceType = .savedPhotosAlbum
            controller.allowsEditing = true
            controller.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? [String]()
            controller.delegate = self
            if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
                OperationQueue.main.addOperation({() -> Void in
                    self.present(controller, animated: true)
                })
            }else {
                present(controller, animated: true) 
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            updateImage = img
        } else {
        updateImage = (info[UIImagePickerControllerOriginalImage] as! UIImage).resizeToWidth(250)
        }
       // updateImage = (info[UIImagePickerControllerOriginalImage] as! UIImage).resizeToWidth(250)
        profileImageView.image = updateImage
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.contentMode = .scaleToFill
        profileImageView.clipsToBounds = true
        if profileImageView.image == updateImage {
            isImage = 1
        }
    }
}

