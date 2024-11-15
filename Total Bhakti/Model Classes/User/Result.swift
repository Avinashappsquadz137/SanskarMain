//
//  constant.swift
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import Foundation

public class Result {
	public var id : String?
	public var name : String?
	public var username : String?
	public var profile_picture : String?
	public var email : String?
	public var password : String?
	public var mobile : String?
	public var gender : String?
	public var login_type : Int?
	public var fb_id : String?
	public var gmail_id : String?
	public var device_type : Int?
	public var device_tokken : String?
    public var creation_time : String?
    public var published_date : String?
	public var otp_verification : Int?
	public var status : Int?
	public var user : String?
	public var otp : String?
    public var about : String?
    public var go_live : String?
    public var country_code : String?
    
    
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Result]
    {
        var models:[Result] = []
        for item in array
        {
            models.append(Result(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		name = dictionary["name"] as? String
		username = dictionary["username"] as? String
		profile_picture = dictionary["profile_picture"] as? String
		email = dictionary["email"] as? String
		password = dictionary["password"] as? String
        mobile = dictionary["mobile"] as? String
        gender = dictionary["gender"] as? String
		login_type = dictionary["login_type"] as? Int
		fb_id = dictionary["fb_id"] as? String
		gmail_id = dictionary["gmail_id"] as? String
		device_type = dictionary["device_type"] as? Int
		device_tokken = dictionary["device_tokken"] as? String
        creation_time = dictionary["creation_time"] as? String
        published_date = dictionary["published_date"] as? String

        
        
		otp_verification = dictionary["otp_verification"] as? Int
		status = dictionary["status"] as? Int
		user = dictionary["user"] as? String
		otp = dictionary["otp"] as? String
        about = dictionary["about"] as? String
        go_live = dictionary["go_live"] as? String
        country_code = dictionary["country_code"] as? String
	}

		
public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.username, forKey: "username")
		dictionary.setValue(self.profile_picture, forKey: "profile_picture")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.mobile, forKey: "mobile")
		dictionary.setValue(self.gender, forKey: "gender")
		dictionary.setValue(self.login_type, forKey: "login_type")
		dictionary.setValue(self.fb_id, forKey: "fb_id")
		dictionary.setValue(self.gmail_id, forKey: "gmail_id")
		dictionary.setValue(self.device_type, forKey: "device_type")
		dictionary.setValue(self.device_tokken, forKey: "device_tokken")
    dictionary.setValue(self.creation_time, forKey: "creation_time")
    dictionary.setValue(self.published_date, forKey: "published_date")

    
    
		dictionary.setValue(self.otp_verification, forKey: "otp_verification")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.user, forKey: "user")
		dictionary.setValue(self.otp, forKey: "otp")
        dictionary.setValue(self.about, forKey: "about")
        dictionary.setValue(self.country_code, forKey: "country_code")
        dictionary.setValue(self.go_live, forKey: "go_live")
		return dictionary
	}

}
