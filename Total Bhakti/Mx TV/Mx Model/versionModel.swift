//
//  versionModel.swift
//  Sanskar
//
//  Created by Warln on 23/06/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import Foundation

struct VersionResponse: Decodable {
    let data: VersionData
}

struct VersionData: Decodable {
    let id: String
    let android: String
    let is_hard_update_android: String
    let ios: String
    let is_hard_update_ios: String
    let aws_sms_android: String
    let aws_sms_ios: String
    let show_ads: String
}

