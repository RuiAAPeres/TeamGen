import ReactiveSwift
import SQLite
import enum Result.NoError

private let defaultPath: String = {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    return "\(path)/database.sqlite3"
}()

protocol DatabaseMakerProtocol {
    func makeDatabase() -> SignalProducer<Connection, NoError>
}

struct DatabaseMaker: DatabaseMakerProtocol {

    private let pathToDatabase: String

    init(pathToDatabase: String = defaultPath) {
        self.pathToDatabase = pathToDatabase
    }

    func makeDatabase() -> SignalProducer<Connection, NoError> {
        return SignalProducer {[pathToDatabase] observer, _ in
            makeDataBase(withPath: pathToDatabase) |> observer.send(value:)
            observer.sendCompleted()
        }
    }
}

private func makeDataBase(withPath pathToDatabase: String) -> Connection {

    let database = try! Connection(pathToDatabase)

    let groups = Table("Groups")

    let groupId = Expression<Int64>("id")
    let groupName = Expression<String>("name")
    let groupDescription = Expression<String>("description")

    let players = Table("Players")

    let playerId = Expression<Int64>("id")
    let playerName = Expression<String>("name")
    let playerGroupForeign = Expression<Int64>("group")

    let skillSpecs = Table("SkillSpecs")

    let skillSpecId = Expression<Int64>("id")
    let skillsSpecName = Expression<String>("name")
    let skillSpecMinValue = Expression<Double>("minValue")
    let skillSpecMaxValue = Expression<Double>("maxValue")
    let skillSpecGroupForeign = Expression<Int64>("group")

    let skills = Table("Skills")

    let skillId = Expression<Int64>("id")
    let skillValue = Expression<Double>("value")
    let skillSkillSpecForeign = Expression<Int64>("skillSpec")
    let skillPlayerForeign = Expression<Int64>("player")

    try! database.run(groups.create(ifNotExists: true) { table in
        table.column(groupId, primaryKey: .autoincrement)
        table.column(groupName, unique: true)
        table.column(groupDescription, defaultValue: "")
    })

    try! database.run(players.create(ifNotExists: true) { table in
        table.column(playerId, primaryKey: .autoincrement)
        table.column(playerName)
        table.column(playerGroupForeign)
        table.foreignKey(playerGroupForeign, references: groups, groupId, delete: .setNull)
    })

    try! database.run(skillSpecs.create(ifNotExists: true) { table in
        table.column(skillSpecId, primaryKey: .autoincrement)
        table.column(skillsSpecName)
        table.column(skillSpecMinValue)
        table.column(skillSpecMaxValue)
        table.column(skillSpecGroupForeign)
        table.foreignKey(skillSpecGroupForeign, references: groups, groupId, delete: .setNull)
    })


    try! database.run(skills.create(ifNotExists: true) { table in
        table.column(skillId, primaryKey: .autoincrement)
        table.column(skillValue)
        table.column(skillSkillSpecForeign)
        table.column(skillPlayerForeign)
        table.foreignKey(skillSkillSpecForeign, references: skillSpecs, skillSpecId, delete: .setNull)
        table.foreignKey(skillPlayerForeign, references: players, playerId, delete: .setNull)
    })

    return database
}
