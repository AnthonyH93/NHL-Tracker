//
//  GameHelper.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-02.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct GameHelper {
    //Returns true if home game for favourite team, false if away game for favourite team
    func decideHomeOrAway(teams: Teams, favTeam: String) -> Bool {
        let homeTeamName = teams.home.team.name
        
        if (homeTeamName == favTeam) {
            return true
        }
        else {
            return false
        }
    }
    
    func formatRecord(leagueRecord: LeagueRecord) -> String {
        let wins = leagueRecord.wins
        let losses = leagueRecord.losses
        let ot = leagueRecord.ot
        
        return String("\(wins)-\(losses)-\(ot)")
    }
}
