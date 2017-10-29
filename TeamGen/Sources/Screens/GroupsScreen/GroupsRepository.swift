import ReactiveSwift
import enum Result.NoError
import SQLite

protocol GroupsRepositoryProtocol {
    func groups() -> SignalProducer<[Group], NoError>
    func group(withName name: String) -> SignalProducer<Group, NoError>
    func make(group: Group) -> SignalProducer<Group, NoError>
    func delete(group: Group) -> SignalProducer<Group, NoError>
    func update(group: Group) -> SignalProducer<Group, NoError>
}

struct GroupsRepository: GroupsRepositoryProtocol {

    private let dataBaseConnection: Connection

    init(dataBaseConnection: Connection) {
        self.dataBaseConnection = dataBaseConnection
    }

    func groups() -> SignalProducer<[Group], NoError> {
        return .empty
    }

    func group(withName name: String) -> SignalProducer<Group, NoError> {
        return .empty
    }

    func make(group: Group) -> SignalProducer<Group, NoError> {
        let groupDBRepresentation = GroupDatabaseRepresentation()
        let skillSpecDBRepresentation = SkillSpecDatabaseRepresentation()
        let playerDBRepresentation = PlayerDatabaseRepresentation()
        let skillDBRepresentation = SkillDatabaseRepresentation()

        let groupsTable = groupDBRepresentation.table
        let skillSpecTable = skillSpecDBRepresentation.table
        let playerSpecTable = playerDBRepresentation.table
        let skillTable = skillDBRepresentation.table

        let groupId = try! dataBaseConnection.run(groupsTable
            .insert(groupDBRepresentation.name <- group.name))

        var tempSkillSpec: [String: Int64] = [:]

        group.skillSpec.forEach { skillSpec in
            let skillSpecId = try! dataBaseConnection.run(skillSpecTable
                .insert(skillSpecDBRepresentation.name <- skillSpec.name,
                        skillSpecDBRepresentation.maxValue <- skillSpec.maxValue,
                        skillSpecDBRepresentation.minValue <- skillSpec.minValue,
                        skillSpecDBRepresentation.groupForeign <- groupId))

            tempSkillSpec.updateValue(skillSpecId, forKey: skillSpec.name)
        }

        group.players.forEach { player in
            let playerId = try! dataBaseConnection.run(playerSpecTable
                .insert(playerDBRepresentation.name <- player.name,
                        playerDBRepresentation.groupForeign <- groupId))

            player.skills.forEach { skill in
                try! dataBaseConnection.run(skillTable
                    .insert(skillDBRepresentation.value <- skill.value,
                            skillDBRepresentation.playerForeign <- playerId,
                            skillDBRepresentation.skillSpecForeign <- tempSkillSpec[skill.spec.name]!))
            }
        }

        return .empty
    }

    func delete(group: Group) -> SignalProducer<Group, NoError> {
        return .empty
    }

    func update(group: Group) -> SignalProducer<Group, NoError> {
        return .empty
    }
}
