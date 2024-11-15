//
//  EpChannel.swift
//  Sanskar
//
//  Created by Warln on 18/11/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import Foundation

class EpChannel : CustomStringConvertible {
    
    var id : String
    var name : String
    var channelUrl: String
    var imageUrl: String
    var programs: [Program]?
    init (id: String, name:String, channelUrl:String, imageUrl:String) {
        self.id = id
        self.name = name
        self.channelUrl = channelUrl
        self.imageUrl = imageUrl
    }
    var description: String {
        
        return "\(id) - \(name)"
    }
    
    
}
