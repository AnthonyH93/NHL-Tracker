//
//  Constants.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-08-29.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation
 
struct NHLTrackerConstants {
    //Picker Favourite Teams
    let NHLTeamsStringArray: [String] = [ "Anaheim Ducks",
                                          "Arizona Coyotes",
                                          "Boston Bruins",
                                          "Buffalo Sabres",
                                          "Calgary Flames",
                                          "Carolina Hurricanes",
                                          "Chicago Blackhawks",
                                          "Colorado Avalanche",
                                          "Columbus Blue Jackets",
                                          "Dallas Stars",
                                          "Detroit Red Wings",
                                          "Edmonton Oilers",
                                          "Florida Panthers",
                                          "Los Angeles Kings",
                                          "Minnesota Wild",
                                          "Montreal Canadians",
                                          "Nashville Predators",
                                          "New Jersey Devils",
                                          "New York Islanders",
                                          "New York Rangers",
                                          "Ottawa Senators",
                                          "Philadelphia Flyers",
                                          "Pittsburgh Penguins",
                                          "San Jose Sharks",
                                          "St. Louis Blues",
                                          "Tampa Bay Lightning",
                                          "Toronto Maple Leafs",
                                          "Vancouver Canucks",
                                          "Vegas Golden Knights",
                                          "Washington Capitals",
                                          "Winnipeg Jets" ]
    
    let favouriteTeamAlertTitle: String = "Favourite Team Updated"
    
    let favouriteTeamAlertMessage: String = "You have updated your favourite team to "
    
    let errorAlertTitle: String = "Error Retrieving Data"
    
    let errorAlertMessage: String = "An error occurred while retrieving data, please check your internet connection and try again."
}
