import SQLite

struct GroupDatabaseRepresentation {
    let table = Table("Groups")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
}
