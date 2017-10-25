import Foundation
import SQLite
@testable import TeamGen

let defaultDatabasePath: String = {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    return "\(path)/database.sqlite3"
}()

let defaultDatabase: Connection = {
    let maker = DatabaseMaker(pathToDatabase: defaultDatabasePath)
    return maker.makeDatabase().first()!.value!
}()

