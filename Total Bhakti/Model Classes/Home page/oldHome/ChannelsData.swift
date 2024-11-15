//
//  constant.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class ChannelsData {
	public var id : String?
	public var name : String?
	public var image : String?
    public var creation_time : String?
    public var published_date : String?
	public var status : String?
    public var channel_url : String?

    

    public class func modelsFromDictionaryArray(array:NSArray) -> [ChannelsData]
    {
        var models:[ChannelsData] = []
        for item in array
        {
            models.append(ChannelsData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		name = dictionary["name"] as? String
		image = dictionary["image"] as? String
        creation_time = dictionary["creation_time"] as? String
        published_date = dictionary["published_date"] as? String

        
		status = dictionary["status"] as? String
        channel_url = dictionary["channel_url"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")

        
		dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.status, forKey: "channel_url")

		return dictionary
	}

}
