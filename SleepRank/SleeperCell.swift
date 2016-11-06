//
//  sleeperCell.swift
//  SleepRank
//
//  Created by Han Liu on 05/11/2016.
//  Copyright © 2016 SleepRank. All rights reserved.
//

import Foundation
import UIKit

class SleeperCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sleepingTimeLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    var sleeper: Sleeper! {
        didSet {
            
            nameLabel.text = sleeper.name
            sleepingTimeLabel.text = ".\(sleeper.sleepingTime)"

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}
