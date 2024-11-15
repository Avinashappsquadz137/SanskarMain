//
//  DataModel.swift
//  Rendate

//  Created by mac on 28/07/20.
//  Copyright © 2020 mac. All rights reserved.
//


import Foundation




//MARK:- DICTIONARY VALIDATION
extension Dictionary {
    
    func validatedValue (_ key:Key) -> String{
        if let object = self[key] as? AnyObject{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return ""
            }
            else if ((object as? String == "null") || (object as? String == "<null>") || (object as? String == "(null)") || (object as? String == "nil") || (object as? String == "Nil")) {
                //logInfo("null string")
                return ""
            }else{
                return "\(object)"
            }
        }else{
            return ""
        }
    }
    
    func ArrayofDict (_ key:Key) -> Array<Dictionary<String,Any>>{
        if let object = self[key] as? AnyObject{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return []
            }
            else if object.count == 0{
                //logInfo("null string")
                return []
            }else{
                return object as? Array<Dictionary<String,Any>> ?? []
            }
        }else{
            return []
        }
    }
}

extension NSDictionary{
    func valueforKey (_ key:Key) -> String{
        if let object = self[key] as? AnyObject{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return ""
            }
            else if ((object as? String == "null") || (object as? String == "<null>") || (object as? String == "(null)") || (object as? String == "nil") || (object as? String == "Nil")) {
                //logInfo("null string")
                return ""
            }else{
                return "\(object)"
            }
        }else{
            return ""
        }
    }
    
    func ArrayofDict (_ key:Key) -> Array<Dictionary<String,Any>>{
        if let object = self[key] as? AnyObject{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return []
            }
            else if object.count == 0{
                //logInfo("null string")
                return []
            }else{
                return object as? Array<Dictionary<String,Any>> ?? []
            }
        }else{
            return []
        }
    }
    





}
// MARK: - ConvertToString
func ConvertToString(date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.string(from: date)
    
}


class YoutubeModel{
    
    var id:String?
    var mobile_menu_ids:String?
    var android_tv_ids:String?
    var video_title:String?
    var video_url:String?
    var author_name:String?
    var thumbnail_url:String?
    var thumbnail_url1:String?
    var video_desc:String?
    var category:String?
    var is_sankirtan:String?
    var is_popular:String?
    var related_guru:String?
    var author_image:String?
    var comments:String?
    var views:String?
    var likes:String?
    var tags:String?
    var published_date:String?
    var creation_time:String?
    var status:String?
    var youtube_url:String?
    var youtube_views:String?
    var youtube_likes:String?
    var uploaded_by:String?
    var deleted_by:String?
    var is_like:String?
    
    init(dict:Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.mobile_menu_ids = dict.validatedValue("mobile_menu_ids")
        self.android_tv_ids = dict.validatedValue("android_tv_ids")
        self.video_title = dict.validatedValue("video_title")
        self.video_url = dict.validatedValue("video_url")
        self.author_name = dict.validatedValue("author_name")
        self.thumbnail_url = dict.validatedValue("thumbnail_url")
        self.thumbnail_url1 = dict.validatedValue("thumbnail_url1")
        self.video_desc = dict.validatedValue("video_desc")
        self.category = dict.validatedValue("category")
        self.is_sankirtan = dict.validatedValue("is_sankirtan")
        self.is_popular = dict.validatedValue("is_popular")
        self.related_guru = dict.validatedValue("related_guru")
        self.author_image = dict.validatedValue("author_image")
        self.comments = dict.validatedValue("comments")
        self.views = dict.validatedValue("views")
        self.likes = dict.validatedValue("likes")
        self.tags = dict.validatedValue("tags")
        self.published_date = dict.validatedValue("published_date")
        self.creation_time = dict.validatedValue("creation_time")
        self.status = dict.validatedValue("status")
        self.youtube_url = dict.validatedValue("youtube_url")
        self.youtube_views = dict.validatedValue("youtube_views")
        self.youtube_likes = dict.validatedValue("youtube_likes")
        self.deleted_by = dict.validatedValue("deleted_by")
        self.is_like = dict.validatedValue("is_like")
    }
}

