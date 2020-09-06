//
//  Season.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-06.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct SeasonResponse: Decodable {
    let seasons: [Season]
}

struct Season: Decodable {
    let seasonID: String
    let regularSeasonStartDate: String
    let regularSeasonEndDate: String
    let numberOfGames: Int
}
