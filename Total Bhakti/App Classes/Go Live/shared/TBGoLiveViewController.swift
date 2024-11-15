//
//  TBGoLiveViewController.swift
//  Total Bhakti
//
//  Created by MAC MINI on 15/05/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
import WowzaGoCoderSDK


class TBGoLiveViewController: TBInternetViewController , WZStatusCallback, WZVideoSink, WZAudioSink {
   
    //MARK:- Variables.
    let SDKSampleSavedConfigKey = "SDKSampleSavedConfigKey"
    let SDKSampleAppLicenseKey = "GOSK-AD45-010C-BDBC-56F0-9015"
    let BlackAndWhiteEffectKey = "BlackAndWhiteKey"
    
    
    var goCoder:WowzaGoCoder?
    var goCoderConfig:WowzaConfig!
    var receivedGoCoderEventCodes = Array<WZEvent>()
    var blackAndWhiteVideoEffect = false
    var goCoderRegistrationChecked = false
    
    //MARK:- IBOutlets.
    @IBOutlet weak var broadcastButton    :  UIButton!
    @IBOutlet weak var settingsButton     :  UIButton!
    @IBOutlet weak var switchCameraButton :  UIButton!
    @IBOutlet weak var torchButton        :  UIButton!
    @IBOutlet weak var micButton          :  UIButton!
   
    @IBOutlet weak var headerView: UIView!
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

      // goCoderConfig?.hostAddress? = "52.66.203.146"
        
        goCoderConfig?.hostAddress = "52.66.203.146"
        goCoderConfig?.applicationName? = "live"
        goCoderConfig?.streamName? = "bhakti"
        goCoderConfig?.username? = "zeekkm@gmail.com"
        goCoderConfig?.password? = "Mktmkt@123"

        blackAndWhiteVideoEffect = UserDefaults.standard.bool(forKey: BlackAndWhiteEffectKey)
        WowzaGoCoder.setLogLevel(.default)
    
        
       // goCoderConfig? = (goCoder?.config)!
        
        
        
        if let savedConfig:Data = UserDefaults.standard.object(forKey: SDKSampleSavedConfigKey) as? Data {
            if let wowzaConfig = NSKeyedUnarchiver.unarchiveObject(with: savedConfig) as? WowzaConfig {
                goCoderConfig = wowzaConfig
            }
            else {
                goCoderConfig = WowzaConfig()
            }
        }
        else {
            goCoderConfig = WowzaConfig()
        }
         
        // Log version and platform info
        print("WowzaGoCoderSDK version =\n major: \(WZVersionInfo.majorVersion())\n minor: \(WZVersionInfo.minorVersion())\n revision: \(WZVersionInfo.revision())\n build: \(WZVersionInfo.buildNumber())\n string: \(WZVersionInfo.string())\n verbose string: \(WZVersionInfo.verboseString())")
        
