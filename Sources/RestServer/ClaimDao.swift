//
//  ClaimDao.swift
//  RestServer
//
//  Created by Abid Bakhtiyar on 10/25/20.
//

import SQLite3
import Cocoa

struct Claim : Codable {
    var id : String
    var title : String?
    var date : String?
    var isSolved : Bool
    
    init(i: String, t: String?, dat: String?, sol: Bool) {
        id = i
        title = t
        date = dat
        isSolved = sol
    }
}

class ClaimDao {
    func addClaim(cObj : Claim) {
        let sqlStmt = String(format:"insert into claim (id, title, date, isSolved) values ('%@', '%@', '%@', 0)", cObj.id, cObj.title!, cObj.date!)
        
        let conn = Database.getInstance().getDbConnection()
        
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a Claim record due to error \(errcode)")
        }
        sqlite3_close(conn)
    }
    
    func getAll() -> [Claim] {
        var cList = [Claim]()
        var resultSet : OpaquePointer?
        let sqlStr = "select id, title, date, isSolved from claim"
        let conn = Database.getInstance().getDbConnection()
        
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW){
                let id_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: id_val!)
                let title_val = sqlite3_column_text(resultSet, 1)
                let title = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSet, 2)
                let date = String(cString: date_val!)
                let sol_val = sqlite3_column_int(resultSet, 3)
                let isSolved = Bool(truncating: sol_val as NSNumber)
                
                cList.append(Claim(i: id, t: title, dat: date, sol: isSolved))

            }
            
        }
        return cList
    }
}

