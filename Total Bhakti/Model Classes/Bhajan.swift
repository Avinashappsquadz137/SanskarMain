//
//  Bhajan.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation
//{
//"author_image" = "";
//"author_name" = "\U0939\U0938\U092e\U0941\U0916 \U092d\U093e\U0908 \U0936\U0928\U0948\U0936\U094d\U0935\U0930\U093e";
//category = 16;
//comments = 0;
//"creation_time" = 1592455065703;
//id = 836;
//"is_like" = 0;
//"is_popular" = 1;
//"is_sankirtan" = 1;
//likes = 2;
//"mobile_menu_ids" = "";
//"published_date" = "2020-06-18";
//"related_guru" = 1;
//status = 0;
//tags = "Sanskar Bhajan,Sanskar Satsang Prayer,Devtional Song,Top 10 bhajan,Top 10 Songs,top songs,sanskar top bhajan,latest bhajan,most viewed bhajan,most viewed songs,\U092e\U0928 \U0915\U0940 \U0936\U093e\U0902\U0924\U093f \U0915\U0947 \U0932\U093f\U090f \U0905\U0935\U0936\U094d\U092f \U0938\U0941\U0928\U0947\U0902 \U092f\U0939 \U092d\U091c\U0928 . . . \U090f\U0915 \U092c\U093e\U0930 \U092d\U091c\U0928 \U0915\U0930\U0932\U0947 - \U0939\U0938\U092e\U0941\U0916 \U092d\U093e\U0908 \U0936\U0928\U0948\U0936\U094d\U0935\U0930\U093e";
//"thumbnail_url" = "https://bhaktiappproduction.s3.ap-south-1.amazonaws.com/videos/thumbnails/1744460min-15924550651.jpg";
//"thumbnail_url1" = "https://bhaktiappproduction.s3.ap-south-1.amazonaws.com/videos/thumbnails/1509157max-15924550651.jpg";
//"uploaded_by" = 1;
//"video_desc" = "<p><span style=\"color: rgba(0, 0, 0, 0.87); font-family: Roboto, Noto, sans-serif; font-size: 15px; white-space: pre-wrap;\">\U092e\U0928 \U0915\U0940 \U0936\U093e\U0902\U0924\U093f \U0915\U0947 \U0932\U093f\U090f \U0905\U0935\U0936\U094d\U092f \U0938\U0941\U0928\U0947\U0902 \U092f\U0939 \U092d\U091c\U0928 . . . \U090f\U0915 \U092c\U093e\U0930 \U092d\U091c\U0928 \U0915\U0930\U0932\U0947 - \U0939\U0938\U092e\U0941\U0916 \U092d\U093e\U0908 \U0936\U0928\U0948\U0936\U094d\U0935\U0930\U093e </span></p>
//\n
//\n<div>&nbsp;</div>
//\n";
//"video_title" = "\U090f\U0915 \U092c\U093e\U0930 \U092d\U091c\U0928 \U0915\U0930\U0932\U0947 ";
//"video_url" = "";
//views = 82;
//"youtube_url" = "oFOBVjfj_BE";
//}

public class Bhajan {
	public var id : String?
	public var title : String?
	public var description : String?
	public var image : String?
	public var media_file : String?
	public var category : Int?
	public var create_time : String?
    public var direct_play : String?
    public var artist_name : String?
    public var artist_image : String?
    public var related_guru : String?
    public var status : Int?
    public var creation_time : String?
    public var likes : String?
    public var artist_id : String?
    public var is_like : String?
    public var god_name : String?
    public var god_image : String?
    public var god_id : Int?
    
    public var video_title: String?
    public var video_url: String?
    public var author_name: String?
    public var thumbnail_url: String?
    public var thumbnail_url1: String?
    public var video_desc: String?
    public var mobile_menu_ids: String?
    public var is_sankirtan: String?
    public var is_popular: String?
    public var author_image: String?
    public var comments: String?
    public var views: String?
    public var tags: String?
    public var published_date: String?
    public var youtube_url: String?
    public var uploaded_by: String?
    
