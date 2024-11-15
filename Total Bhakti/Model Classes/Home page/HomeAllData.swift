

import Foundation
public class HomeAllData {
	public var status : Bool?
	public var message : String?
	public var channel : Array<Channel>?
	public var promotion : Promotion?
	public var videos : Array<Videos>?
	public var guru : Array<guruData>?
	public var bhajan : Array<AudioBhajan>?
	public var news : Array<News>?
    public var homeVideo : String?
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let HomeAllData_list = HomeAllData.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of HomeAllData Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [HomeAllData]
    {
        var models:[HomeAllData] = []
        for item in array
        {
            models.append(HomeAllData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let HomeAllData = HomeAllData(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: HomeAllData Instance.
*/
	required public init?(dictionary: NSDictionary) {

		status = dictionary["status"] as? Bool
		message = dictionary["message"] as? String
        if (dictionary["channel"] != nil) { channel = Channel.modelsFromDictionaryArray(array: dictionary["channel"] as! NSArray) }
		if (dictionary["promotion"] != nil) { promotion = Promotion(dictionary: dictionary["promotion"] as! NSDictionary) }
        if (dictionary["video"] != nil) { videos = Videos.modelsFromDictionaryArray(array: dictionary["video"] as! NSArray) }
        if (dictionary["guru"] != nil) { guru = guruData.modelsFromDictionaryArray(array: dictionary["guru"] as! NSArray) }
        if (dictionary["bhajan"] != nil) { bhajan = AudioBhajan.modelsFromDictionaryArray(array: dictionary["bhajan"] as! NSArray) }
        if (dictionary["news"] != nil) { news = News.modelsFromDictionaryArray(array: dictionary["news"] as! NSArray) }
        homeVideo = dictionary["home_video"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.homeVideo, forKey: "home_video")

        
		dictionary.setValue(self.promotion?.dictionaryRepresentation(), forKey: "promotion")

		return dictionary
	}

}
