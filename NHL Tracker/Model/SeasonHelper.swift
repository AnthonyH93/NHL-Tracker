//
//  SeasonHelper.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-07.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct SeasonHelper {

    //Function to format seasonID returned from api
    func formatSeasonID(seasonID: String) -> String {
        var year1 = seasonID
        if (year1.count > 4) {
            year1.removeLast(4)
        }
        var year2 = seasonID
        if (year2.count > 4) {
            year2.removeFirst(4)
        }
        return "\(year1)-\(year2)"
    }
    
    //Function to format the table view section title to be the correct length
    func formatSectionTitle(teamAndSeason: String) -> String {
        if (teamAndSeason.count > 29) {
            return "\(teamAndSeason) Games"
        }
        else {
            return "\(teamAndSeason) Schedule"
        }
    }
}
