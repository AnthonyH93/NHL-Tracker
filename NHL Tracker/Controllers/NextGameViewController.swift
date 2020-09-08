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
    @IBOutlet weak var shotsOnGoal1Label: UILabel!
    @IBOutlet weak var shotsOnGoal2Label: UILabel!
    @IBOutlet weak var powerPlayButton1: UIButton!
    @IBOutlet weak var powerPlayButton2: UIButton!
    @IBOutlet weak var emptyNetButton1: UIButton!
    @IBOutlet weak var emptyNetButton2: UIButton!
    @IBOutlet weak var powerPlayLabel1: UILabel!
    @IBOutlet weak var emptyNetLabel1: UILabel!
    @IBOutlet weak var powerPlayLabel2: UILabel!
    @IBOutlet weak var emptyNetLabel2: UILabel!
    
    let dataPersistence = DataPersistence()
    let nhlApiServices = NHLApiServices()
    let teamConversions = TeamConversions()
    let gameHelper = GameHelper()
    let constants = NHLTrackerConstants()
    
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
        
        var nextGamePK = 0
        var prevGamePK = 0
        
        var homeTeamScore = 0
        var awayTeamScore = 0
        var homeTeamSOG = 0
        var awayTeamSOG = 0
        var homeTeamPP = false
        var awayTeamPP = false
        var homeTeamEN = false
        var awayTeamEN = false
        var currentPeriod = ""
        var periodTimeLeft = ""
        
        //Decide label initial values based on saved favourite team
        if let savedFavouriteTeam = dataPersistence.loadFavouriteNHLTeam() {
            let favouriteTeamName = savedFavouriteTeam.favouriteTeam
            
            favTeamTitle.text = favouriteTeamName + " Next Game"
            favTeamTitle.textColor = .label
            
            let queue = OperationQueue()
            
            //Call both APIs first, then change UI elements based on responses
            let operation1 = BlockOperation {
                let group = DispatchGroup()
                group.enter()
                self.nhlApiServices.fetchNextGame(teamID: savedFavouriteTeam.favouriteTeamNumber) { responseObject, error in
                    guard let responseObject = responseObject, error == nil else {
                        print(error ?? "Unknown error with next game")
                        DispatchQueue.main.async {
                            self.displayErrorAlert()
                        }
                        return
                    }
                    
                    //Check if there is a scheduled next game to display
                    if let nextGame = responseObject.teams[0].nextGameSchedule {
                        nextGameAvailable = true
                        nextGameIsHome = self.gameHelper.decideHomeOrAway(teams: nextGame.dates[0].games[0].teams, favTeam: favouriteTeamName)
                        nextGameTeam1 = self.teamConversions.teamNameToShortName(teamToConvert: favouriteTeamName)
                        nextGameVenue = "@" + nextGame.dates[0].games[0].venue.name
                        nextGameStatus = nextGame.dates[0].games[0].status.detailedState
                        nextGamePK = nextGame.dates[0].games[0].gamePk
                        
                        //Format date to display on the screen
                        if let date = self.dateFormatterGet.date(from: nextGame.dates[0].games[0].gameDate) {
                            nextGameDate = self.dateFormatterPrint.string(from: date) + " EST"
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
                        DispatchQueue.main.async {
                            self.displayErrorAlert()
                        }
                        return
                    }
                    //Check if there is a previous game to display
                    if let previousGame = responseObject.teams[0].previousGameSchedule {
                        prevGameAvailable = true
                        prevGameIsHome = self.gameHelper.decideHomeOrAway(teams: previousGame.dates[0].games[0].teams, favTeam: favouriteTeamName)
                        prevGameTeam1 = self.teamConversions.teamNameToShortName(teamToConvert: favouriteTeamName)
                        prevGameVenue = "@" + previousGame.dates[0].games[0].venue.name
                        prevGameStatus = previousGame.dates[0].games[0].status.detailedState
                        prevGamePK = previousGame.dates[0].games[0].gamePk
                        
                        //Format date to display on the screen
                        if let date = self.dateFormatterGet.date(from: previousGame.dates[0].games[0].gameDate) {
                            prevGameDate = self.dateFormatterPrint.string(from: date) + " EST"
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
            
            
            //Operation to get the linescore of a game with the given PK found in either next game call or previous game call
            let operation2 = BlockOperation {
                let group = DispatchGroup()
                if (nextGameAvailable) {
                    group.enter()
                    //Use the next game if it was found, score might not exist if the game hasn't started
                    self.nhlApiServices.fetchLineScore(teamPK: nextGamePK) { responseObject, error in
                        guard let responseObject = responseObject, error == nil else {
                            print(error ?? "Unknown error with line score")
                            DispatchQueue.main.async {
                                self.displayErrorAlert()
                            }
                            return
                        }
                        //Use the response object and extract data needed
                        homeTeamScore = responseObject.teams.home.goals
                        awayTeamScore = responseObject.teams.away.goals
                        currentPeriod = responseObject.currentPeriodOrdinal ?? ""
                        periodTimeLeft = responseObject.currentPeriodTimeRemaining ?? ""
                        homeTeamSOG = responseObject.teams.home.shotsOnGoal
                        awayTeamSOG = responseObject.teams.away.shotsOnGoal
                        homeTeamPP = responseObject.teams.home.powerPlay
                        awayTeamPP = responseObject.teams.away.powerPlay
                        homeTeamEN = responseObject.teams.home.goaliePulled
                        awayTeamEN = responseObject.teams.away.goaliePulled
                        group.leave()
                    }
                    group.wait()
                }
                else {
                    if (prevGameAvailable) {
                        group.enter()
                        //Use the previous game if the next game was not found and the previous game was found
                        self.nhlApiServices.fetchLineScore(teamPK: prevGamePK) { responseObject, error in
                            guard let responseObject = responseObject, error == nil else {
                                print(error ?? "Unknown error with line score")
                                DispatchQueue.main.async {
                                    self.displayErrorAlert()
                                }
                                return
                            }
                            //Use the response object and extract data needed
                            homeTeamScore = responseObject.teams.home.goals
                            awayTeamScore = responseObject.teams.away.goals
                            currentPeriod = responseObject.currentPeriodOrdinal ?? ""
                            homeTeamSOG = responseObject.teams.home.shotsOnGoal
                            awayTeamSOG = responseObject.teams.away.shotsOnGoal
                            homeTeamPP = responseObject.teams.home.powerPlay
                            awayTeamPP = responseObject.teams.away.powerPlay
                            homeTeamEN = responseObject.teams.home.goaliePulled
                            awayTeamEN = responseObject.teams.away.goaliePulled
                            group.leave()
                        }
                        group.wait()
                    }
                }
            }
            //Operation to update UI after API calls are complete
            let operation3 = BlockOperation {
                //Update UI based on the result of the API calls
                DispatchQueue.main.async {
                    //Buttons and their labels should be hidden if the game is not in progress - will make them visible if game is in progress
                    self.powerPlayButton1.isHidden = true
                    self.powerPlayButton2.isHidden = true
                    self.emptyNetButton1.isHidden = true
                    self.emptyNetButton2.isHidden = true
                    self.powerPlayLabel1.isHidden = true
                    self.powerPlayLabel2.isHidden = true
                    self.emptyNetLabel1.isHidden = true
                    self.emptyNetLabel2.isHidden = true
                    //Prioritize next game if it is available
                    if (nextGameAvailable){
                        self.previousGameLabel.isHidden = true
                        self.periodLabel.isHidden = false
                        self.team1Label.text = nextGameTeam1
                        self.team2label.text = nextGameTeam2
                        self.record1Label.text = nextGameRecord1
                        self.record2Label.text = nextGameRecord2
                        self.timeLabel.text = nextGameDate
                        self.cityLabel.text = nextGameVenue
                        self.gameStateLabel.text = self.gameHelper.fixStatusCode(statusCode: nextGameStatus)
                        
                        //If the game has not started than there will not be a current perioud
                        if (currentPeriod != "") {
                            //If game is in progress then buttons and their labels should not be hidden
                            self.powerPlayButton1.isHidden = false
                            self.powerPlayButton2.isHidden = false
                            self.emptyNetButton1.isHidden = false
                            self.emptyNetButton2.isHidden = false
                            self.powerPlayLabel1.isHidden = false
                            self.powerPlayLabel2.isHidden = false
                            self.emptyNetLabel1.isHidden = false
                            self.emptyNetLabel2.isHidden = false
                            //Setup the button colours for the empty net and power play buttons
                            self.setupButtonColours(nextGameHome: nextGameIsHome, nextGameFound: nextGameAvailable, homeEN: homeTeamEN, awayEN: awayTeamEN, homePP: homeTeamPP, awayPP: awayTeamPP)
                            if (periodTimeLeft != "END") {
                                self.periodLabel.text = currentPeriod + " period with " + periodTimeLeft + " remaining"
                            }
                            else {
                                self.periodLabel.text = currentPeriod + " period " + periodTimeLeft.lowercased()
                            }
                        }
                        else {
                            self.periodLabel.text = ""
                        }
                        
                        //Bold the home team and set scores and shots
                        if (nextGameIsHome) {
                            self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                            self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                            self.score1Label.text = "\(homeTeamScore)"
                            self.score2Label.text = "\(awayTeamScore)"
                            self.shotsOnGoal1Label.text = "\(homeTeamSOG) SOG"
                            self.shotsOnGoal2Label.text = "\(awayTeamSOG) SOG"
                        }
                        else {
                            self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                            self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                            self.score1Label.text = "\(awayTeamScore)"
                            self.score2Label.text = "\(homeTeamScore)"
                            self.shotsOnGoal1Label.text = "\(awayTeamSOG) SOG"
                            self.shotsOnGoal2Label.text = "\(homeTeamSOG) SOG"
                        }
                    }
                    else {
                        self.favTeamTitle.text = favouriteTeamName + " Previous Game"
                        if (prevGameAvailable){
                            self.previousGameLabel.isHidden = false
                            self.periodLabel.isHidden = true
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
                                self.score1Label.text = "\(homeTeamScore)"
                                self.score2Label.text = "\(awayTeamScore)"
                                self.shotsOnGoal1Label.text = "\(homeTeamSOG) SOG"
                                self.shotsOnGoal2Label.text = "\(awayTeamSOG) SOG"
                            }
                            else {
                                self.team1Label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
                                self.team2label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                                self.score1Label.text = "\(awayTeamScore)"
                                self.score2Label.text = "\(homeTeamScore)"
                                self.shotsOnGoal1Label.text = "\(awayTeamSOG) SOG"
                                self.shotsOnGoal2Label.text = "\(homeTeamSOG) SOG"
                            }
                        }
                    }
                }
            }
            
            //Block the UI updates until all API calls are finished
            operation2.addDependency(operation1)
            operation3.addDependency(operation2)
            
            //Add operations to the operation queue
            queue.addOperation(operation1)
            queue.addOperation(operation2)
            queue.addOperation(operation3)
            
        }
        else {
            favTeamTitle.text = "Please select a favourite team"
            favTeamTitle.textColor = .systemRed
        }
    }
    
    //MARK: Private Functions
    //Function to setup the colour of the empty net and power play buttons
    private func setupButtonColours(nextGameHome: Bool, nextGameFound: Bool, homeEN: Bool, awayEN: Bool, homePP: Bool, awayPP: Bool) -> Void {
        if (nextGameFound) {
            if (nextGameHome) {
                //Series of switch statements to decide the background colours of the buttons
                switch homePP {
                case true:
                    powerPlayButton1.backgroundColor = UIColor.systemGreen
                default:
                    powerPlayButton1.backgroundColor = UIColor.darkGray
                }
                switch awayPP {
                case true:
                    powerPlayButton2.backgroundColor = UIColor.systemGreen
                default:
                    powerPlayButton2.backgroundColor = UIColor.darkGray
                }
                switch homeEN {
                case true:
                    emptyNetButton1.backgroundColor = UIColor.systemGreen
                default:
                    emptyNetButton1.backgroundColor = UIColor.darkGray
                }
                switch awayPP {
                case true:
                    emptyNetButton2.backgroundColor = UIColor.systemGreen
                default:
                    emptyNetButton2.backgroundColor = UIColor.darkGray
                }
            }
            //Next game is away
            else {
                //Series of switch statements to decide the background colours of the buttons
                switch homePP {
                case true:
                    powerPlayButton2.backgroundColor = UIColor.systemGreen
                default:
                    powerPlayButton2.backgroundColor = UIColor.darkGray
                }
                switch awayPP {
                case true:
                    powerPlayButton1.backgroundColor = UIColor.systemGreen
                default:
                    powerPlayButton1.backgroundColor = UIColor.darkGray
                }
                switch homeEN {
                case true:
                    emptyNetButton2.backgroundColor = UIColor.systemGreen
                default:
                    emptyNetButton2.backgroundColor = UIColor.darkGray
                }
                switch awayPP {
                case true:
                    emptyNetButton1.backgroundColor = UIColor.systemGreen
                default:
                    emptyNetButton1.backgroundColor = UIColor.darkGray
                }
            }
        }
        //If there is no next game then all buttons should be gray as once a game is over the empty net and power play will be false
        else {
            powerPlayButton1.backgroundColor = UIColor.darkGray
            powerPlayButton2.backgroundColor = UIColor.darkGray
            emptyNetButton1.backgroundColor = UIColor.darkGray
            emptyNetButton2.backgroundColor = UIColor.darkGray
        }
    }
    
    //Function to display an error alert when an API call fails
    private func displayErrorAlert() {
        //Create and display alert about an API error
        let errorAlert = UIAlertController(title: constants.errorAlertTitle, message: constants.errorAlertMessage, preferredStyle: .alert)
        
        //create Okay button
        let doneAction = UIAlertAction(title: "Done", style: .default) {
            (action) -> Void in
        }
        
        //Add task to tableview buttons
        errorAlert.addAction(doneAction)
        
        self.present(errorAlert, animated: true, completion: nil)
    }
}
