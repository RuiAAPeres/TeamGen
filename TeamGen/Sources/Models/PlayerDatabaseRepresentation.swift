import SQLite

struct PlayerDatabaseRepresentation {
    let table = Table("Players")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let groupForeign = Expression<Int64>("group")
}

