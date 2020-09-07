//
//  SeasonGame.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-07.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

//Class to represent a season game for the season game table view cell
class SeasonGame {
    
    //MARK: Initialization
    //Prepares and instance of a class for use
    init(homeTeamName: String, awayTeamName: String, homeTeamScore: Int, awayTeamScore: Int, time: String, arena: String, isHomeGame: Bool) {
        //Initialize stored properties
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.homeTeamScore = homeTeamScore
        self.awayTeamScore = awayTeamScore
        self.time = time
        self.arena = arena
        self.isHomeGame = isHomeGame
    }
    
    //MARK: Properties
    let homeTeamName: String
    let awayTeamName: String
    let homeTeamScore: Int
    let awayTeamScore: Int
    let time: String
    let arena: String
    let isHomeGame: Bool
}
