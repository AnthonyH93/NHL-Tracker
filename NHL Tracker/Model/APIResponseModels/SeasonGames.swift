//
//  SeasonGames.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-09.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct Seasongames: Decodable {
    let totalGames: Int
    let dates: [FullGame]
}
