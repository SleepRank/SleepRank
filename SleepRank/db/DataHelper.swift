import Foundation
import SQLite


protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
}


class UserDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Users"
    
    static let table = Table(TABLE_NAME)
    static let userId = Expression<Int64>("userId")
    static let name = Expression<String>("name")
    static let rank = Expression<Int64>("rank")
    static let sleepTime = Expression<Double>("sleepTime")
    static let friendArray = Expression<Int64>("friendArray")
    static let favArray = Expression<Int>("favArray")
    static let numOfLikes = Expression<Int64>("numOfLikes")
    static let hasUpdated = Expression<Bool>("hasUpdated")
    
    
    typealias T = User
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(userId, primaryKey: true)
                t.column(name)
                t.column(rank)
                t.column(sleepTime)
                t.column(friendArray)
                t.column(favArray)
                t.column(hasUpdated)
            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.name != nil ) {
            let insert = table.insert(name <- item.name!)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
        
    }
    
    /************* Update ***********/
    static func updateSleepingTime (item: T) throws -> Bool {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(userId == item.userId!)
        if (try DB.run(query.update(sleepTime <- (item.sleepTime)!)) > 0) {
            print("Succesfully updated sleeping time!")
            return true
        } else {
            print("Item has not been found!")
            return false
        }
        
    }
    
    static func updateFriendArray (item: T, newFriends: Int64) throws -> Bool {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(userId == item.userId!)
        // Check later !
        if try DB.run(query.insert((friendArray <- newFriends))) > 0 {
            return true
        }
        return false
    }
    
    static func increaseNumOfLikes(item: T) throws -> Bool {
        var res = try find(id: item.userId!)
        if (res != nil) {
            res?.numOfLikes = (res?.numOfLikes)! + 1
            return true
        }
        return false
    }
    
    static func decreaseNumOfLikes(item: T) throws -> Bool {
        var res = try find(id: item.userId!)
        if (res != nil) {
            res?.numOfLikes = (res?.numOfLikes)! - 1
            return true
        }
        return false
    }
    
    static func rankFunc(item: T) throws -> [Int64?] {
        let theUser = try find(id: item.userId!)
        if (theUser == nil) { return [] }
        
        let rankedFriends = theUser!.friendArray.sorted(by: desceeding as! (Int64?, Int64?) -> Bool)
        return rankedFriends
    }
    
    static func getRank(item: T) throws -> Int {
        let res = try rankFunc(item: item);
        if (res.isEmpty) { return -1 }
        
        for (index, element) in res.enumerated() {
            if (element == item.userId) { return index }
        }
        // If there is error, return -1
        return -1
    }
    
    static func desceeding(_ s1: Int64, _ s2: Int64) throws -> Bool {
        let sleeping1 = try find(id: s1)
        let sleeping2 = try find(id: s2)
        return (sleeping1?.sleepTime)! > (sleeping2?.sleepTime)!
    }
    
    /************** End of Updates ***********/
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.userId {
            let query = table.filter(userId == id)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(userId == id)
        let items = try DB.prepare(query)
        for item in  items {
            return User(userId: item[userId], name: item[name], rank: item[rank], sleepTime: item[sleepTime], friendArray: [item[friendArray]], favArray: [item[friendArray]], numOfLikes: item[numOfLikes], hasUpdated: item[hasUpdated])
        }
        
        return nil
        
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(User(userId: item[userId], name: item[name], rank: item[rank], sleepTime: item[sleepTime], friendArray: [item[friendArray]], favArray: [item[friendArray]], numOfLikes: item[numOfLikes], hasUpdated: item[hasUpdated]))
        }
        
        return retArray
        
    }
}
