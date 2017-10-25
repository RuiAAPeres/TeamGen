import ReactiveSwift
import enum Result.NoError
import SQLite

protocol GroupsRepositoryProtocol {
    func groups() -> SignalProducer<[Group], NoError>
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

    func make(group: Group) -> SignalProducer<Group, NoError> {
        let groupDBRepresentation = GroupDatabaseRepresentation()
        let groupsTable = groupDBRepresentation.table

        try! dataBaseConnection.run(groupsTable
            .insert(groupDBRepresentation.name <- group.name))

        for group in try! dataBaseConnection.prepare(groupsTable) {
            print(group)
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
