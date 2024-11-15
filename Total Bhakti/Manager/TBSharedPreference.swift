//
//  TBSharedPreference.swift
//  Total Bhakti
//
//  Created by Prashant on 23/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class TBSharedPreference : NSObject {
    class var sharedIntance : TBSharedPreference {
        struct Static {
            static let intance = TBSharedPreference()
        }
        return Static.intance
    }
    
    let sharedPreference =  UserDefaults.standard
    
    //MARK:- Clear All User Data.
    func clearAllPreference(){
        if let bundle = Bundle.main.bundleIdentifier {
            sharedPreference.removePersistentDomain(forName: bundle)
        }
    }
    
    //MARK:- Setter Methods
    func setLoginStatus(_ status : Bool) {
        sharedPreference.set(status, forKey: "userLoggedIn")
    }
    
    func setUserData(_ userData : User)  {
        sharedPreference.set(userData.dictionaryRepresentation(), forKey: "userData")
    }
    
    func setUserPlaylist(_ playlistArr : NSArray) {
        sharedPreference.set(playlistArr, forKey: "playlistArr")
    }
    
    //MARK:- Getter Methods.
    func getLoginStatue() -> Bool? {
        return sharedPreference.value(forKey: "userLoggedIn") as? Bool
    }
    
    func getUserData() -> NSDictionary? {
        return sharedPreference.value(forKey: "userData") as? NSDictionary
    }
    func getvideoData() -> NSDictionary? {
        return sharedPreference.value(forKey: "videoData") as? NSDictionary
    }
    
    func getplaylist() ->  NSArray? {
        return sharedPreference.value(forKey: "playlistArr") as? NSArray
    }
}



