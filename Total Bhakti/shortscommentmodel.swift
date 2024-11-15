//
//  shortscommentmodel.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 15/05/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import Foundation

struct CommentResponse: Codable {
    let status: Bool
    let message: String
    let data: [Comment]
    let error: [String]
}

struct Comment: Codable {
    let id: String
    let userId: String
    let type: String
    let typeId: String
    let comments: String
    let creationTime: String
    let userMobile: String
    let userEmail: String

    enum CodingKeys: String, CodingKey {
        case id, type, comments
        case userId = "user_id"
        case typeId = "type_id"
        case creationTime = "creation_time"
        case userMobile = "user_mobile"
        case userEmail = "user_email"
    }
}



struct ShortVideoResponse: Codable {
    let status: Bool
    let message: String
    let data: [ShortVideo]
    let error: [String]
}

struct ShortVideo: Codable {
    let id: String
    let title: String
    let description: String
    let thumbnail: String
    let video_url: String
    let total_share: String
    var total_like: String
    var is_liked: String
    var total_comments: String
}
