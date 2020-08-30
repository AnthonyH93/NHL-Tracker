//
//  favouriteNHLTeam.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-08-30.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

//Class for representing the users favourite team
class FavouriteNHLTeam : NSObject, NSCoding {
    
    //MARK: Initialization
    
    //Prepares and instance of a class for use
    init(favouriteTeam: String, favouriteTeamNumber: Int64) {
        //Initialize stored properties
        self.favouriteTeam = favouriteTeam
        self.favouriteTeamNumber = favouriteTeamNumber
    }
    
    //MARK: Properties
    
    var favouriteTeam: String
    var favouriteTeamNumber: Int64
    
    //MARK: Archiving Paths
    
    //Marked with static since they belong to the class instead of an instance of the class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("favouriteTeam")
    
    //MARK: Types
    
    struct PropertyKey {
        static let favouriteTeam = "favouriteTeam"
        static let favouriteTeamNumber = "favouriteTeamNumber"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(favouriteTeam, forKey: PropertyKey.favouriteTeam)
        aCoder.encode(favouriteTeamNumber, forKey: PropertyKey.favouriteTeamNumber)
    }
    
    //convenience means it is a secondary initializer (must call designated initializer), the ? means it is failable
    required convenience init?(coder aDecoder: NSCoder) {
        
        let favouriteTeam = aDecoder.decodeObject(forKey: PropertyKey.favouriteTeam) as! String
        
        let favouriteTeamNumber = aDecoder.decodeInt64(forKey: PropertyKey.favouriteTeamNumber)
        
        //Must call designated initializer.
        self.init(favouriteTeam: favouriteTeam, favouriteTeamNumber: favouriteTeamNumber)
    }
}
