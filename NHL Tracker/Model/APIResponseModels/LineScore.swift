//
//  LineScore.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-03.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct LineScore: Decodable {
    let currentPeriod: Int
    let currentPeriodOrdinal: String?
    let currentPeriodTimeRemaining: String?
    let teams: LineScoreTeams
}

struct LineScoreTeams: Decodable {
    let home: LineScoreTeam
    let away: LineScoreTeam
}

struct LineScoreTeam: Decodable {
    let team: BasicTeam
    let goals: Int
    let shotsOnGoal: Int
    let goaliePulled: Bool
    let powerPlay: Bool
}
