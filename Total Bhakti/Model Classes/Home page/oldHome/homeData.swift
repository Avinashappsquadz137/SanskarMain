//
//  constant.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class homeData {
	public var category : String?
	public var videos : Array<videosResult>?


    public class func modelsFromDictionaryArray(array:NSArray) -> [homeData]
    {
        var models:[homeData] = []
        for item in array
        {
            models.append(homeData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		category = dictionary["category"] as? String
        if (dictionary["videos"] != nil) { videos = videosResult.modelsFromDictionaryArray(array: dictionary["videos"] as! NSArray) }
	}

		
    public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.category, forKey: "category")

		return dictionary
	}

}
