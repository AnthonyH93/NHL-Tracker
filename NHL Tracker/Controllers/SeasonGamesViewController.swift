//
//  SecondViewController.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-08-29.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class SeasonGamesViewController: UIViewController, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    private var tableTeams: [String] = []
    private var favouriteTeamName: String = ""
    private var currentSeason: String = ""
    
    let dataPersistence = DataPersistence()
    let nhlApiServices = NHLApiServices()
    let teamConversions = TeamConversions()
    let seasonHelper = SeasonHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Need to call API here to setup for the table view data
        if let savedFavouriteTeam = dataPersistence.loadFavouriteNHLTeam() {
            favouriteTeamName = savedFavouriteTeam.favouriteTeam
            var seasonStartDate = ""
            var seasonEndDate = ""
            var seasonGames = 0
            
            let queue = OperationQueue()
            
            //Call current season API method first to get start and end dates
            let operation1 = BlockOperation {
                let group = DispatchGroup()
                group.enter()
                self.nhlApiServices.fetchCurrentSeason() { responseObject, error in
                    guard let responseObject = responseObject, error == nil else {
                        print(error ?? "Unknown error with current season")
                        return
                    }
                    //Update start date, end date and number of games with the response
                    seasonStartDate = responseObject.seasons[0].regularSeasonStartDate
                    seasonEndDate = responseObject.seasons[0].regularSeasonEndDate
                    seasonGames = responseObject.seasons[0].numberOfGames
                    self.currentSeason = self.seasonHelper.formatSeasonID(seasonID: responseObject.seasons[0].seasonId)
                    group.leave()
                }
                group.wait()
            }
            
            //Call the next API method to get all the games for the given dates and team ID
            let operation2 = BlockOperation {
                let group = DispatchGroup()
                group.enter()
                self.nhlApiServices.fetchSeasonGames(teamID: savedFavouriteTeam.favouriteTeamNumber, startDate: seasonStartDate, endDate: seasonEndDate) { responseObject, error in
                    guard let responseObject = responseObject, error == nil else {
                        print(error ?? "Unknown error with season games")
                        return
                    }
                    
                    let seasonGames = responseObject.dates
                    
                    if (self.tableTeams.count > 0) {
                        self.tableTeams.removeAll()
                    }
                    
                    for i in 0 ..< seasonGames.count {
                        self.tableTeams.append(seasonGames[i].games[0].teams.home.team.name)
                    }
                    
                    group.leave()
                }
                group.wait()
            }
            
            //Reload table data once we are sure that it is set up
            let operation3 = BlockOperation {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            //Block the operations that depend on the results of others
            operation2.addDependency(operation1)
            operation3.addDependency(operation2)
            
            //Add operations to the operation queue
            queue.addOperation(operation1)
            queue.addOperation(operation2)
            queue.addOperation(operation3)
        }
    }
    
    //MARK: Table View Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        
        let text = tableTeams[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let teamAndSeason = "\(favouriteTeamName) \(currentSeason)"
        //Choose games or schedule as part of the title depending on the team name and season length
        let title = self.seasonHelper.formatSectionTitle(teamAndSeason: teamAndSeason)
        return title
    }
}
