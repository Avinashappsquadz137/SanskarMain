//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation
 
public class Comments {
	public var id : String?
	public var video_id : String?
	public var user_id : String?
	public var comment : String?
	public var time : String?
	public var name : String?
	public var profile_picture : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Comments_list = Comments.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Comments Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Comments]
    {
        var models:[Comments] = []
        for item in array
        {
            models.append(Comments(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Comments = Comments(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Comments Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		video_id = dictionary["video_id"] as? String
		user_id = dictionary["user_id"] as? String
		comment = dictionary["comment"] as? String
		time = dictionary["time"] as? String
		name = dictionary["name"] as? String
		profile_picture = dictionary["profile_picture"] as? String
	}

/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.video_id, forKey: "video_id")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.comment, forKey: "comment")
		dictionary.setValue(self.time, forKey: "time")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.profile_picture, forKey: "profile_picture")

		return dictionary
	}

}
