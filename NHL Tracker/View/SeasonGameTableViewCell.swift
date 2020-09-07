//
//  SeasonGameTableViewCell.swift
//  NHL Tracker
//
//  Created by Anthony Hopkins on 2020-09-07.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class SeasonGameTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var score1Label: UILabel!
    @IBOutlet weak var score2Label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var arenaLabel: UILabel!
    @IBOutlet weak var gameNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