class AdModel{
    
    var status: String?
    var message: String?
    var live_tv: [live_tvModel] = []
    var video: [live_tvModel] = []
    var bhajan: [live_tvModel] = []
    
    init(dict:Dictionary<String,Any>) {
        
        let data = dict.ArrayofDict("live_tv")
        _ = data.filter{(dictData) -> Bool in
            self.live_tv.append(live_tvModel(dict:(dictData as NSDictionary) as! Dictionary<String, Any>))
            return true
        }
//        let data = dict.ArrayofDict("video")
//        _ = data.filter{(dictData) -> Bool in
//            self.video.append(live_tvModel(dict:(dictData as NSDictionary) as! Dictionary<String, Any>))
//            return true
//        }
//        let data = dict.ArrayofDict("live_tv")
//        _ = data.filter{(dictData) -> Bool in
//            self.live_tv.append(live_tvModel(dict:(dictData as NSDictionary) as! Dictionary<String, Any>))
//            return true
//        }
    }
}

class live_tvModel{
    
    var id: String?
    var category: String?
    var title: String?
    var media_type: String?
    var media: String?
    var gap_duration:String?
    
    init(dict:Dictionary<String,Any>) {

        self.id = dict.validatedValue("id")
        self.category = dict.validatedValue("category")
        self.title = dict.validatedValue("title")
        self.media_type = dict.validatedValue("media_type")
        self.media = dict.validatedValue("media")
        self.gap_duration = dict.validatedValue("gap_duration")
    }

}

class CategoryModel{
    
    var id :String
    var menu_title:String
    var premium_cat_id: String
    var premium_auth_id: String
    var menu_type_id:String
    var type:String
    var web_view_bhajan: String
    var web_view_news: String
    var web_view_video: String
    var videoList : [videosResult] = []
    var bhajanList : [Bhajan] = []
    var channelList : [channelModel] = []
    var shortslist : [shortsmodel] = []
    var guruList : [guruData] = []
    var newList : [News] = []
    var seasonList : [freeModel] = []
    var freeList: [freeModel] = []
    var catwise: [freeModel] = []
    var authwise: [freeModel] = []
    var promotionList: [freeModel] = []
    var trendingVideoList: [videosResult] = []
    var trendingBhajanList: [trendingBhajanModel] = []
    var seasonwatchmorelist: [seasonmoreepisodemodel] = []

    
    
    init(dict:Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.menu_title = dict.validatedValue("menu_title")
        self.premium_cat_id = dict.validatedValue("premium_cat_id")
        self.premium_auth_id = dict.validatedValue("premium_auth_id")
        self.menu_type_id = dict.validatedValue("menu_type_id")
        self.type =  dict.validatedValue("type")
        self.web_view_bhajan =  dict.validatedValue("web_view_bhajan")
        self.web_view_news =  dict.validatedValue("web_view_news")
        self.web_view_video =  dict.validatedValue("web_view_video")

        
        if  type == "video"{
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.videoList.append(videosResult(dictionary:dictData as NSDictionary)!)
                return true
            }
        }
        
