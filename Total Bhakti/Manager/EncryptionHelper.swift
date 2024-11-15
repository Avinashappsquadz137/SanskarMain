//
//  EncryptionHelper.swift
//  Sanskar
//
//  Created by Warln on 01/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import Foundation

class EncryptionHelper: NSObject {
    
    class func getAesKey(char:Character) -> Character {
        
        switch char {
        case "0":
            return "!"
        case "1":
            return "*"
        case "2":
            return "@"
        case "3":
            return "#"
        case "4":
            return ")"
        case "5":
            return "("
        case "6":
            return "$"
        case "7":
            return "^"
        case "8":
            return "%"
        case "9":
            return "1"
        default:
            return "\0"
        }
        
    }
    
    class func getVI(char:Character) -> Character {
        switch char {
        case "0":
            return "?"
        case "1":
            return "\\"
        case "2":
            return ":"
        case "3":
            return ">"
        case "4":
            return "<"
        case "5":
            return "{"
        case "6":
            return "}"
        case "7":
            return "@"
        case "8":
            return "#"
        case "9":
            return "V"
        default:
            return "\0"
        }
        //        print(self.genretedAesKey)
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
}

//extension Dictionary {
//    var jsonStringRepresentation: String? {
//        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
//                                                            options: [.prettyPrinted]) else {
//            return nil
//        }
//        return String(data: theJSONData, encoding: .ascii)
//    }
//}

