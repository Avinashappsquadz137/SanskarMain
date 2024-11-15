//
//  constant.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class videosResult {
    public var id : String?
    public var video_title : String?
    public var video_url : String?
    public var youtube_url : String?
    public var author_name : String?
    public var thumbnail_url : String?
    public var thumbnail_url1 : String?
    public var video_desc : String?
    public var description : String?
    public var category : String?
    public var comments : String?
    public var views : String?
    public var likes : String?
    public var creation_time : String?
    
    
    public var is_like : String?
    public var related_guru : String?
    public var author_image : String?
    public var tags : String?
    public var is_sankirtan : String?
    public var multiple_videos: [multiplevideos] = []
    
    public var mobile_menu_ids : String?
    public var is_popular : String?
    public var published_date : String?
    public var status : String?
    public var uploaded_by : String?
        
    
    //Continue watching
    var youtube_views : String?
    var youtube_likes : String?
    var deleted_by : String?
    var mobile_menu_id : String?
    var pause_at : String?
    var type : String?
    var yt_episode_url: String?
    var episode_title: String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [videosResult]
    {
        var models:[videosResult] = []
        for item in array
        {
            models.append(videosResult(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        video_title = dictionary["video_title"] as? String
        video_url = dictionary["video_url"] as? String
        youtube_url = dictionary["youtube_url"] as? String
        author_name = dictionary["author_name"] as? String
        thumbnail_url = dictionary["thumbnail_url"] as? String
        video_desc = dictionary["video_desc"] as? String
        category = dictionary["category"] as? String
        comments = dictionary["comments"] as? String
        views = dictionary["views"] as? String
        likes = dictionary["likes"] as? String
        description = dictionary["description"] as? String
        creation_time = dictionary["creation_time"] as? String

        
        is_like = dictionary["is_like"] as? String
        related_guru = dictionary["related_guru"] as? String
        author_image = dictionary["author_image"] as? String
        tags = dictionary["tags"] as? String
        is_sankirtan = dictionary["is_sankirtan"] as? String
        mobile_menu_ids = dictionary["mobile_menu_ids"] as? String
        is_popular = dictionary["is_popular"] as? String
        published_date = dictionary["published_date"] as? String
        status = dictionary["status"] as? String
        uploaded_by = dictionary["uploaded_by"] as? String
        thumbnail_url1 = dictionary["thumbnail_url1"] as? String
        
        
        //Continue watching
        youtube_views = dictionary["youtube_views"] as? String
        youtube_likes = dictionary["youtube_likes"] as? String
        deleted_by = dictionary["deleted_by"] as? String
        mobile_menu_id = dictionary["mobile_menu_id"] as? String
        pause_at = dictionary["pause_at"] as? String
        type = dictionary["type"] as? String
        yt_episode_url = dictionary["yt_episode_url"] as? String
        episode_title = dictionary["yt_episode_url"] as? String

        
        let data = dictionary["multiple_videos"]
        
        if data != nil {
            let array = dictionary["multiple_videos"] as! Array<NSDictionary>
            
            for dict in array{
                multiple_videos.append(multiplevideos(dict: dict))
            }
        }
        
        
    }
    
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.video_title, forKey: "video_title")
        dictionary.setValue(self.video_url, forKey: "video_url")
        dictionary.setValue(self.youtube_url, forKey: "youtube_url")
        dictionary.setValue(self.author_name, forKey: "author_name")
        dictionary.setValue(self.thumbnail_url, forKey: "thumbnail_url")
        dictionary.setValue(self.video_desc, forKey: "video_desc")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.comments, forKey: "comments")
        dictionary.setValue(self.views, forKey: "views")
        dictionary.setValue(self.likes, forKey: "likes")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")

        
        
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.is_like, forKey: "is_like")
        dictionary.setValue(self.related_guru, forKey: "related_guru")
        dictionary.setValue(self.author_image, forKey: "author_image")
        dictionary.setValue(self.tags, forKey: "tags")
        dictionary.setValue(self.is_sankirtan, forKey: "is_sankirtan")
        
        return dictionary
    }
    
}
public class multiplevideos {
    
    public var day : String?
    public var thumbnail_url :String?
    public var video_title : String?
    public var video_url : String?
    public var youtube_url : String?
    
    init(dict:NSDictionary) {
        
        day           = dict["day"] as? String ?? ""
        thumbnail_url = dict["thumbnail_url"] as? String ?? ""
        video_title   = dict["video_title"] as? String ?? ""
        video_url     = dict["video_url"] as? String ?? ""
        youtube_url   = dict["youtube_url"] as? String ?? ""
    }
    
    
}
