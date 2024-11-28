//
//  LiveBhajanModel.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 27/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//
//
import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class LiveDarshan {
    public var id : String?
    public var title : String?
    public var description : String?
    public var thumbnail : String?
    public var video_type : String?
    public var temple_id : String?
    public var video_url : String?
    public var published_date : String?
    public var temple_name : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [LiveDarshan]
    {
        var models:[LiveDarshan] = []
        for item in array
        {
            models.append(LiveDarshan(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        thumbnail = dictionary["thumbnail"] as? String
        video_type = dictionary["video_type"] as? String
        temple_id = dictionary["temple_id"] as? String
        video_url = dictionary["video_url"] as? String
        published_date = dictionary["published_date"] as? String
        temple_name = dictionary["temple_name"] as? String
    }


    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.thumbnail, forKey: "thumbnail")
        dictionary.setValue(self.video_type, forKey: "video_type")
        dictionary.setValue(self.temple_id, forKey: "temple_id")
        dictionary.setValue(self.video_url, forKey: "video_url")
        dictionary.setValue(self.published_date, forKey: "published_date")
        dictionary.setValue(self.temple_name, forKey: "temple_name")

        return dictionary
    }

}
