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
    var pickerData: [String] = [String]()
    
    let constants = NHLTrackerConstants()
    let dataPersistence = DataPersistence()
    let helperFunctions = HelperFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Connect data:
        self.favouriteTeamPicker.delegate = self
        self.favouriteTeamPicker.dataSource = self
        
        pickerData = constants.NHLTeamsStringArray
        
        favouriteTeamPicker.selectRow(2, inComponent: 0, animated: false)
        
        updateFavouriteTeamBtn.layer.cornerRadius = 10
    }
    
    //MARK: Button Actions
    @IBAction func updateFavouriteTeamPressed(_ sender: Any) {
        let pickerNum = favouriteTeamPicker.selectedRow(inComponent: 0)
        let chosenTeam = pickerData[pickerNum]
        let chosenTeamNumber = helperFunctions.teamNameToID(teamToConvert: chosenTeam)
        
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
