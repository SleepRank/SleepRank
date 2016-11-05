//
//  DBManager.swift
//  SleepRank
//
//  Created by Guocheng Wei on 11/5/16.
//  Copyright © 2016 SleepRank. All rights reserved.
//

import SQLite
import Foundation

enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
    
    private init() {
        let path = "db.sqlite3"
        
        do {
            BBDB = try Connection(path)
        } catch _ {
            BBDB = nil
        }
    }
    
    func createTables() throws{
        do {
            try UserDataHelper.createTable()
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}
