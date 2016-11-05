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
            return User(userId: item[userId], name: item[name], rank: item[rank], sleepTime: item[sleepTime], hasUpdated: item[hasUpdated])
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
            retArray.append(User(userId: item[userId], name: item[name], rank: item[rank], sleepTime: item[sleepTime], hasUpdated: item[hasUpdated]))
        }
        
        return retArray
        
    }
}
