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
    
    var id:String!
    var rank:String!
    var name:String!
    var sleepBegin:Date!
    var sleepEnd:Date!
    var sleepTime: Double!
    var profileImageUrl: URL?
    
    init(r: String, s:String, t:Double, u:URL?, b:Date, e:Date) {
        rank = r
        name = s
        sleepTime = t
        profileImageUrl = u
    }
    
    static func > (ls:Sleeper, rs:Sleeper) -> Bool {
        return ls.sleepTime > rs.sleepTime
    }
    
}
