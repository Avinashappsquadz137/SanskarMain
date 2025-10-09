//
//  MoreLikeThisModels.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 09/10/25.
//  Copyright © 2025 MAC MINI. All rights reserved.
//
import Foundation
struct MoreLikeThisModels : Codable {
    let status : Bool?
    let message : String?
    let data : [MoreLikeThis]?
    let error : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([MoreLikeThis].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct MoreLikeThis : Codable {
    let season_id : String?
    let season_title : String?
    let description : String?
    let season_thumbnail : String?
    let vertical_banner : String?
    let custom_promo_video : String?
    let short_video : String?
    let yt_short_video : String?
    let promo_video : String?
    let yt_promo_video : String?
    let author_id : String?
    let author_name : String?
    let category_id : String?
    let categories : String?

    enum CodingKeys: String, CodingKey {

        case season_id = "season_id"
        case season_title = "season_title"
        case description = "description"
        case season_thumbnail = "season_thumbnail"
        case vertical_banner = "vertical_banner"
        case custom_promo_video = "custom_promo_video"
        case short_video = "short_video"
        case yt_short_video = "yt_short_video"
        case promo_video = "promo_video"
        case yt_promo_video = "yt_promo_video"
        case author_id = "author_id"
        case author_name = "author_name"
        case category_id = "category_id"
        case categories = "categories"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        season_id = try values.decodeIfPresent(String.self, forKey: .season_id)
        season_title = try values.decodeIfPresent(String.self, forKey: .season_title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        season_thumbnail = try values.decodeIfPresent(String.self, forKey: .season_thumbnail)
        vertical_banner = try values.decodeIfPresent(String.self, forKey: .vertical_banner)
        custom_promo_video = try values.decodeIfPresent(String.self, forKey: .custom_promo_video)
        short_video = try values.decodeIfPresent(String.self, forKey: .short_video)
        yt_short_video = try values.decodeIfPresent(String.self, forKey: .yt_short_video)
        promo_video = try values.decodeIfPresent(String.self, forKey: .promo_video)
        yt_promo_video = try values.decodeIfPresent(String.self, forKey: .yt_promo_video)
        author_id = try values.decodeIfPresent(String.self, forKey: .author_id)
        author_name = try values.decodeIfPresent(String.self, forKey: .author_name)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        categories = try values.decodeIfPresent(String.self, forKey: .categories)
    }

}

