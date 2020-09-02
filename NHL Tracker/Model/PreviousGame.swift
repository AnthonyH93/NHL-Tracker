//
//  PreviousGame.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-01.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct OuterTeam_Previous: Decodable {
    let teams: [FullTeam_Previous]
}

struct FullTeam_Previous: Decodable {
    let name: String
    let previousGameSchedule: FullGame?
}
