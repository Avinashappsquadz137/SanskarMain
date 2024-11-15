//
//  TAdsBanners.swift
//  Total Bhakti
//
//  Created by MAC MINI on 13/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class AdsBanners {
	public var id : String?
	public var title : String?
	public var image : String?
	public var position : Int?
	public var published_date : String?
	public var status : Int?
	public var creation_time : Int?

    public class func modelsFromDictionaryArray(array:NSArray) -> [AdsBanners]
    {
        var models:[AdsBanners] = []
        for item in array
        {
            models.append(AdsBanners(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		title = dictionary["title"] as? String
		image = dictionary["image"] as? String
		position = dictionary["position"] as? Int
		published_date = dictionary["published_date"] as? String
		status = dictionary["status"] as? Int
		creation_time = dictionary["creation_time"] as? Int
	}

		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.position, forKey: "position")
		dictionary.setValue(self.published_date, forKey: "published_date")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.creation_time, forKey: "creation_time")

		return dictionary
	}

}
