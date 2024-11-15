//
//  PremiumData.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 30/01/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import Foundation
//MARK:- DICTIONARY VALIDATION
//extension Dictionary {
//
//    func validatedValue (_ key:Key) -> String{
//        if let object = self[key] as? AnyObject{
//            if object is NSNull{
//                // if key not exist or key contain NSNull
//                return ""
//            }
//            else if ((object as? String == "null") || (object as? String == "<null>") || (object as? String == "(null)") || (object as? String == "nil") || (object as? String == "Nil")) {
//                //logInfo("null string")
//                return ""
//            }else{
//                return "\(object)"
//            }
//        }else{
//            return ""
//        }
//    }
//
//    func ArrayofDict (_ key:Key) -> Array<Dictionary<String,Any>>{
//        if let object = self[key] as? AnyObject{
//            if object is NSNull{
//                // if key not exist or key contain NSNull
//                return []
//            }
//            else if object.count == 0{
//                //logInfo("null string")
//                return []
//            }else{
//                return object as? Array<Dictionary<String,Any>> ?? []
//            }
//        }else{
//            return []
//        }
//    }
//}

//extension NSDictionary{
//    func valueforKey (_ key:Key) -> String{
//        if let object = self[key] as? AnyObject{
//            if object is NSNull{
//                // if key not exist or key contain NSNull
//                return ""
//            }
//            else if ((object as? String == "null") || (object as? String == "<null>") || (object as? String == "(null)") || (object as? String == "nil") || (object as? String == "Nil")) {
//                //logInfo("null string")
//                return ""
//            }else{
//                return "\(object)"
//            }
//        }else{
//            return ""
//        }
//    }
//
//    func ArrayofDict (_ key:Key) -> Array<Dictionary<String,Any>>{
//        if let object = self[key] as? AnyObject{
//            if object is NSNull{
//                // if key not exist or key contain NSNull
//                return []
//            }
//            else if object.count == 0{
//                //logInfo("null string")
//                return []
//            }else{
//                return object as? Array<Dictionary<String,Any>> ?? []
//            }
//        }else{
//            return []
//        }
//    }
//
//
//
//
//
//
//}


class PremiumDataModel{
    
    var season_id: String?
    var season_title: String?
    var season_thumbnail: String?
    var short_video: String?
    var promo_video: String?
    var yt_promo_video: String?
    var episode_details : [episode_detail_Model] = []
    
    var description: String?
    var short_desc: String?
    
    init(dict:Dictionary<String,Any>) {
        self.season_id = dict.validatedValue("season_id")
        self.season_title = dict.validatedValue("season_title")
        self.season_thumbnail = dict.validatedValue("season_thumbnail")
        self.short_video = dict.validatedValue("short_video")
        self.promo_video = dict.validatedValue("promo_video")
        self.yt_promo_video = dict.validatedValue("yt_promo_video")

        self.description = dict.validatedValue("description")
        self.short_desc = dict.validatedValue("short_desc")

        
        let data = dict.ArrayofDict("episode_details")
        _ = data.filter{(dictData) -> Bool in
            self.episode_details.append(episode_detail_Model(dict:(dictData as NSDictionary) as! Dictionary<String, Any>))
            return true
        }
        
    }
}

class bhagwatGeetaModel{
    
    var season_id: String?
    var season_title: String?
    var season_thumbnail: String?
    var short_video: String?
    var promo_video: String?
    var yt_promo_video: String?
    var episode_details : [episode_detail_Model] = []
    
    
    init(dict:Dictionary<String,Any>) {
        self.season_id = dict.validatedValue("season_id")
        self.season_title = dict.validatedValue("season_title")
        self.season_thumbnail = dict.validatedValue("season_thumbnail")
        self.short_video = dict.validatedValue("short_video")
        self.promo_video = dict.validatedValue("promo_video")
        self.yt_promo_video = dict.validatedValue("yt_promo_video")
        
        
        let data = dict.ArrayofDict("episode_details")
        _ = data.filter{(dictData) -> Bool in
            self.episode_details.append(episode_detail_Model(dict:(dictData as NSDictionary) as! Dictionary<String, Any>))
            return true
        }
        
    }
}


class episode_detail_Model{
    var id: String?
    var episode_title: String?
    var thumbnail_url: String?
    var episode_url: String?
    var yt_episode_url: String?
    var status: String?
    var season_title: String?
    
    
    var season_id: String?
    var episode_id: String?
    var is_locked: String?
    var episode_description: String?
    
    
    var description: String?
    var season_thumbnail: String?
    var short_video: String?
    var yt_short_video: String?
    var promo_video: String?
    var yt_promo_video: String?
    var author_id: String?
    var author_name: String?
    
    
    init(dict:Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.episode_title = dict.validatedValue("episode_title")
        self.thumbnail_url = dict.validatedValue("thumbnail_url")
        self.episode_url = dict.validatedValue("episode_url")
        self.yt_episode_url = dict.validatedValue("yt_episode_url")
        self.status = dict.validatedValue("status")
        self.season_title = dict.validatedValue("season_title")
        
        self.season_id = dict.validatedValue("season_id")
        self.episode_id = dict.validatedValue("episode_id")
        self.is_locked = dict.validatedValue("is_locked")
        self.episode_description = dict.validatedValue("episode_description")


        self.description = dict.validatedValue("description")
        self.season_thumbnail = dict.validatedValue("season_thumbnail")
        self.short_video = dict.validatedValue("short_video")
        self.short_video = dict.validatedValue("short_video")
        self.yt_short_video = dict.validatedValue("yt_short_video")
        self.promo_video = dict.validatedValue("promo_video")
        self.yt_promo_video = dict.validatedValue("yt_promo_video")
        self.author_id = dict.validatedValue("author_id")
        self.author_name = dict.validatedValue("author_name")

    }
}
//class categoryOneModel{
//    
//   var id: String
//   var season_title: String
//   var season_thumbnail: String
//   var short_video: String
//   var promo_video: String
//   var yt_promo_video: String
//   var author_id: String
//   var author_name: String
//    
//    init(dict:Dictionary<String,Any>) {
//        self.id = dict.validatedValue("id")
//        self.season_title = dict.validatedValue("season_title")
//        self.season_thumbnail = dict.validatedValue("season_thumbnail")
//        self.short_video = dict.validatedValue("short_video")
//        self.promo_video = dict.validatedValue("promo_video")
//        self.yt_promo_video = dict.validatedValue("yt_promo_video")
//        self.author_id = dict.validatedValue("author_id")
//        self.author_name = dict.validatedValue("author_name")
//    }
//}



