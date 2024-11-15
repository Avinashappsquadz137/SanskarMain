//
//  constant.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class User {
    public var status : Bool?
    public var message : String?
    public var result : Result?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        status = dictionary["status"] as? Bool
        message = dictionary["message"] as? String
        if (dictionary["data"] != nil) {
            
            guard let data =  dictionary["data"] as? NSDictionary else {
                return
            }
            result = Result(dictionary: data)
            }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.result?.dictionaryRepresentation(), forKey: "data")
        
        return dictionary
    }
    
}
