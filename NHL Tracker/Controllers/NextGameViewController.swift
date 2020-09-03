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
        
        //Hide for now, will need to unhide depending on API response
        //previousGameLabel.isHidden = true
        //Setup date formatter formats
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatterPrint.dateFormat = "MMM dd, yyyy @HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Decide label initial values based on saved favourite team
        if let savedFavouriteTeam = dataPersistence.loadFavouriteNHLTeam() {
            let favouriteTeamName = savedFavouriteTeam.favouriteTeam
            
            var nextGameAvailable = false
            
            favTeamTitle.text = favouriteTeamName + " Next Game"
            favTeamTitle.textColor = .black
            
            //Get the next game of the users favourite team
            nhlApiServices.fetchNextGame(teamID: savedFavouriteTeam.favouriteTeamNumber) { responseObject, error in
                guard let responseObject = responseObject, error == nil else {
                    print(error ?? "Unknown error")
                    return
                }
                //Check if there is a scheduled next game to display
                if let nextGame = responseObject.teams[0].nextGameSchedule {
                    nextGameAvailable = true
                    self.previousGameLabel.isHidden = true
                    
                    let homeGame = self.gameHelper.decideHomeOrAway(teams: nextGame.dates[0].games[0].teams, favTeam: favouriteTeamName)
                    DispatchQueue.main.async {
                        self.team1Label.text = self.teamConversions.teamNameToShortName(teamToConvert: favouriteTeamName)
                        self.cityLabel.text = "@" + nextGame.dates[0].games[0].venue.name
                        
                        //Format date to display on the screen
                        if let date = self.dateFormatterGet.date(from: nextGame.dates[0].games[0].gameDate) {
                            self.timeLabel.text = self.dateFormatterPrint.string(from: date)
                        }
                        
                        if (homeGame) {
                            //Bold home team
                            self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                            self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                            
                            self.team2label.text = self.teamConversions.teamNameToShortName(teamToConvert: nextGame.dates[0].games[0].teams.away.team.name)
                            self.record2Label.text = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.away.leagueRecord)
                            self.record1Label.text = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.home.leagueRecord)
                        }
                        else {
                            //Bold home team
                            self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                            self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                            
                            self.team2label.text = self.teamConversions.teamNameToShortName(teamToConvert: nextGame.dates[0].games[0].teams.home.team.name)
                            self.record2Label.text = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.home.leagueRecord)
                            self.record1Label.text = self.gameHelper.formatRecord(leagueRecord: nextGame.dates[0].games[0].teams.away.leagueRecord)
                        }
                        
                    }
                }
            }
            
            //Fetch previous game if a next game is unavailable
            if !nextGameAvailable {
                //Get the previous game of the users favourite team
                nhlApiServices.fetchPreviousGame(teamID: savedFavouriteTeam.favouriteTeamNumber) { responseObject, error in
                    guard let responseObject = responseObject, error == nil else {
                        print(error ?? "Unknown error")
                        return
                    }
                    
                    //Check if there is a previous game to display
                    if let previousGame = responseObject.teams[0].previousGameSchedule {
                        self.previousGameLabel.isHidden = false
                        
                        let homeGame = self.gameHelper.decideHomeOrAway(teams: previousGame.dates[0].games[0].teams, favTeam: favouriteTeamName)
                        DispatchQueue.main.async {
                            self.team1Label.text = self.teamConversions.teamNameToShortName(teamToConvert: favouriteTeamName)
                            self.cityLabel.text = "@" + previousGame.dates[0].games[0].venue.name
                            
                            //Format date to display on the screen
                            if let date = self.dateFormatterGet.date(from: previousGame.dates[0].games[0].gameDate) {
                                self.timeLabel.text = self.dateFormatterPrint.string(from: date)
                            }
                            
                            if (homeGame) {
                                //Bold home team
                                self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                                self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                                
                                self.team2label.text = self.teamConversions.teamNameToShortName(teamToConvert: previousGame.dates[0].games[0].teams.away.team.name)
                                self.record2Label.text = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.away.leagueRecord)
                                self.record1Label.text = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.home.leagueRecord)
                            }
                            else {
                                //Bold home team
                                self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                                self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                                
                                self.team2label.text = self.teamConversions.teamNameToShortName(teamToConvert: previousGame.dates[0].games[0].teams.home.team.name)
                                self.record2Label.text = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.home.leagueRecord)
                                self.record1Label.text = self.gameHelper.formatRecord(leagueRecord: previousGame.dates[0].games[0].teams.away.leagueRecord)
                            }
                        }
                    }
                }
            }
        }
        else {
            favTeamTitle.text = "Please select a favourite team"
            favTeamTitle.textColor = .systemRed
        }
    }


}

