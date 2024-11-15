//
//  constant.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class guruData {
	public var id : String?
	public var name : String?
	public var profile_image : String?
	public var description : String?
    public var creation_time : Int?
    public var published_date : Int?
    public var is_follow : String?
    public var is_like : String?
    public var likes_count : String?
    public var followers_count : String?
    public var banner_image : String?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [guruData]
    {
        var models:[guruData] = []
        for item in array
        {
            models.append(guruData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		name = dictionary["name"] as? String
		profile_image = dictionary["profile_image"] as? String
		description = dictionary["description"] as? String
        creation_time = dictionary["creation_time"] as? Int
        published_date = dictionary["published_date"] as? Int
        
        is_like = dictionary["is_like"] as? String
        is_follow = dictionary["is_follow"] as? String
        likes_count = dictionary["likes_count"] as? String
        followers_count = dictionary["followers_count"] as? String
        banner_image = dictionary["banner_image"] as? String
	}

		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.profile_image, forKey: "profile_image")
		dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")
        dictionary.setValue(self.is_like, forKey: "is_like")
        dictionary.setValue(self.is_follow, forKey: "is_follow")
        dictionary.setValue(self.likes_count, forKey: "likes_count")
        dictionary.setValue(self.followers_count, forKey: "followers_count")
         dictionary.setValue(self.banner_image, forKey: "banner_image")
		return dictionary
	}

}
