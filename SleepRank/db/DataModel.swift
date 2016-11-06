//
//  DataModel.swift
//
//  Created by Guocheng Wei on 11/5/2016.
//  Copyright © 206 Guocheng Wei. All rights reserved.
//

import Foundation

typealias User = (
    userId: Int64?,
    name: String?,
    rank: Int64?,
    sleepTime: Double?,
    friendArray: [Int64?],
    favArray: [Int64?],
    numOfLikes: Int64?,
    hasUpdated: Bool?
)