        if  type == "bhajan"{
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.bhajanList.append(Bhajan(dictionary:dictData as NSDictionary)!)
                return true
            }
        }
        
        if type == "channel"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.channelList.append(channelModel(dict:dictData))
                return true
            }

            channelTableArr = channelList
         }
        
        if type == "guru"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.guruList.append(guruData(dictionary:dictData as NSDictionary)!)
                return true
            }

         }
        
        if type == "news"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.newList.append(News(dictionary:dictData as NSDictionary)!)
                return true
            }

         }
        
        if type == "season"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.seasonList.append(freeModel(dict:dictData))
                return true
            }

         }
        
        if type == "author wise season"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.authwise.append(freeModel(dict:dictData))
                return true
            }

         }
        
        if type == "category wise season"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.catwise.append(freeModel(dict:dictData))
                return true
            }

         }
        
        if type == "promotion"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.promotionList.append(freeModel(dict:dictData))
                return true
            }

         }
        
        if type == "free"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.freeList.append(freeModel(dict:dictData))
                return true
            }

         }
        
        if type == "trending video"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.trendingVideoList.append(videosResult(dictionary:dictData as NSDictionary)!)
                return true
            }

         }
        if type == "shorts"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.shortslist.append(shortsmodel(dict:(dictData as NSDictionary) as! Dictionary<String, Any>))
                return true
            }

         }
        
        if type == "trending bhajan"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.trendingBhajanList.append(trendingBhajanModel(dict:dictData))
                return true
            }
         }
        if type == "continue watching"{
            
            let data = dict.ArrayofDict("list")
            _ = data.filter{(dictData) -> Bool in
                self.videoList.append(videosResult(dictionary:dictData as NSDictionary)!)
                return true
            }
         }
}
}

class guruModel{
    
    var id: String
    var name: String
    var profile_image: String
    var banner_image: String
    var descript: String
    var followers_count: String
    var likes_count: String
    var creation_time: String
    var published_date: String
    var status: String
    
    
    
    init(dict:Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.name = dict.validatedValue("name")
        self.profile_image = dict.validatedValue("profile_image")
        self.banner_image = dict.validatedValue("banner_image")
        self.descript = dict.validatedValue("description")
        self.followers_count = dict.validatedValue("followers_count")
        self.likes_count = dict.validatedValue("likes_count")
        self.creation_time = dict.validatedValue("creation_time")
        self.published_date = dict.validatedValue("published_date")
        self.status = dict.validatedValue("status")
        
    }
}

class newsModel{
        var shortDesc: String
        var descrip: String
        var id: String
        var title: String
        var image: String
        var views_count: String
        var status: String
    var creation_time: String
    var published_date: String
    
        init(dict:Dictionary<String,Any>) {
            self.shortDesc = dict.validatedValue("shortDesc")
            self.descrip = dict.validatedValue("description")
            self.id = dict.validatedValue("id")
            self.title = dict.validatedValue("title")
            self.image = dict.validatedValue("image")
            self.views_count = dict.validatedValue("views_count")
            self.status = dict.validatedValue("status")
            self.creation_time = dict.validatedValue("creation_time")
            self.published_date = dict.validatedValue("published_date")

        }
    }
    
class bhajanModel{
    
    var id: String?
    var title: String?
    var descript: String?
    var image: String?
    var thumbnail1: String?
    var thumbnail2: String?
    var media_file: String?
    var artist_name: String?
    var artist_image: String?
    var mobile_menu_ids: String?
    var category: String?
    var related_guru: String?
    var artists_id: String?
    var god_id: String?
    var god_name: String?
    var god_image: String?
    var likes: String?
    var creation_time: String?
    var published_date: String?
    var status: String?
    var uploaded_by: String?
    var direct_play: String?
    var is_like: String?

    init(dict:Dictionary<String,Any>){
        self.id = dict.validatedValue("id")
        self.title = dict.validatedValue("title")
        self.descript = dict.validatedValue("description")
        self.image = dict.validatedValue("image")
        self.thumbnail1 = dict.validatedValue("thumbnail1")
        self.thumbnail2 = dict.validatedValue("thumbnail2")
        self.media_file = dict.validatedValue("media_file")
        self.artist_name = dict.validatedValue("artist_name")
        self.artist_image = dict.validatedValue("artist_image")
        self.mobile_menu_ids = dict.validatedValue("mobile_menu_ids")
        self.category = dict.validatedValue("category")
        self.related_guru = dict.validatedValue("related_guru")
        self.artists_id = dict.validatedValue("artists_id")
        self.god_id = dict.validatedValue("god_id")
        self.god_name = dict.validatedValue("god_name")
        self.god_image = dict.validatedValue("god_image")
        self.likes = dict.validatedValue("likes")
        self.creation_time = dict.validatedValue("creation_time")
        self.published_date = dict.validatedValue("published_date")
        self.status = dict.validatedValue("status")
        self.uploaded_by = dict.validatedValue("uploaded_by")
        self.direct_play = dict.validatedValue("direct_play")
        self.is_like = dict.validatedValue("is_like")
    }
    
    
}
class videoModel{
    
