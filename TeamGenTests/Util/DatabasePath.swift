import Foundation
import SQLite
@testable import TeamGen

let defaultDatabasePath: String = {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    return "\(path)/database.sqlite3"
}()
