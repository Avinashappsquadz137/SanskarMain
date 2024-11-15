//
//  loader.swift
//  Total Bhakti
//  Created by MAC MINI on 12/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit
class loader : NSObject {
    class var shareInstance: loader {
        struct Static {
            static let instance = loader()
        }
        return Static.instance
    }
     var myView = UIView()
      var bgView = UIView()
     var loadingImageView = UIImageView()
    
    func showLoading(_ view : UIView)  {
        myView.frame = CGRect(x: 0, y: 0, width: AppConstant.KSCREENSIZE.width, height: AppConstant.KSCREENSIZE.height)
        myView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30)
        bgView.frame = CGRect(x: 0, y: 0, width: 95, height: 95)
        bgView.center = myView.center
        bgView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.85)
        bgView.layer.cornerRadius = 10.0
//        bgView.backgroundColor = UIColor.clear
        loadingImageView.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
        loadingImageView.center = myView.center
        loadingImageView.loadGif(name: "Total_bhakti_logo_gif1")
        view.addSubview(myView)
        view.addSubview(bgView)
        view.addSubview(loadingImageView)
        
    }
    
    func hideLoading() {
      myView.removeFromSuperview()
        bgView.removeFromSuperview()
      loadingImageView.removeFromSuperview()
    }
    
}


fileprivate var aView : UIView?
extension UIViewController{
    
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
}