    var id :String
    var video_title :String
    var video_url :String
    var author_name :String
    var thumbnail_url :String
    var thumbnail_url1 :String
    var video_desc :String
    var category :String
    var is_sankirtan :String
    var is_popular :String
    var related_guru :String
    var author_image :String
    var comments :String
    var views :String
    var likes :String
    var tags :String
    var published_date :String
    var creation_time :String
    var status :String
    var youtube_url :String
    var uploaded_by :String
    var is_like : String
    
    init(dict:Dictionary<String,Any>) {
        
        self.id  = dict.validatedValue("id")
        self.video_title  = dict.validatedValue("video_title")
        self.video_url  = dict.validatedValue("video_url")
        self.author_name  = dict.validatedValue("author_name")
        self.thumbnail_url  = dict.validatedValue("thumbnail_url")
        self.thumbnail_url1  = dict.validatedValue("thumbnail_url1")
        self.video_desc  = dict.validatedValue("video_desc")
        self.category  = dict.validatedValue("category")
        self.is_sankirtan  = dict.validatedValue("is_sankirtan")
        self.is_popular  = dict.validatedValue("is_popular")
        self.related_guru  = dict.validatedValue("related_guru")
        self.author_image  = dict.validatedValue("author_image")
        self.comments  = dict.validatedValue("comments")
        self.views  = dict.validatedValue("views")
        self.likes  = dict.validatedValue("likes")
        self.tags  = dict.validatedValue("tags")
        self.published_date  = dict.validatedValue("published_date")
        self.creation_time  = dict.validatedValue("creation_time")
        self.status  = dict.validatedValue("status")
        self.youtube_url  = dict.validatedValue("youtube_url")
        self.uploaded_by  = dict.validatedValue("uploaded_by")
        
        self.is_like  = dict.validatedValue("is_like")
    }
    
}

class channelModel{
    
    var id : String
    var name: String
    var descript: String
    var channel_url: String?
    var image: String?
    var likes: String
    var live_users: String
    var creation_time: String
    var published_date: String
    var status: String
    var is_likes : String
    var isSelected: Bool
    init(dict:Dictionary<String,Any>) {
        self.id  = dict.validatedValue("id")
        self.name = dict.validatedValue("name")
        self.descript = dict.validatedValue("description")
        self.channel_url = dict.validatedValue("channel_url")
        self.image = dict.validatedValue("image")
        self.likes = dict.validatedValue("likes")
        self.live_users = dict.validatedValue("live_users")
        self.creation_time = dict.validatedValue("creation_time")
        self.published_date = dict.validatedValue("published_date")
        
        self.status = dict.validatedValue("status")
        self.is_likes = dict.validatedValue("is_likes")
        self.isSelected = false

    }
}

class shortsmodel{
    
    var id : String
    var title: String
    var description: String
    var thumbnail: String?
    var videoUrl: String?
   
    init(dict:Dictionary<String,Any>) {
        self.id  = dict.validatedValue("id")
        self.title = dict.validatedValue("title")
        self.description = dict.validatedValue("description")
        self.thumbnail = dict.validatedValue("thumbnail")
        self.videoUrl = dict.validatedValue("videoUrl")
        
    }
}

class seasonModel{
    var promo_video : String
    var season_id : String
    var season_thumbnail : String
    var season_title : String
    var yt_promo_video : String
    
