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
    let dataPersistence = DataPersistence()
    let nhlApiServices = NHLApiServices()
    let teamConversions = TeamConversions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nhlApiServices.fetchCurrentSeason() { responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error with current season")
                return
            }
            print(responseObject)
            
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
}
