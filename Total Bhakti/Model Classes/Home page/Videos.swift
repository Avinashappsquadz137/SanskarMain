
import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Videos {
	public var id : String?
	public var category : String?
	public var videos : Array<videosResult>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let videos_list = Videos.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Videos Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Videos]
    {
        var models:[Videos] = []
        for item in array
        {
            models.append(Videos(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let videos = Videos(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Videos Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		category = dictionary["category"] as? String
        if (dictionary["videos"] != nil) { videos = videosResult.modelsFromDictionaryArray(array: dictionary["videos"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.category, forKey: "category")

		return dictionary
	}

}
