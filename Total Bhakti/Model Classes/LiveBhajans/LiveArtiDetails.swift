//
//  LiveArtiDetails.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 30/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import Foundation

public class MoreForAarti {
    public var status: Bool?
    public var message: String?
    public var data: [DataModel]?
    public var error: [CustomError]?

    public class func modelsFromDictionaryArray(array: NSArray) -> [MoreForAarti] {
        var models: [MoreForAarti] = []
        for item in array {
            if let dictionary = item as? NSDictionary {
                if let model = MoreForAarti(dictionary: dictionary) {
                    models.append(model)
                }
            }
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {
        status = dictionary["status"] as? Bool
        message = dictionary["message"] as? String

        // Parse `data`
        if let dataArray = dictionary["data"] as? NSArray {
            data = DataModel.modelsFromDictionaryArray(array: dataArray)
        }

        // Parse `error`
        if let errorArray = dictionary["error"] as? NSArray {
            error = CustomError.modelsFromDictionaryArray(array: errorArray)
        }
    }

    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.message, forKey: "message")

        return dictionary
    }
}

public class DataModel {
    public var id: String?
    public var title: String?
    public var description: String?
    public var thumbnail: String?
    public var video_type: String?
    public var temple_id: String?
    public var video_url: String?
    public var published_date: String?
    public var temple_name: String?

    public class func modelsFromDictionaryArray(array: NSArray) -> [DataModel] {
        var models: [DataModel] = []
        for item in array {
            if let dictionary = item as? NSDictionary {
                if let model = DataModel(dictionary: dictionary) {
                    models.append(model)
                }
            }
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        thumbnail = dictionary["thumbnail"] as? String
        video_type = dictionary["video_type"] as? String
        temple_id = dictionary["temple_id"] as? String
        video_url = dictionary["video_url"] as? String
        published_date = dictionary["published_date"] as? String
        temple_name = dictionary["temple_name"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.thumbnail, forKey: "thumbnail")
        dictionary.setValue(self.video_type, forKey: "video_type")
        dictionary.setValue(self.temple_id, forKey: "temple_id")
        dictionary.setValue(self.video_url, forKey: "video_url")
        dictionary.setValue(self.published_date, forKey: "published_date")
        dictionary.setValue(self.temple_name, forKey: "temple_name")

        return dictionary
    }
}

public class CustomError {
    public var code: String?
    public var message: String?

    public class func modelsFromDictionaryArray(array: NSArray) -> [CustomError] {
        var models: [CustomError] = []
        for item in array {
            if let dictionary = item as? NSDictionary {
                if let model = CustomError(dictionary: dictionary) {
                    models.append(model)
                }
            }
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {
        code = dictionary["code"] as? String
        message = dictionary["message"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.code, forKey: "code")
        dictionary.setValue(self.message, forKey: "message")

        return dictionary
    }
}
