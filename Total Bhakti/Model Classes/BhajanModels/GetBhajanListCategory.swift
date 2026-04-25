//
//  GetBhajanListCategory.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 25/04/26.
//  Copyright © 2026 MAC MINI. All rights reserved.
//
import Foundation

struct BhajanCategoryResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [BhajanCategory]?
}

struct BhajanCategory: Codable, Identifiable, Hashable {
    let category_name: String?
    let category_id: String?
    
    var id: String {
        category_id ?? category_name ?? UUID().uuidString
    }
    
    var title: String {
        category_name ?? "Unknown"
    }
}


struct GetBhajanListCategory : Codable {
    let status : Bool?
    let message : String?
    let data : [BhajanListCategory]?
    let error : APIError?

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
        data = try values.decodeIfPresent([BhajanListCategory].self, forKey: .data)
        error = try values.decodeIfPresent(APIError.self, forKey: .error)
    }

}

struct BhajanListCategory : Codable {
    let category_name : String?
    let bhajan : [BhajanList]?

    enum CodingKeys: String, CodingKey {

        case category_name = "category_name"
        case bhajan = "bhajan"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
        bhajan = try values.decodeIfPresent([BhajanList].self, forKey: .bhajan)
    }

}

struct BhajanList : Codable {
    let id : String?
    let title : String?
    let description : String?
    let image : String?
    let thumbnail1 : String?
    let thumbnail2 : String?
    let media_file : String?
    let artist_name : String?
    let artist_image : String?
    let mobile_menu_ids : String?
    let category : String?
    let related_guru : String?
    let artists_id : String?
    let god_id : String?
    let god_name : String?
    let god_image : String?
    let likes : String?
    let play_count : String?
    let creation_time : String?
    let published_date : String?
    let status : String?
    let uploaded_by : String?
    let deleted_by : String?
    let direct_play : String?
    let is_like : String?
    let category_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case description = "description"
        case image = "image"
        case thumbnail1 = "thumbnail1"
        case thumbnail2 = "thumbnail2"
        case media_file = "media_file"
        case artist_name = "artist_name"
        case artist_image = "artist_image"
        case mobile_menu_ids = "mobile_menu_ids"
        case category = "category"
        case related_guru = "related_guru"
        case artists_id = "artists_id"
        case god_id = "god_id"
        case god_name = "god_name"
        case god_image = "god_image"
        case likes = "likes"
        case play_count = "play_count"
        case creation_time = "creation_time"
        case published_date = "published_date"
        case status = "status"
        case uploaded_by = "uploaded_by"
        case deleted_by = "deleted_by"
        case direct_play = "direct_play"
        case is_like = "is_like"
        case category_name = "category_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        thumbnail1 = try values.decodeIfPresent(String.self, forKey: .thumbnail1)
        thumbnail2 = try values.decodeIfPresent(String.self, forKey: .thumbnail2)
        media_file = try values.decodeIfPresent(String.self, forKey: .media_file)
        artist_name = try values.decodeIfPresent(String.self, forKey: .artist_name)
        artist_image = try values.decodeIfPresent(String.self, forKey: .artist_image)
        mobile_menu_ids = try values.decodeIfPresent(String.self, forKey: .mobile_menu_ids)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        related_guru = try values.decodeIfPresent(String.self, forKey: .related_guru)
        artists_id = try values.decodeIfPresent(String.self, forKey: .artists_id)
        god_id = try values.decodeIfPresent(String.self, forKey: .god_id)
        god_name = try values.decodeIfPresent(String.self, forKey: .god_name)
        god_image = try values.decodeIfPresent(String.self, forKey: .god_image)
        likes = try values.decodeIfPresent(String.self, forKey: .likes)
        play_count = try values.decodeIfPresent(String.self, forKey: .play_count)
        creation_time = try values.decodeIfPresent(String.self, forKey: .creation_time)
        published_date = try values.decodeIfPresent(String.self, forKey: .published_date)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        uploaded_by = try values.decodeIfPresent(String.self, forKey: .uploaded_by)
        deleted_by = try values.decodeIfPresent(String.self, forKey: .deleted_by)
        direct_play = try values.decodeIfPresent(String.self, forKey: .direct_play)
        is_like = try values.decodeIfPresent(String.self, forKey: .is_like)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
    }

}

struct APIError: Codable {}

extension GetBhajanListCategory {
    var flattenedBhajansWithCategory: [(item: BhajanList, categoryName: String?)] {
        return data?.flatMap { categoryBlock in
            (categoryBlock.bhajan ?? []).map { item in
                (item: item, categoryName: item.category_name ?? categoryBlock.category_name)
            }
        } ?? []
    }
}