    init(dict:Dictionary<String,Any>) {
        self.promo_video = dict.validatedValue("promo_video")
        self.season_id = dict.validatedValue("season_id")
        self.season_thumbnail = dict.validatedValue("season_thumbnail")
        self.season_title = dict.validatedValue("season_title")
        self.yt_promo_video = dict.validatedValue("yt_promo_video")
        
    }
}

class promotionModel{
    var promo_video : String
    var season_id : String
    var season_thumbnail : String
    var season_title : String
    var yt_promo_video : String
    
    init(dict:Dictionary<String,Any>) {
        self.promo_video = dict.validatedValue("promo_video")
        self.season_id = dict.validatedValue("season_id")
        self.season_thumbnail = dict.validatedValue("season_thumbnail")
        self.season_title = dict.validatedValue("season_title")
        self.yt_promo_video = dict.validatedValue("yt_promo_video")
        
    }
}

class trendingVideoModel{
    var id: String?
    var video_title: String?
    var video_url: String?
    var author_name: String?
    var thumbnail_url: String?
    var thumbnail_url1: String?
    var video_desc: String?
    var mobile_menu_ids: String?
    var category: String?
    var is_sankirtan: String?
    var is_popular: String?
    var related_guru: String?
    var author_image: String?
    var comments: String?
    var views: String?
    var likes: String?
    var tags: String?
    var published_date: String?
    var creation_time: String?
    var status: String?
    var youtube_url: String?
    var uploaded_by: String?
    var is_like: String?
        
    init(dict:Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.video_title = dict.validatedValue("video_title")
        self.video_url = dict.validatedValue("video_url")
        self.author_name = dict.validatedValue("author_name")
        self.thumbnail_url = dict.validatedValue("thumbnail_url")
        self.thumbnail_url1 = dict.validatedValue("thumbnail_url1")
        self.video_desc = dict.validatedValue("video_desc")
        self.mobile_menu_ids = dict.validatedValue("mobile_menu_ids")
        self.category = dict.validatedValue("category")
        self.is_sankirtan = dict.validatedValue("is_sankirtan")
        self.is_popular = dict.validatedValue("is_popular")
        self.category = dict.validatedValue("category")
        self.related_guru = dict.validatedValue("category")
        self.author_image = dict.validatedValue("author_image")
        self.comments = dict.validatedValue("comments")
        self.views = dict.validatedValue("views")
        self.likes = dict.validatedValue("likes")
        self.tags = dict.validatedValue("tags")
        self.published_date = dict.validatedValue("published_date")
        self.creation_time = dict.validatedValue("creation_time")
        self.status = dict.validatedValue("status")
        self.youtube_url = dict.validatedValue("youtube_url")
        self.uploaded_by = dict.validatedValue("uploaded_by")
        self.is_like = dict.validatedValue("is_like")
    }
}

public class trendingBhajanModel{
    var id: String
    var title: String
    var descript: String
    var image: String
    var thumbnail1: String
    var thumbnail2: String
    var media_file: String
    var artist_name: String
    var artist_image: String
    var mobile_menu_ids: String
    var category: String
    var related_guru: String
    var artists_id: String
    var god_id: String
    var god_name: String
    var god_image: String
    var likes: String
    var creation_time: String
    var published_date: String
    var status: String
    var uploaded_by: String
    var direct_play: String
    var is_like: String
        
    //Universal Model
    var description: String?
    var deleted_by: String?
    
