

import Foundation
 

public class AudioBhajan {
	public var category_name : String?
	public var audio : Array<Bhajan>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let AudioBhajan_list = AudioBhajan.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AudioBhajan Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AudioBhajan]
    {
        var models:[AudioBhajan] = []
        for item in array
        {
            models.append(AudioBhajan(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let AudioBhajan = AudioBhajan(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AudioBhajan Instance.
*/
	required public init?(dictionary: NSDictionary) {

		category_name = dictionary["category_name"] as? String
        if (dictionary["bhajan"] != nil) { audio = Bhajan.modelsFromDictionaryArray(array: dictionary["bhajan"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.category_name, forKey: "category_name")

		return dictionary
	}

}
