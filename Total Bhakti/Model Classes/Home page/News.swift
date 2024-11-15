/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class News {
	public var id : String?
	public var title : String?
	public var shortDesc : String?
	public var description : String?
	public var image : String?
	public var views_count : String?
	public var creation_time : String?
	public var status : String?
    public var published_date : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let news_list = News.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of News Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [News]
    {
        var models:[News] = []
        for item in array
        {
            models.append(News(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let news = News(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: News Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		title = dictionary["title"] as? String
		shortDesc = dictionary["shortDesc"] as? String
		description = dictionary["description"] as? String
		image = dictionary["image"] as? String
		views_count = dictionary["views_count"] as? String
        creation_time = dictionary["creation_time"] as? String
        published_date = dictionary["published_date"] as? String

        
		status = dictionary["status"] as? String
        published_date = dictionary["published_date"] as? String        
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.shortDesc, forKey: "shortDesc")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.views_count, forKey: "views_count")
        dictionary.setValue(self.creation_time, forKey: "creation_time")
        dictionary.setValue(self.published_date, forKey: "published_date")
		dictionary.setValue(self.status, forKey: "status")
        

		return dictionary
	}

}
