//
//  SleeperDetailViewController.swift
//  SleepRank
//
//  Created by Han Liu on 05/11/2016.
//  Copyright © 2016 SleepRank. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class SleeperDetailViewController: UIViewController {
    
    var sleeper: Sleeper!

    @IBOutlet weak var sleepTime: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sleepEnd: UILabel!
    @IBOutlet weak var sleepBegin: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = sleeper.name
        sleepTime.text = String(format: "%.2f", sleeper.sleepTime!) + " hours"
        sleepBegin.text = "\(sleeper.sleepBegin!)"
        sleepEnd.text = "\(sleeper.sleepEnd!)"
        if let Url = sleeper.profileImageUrl {
            profileImage.downloadedFrom(url: Url)
        } else {
            let noImageUrl: URL = URL(string: "http://1vyf1h2a37bmf88hy3i8ce9e.wpengine.netdna-cdn.com/wp-content/themes/public/img/noimgavailable.jpg")!
            profileImage.downloadedFrom(url: noImageUrl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