    var is_audio_playlist_exist: String?
    var play_count: String?
    init(dict:Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.title = dict.validatedValue("title")
        self.descript = dict.validatedValue("description")
        self.image = dict.validatedValue("image")
        self.thumbnail1 = dict.validatedValue("thumbnail1")
        self.thumbnail2 = dict.validatedValue("thumbnail2")
        self.media_file = dict.validatedValue("media_file")
        self.artist_name = dict.validatedValue("artist_name")
        self.artist_image = dict.validatedValue("artist_image")
        self.mobile_menu_ids = dict.validatedValue("mobile_menu_ids")
        self.god_name = dict.validatedValue("god_name")
        self.category = dict.validatedValue("category")
        self.related_guru = dict.validatedValue("related_guru")
        self.artists_id = dict.validatedValue("artists_id")
        self.god_id = dict.validatedValue("god_id")
        self.god_image = dict.validatedValue("god_image")
        self.creation_time = dict.validatedValue("creation_time")
        self.likes = dict.validatedValue("likes")
        self.published_date = dict.validatedValue("published_date")
        self.status = dict.validatedValue("status")
        self.uploaded_by = dict.validatedValue("uploaded_by")
        self.direct_play = dict.validatedValue("direct_play")
        self.is_like = dict.validatedValue("is_like")
        
        //Universal Model
        self.description = dict.validatedValue("description")
        self.deleted_by = dict.validatedValue("deleted_by")
        self.is_audio_playlist_exist = dict.validatedValue("is_audio_playlist_exist")
        self.play_count = dict.validatedValue("play_count")
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.descript, forKey: "description")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.thumbnail1, forKey: "thumbnail1")
        dictionary.setValue(self.thumbnail2, forKey: "thumbnail2")
        dictionary.setValue(self.media_file, forKey: "media_file")
        dictionary.setValue(self.artist_name, forKey: "artist_name")
        dictionary.setValue(self.artist_image, forKey: "artist_image")
        dictionary.setValue(self.mobile_menu_ids, forKey: "mobile_menu_ids")
        dictionary.setValue(self.god_name, forKey: "god_name")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.related_guru, forKey: "related_guru")
        dictionary.setValue(self.artists_id, forKey: "artists_id")
        dictionary.setValue(self.god_id, forKey: "god_id")
        dictionary.setValue(self.god_image, forKey: "god_image")
        dictionary.setValue(self.likes, forKey: "likes")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.uploaded_by, forKey: "uploaded_by")
        dictionary.setValue(self.direct_play, forKey: "direct_play")
        dictionary.setValue(self.is_like, forKey: "is_like")

        
        //Universal Model
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.deleted_by, forKey: "deleted_by")
        dictionary.setValue(self.is_audio_playlist_exist, forKey: "is_audio_playlist_exist")
        dictionary.setValue(self.play_count, forKey: "play_count")

        return dictionary

    }

}
class paymentModel{
    var plan_id: String?
    var plan_name: String?
    var validity: String?
    var amount: String?
    let currency : String?
    var is_Selected : Bool?
    var coupon_applied: String?
    
    var id: String?
    var coupon_tilte: String?
    var coupon_type: String?
    var coupon_value: String?
    var start: String?
    var end: String?
    var promocode_applied: String?
    var promocode: String?
    var apple_pay_id: String?
    var ios_amount: String?
    
    init(dict:Dictionary<String,Any>) {
        self.plan_id = dict.validatedValue("plan_id")
        self.plan_name = dict.validatedValue("plan_name")
        self.validity = dict.validatedValue("validity")
        self.amount = dict.validatedValue("amount")
        self.currency = dict.validatedValue("currency")
        self.is_Selected = false
        self.coupon_applied = dict.validatedValue("coupon_applied")
        self.apple_pay_id = dict.validatedValue("apple_pay_id")
        self.ios_amount = dict.validatedValue("ios_amount")
        
        self.id = dict.validatedValue("id")
        self.coupon_tilte = dict.validatedValue("coupon_tilte")
        self.coupon_type = dict.validatedValue("coupon_type")
        self.coupon_value = dict.validatedValue("coupon_value")
        self.start = dict.validatedValue("start")
        self.end = dict.validatedValue("end")
        
        self.promocode_applied = dict.validatedValue("promocode_applied")
        self.promocode = dict.validatedValue("promocode")

    }
    
}

 
class freeModel{
    var episode_id : String
    var episode_title : String
    var episode_url : String
    var season_id : String
    var thumbnail_url : String
    var yt_episode_url : String
    var token: String?
    var encrypted_url: String?
    
    var status: String?
    var is_locked: String?
    var short_desc: String?
    var season_title: String?
    
