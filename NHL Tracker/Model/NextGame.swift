//
//  NextGame.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-02.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct OuterTeam_Next: Decodable {
    let teams: [FullTeam_Next]
}

struct FullTeam_Next: Decodable {
    let name: String
    let nextGameSchedule: FullGame?
}
