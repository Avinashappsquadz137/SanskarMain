//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class Category {
    
	public var id : String?
	public var category_name : String?
    public var creation_time : Int?
    public var published_date : Int?
	public var status : Int?
    public var isSelected : Bool?
    
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Category]
    {
        var models:[Category] = []
        for item in array
        {
            models.append(Category(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		category_name = dictionary["category_name"] as? String
        creation_time = dictionary["creation_time"] as? Int
        published_date = dictionary["published_date"] as? Int

        
		status = dictionary["status"] as? Int
        isSelected = dictionary["isSelected"] as? Bool
	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
        
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.category_name, forKey: "category_name")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")
		dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.isSelected, forKey: "isSelected")
        
		return dictionary
	}

}
