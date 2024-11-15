//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class VideosData1 {
	public var status : Bool?
	public var message : String?
	public var result : videoAndCategory?

    public class func modelsFromDictionaryArray(array:NSArray) -> [VideosData1]
    {
        var models:[VideosData1] = []
        for item in array
        {
            models.append(VideosData1(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		status = dictionary["status"] as? Bool
		message = dictionary["message"] as? String
        
        if status == false{
            return
        }
		if (dictionary["data"] != nil) { result = videoAndCategory(dictionary: dictionary["data"] as! NSDictionary) }
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.result?.dictionaryRepresentation(), forKey: "data")

		return dictionary
	}

}
