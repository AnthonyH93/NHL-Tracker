//
//  HelperFunctions.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-08-30.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

//Struct for representing various helper functions used for converting different data for NHL teams
struct TeamConversions {
    //Function to convert team to ID for the nhlapi
    func teamNameToID(teamToConvert: String) -> Int64 {
        //Map team name string to IDs
        var teamID: Int64 = 0
        
        switch teamToConvert {
        case "New Jersey Devils":
            teamID = 1
        case "New York Islanders":
            teamID = 2
        case "New York Rangers":
            teamID = 3
        case "Philadelphia Flyers":
            teamID = 4
        case "Pittsburgh Penguins":
            teamID = 5
        case "Boston Bruins":
            teamID = 6
        case "Buffalo Sabres":
            teamID = 7
        case "Montreal Canadiens":
            teamID = 8
        case "Ottawa Senators":
            teamID = 9
        case "Toronto Maple Leafs":
            teamID = 10
        case "Carolina Hurricanes":
            teamID = 12
        case "Florida Panthers":
            teamID = 13
        case "Tampa Bay Lightning":
            teamID = 14
        case "Washington Capitals":
            teamID = 15
        case "Chicago Blackhawks":
            teamID = 16
        case "Detroit Red Wings":
            teamID = 17
        case "Nashville Predators":
            teamID = 18
        case "St. Louis Blues":
            teamID = 19
        case "Calgary Flames":
            teamID = 20
        case "Colorado Avalanche":
            teamID = 21
        case "Edmonton Oilers":
            teamID = 22
        case "Vancouver Canucks":
            teamID = 23
        case "Anaheim Ducks":
            teamID = 24
        case "Dallas Stars":
            teamID = 25
        case "Los Angeles Kings":
            teamID = 26
        case "San Jose Sharks":
            teamID = 28
        case "Columbus Blue Jackets":
            teamID = 29
        case "Minnesota Wild":
            teamID = 30
        case "Winnipeg Jets":
            teamID = 52
        case "Arizona Coyotes":
            teamID = 53
        case "Vegas Golden Knights":
            teamID = 54
        //NOTE: Future expansion team Seattle Kraken will be teamID 55
        default:
            //Not a valid team
            teamID = -1
        }
        return teamID
    }
    
    func teamNameToAlphabeticalIndex(teamToConvert: String) -> Int {
        var teamIndex: Int = 0
        
        switch teamToConvert {
        case "Anaheim Ducks":
            teamIndex = 0
        case "Arizona Coyotes":
            teamIndex = 1
        case "Boston Bruins":
            teamIndex = 2
        case "Buffalo Sabres":
            teamIndex = 3
        case "Calgary Flames":
            teamIndex = 4
        case "Carolina Hurricanes":
            teamIndex = 5
        case "Chicago Blackhawks":
            teamIndex = 6
        case "Colorado Avalanche":
            teamIndex = 7
        case "Columbus Blue Jackets":
            teamIndex = 8
        case "Dallas Stars":
            teamIndex = 9
        case "Detroit Red Wings":
            teamIndex = 10
        case "Edmonton Oilers":
            teamIndex = 11
        case "Florida Panthers":
            teamIndex = 12
        case "Los Angeles Kings":
            teamIndex = 13
        case "Minnesota Wild":
            teamIndex = 14
        case "Montreal Canadiens":
            teamIndex = 15
        case "Nashville Predators":
            teamIndex = 16
        case "New Jersey Devils":
            teamIndex = 17
        case "New York Islanders":
            teamIndex = 18
        case "New York Rangers":
            teamIndex = 19
        case "Ottawa Senators":
            teamIndex = 20
        case "Philadelphia Flyers":
            teamIndex = 21
        case "Pittsburgh Penguins":
            teamIndex = 22
        case "San Jose Sharks":
            teamIndex = 23
        case "St. Louis Blues":
            teamIndex = 24
        case "Tampa Bay Lightning":
            teamIndex = 25
        case "Toronto Maple Leafs":
            teamIndex = 26
        case "Vancouver Canucks":
            teamIndex = 27
        case "Vegas Golden Knights":
            teamIndex = 28
        case "Washington Capitals":
            teamIndex = 29
        case "Winnipeg Jets":
            teamIndex = 30
        //NOTE: Future expansion team Seattle Kraken will be teamID 55
        default:
            //Not a valid team
            fatalError("Not a valid NHL team")
        }
        return teamIndex
    }
}
