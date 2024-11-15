//
//  holimodel.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 08/03/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import Foundation
struct Festival: Decodable {
    let title: String
    let guruName: String
    let description: String
    let location: String
    let profileLogo: String
    let thumbnail: String
    let guruProfile: String
    let publishedDate: String
    let startTime: String
    let endTime: String
    let invitationCode: String

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case guruName = "guru_name"
        case description = "description"
        case location    = "location"
        case profileLogo = "profile_logo"
        case thumbnail   = "thumbnail"
        case guruProfile = "guru_profile"
        case publishedDate = "published_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case invitationCode = "invitation_code"
    }
}
