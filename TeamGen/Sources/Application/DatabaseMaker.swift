import ReactiveSwift
import SQLite

private let defaultPath: String = {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    return "\(path)/database.sqlite3"
}()

func makeDataBase(withPath path: String = defaultPath) -> SignalProducer<Connection, CoreError> {
    guard let database = try? Connection(path) else {
        return "Couldn't create database with path: \(path)"
            |> CoreError.creatingDatabase
            |> SignalProducer.init(error:)
    }

    return makeDataBase(with: database)
}

func makeDataBase(with database: Connection) -> SignalProducer<Connection, CoreError> {
    do {
        let groupDBRepresentation = GroupDatabaseRepresentation()
        let playerDBRepresentation = PlayerDatabaseRepresentation()
        let skillSpecDBRepresentation = SkillSpecDatabaseRepresentation()
        let skillDBRepresentation = SkillDatabaseRepresentation()

        try database.run(groupDBRepresentation.table.create(ifNotExists: true) { table in
            table.column(groupDBRepresentation.id, primaryKey: .autoincrement)
            table.column(groupDBRepresentation.name, unique: true)
        })

        try database.run(playerDBRepresentation.table.create(ifNotExists: true) { table in
            table.column(playerDBRepresentation.id, primaryKey: .autoincrement)
            table.column(playerDBRepresentation.name, unique: true)
            table.column(playerDBRepresentation.groupForeign)
            table.foreignKey(playerDBRepresentation.groupForeign,
                             references: groupDBRepresentation.table,
                             groupDBRepresentation.id,
                             delete: .setNull)
        })

        try database.run(skillSpecDBRepresentation.table.create(ifNotExists: true) { table in
            table.column(skillSpecDBRepresentation.id, primaryKey: .autoincrement)
            table.column(skillSpecDBRepresentation.name, unique: true)
            table.column(skillSpecDBRepresentation.minValue)
            table.column(skillSpecDBRepresentation.maxValue)
            table.column(skillSpecDBRepresentation.groupForeign)
            table.foreignKey(skillSpecDBRepresentation.groupForeign,
                             references: groupDBRepresentation.table,
                             groupDBRepresentation.id,
                             delete: .setNull)
        })

        try database.run(skillDBRepresentation.table.create(ifNotExists: true) { table in
            table.column(skillDBRepresentation.id, primaryKey: .autoincrement)
            table.column(skillDBRepresentation.value)
            table.column(skillDBRepresentation.skillSpecForeign)
            table.column(skillDBRepresentation.playerForeign)
            table.foreignKey(skillDBRepresentation.skillSpecForeign,
                             references: skillSpecDBRepresentation.table,
                             skillSpecDBRepresentation.id,
                             delete: .setNull)

            table.foreignKey(skillDBRepresentation.playerForeign,
                             references: playerDBRepresentation.table,
                             playerDBRepresentation.id,
                             delete: .setNull)
        })

        return database |> SignalProducer.init(value:)
    }
    catch {
        return error.localizedDescription
            |> CoreError.creatingDatabase
            |> SignalProducer.init(error:)
    }
}

