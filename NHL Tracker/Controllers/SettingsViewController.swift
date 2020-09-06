//
//  SettingsViewController.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-08-29.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var favouriteTeamPicker: UIPickerView!
    @IBOutlet weak var updateFavouriteTeamBtn: UIButton!
    
    //MARK: Variables
    private var pickerData: [String] = [String]()
    
    let constants = NHLTrackerConstants()
    let dataPersistence = DataPersistence()
    let teamConversions = TeamConversions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Connect data:
        self.favouriteTeamPicker.delegate = self
        self.favouriteTeamPicker.dataSource = self
        
        //Set the UI picker data to the array of alphabetical NHL teams
        pickerData = constants.NHLTeamsStringArray
        
        //If there is a saved favouirte team then set the picker to display that team, else use default
        if let savedFavouriteTeam = dataPersistence.loadFavouriteNHLTeam() {
            let favouriteTeamName = savedFavouriteTeam.favouriteTeam
            let favouriteTeamAlphabeticIndex = teamConversions.teamNameToAlphabeticalIndex(teamToConvert: favouriteTeamName)
            
            favouriteTeamPicker.selectRow(favouriteTeamAlphabeticIndex, inComponent: 0, animated: false)
        }
        else {
            favouriteTeamPicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        updateFavouriteTeamBtn.layer.cornerRadius = 10
    }
    
    //MARK: Button Actions
    @IBAction func updateFavouriteTeamPressed(_ sender: Any) {
        let pickerNum = favouriteTeamPicker.selectedRow(inComponent: 0)
        let chosenTeam = pickerData[pickerNum]
        let chosenTeamNumber = teamConversions.teamNameToID(teamToConvert: chosenTeam)
        
        let newFavouriteTeam = FavouriteNHLTeam(favouriteTeam: chosenTeam, favouriteTeamNumber: chosenTeamNumber)
        dataPersistence.saveFavouriteNHLTeam(favouriteNHLTeam: newFavouriteTeam)
        
        //Create and display alert about the favourite team change
        let teamUpdateAlert = UIAlertController(title: constants.favouriteTeamAlertTitle, message: constants.favouriteTeamAlertMessage + chosenTeam, preferredStyle: .alert)
        
        //create Okay button
        let doneAction = UIAlertAction(title: "Done", style: .default) {
            (action) -> Void in
        }
        
        //Add task to tableview buttons
        teamUpdateAlert.addAction(doneAction)
        
        self.present(teamUpdateAlert, animated: true, completion: nil)
    }
    
    //MARK: Picker Functions
    //Number of columns of data for the favourite team picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Number of rows of data for the favourite team picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
