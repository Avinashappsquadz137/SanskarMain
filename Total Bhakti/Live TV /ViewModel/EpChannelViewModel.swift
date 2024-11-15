//
//  EpChannelViewModel.swift
//  Sanskar
//
//  Created by Warln on 18/11/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import Foundation
import UIKit

class EpChannelViewModel {
    var epChannel : EpChannel
    var nameText : String
    var Url : URL?
    
    init (epChannel: EpChannel) {
        self.epChannel = epChannel
        self.nameText = epChannel.name
        self.Url = URL(string: epChannel.imageUrl)
    }
    
}