        print("Platform Info:\n\(WZPlatformInfo.string())")
        if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(SDKSampleAppLicenseKey) {
          
             self.showAlert("GoCoder SDK Licensing Error", error: goCoderLicensingError as NSError)
        }
        // Do any additional setup after loading the view.
    }
    
      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let savedConfigData = NSKeyedArchiver.archivedData(withRootObject: goCoderConfig)
        UserDefaults.standard.set(savedConfigData, forKey: SDKSampleSavedConfigKey)
        UserDefaults.standard.synchronize()
        
        // Update the configuration settings in the GoCoder SDK
        if (goCoder != nil) {
            goCoder?.config = goCoderConfig
            blackAndWhiteVideoEffect = UserDefaults.standard.bool(forKey: BlackAndWhiteKey)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        goCoder?.cameraPreview?.previewLayer?.frame = view.bounds
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !goCoderRegistrationChecked {
            goCoderRegistrationChecked = true
            if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(SDKSampleAppLicenseKey) {
                self.showAlert("GoCoder SDK Licensing Error", error: goCoderLicensingError as NSError)
            }
            else {
                // Initialize the GoCoder SDK
                if let goCoder = WowzaGoCoder.sharedInstance() {
                    self.goCoder = goCoder
                    
                    // Request camera and microphone permissions
                    WowzaGoCoder.requestPermission(for: .camera, response: { (permission) in
                        print("Camera permission is: \(permission == .authorized ? "authorized" : "denied")")
                    })
                    
                    WowzaGoCoder.requestPermission(for: .microphone, response: { (permission) in
                        print("Microphone permission is: \(permission == .authorized ? "authorized" : "denied")")
                    })
                    self.goCoder?.register(self as WZAudioSink)
                    self.goCoder?.register(self as WZVideoSink)
                    self.goCoder?.config = self.goCoderConfig
                    
                    // Specify the view in which to display the camera preview
                    self.goCoder?.cameraView = self.view
                    
                    // Start the camera preview
                    self.goCoder?.cameraPreview?.start()
                }
                self.updateUIControls()
                
            }
        }
    }
    
    override var prefersStatusBarHidden:Bool {
        return true
    }


    //MARK:- ScreenBtn Actions.
    @IBAction func screenBtnAction (_ sender : UIButton) {
        switch sender.tag {
        case 10://boradCastbtn Tapped
        
            //goCoderConfig.hostAddress = "52.66.203.146"
           // goCoderConfig.ho
            // Ensure the minimum set of configuration settings have been specified necessary to
            // initiate a broadcast streaming session
            if let configError = goCoder?.config.validateForBroadcast() {
                self.showAlert("Incomplete Streaming Settings", error: configError as NSError)
            }
            else {
                // Disable the U/I controls
                broadcastButton.isEnabled    = false
                torchButton.isEnabled        = false
                switchCameraButton.isEnabled = false
                settingsButton.isEnabled     = false
                
                if goCoder?.status.state == .running {
                    goCoder?.endStreaming(self)
                }
                else {
                    receivedGoCoderEventCodes.removeAll()
                    goCoder?.startStreaming(self)
                    let audioMuted = goCoder?.isAudioMuted ?? false
                    micButton.setImage(UIImage(named: audioMuted ? "mic_off_button" : "mic_on_button"), for: UIControlState())
                }
            }
            
        case 20: //swichCamera.
        if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
            if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
                goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
                goCoder?.config = goCoderConfig
            }
            
            goCoder?.cameraPreview?.switchCamera()
            torchButton.setImage(UIImage(named: "torch_on_button"), for: UIControlState())
            self.updateUIControls()
            }
            
        case 30://did Tap on torchBtn.
            var newTorchState = goCoder?.cameraPreview?.camera?.isTorchOn ?? true
            newTorchState = !newTorchState
            goCoder?.cameraPreview?.camera?.isTorchOn = newTorchState
            torchButton.setImage(UIImage(named: newTorchState ? "torch_off_button" : "torch_on_button"), for: UIControlState())
            
        case 40://did tap on mic Btn
            var newMutedState = self.goCoder?.isAudioMuted ?? true
            newMutedState = !newMutedState
            goCoder?.isAudioMuted = newMutedState
            micButton.setImage(UIImage(named: newMutedState ? "mic_off_button" : "mic_on_button"), for: UIControlState())
            
        case 50://didTapON settingBtn
            if let settingsNavigationController = UIStoryboard(name: "AppSettings", bundle: nil).instantiateViewController(withIdentifier: "settingsNavigationController") as? UINavigationController {
                
                if let settingsViewController = settingsNavigationController.topViewController as? SettingsViewController {
                    settingsViewController.addAllSections()
                    settingsViewController.removeDisplay(.recordVideoLocally)
                    settingsViewController.removeDisplay(.backgroundMode)
                    let viewModel = SettingsViewModel(sessionConfig: goCoderConfig)
                    viewModel?.supportedPresetConfigs = goCoder?.cameraPreview?.camera?.supportedPresetConfigs
                    settingsViewController.viewModel = viewModel!
                }
                
                
                self.present(settingsNavigationController, animated: true, completion: nil)
            }
            
        case 100://backBtn
            _ = navigationController?.popViewController(animated: true)
        default:
            break
        }
        
    }
    
    func updateUIControls() {
        if self.goCoder?.status.state != .idle && self.goCoder?.status.state != .running {
            // If a streaming broadcast session is in the process of starting up or shutting down,
            // disable the UI controls
            self.broadcastButton.isEnabled    = false
            self.torchButton.isEnabled        = false
            self.switchCameraButton.isEnabled = false
            self.settingsButton.isEnabled     = false
            self.micButton.isHidden           = true
            self.micButton.isEnabled          = false
        }
        else {
            // Set the UI control state based on the streaming broadcast status, configuration,
            // and device capability
            self.broadcastButton.isEnabled    = true
            self.switchCameraButton.isEnabled = ((self.goCoder?.cameraPreview?.cameras?.count) ?? 0) > 1
            self.torchButton.isEnabled        = self.goCoder?.cameraPreview?.camera?.hasTorch ?? false
            let isStreaming                   = self.goCoder?.isStreaming ?? false
            self.settingsButton.isEnabled     = !isStreaming
            // The mic icon should only be displayed while streaming and audio streaming has been enabled
            // in the GoCoder SDK configuration setiings
            self.micButton.isEnabled          = isStreaming && self.goCoderConfig.audioEnabled
            self.micButton.isHidden           = !self.micButton.isEnabled
        }
    }
    
    //MARK: - WZStatusCallback Protocol Instance Methods
    
    func onWZStatus(_ status: WZStatus!) {
        switch (status.state) {
        case .idle:
            DispatchQueue.main.async { () -> Void in
                self.broadcastButton.setImage(UIImage(named: "start_button"), for: UIControlState())
                self.updateUIControls()
            }
            
        case .running:
            DispatchQueue.main.async { () -> Void in
                self.broadcastButton.setImage(UIImage(named: "stop_button"), for: UIControlState())
                self.updateUIControls()
            }
        case .stopping, .starting:
            DispatchQueue.main.async { () -> Void in
                self.updateUIControls()
            }
            
        case .buffering: break
        default: break
        }
    }

    
    func onWZEvent(_ status: WZStatus!) {
        // If an event is reported by the GoCoder SDK, display an alert dialog describing the event,
        // but only if we haven't already shown an alert for this event
        
        DispatchQueue.main.async { () -> Void in
            if !self.receivedGoCoderEventCodes.contains(status.event) {
                self.receivedGoCoderEventCodes.append(status.event)
               // self.addAlert("Live Streaming Event", message: status as! String, buttonTitle: ALERTS.kAlertOK)
              //  self.showAlert("Live Streaming Event", status: status)
            }
            
            self.updateUIControls()
        }
    }
  
    func onWZError(_ status: WZStatus!) {
        // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
        DispatchQueue.main.async { () -> Void in
            self.showAlert("Live Streaming Error", status: status)
            self.updateUIControls()
        }
    }

    
    //MARK: - WZVideoSink Protocol Methods
    
    func videoFrameWasCaptured(_ imageBuffer: CVImageBuffer, framePresentationTime: CMTime, frameDuration: CMTime) {
        if goCoder != nil && goCoder!.isStreaming && blackAndWhiteVideoEffect {
            // convert frame to b/w using CoreImage tonal filter
            var frameImage = CIImage(cvImageBuffer: imageBuffer)
            if let grayFilter = CIFilter(name: "CIPhotoEffectTonal") {
                grayFilter.setValue(frameImage, forKeyPath: "inputImage")
                if let outImage = grayFilter.outputImage {
                    frameImage = outImage
                    
                    let context = CIContext(options: nil)
                    context.render(frameImage, to: imageBuffer)
                }
                
            }
        }
    }
    
    func videoCaptureInterruptionStarted() {
        goCoder?.endStreaming(self)
    }
    
    
    //MARK: - WZAudioSink Protocol Methods
    
    func audioLevelDidChange(_ level: Float) {
        //        print("Audio level did change: \(level)");
    }
    
    
    //MARK: - Alerts
    
    func showAlert(_ title:String, status:WZStatus) {
        let alertController = UIAlertController(title: title, message: status.description, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(_ title:String, error:NSError) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
  

}
