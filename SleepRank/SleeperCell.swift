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
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sleepingTimeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var sleeper: Sleeper! {
        didSet {
            rankLabel.text = sleeper.rank
            nameLabel.text = sleeper.name
            sleepingTimeLabel.text = String(format: "%.2f", sleeper.sleepTime!) + " hours"
            if let Url = sleeper.profileImageUrl {
                profileImageView.downloadedFrom(url: Url)
            } else {
                let noImageUrl: URL = URL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
                profileImageView.downloadedFrom(url: noImageUrl)
            }
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
