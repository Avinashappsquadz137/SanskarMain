//
//  TBNotification.swift
//  Total Bhakti
//
//  Created by MAC MINI on 13/02/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class notification {

    public var id : String?
    public var user_type : String?
    public var user_id : String?
    public var post_type : String?
    public var post_id : String?
    public var text : String?
    public var device_type  : String?
    public var notification_type : String?
    public var image : String?
    public var extra : String?
    public var sent_by : String?
    public var created_on : String?
    public var is_view : String?
    public var notification_thumbnail : String?

    
    public class func modelsFromDictionaryArray(array:NSArray) -> [notification]
    {
        var models:[notification] = []
        for item in array
        {
            models.append(notification(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
        user_type = dictionary["user_type"] as? String
		user_id = dictionary["user_id"] as? String
		post_type = dictionary["post_type"] as? String
		post_id = dictionary["post_id"] as? String
		text = dictionary["text"] as? String
        device_type = dictionary["device_type"] as? String
        notification_type = dictionary["notification_type"] as? String
        image = dictionary["image"] as? String
        extra = dictionary["extra"] as? String
        sent_by = dictionary["sent_by"] as? String
        created_on = dictionary["created_on"] as? String
        is_view    = dictionary["is_view"] as? String
        notification_thumbnail = dictionary["notification_thumbnail"] as? String
      
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.user_type, forKey: "user_type")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.post_type, forKey: "post_type")
		dictionary.setValue(self.post_id, forKey: "post_id")
		dictionary.setValue(self.text, forKey: "text")
        dictionary.setValue(self.device_type, forKey: "device_type")
        dictionary.setValue(self.notification_type, forKey: "notification_type")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.extra, forKey: "extra")
        dictionary.setValue(self.sent_by, forKey: "sent_by")
        dictionary.setValue(self.created_on, forKey: "created_on")
        dictionary.setValue(self.is_view, forKey: "is_view")
         dictionary.setValue(self.notification_thumbnail, forKey: "notification_thumbnail")
        

		return dictionary
	}

}
