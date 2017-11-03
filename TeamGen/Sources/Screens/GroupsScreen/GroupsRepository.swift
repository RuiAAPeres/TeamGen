 import ReactiveSwift
 import enum Result.NoError
 import SQLite

 protocol GroupsRepositoryProtocol {
    func groups() -> SignalProducer<[Group], CoreError>
    func group(withName name: String) -> SignalProducer<Group, CoreError>
    func make(group: Group) -> SignalProducer<Group, CoreError>
    func delete(group: Group) -> SignalProducer<Group, CoreError>
    func update(group: Group) -> SignalProducer<Group, CoreError>
 }

 struct GroupsRepository: GroupsRepositoryProtocol {

    private let dataBaseConnection: Connection

    init(dataBaseConnection: Connection) {
        self.dataBaseConnection = dataBaseConnection
    }

    func groups() -> SignalProducer<[Group], CoreError> {
        return .empty
    }

    func group(withName name: String) -> SignalProducer<Group, CoreError> {
        return SignalProducer { [dataBaseConnection] observer, _ in
            do {
                let groupDBRepresentation = GroupDatabaseRepresentation()
                let skillSpecDBRepresentation = SkillSpecDatabaseRepresentation()
                let playerDBRepresentation = PlayerDatabaseRepresentation()
                let skillDBRepresentation = SkillDatabaseRepresentation()

                let groupsTable = groupDBRepresentation.table
                let skillSpecTable = skillSpecDBRepresentation.table
                let playerSpecTable = playerDBRepresentation.table
                let skillTable = skillDBRepresentation.table

                let groupFilter = groupsTable.filter(groupDBRepresentation.name == name)

                guard let group = try dataBaseConnection.pluck(groupFilter) else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't find group with name \(name)"])
                }
                
                let groupName = try group.get(groupDBRepresentation.name).datatypeValue

                let groupPlayersFilter = try playerSpecTable.filter(group.get(groupDBRepresentation.id) == playerDBRepresentation.groupForeign)
                let groupSkillSetFilter = try skillSpecTable.filter(group.get(groupDBRepresentation.id) == skillSpecDBRepresentation.groupForeign)

                let skillSpecs: [(SkillSpec, Int64)] = try dataBaseConnection.prepare(groupSkillSetFilter).map { skillSpec in

                    let identifier = try skillSpec.get(skillSpecDBRepresentation.id).datatypeValue
                    let name = try skillSpec.get(skillSpecDBRepresentation.name).datatypeValue
                    let minValue = try skillSpec.get(skillSpecDBRepresentation.minValue).datatypeValue
                    let maxValue = try skillSpec.get(skillSpecDBRepresentation.maxValue).datatypeValue

                    return (SkillSpec(name: name, minValue: minValue, maxValue: maxValue), identifier)
                }

                let players: [Player] = try dataBaseConnection.prepare(groupPlayersFilter).map { player in
                    let playerName = try player.get(playerDBRepresentation.name).datatypeValue
                    let skillFilter = try skillTable.filter(player.get(playerDBRepresentation.id) == skillDBRepresentation.playerForeign)

                    let skills: [Skill] = try dataBaseConnection.prepare(skillFilter).map { skill in
                        let specIdentifier = try skill.get(skillDBRepresentation.skillSpecForeign).datatypeValue
                        let value = try skill.get(skillDBRepresentation.value).datatypeValue
                        let spec = skillSpecs.filter { $0.1 == specIdentifier }.first?.0

                        guard let unwrapped = spec,
                            let skill = Skill(value: value, spec: unwrapped) else {
                                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't create skill"])
                        }

                        return skill
                    }

                    return Player(name: playerName, skills: skills)
                }

                Group(name: groupName, players: players, skillSpec: skillSpecs.map { $0.0 } )
                    |> observer.send(value:)
                observer.sendCompleted()
            }
            catch {
                return error.localizedDescription
                    |> CoreError.reading
                    |> observer.send(error:)
            }
        }
    }

    func make(group: Group) -> SignalProducer<Group, CoreError> {
        let make: SignalProducer<String, CoreError> = SignalProducer { [dataBaseConnection] observer, _ in
            do {
                let groupDBRepresentation = GroupDatabaseRepresentation()
                let skillSpecDBRepresentation = SkillSpecDatabaseRepresentation()
                let playerDBRepresentation = PlayerDatabaseRepresentation()
                let skillDBRepresentation = SkillDatabaseRepresentation()

                let groupsTable = groupDBRepresentation.table
                let skillSpecTable = skillSpecDBRepresentation.table
                let playerSpecTable = playerDBRepresentation.table
                let skillTable = skillDBRepresentation.table

                let groupId = try dataBaseConnection.run(groupsTable
                    .insert(groupDBRepresentation.name <- group.name))

                var tempSkillSpec: [String: Int64] = [:]

                try group.skillSpec.forEach { skillSpec in
                    let skillSpecId = try dataBaseConnection.run(skillSpecTable
                        .insert(skillSpecDBRepresentation.name <- skillSpec.name,
                                skillSpecDBRepresentation.maxValue <- skillSpec.maxValue,
                                skillSpecDBRepresentation.minValue <- skillSpec.minValue,
                                skillSpecDBRepresentation.groupForeign <- groupId))

                    tempSkillSpec.updateValue(skillSpecId, forKey: skillSpec.name)
                }

                try group.players.forEach { player in
                    let playerId = try dataBaseConnection.run(playerSpecTable
                        .insert(playerDBRepresentation.name <- player.name,
                                playerDBRepresentation.groupForeign <- groupId))

                    try player.skills.forEach { skill in

                        guard let skillSpecIdentifier = tempSkillSpec[skill.spec.name] else {
                            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't find a skillSpec with name \(skill.spec.name)"])
                        }

                        try dataBaseConnection.run(skillTable
                            .insert(skillDBRepresentation.value <- skill.value,
                                    skillDBRepresentation.playerForeign <- playerId,
                                    skillDBRepresentation.skillSpecForeign <- skillSpecIdentifier))
                    }
                }

                observer.send(value: group.name)
                observer.sendCompleted()
            }
            catch {
                return error.localizedDescription
                    |> CoreError.inserting
                    |> observer.send(error:)
            }
        }

        return make.flatMap(.latest, group(withName:))
    }

    func delete(group: Group) -> SignalProducer<Group, CoreError> {
        return SignalProducer { [dataBaseConnection] observer, _ in
            let groupDBRepresentation = GroupDatabaseRepresentation()
            let groupsTable = groupDBRepresentation.table

            do {
                let groupFilter = groupsTable.filter(groupDBRepresentation.name == group.name)
                try dataBaseConnection.run(groupFilter.delete())

                observer.send(value: group)
                observer.sendCompleted()
            }
            catch {
                return error.localizedDescription
                    |> CoreError.deleting
                    |> observer.send(error:)
            }
        }
    }

    func update(group: Group) -> SignalProducer<Group, CoreError> {
        return .empty
    }
 }
