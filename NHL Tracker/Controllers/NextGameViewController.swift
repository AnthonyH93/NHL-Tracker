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
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var untilNextGameLabel: UILabel!
    
    let dataPersistence = DataPersistence()
    let nhlApiServices = NHLApiServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favTeamTitle.adjustsFontSizeToFitWidth = true
        
        //Hide for now, will need to unhide depending on API response
        previousGameLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Decide label initial values based on saved favourite team
        if let savedFavouriteTeam = dataPersistence.loadFavouriteNHLTeam() {
            let favouriteTeamName = savedFavouriteTeam.favouriteTeam
            
            favTeamTitle.text = favouriteTeamName + " Next Game"
            favTeamTitle.textColor = .black
            
            nhlApiServices.fetchNextGame(teamID: savedFavouriteTeam.favouriteTeamNumber) { responseObject, error in
                guard let responseObject = responseObject, error == nil else {
                    print(error ?? "Unknown error")
                    return
                }
                print(responseObject)
            }
        }
        else {
            favTeamTitle.text = "Please select a favourite team"
            favTeamTitle.textColor = .systemRed
        }
    }


}

