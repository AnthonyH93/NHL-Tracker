//
//  NextGame.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-01.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct FullGame: Decodable {
    let dates: [Date]
}

struct Date: Decodable {
    let date: String
    let games: [Game]
}

struct Game: Decodable {
    let gamePk: Int
    let gameType: String
    let season: String
    let gameDate: String
    let status: Status
    let teams: Teams
    let venue: Venue
}

struct Status: Decodable {
    let abstractGameState: String
    let codedGameState: String
    let detailedState: String
    let statusCode: String
    let startTimeTBD: Bool
}

struct Teams: Decodable {
    let away: Team
    let home: Team
}

struct Team: Decodable {
    let leagueRecord: LeagueRecord
    let score: Int
    let team: BasicTeam
}

struct Venue: Decodable {
    let name: String
}

struct BasicTeam: Decodable {
    let id: Int
    let name: String
}

struct LeagueRecord: Decodable {
    let wins: Int
    let losses: Int
    let ot: Int
}
