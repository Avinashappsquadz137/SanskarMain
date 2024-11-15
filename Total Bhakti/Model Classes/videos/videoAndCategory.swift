//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//


import Foundation

public class videoAndCategory {
    
	public var category  : Array<Category>?
	public var videos    : Array<videosResult>?
    public var adsBanner : Array<AdsBanners>?

    public class func modelsFromDictionaryArray(array:NSArray) -> [videosResult]
    {
        var models:[videosResult] = []
        for item in array
        {
            models.append(videosResult(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

        if (dictionary["category"] != nil) { category = Category.modelsFromDictionaryArray(array: dictionary["category"] as! NSArray) }
        if (dictionary["videos"] != nil) { videos = videosResult.modelsFromDictionaryArray(array: dictionary["videos"] as! NSArray) }
        if (dictionary["banners"] != nil) { adsBanner = AdsBanners.modelsFromDictionaryArray(array: dictionary["banners"] as! NSArray) }
	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		return dictionary
	}

}
