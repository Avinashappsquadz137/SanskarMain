//
//  MxModel.swift
//  Sanskar
//
//  Created by Warln on 07/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import Foundation

struct MxModel : Codable {
    let status : Bool?
    let message : String?
    let days : [[MXDays]]?
    let error : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case days = "Days"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        days = try values.decodeIfPresent([[MXDays]].self, forKey: .days)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct MXDays : Codable {
    let id : String?
    let name : String?
    let channel_url : String?
    let image : String?
    let release_date : String?
    let events : [MxEvents]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case channel_url = "channel_url"
        case image = "image"
        case release_date = "release_date"
        case events = "Events"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        channel_url = try values.decodeIfPresent(String.self, forKey: .channel_url)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
        events = try values.decodeIfPresent([MxEvents ].self, forKey: .events)
    }

}

struct MxEvents : Codable {
    let program_title : String?
    let thumbnail : String?
    let start_time : String?
    let start_time_milliseconds : Int?
    let duration : String?
    let duration_milliseconds : Int?
    let duration_minutes : Int?
    let end_time : String?
    let end_time_milliseconds : Int?

    enum CodingKeys: String, CodingKey {

        case program_title = "program_title"
        case thumbnail = "thumbnail"
        case start_time = "start_time"
        case start_time_milliseconds = "start_time_milliseconds"
        case duration = "duration"
        case duration_milliseconds = "duration_milliseconds"
        case duration_minutes = "duration_minutes"
        case end_time = "end_time"
        case end_time_milliseconds = "end_time_milliseconds"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        program_title = try values.decodeIfPresent(String.self, forKey: .program_title)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        start_time_milliseconds = try values.decodeIfPresent(Int.self, forKey: .start_time_milliseconds)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
        duration_milliseconds = try values.decodeIfPresent(Int.self, forKey: .duration_milliseconds)
        duration_minutes = try values.decodeIfPresent(Int.self, forKey: .duration_minutes)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        end_time_milliseconds = try values.decodeIfPresent(Int.self, forKey: .end_time_milliseconds)
    }

}


