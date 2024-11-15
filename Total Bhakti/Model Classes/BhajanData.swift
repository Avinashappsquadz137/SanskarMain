//
//  BhajanData.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class BhajanData {
	public var id : Int?
	public var category_name : String?
    public var creation_time : Int?
    public var published_date : Int?
	public var bhajan : Array<Bhajan>?
//
    public class func modelsFromDictionaryArray(array:NSArray) -> [BhajanData]
    {
        var models:[BhajanData] = []
        for item in array
        {
            models.append(BhajanData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		category_name = dictionary["category_name"] as? String
        published_date = dictionary["published_date"] as? Int
        if (dictionary["bhajan"] != nil) { bhajan = Bhajan.modelsFromDictionaryArray(array: dictionary["bhajan"] as! NSArray) }
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.category_name, forKey: "category_name")
		dictionary.setValue(self.published_date, forKey: "published_date")

		return dictionary
	}

}
