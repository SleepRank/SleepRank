//
//  Sleeper.swift
//  SleepRank
//
//  Created by Han Liu on 05/11/2016.
//  Copyright © 2016 SleepRank. All rights reserved.
//

import Foundation
import UIKit

class Sleeper: NSObject {
    
    var rank:String!
    var name:String!
    var sleepTime: Double!
    // var profileImageUrl: URL?
    
    init(r: String, s:String, t:Double) {
        rank = r
        name = s
        sleepTime = t
    }
    
}
