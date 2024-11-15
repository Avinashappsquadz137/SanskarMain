//
//  NewsResult.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//
import Foundation

public class NewsResult {
	public var id : String?
	public var title : String?
	public var description : String?
	public var image : String?
    public var creation_time : String?
    public var published_date : String?
    public var views_count : String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [NewsResult]
    {
        var models:[NewsResult] = []
        for item in array
        {
            models.append(NewsResult(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		title = dictionary["title"] as? String
		description = dictionary["description"] as? String
		image = dictionary["image"] as? String
        creation_time = dictionary["creation_time"] as? String
        published_date = dictionary["published_date"] as? String
        views_count = dictionary["views_count"] as? String
        
        
	}

		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")
        dictionary.setValue(self.views_count, forKey: "views_count")
        
		return dictionary
	}

}
