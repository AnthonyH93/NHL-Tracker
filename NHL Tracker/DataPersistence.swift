//
//  DataPersistence.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-08-30.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit
import os.log

//Struct for all data persistence loads and saves to resuse code in multiple view controllers
struct DataPersistence {
    
    //Save a users favourite NHL team
    func saveFavouriteNHLTeam(favouriteNHLTeam: FavouriteNHLTeam) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("favouriteNHLTeam")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: favouriteNHLTeam, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Favourite team successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save preferences...", log: OSLog.default, type: .error)
        }
    }
    
    //Safe method to load a users favourite NHL team
    //If there is no saved team on the device this method returns nil
    func loadFavouriteNHLTeam() -> FavouriteNHLTeam? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("favouriteNHLTeam")
        
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)

                if let loadedFavouriteNHLTeam = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? FavouriteNHLTeam{
                    return loadedFavouriteNHLTeam
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
}
