//
//  HttpHelper.swift
//  Sanskar
//
//  Created by Warln on 07/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit
import Alamofire

// Type alias for response handler closure
/// <#Description#>
/// - Parameters:
///   - result: Bool
///   - response: Response as Dictionary
///   - error: error
///   - data:data
/// - Returns: Void
 typealias responseHandler = (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ data: Data?) -> Void


class HttpHelper: NSObject {
    
    class func getServerPath() -> String {
//        let serverPath: String = BASEURL
//        let serverPath: String = "https://app.sanskargroup.in/data_model"
        let serverPath: String =  "https://app.sanskargroup.in/data_model"  //"https://app.sanskargroup.in/sanskar_development/data_model/"
        return serverPath
    }
    
    class func getFullPath(path: String) -> String {
        
        var fullPath: String!
        fullPath = HttpHelper.getServerPath()
        fullPath.append("/")
        fullPath.append(path)
        let escapedAddress: String = fullPath.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        return escapedAddress
        
    }
    class func setHeader() -> Dictionary<String, String> {
        
        var dict = Dictionary<String,String>()
        
        dict["jwt"] = ""
       
        return dict
    }
    
    class func json(from object:AnyObject) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func setRequest(dict: NSDictionary, url: String)->NSMutableURLRequest{
        let request = NSMutableURLRequest(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 50 // 10 secs
        let values = ["key": "value"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        return request
    }
    class  func convertToDictionary(text: String) -> [String: Any]?
    {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //post
    /// Call the function and pass api
    /// - Parameters:
    ///   - postData: Parameter as [String: Any]
    ///   - url: API Url
    ///   - identifire: Option identifier to handle check
    ///   - completionHandler: response handling code
    class func apiCall(postData:NSDictionary, url: String, identifire : String = "",  completionHandler: @escaping responseHandler) {
        let path: String = HttpHelper.getFullPath(path: url)
     
        print("Request URL ->  \(path)")
        print("Request parameter ->  \(postData.jsonStringRepresentation?.description ?? "")")
        
        print("Request Header ->  \(HttpHelper.setHeader().jsonStringRepresentation?.description ?? "")")

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    if value is NSArray{
                        let str = HttpHelper.json(from:(value as AnyObject))
                        multipartFormData.append((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                    else{
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path,
            headers:HttpHelper.setHeader(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                      //  print("HTTP URLResponse -> \(String(describing: response.response))")

                        if response.result.value is NSDictionary
                        {
                            print("HTTP Response Value -> \((response.result.value as! NSDictionary).jsonStringRepresentation ?? "")")
                            
                            completionHandler(true,response.result.value as! NSDictionary?,nil,response.data)
                        }
                        else{
                            print("HTTP Response Value -> \(String(describing: response.result.value))")
                            
                            completionHandler(true,nil,nil,response.data)
                        }
                    }
                case .failure(let encodingError):
//                    Loader.hideLoader()
                    print(encodingError)
                    completionHandler(false,nil,encodingError as NSError?,nil)
                }
            }
        )
    }
    
    class func apiCallWithout(postData:NSDictionary,url: String,identifire : String, completionHandler: @escaping responseHandler ) {
        let path: String = HttpHelper.getFullPath(path: url)
        
        print("Request URL ->  \(path)")
        print("Request parameter ->  \(postData.jsonStringRepresentation?.description ?? "")")
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    if value is NSArray{
                        let str = HttpHelper.json(from:(value as AnyObject))
                        multipartFormData.append((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                    else{
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path,
            headers:[:],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        //  print("HTTP URLResponse -> \(String(describing: response.response))")

                          if response.result.value is NSDictionary
                          {
                              print("HTTP Response Value -> \((response.result.value as! NSDictionary).jsonStringRepresentation ?? "")")
                              
                              completionHandler(true,response.result.value as! NSDictionary?,nil,response.data)
                          }
                          else{
                              print("HTTP Response Value -> \(String(describing: response.result.value))")
                              
                              completionHandler(true,nil,nil,response.data)
                          }
                      }
                case .failure(let encodingError):
//                    Loader.hideLoader()
                    print(encodingError)
                    completionHandler(false,nil,encodingError as NSError?,nil)
                }
            }
        )
    }

    
    class func apiCall2(postData:NSDictionary,url: String,identifire : String, completionHandler: @escaping (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        let path: String = HttpHelper.getFullPath(path: url)
        
        print(path)
        print(postData)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    print(key , value)
                    if value is NSArray{
                        let str = HttpHelper.json(from:(value as AnyObject))
                        multipartFormData.append((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                    else{
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path,
            headers:HttpHelper.setHeader(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    upload.responseString { response in
                        debugPrint(upload.responseString)
                        if response.result.value is NSDictionary
                        {
                            completionHandler(true,response.result.value as! NSDictionary?,nil,"response")
                        }
                        else{
                            completionHandler(true,nil,nil,"response")
                        }
                    }
                case .failure(let encodingError):
//                    Loader.hideLoader()
                    print(encodingError)
                    completionHandler(false,nil,encodingError as NSError?,"response")
                }
            }
        )
    }
    
    // MARK: MULTIPART POST
    class func apiCall1(_ postData:NSDictionary, _ url: String , _ identifire : String, completionHandler: @escaping (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        let path: String = HttpHelper.getFullPath(path: url)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    print(key , value)
                    if value is NSArray{
                        let str = HttpHelper.json(from:(value as AnyObject))
                        multipartFormData.append((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                    else{
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path,
            headers: [:],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        debugPrint(response)
                        completionHandler(true,response.result.value as! NSDictionary?,nil,"response")
                    }
                case .failure(let encodingError):
//                    Loader.hideLoader()
                    print(encodingError)
                    completionHandler(false,nil,encodingError as NSError?,"response")
                }
            }
        )
    }
    //get request
    class func getDetailFromYouTubeURL(url:String, completionHandler: @escaping (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            debugPrint(response)
            
            if let dict = response.result.value{
                completionHandler(true, dict as? NSDictionary ,nil,"response")
            }
            else{
//                Loader.hideLoader()
                completionHandler(false,nil,response.result.error as NSError?,"response")
            }
        }
    }
}

struct BodyStringEncoding: ParameterEncoding {
    
    private let body: String
    
    init(body: String) { self.body = body }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}

extension BodyStringEncoding.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyURLRequest: return "Empty url request"
        case .encodingProblem: return "Encoding problem"
        }
    }
}


extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}

extension NSDictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}

extension Array {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}