    //Promotion Model
    var description: String?
    var season_thumbnail: String?
    var short_video: String?
    var promo_video: String?
    var yt_promo_video: String?
    var custom_promo_video: String?
    var custom_episode_url: String
    var episode_description: String?
    
    
    //Premium see more
    var id: String?
    var cat_name: String?
    var season_details : [episode_detail_Model] = []
    
    
    //Continue watching
    var video_title: String?
    var video_url: String?
    var author_name: String?
    var thumbnail_url1: String?
    var video_desc: String?
    var mobile_menu_ids: String?
    var category: String?
    var is_sankirtan: String?
    var is_popular: String?
    var related_guru: String?
    var author_image: String?
    var comments: String?
    var views: String?
    var likes: String?
    var tags: String?
    var published_date: String?
    var creation_time: String?
    var youtube_url: String?
    var youtube_views: String?
    var youtube_likes: String?
    var uploaded_by: String?
    var deleted_by: String?
    var mobile_menu_id: String?
    var pause_at: String?
    var type: String?
    var is_like: String?
    var progress:String?
    var vertical_banner:String?
        
    //Premium See more
    var yt_short_video: String?
    var author_id: String?
    var category_ids: String?
    var categories: String?
    
    
    init(dict:Dictionary<String,Any>) {
        self.episode_id = dict.validatedValue("episode_id")
        self.episode_title = dict.validatedValue("episode_title")
        self.episode_url = dict.validatedValue("episode_url")
        self.season_id = dict.validatedValue("season_id")
        self.thumbnail_url = dict.validatedValue("thumbnail_url")
        self.yt_episode_url = dict.validatedValue("yt_episode_url")
        self.status = dict.validatedValue("status")
        self.is_locked = dict.validatedValue("is_locked")
        self.short_desc = dict.validatedValue("short_desc")
        self.season_title = dict.validatedValue("season_title")
        self.token = dict.validatedValue("token")
        self.encrypted_url = dict.validatedValue("encrypted_url")
        
        self.description = dict.validatedValue("description")
        self.season_thumbnail = dict.validatedValue("season_thumbnail")
        self.short_video = dict.validatedValue("short_video")
        self.promo_video = dict.validatedValue("promo_video")
        self.yt_promo_video = dict.validatedValue("yt_promo_video")
        self.custom_promo_video = dict.validatedValue("custom_promo_video")
        self.custom_episode_url = dict.validatedValue("custom_episode_url")
        self.id = dict.validatedValue("id")
        self.cat_name = dict.validatedValue("cat_name")
        self.episode_description = dict.validatedValue("episode_description")

        
        //Contiue watching
        self.video_title = dict.validatedValue("video_title")
        self.video_url = dict.validatedValue("video_url")
        self.author_name = dict.validatedValue("author_name")
        self.thumbnail_url1 = dict.validatedValue("thumbnail_url1")
        self.video_desc = dict.validatedValue("video_desc")
        self.mobile_menu_ids = dict.validatedValue("mobile_menu_ids")
        self.category = dict.validatedValue("category")
        self.is_sankirtan = dict.validatedValue("is_sankirtan")
        self.is_popular = dict.validatedValue("is_popular")
        self.related_guru = dict.validatedValue("related_guru")
        self.author_image = dict.validatedValue("author_image")
        self.comments = dict.validatedValue("comments")
        self.views = dict.validatedValue("views")
        self.likes = dict.validatedValue("likes")
        self.tags = dict.validatedValue("tags")
        self.published_date = dict.validatedValue("published_date")
        self.creation_time = dict.validatedValue("creation_time")
        self.youtube_url = dict.validatedValue("youtube_url")
        self.youtube_views = dict.validatedValue("youtube_views")
        self.youtube_likes = dict.validatedValue("youtube_likes")
        self.uploaded_by = dict.validatedValue("uploaded_by")
        self.deleted_by = dict.validatedValue("deleted_by")
        self.mobile_menu_id = dict.validatedValue("mobile_menu_id")
        self.pause_at = dict.validatedValue("pause_at")
        self.type = dict.validatedValue("type")
        self.is_like = dict.validatedValue("is_like")
        self.progress = dict.validatedValue("progress")
        self.vertical_banner = dict.validatedValue("vertical_banner")

        //Premium See more
        self.yt_short_video = dict.validatedValue("yt_short_video")
        self.author_id = dict.validatedValue("author_id")
        self.category_ids = dict.validatedValue("category_ids")
        self.categories = dict.validatedValue("categories")
        
        let data = dict.ArrayofDict("season_details")
        _ = data.filter{(dictData) -> Bool in
            self.season_details.append(episode_detail_Model(dict:(dictData as NSDictionary) as! Dictionary<String, Any>))
            return true
        }
        
    }
}


