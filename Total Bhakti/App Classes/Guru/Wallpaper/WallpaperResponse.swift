//
//  WallpaperResponse.swift
//  Sanskar
//
//  Created by Warln on 14/04/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import Foundation

struct WallpaperResponse: Decodable {
    let data: [WallMenu]
}

struct WallMenu: Decodable {
    let category_name: String
    let id: String
    let wallpaper: [WallData]
}

struct WallData: Decodable {
    let title: String
    let wallpaper: String
}

struct WallDetailResponse: Decodable {
    let data: [WallData]
}


