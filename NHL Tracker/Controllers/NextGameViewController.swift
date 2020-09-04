//
//  FirstViewController.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-08-29.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class NextGameViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var favTeamTitle: UILabel!
    @IBOutlet weak var previousGameLabel: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2label: UILabel!
    @IBOutlet weak var record1Label: UILabel!
    @IBOutlet weak var record2Label: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var score1Label: UILabel!
    @IBOutlet weak var score2Label: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var gameStateLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    
    let dataPersistence = DataPersistence()
    let nhlApiServices = NHLApiServices()
    let teamConversions = TeamConversions()
    let gameHelper = GameHelper()
    
    let dateFormatterGet = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favTeamTitle.adjustsFontSizeToFitWidth = true
        team1Label.adjustsFontSizeToFitWidth = true
        team2label.adjustsFontSizeToFitWidth = true
        
        //Setup date formatter formats
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatterPrint.dateFormat = "MMM dd, yyyy @HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //UI element variables
        var nextGameTeam1 = ""
        var nextGameTeam2 = ""
        var nextGameRecord1 = ""
        var nextGameRecord2 = ""
        var nextGameDate = ""
        var nextGameVenue = ""
        var nextGameIsHome = false
        var nextGameStatus = ""
        
        var prevGameTeam1 = ""
        var prevGameTeam2 = ""
        var prevGameRecord1 = ""
        var prevGameRecord2 = ""
        var prevGameDate = ""
        var prevGameVenue = ""
        var prevGameIsHome = false
        var prevGameStatus = ""
        
        var nextGameAvailable = false
        var prevGameAvailable = false
        
        //Decide label initial values based on saved favourite team
        if let savedFavouriteTeam = dataPersistence.loadFavouriteNHLTeam() {
            let favouriteTeamName = savedFavouriteTeam.favouriteTeam
            
            favTeamTitle.text = favouriteTeamName + " Next Game"
            favTeamTitle.textColor = .black
            
            let queue = OperationQueue()
            
            //Call both APIs first, then change UI elements based on responses
            let operation1 = BlockOperation {
                let group = DispatchGroup()
                group.enter()
                self.nhlApiServices.fetchNextGame(teamID: savedFavouriteTeam.favouriteTeamNumber) { responseObject, error in
                    guard let responseObject = responseObject, error == nil else {
                        print(error ?? "Unknown error with next game")
                        return
                    }
                    
                    //Check if there is a scheduled next game to display
                    if let nextGame = responseObject.teams[0].nextGameSchedule {
                        nextGameAvailable = true
                        nextGameIsHome = self.gameHelper.decideHomeOrAway(teams: nextGame.dates[0].games[0].teams, favTeam: favouriteTeamName)
                        nextGameTeam1 = self.teamConversions.teamNameToShortName(teamToConvert: favouriteTeamName)
                        nextGameVenue = "@" + nextGame.dates[0].games[0].venue.name
                        nextGameStatus = nextGame.dates[0].games[0].status.detailedState
                        
                        //Format date to display on the screen
                        if let date = self.dateFormatterGet.date(from: nextGame.dates[0].games[0].gameDate) {
                            nextGameDate = self.dateFormatterPrint.string(from: date)
                        }
                        if (nextGameIsHome) {
                            nextGameTeam2 = self.teamConversions.teamNameToShortName(teamToConvert: nextGame.dates[0].games[0].teams.away.team.name)
                            nextGameRecord2 = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.away.leagueRecord)
                            nextGameRecord1 = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.home.leagueRecord)
                        }
                        else {
                            nextGameTeam2 = self.teamConversions.teamNameToShortName(teamToConvert: nextGame.dates[0].games[0].teams.home.team.name)
                            nextGameRecord2 = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.home.leagueRecord)
                            nextGameRecord1 = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.away.leagueRecord)
                        }
                    }
                    group.leave()
                }
                
                group.enter()
                //Get the previous game of the users favourite team
                self.nhlApiServices.fetchPreviousGame(teamID: savedFavouriteTeam.favouriteTeamNumber) { responseObject, error in
                    guard let responseObject = responseObject, error == nil else {
                        print(error ?? "Unknown error with previous game")
                        return
                    }
                    //Check if there is a previous game to display
                    if let previousGame = responseObject.teams[0].previousGameSchedule {
                        prevGameAvailable = true
                        prevGameIsHome = self.gameHelper.decideHomeOrAway(teams: previousGame.dates[0].games[0].teams, favTeam: favouriteTeamName)
                        prevGameTeam1 = self.teamConversions.teamNameToShortName(teamToConvert: favouriteTeamName)
                        prevGameVenue = "@" + previousGame.dates[0].games[0].venue.name
                        prevGameStatus = previousGame.dates[0].games[0].status.detailedState
                        
                        //Format date to display on the screen
                        if let date = self.dateFormatterGet.date(from: previousGame.dates[0].games[0].gameDate) {
                            prevGameDate = self.dateFormatterPrint.string(from: date)
                        }
                        if (prevGameIsHome) {
                            prevGameTeam2 = self.teamConversions.teamNameToShortName(teamToConvert: previousGame.dates[0].games[0].teams.away.team.name)
                            prevGameRecord2 = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.away.leagueRecord)
                            prevGameRecord1 = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.home.leagueRecord)
                        }
                        else {
                            prevGameTeam2 = self.teamConversions.teamNameToShortName(teamToConvert: previousGame.dates[0].games[0].teams.home.team.name)
                            prevGameRecord2 = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.home.leagueRecord)
                            prevGameRecord1 = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.away.leagueRecord)
                        }
                    }
                    group.leave()
                }
                group.wait()
            }
            
            //Operation to update UI after API calls are complete
            let operation2 = BlockOperation {
                //Update UI based on the result of the API calls
                DispatchQueue.main.async {
                    //Prioritize next game if it is available
                    if (nextGameAvailable){
                        self.previousGameLabel.isHidden = true
                        self.team1Label.text = nextGameTeam1
                        self.team2label.text = nextGameTeam2
                        self.record1Label.text = nextGameRecord1
                        self.record2Label.text = nextGameRecord2
                        self.timeLabel.text = nextGameDate
                        self.cityLabel.text = nextGameVenue
                        self.gameStateLabel.text = self.gameHelper.fixStatusCode(statusCode: nextGameStatus)
                        
                        //Bold the home team
                        if (nextGameIsHome) {
                            self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                            self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                        }
                        else {
                            self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                            self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                        }
                    }
                    else {
                        if (prevGameAvailable){
                            self.previousGameLabel.isHidden = false
                            self.team1Label.text = prevGameTeam1
                            self.team2label.text = prevGameTeam2
                            self.record1Label.text = prevGameRecord1
                            self.record2Label.text = prevGameRecord2
                            self.timeLabel.text = prevGameDate
                            self.cityLabel.text = prevGameVenue
                            self.gameStateLabel.text = self.gameHelper.fixStatusCode(statusCode: prevGameStatus)
                            
                            //Bold the home team
                            if (prevGameIsHome) {
                                self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                                self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                            }
                            else {
                                self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                                self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                            }
                        }
                    }
                }
            }
            
            //Block the UI updates until all API calls are finished
            operation2.addDependency(operation1)
            
            //Add operations to the operation queue
            queue.addOperation(operation1)
            queue.addOperation(operation2)
            
        }
        else {
            favTeamTitle.text = "Please select a favourite team"
            favTeamTitle.textColor = .systemRed
        }
    }
}
