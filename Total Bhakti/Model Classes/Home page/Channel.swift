/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Channel {
	public var id : String?
	public var name : String?
	public var image : String?
    public var creation_time : String?
    public var published_date : String?
	public var status : String?
    public var channel_url : String?
    public var description :String?
    public var is_likes :String?
    public var likes :String?
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let channel_list = Channel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Channel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Channel]
    {
        var models:[Channel] = []
        for item in array
        {
            models.append(Channel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let channel = Channel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Channel Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		name = dictionary["name"] as? String
		image = dictionary["image"] as? String
        creation_time = dictionary["creation_time"] as? String
        published_date = dictionary["published_date"] as? String

        
		status = dictionary["status"] as? String
        channel_url = dictionary["channel_url"] as? String
        description = dictionary["description"] as? String
        likes = dictionary["likes"] as? String
        is_likes = "\(dictionary["is_likes"]!)"
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")
        
		dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.channel_url, forKey: "channel_Url")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.is_likes, forKey: "is_likes")
        dictionary.setValue(self.likes, forKey: "likes")
        
		return dictionary
	}

}