class seeMoreModel{
    
    var episode_id: String?
    var episode_title: String?
    var episode_url: String?
    var season_id: String?
    var thumbnail_url: String?
    var yt_episode_url: String?
    
    var promo_video: String?
    var season_thumbnail: String?
    var season_title: String?

    
    init(dict: Dictionary<String,Any>) {
        self.episode_id = dict.validatedValue("episode_id")
        self.episode_title = dict.validatedValue("episode_title")
        self.episode_url = dict.validatedValue("episode_url")
        self.season_id = dict.validatedValue("season_id")
        self.thumbnail_url = dict.validatedValue("thumbnail_url")
        self.yt_episode_url = dict.validatedValue("yt_episode_url")
        
        self.promo_video = dict.validatedValue("promo_video")
        self.season_thumbnail = dict.validatedValue("season_thumbnail")
        self.season_title = dict.validatedValue("season_title")
    }
}

class couponListModel{
    var id: String?
    var coupon_tilte: String?
    var coupon_type: String?
    var coupon_value: String?
    var start: String?
    var end: String?
    var promocode_applied: String?
    var promocode: String?
    
    init(dict: Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.coupon_tilte = dict.validatedValue("coupon_tilte")
        self.coupon_type = dict.validatedValue("coupon_type")
        self.coupon_value = dict.validatedValue("coupon_value")
        self.start = dict.validatedValue("start")
        self.promocode_applied = dict.validatedValue("promocode_applied")
        self.promocode = dict.validatedValue("promocode")

    }
}

class seasonmoreepisodemodel{
    
    var id : String
    var season_id : String
    var thumbnail_url : String
    var cat_id : String
    var auth_id: String?
    var episode_title : String?
    var episode_description: String?
    var episode_url: String?
    var yt_episode_url: String?
    var token: String?
    var encrypted_url: String?
    var custom_episode_url: String?
    var creation_time: String?
    var modified_time: String?
    var uploaded_by: String?
    var status: String?
    var position: String
    var is_locked: String?
    
    
    init(dict:Dictionary<String,Any>) {
        self.id = dict.validatedValue("id")
        self.season_id = dict.validatedValue("season_id")
        self.thumbnail_url = dict.validatedValue("thumbnail_url")
        self.cat_id = dict.validatedValue("cat_id")
        self.auth_id = dict.validatedValue("auth_id")
        self.episode_title = dict.validatedValue("episode_title")
        self.episode_description = dict.validatedValue("episode_description")
        self.episode_url = dict.validatedValue("episode_url")
        self.yt_episode_url = dict.validatedValue("yt_episode_url")
        self.token = dict.validatedValue("token")
        self.encrypted_url = dict.validatedValue("encrypted_url")
        self.custom_episode_url = dict.validatedValue("custom_episode_url")
        self.creation_time = dict.validatedValue("creation_time")
        self.modified_time = dict.validatedValue("modified_time")
        self.uploaded_by = dict.validatedValue("uploaded_by")
        self.status = dict.validatedValue("status")
        self.position = dict.validatedValue("position")
        self.is_locked = dict.validatedValue("is_locked")
        
        
    }
}