    //Show playlist
    public var thumbnail1: String?
    public var thumbnail2: String?
    public var artists_id: String?
    public var play_count: String?
    public var deleted_by: String?
    public var is_audio_playlist_exist: String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Bhajan]
    {
        var models:[Bhajan] = []
        for item in array
        {
            models.append(Bhajan(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? String
        video_title = dictionary["video_title"] as? String
        author_name = dictionary["author_name"] as? String
        thumbnail_url = dictionary["thumbnail_url"] as? String
        thumbnail_url1 = dictionary["thumbnail_url1"] as? String
        video_desc = dictionary["video_desc"] as? String
        mobile_menu_ids = dictionary["mobile_menu_ids"] as? String
        is_sankirtan = dictionary["is_sankirtan"] as? String
        is_popular = dictionary["is_popular"] as? String
        author_image = dictionary["author_image"] as? String
        comments = dictionary["comments"] as? String
        views = dictionary["views"] as? String
        tags = dictionary["tags"] as? String
        published_date = dictionary["published_date"] as? String
        youtube_url = dictionary["youtube_url"] as? String
        uploaded_by = dictionary["uploaded_by"] as? String

		title = dictionary["title"] as? String
		description = dictionary["description"] as? String
		image = dictionary["image"] as? String
		media_file = dictionary["media_file"] as? String
		category = dictionary["category"] as? Int
		create_time = dictionary["create_time"] as? String
        direct_play = dictionary["direct_play"] as? String
        artist_name = dictionary["artist_name"] as? String
        artist_image = dictionary["artist_image"] as? String
        related_guru = dictionary["related_guru"] as? String
        status = dictionary["status"] as? Int
        creation_time = dictionary["creation_time"] as? String
        likes = dictionary["likes"] as? String
        is_like = dictionary["is_like"] as? String
        artist_id = dictionary["artists_id"] as? String
        god_name = dictionary["god_name"] as? String
        god_image = dictionary["god_image"] as? String
        god_id = dictionary["god_id"] as? Int
        published_date = dictionary["published_date"] as? String

        //Show playlist
        thumbnail1 = dictionary["thumbnail1"] as? String
        thumbnail2 = dictionary["thumbnail2"] as? String
        artists_id = dictionary["artists_id"] as? String
        play_count = dictionary["play_count"] as? String
        deleted_by = dictionary["deleted_by"] as? String
        is_audio_playlist_exist = dictionary["is_audio_playlist_exist"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.media_file, forKey: "media_file")
		dictionary.setValue(self.category, forKey: "category")
		dictionary.setValue(self.create_time, forKey: "create_time")
        dictionary.setValue(self.direct_play, forKey: "direct_play")
        dictionary.setValue(self.artist_name, forKey: "artist_name")
        dictionary.setValue(self.artist_image, forKey: "artist_image")
        dictionary.setValue(self.related_guru, forKey: "related_guru")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.likes, forKey: "likes")
        dictionary.setValue(self.is_like, forKey: "is_like")
        dictionary.setValue(self.artist_id, forKey: "artists_id")
        dictionary.setValue(self.god_name, forKey: "god_name")
        dictionary.setValue(self.god_image, forKey: "god_image")
        dictionary.setValue(self.god_id, forKey: "god_id")
        dictionary.setValue(self.published_date, forKey: "published_date")
        
        
        //Show playlist
        dictionary.setValue(self.thumbnail1, forKey: "thumbnail1")
        dictionary.setValue(self.thumbnail2, forKey: "thumbnail2")
        dictionary.setValue(self.artists_id, forKey: "artists_id")
        dictionary.setValue(self.play_count, forKey: "play_count")
        dictionary.setValue(self.deleted_by, forKey: "deleted_by")

        return dictionary
	}

}
