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
        return .empty
    }

    func delete(group: Group) -> SignalProducer<Group, NoError> {
        return .empty
    }

    func update(group: Group) -> SignalProducer<Group, NoError> {
        return .empty
    }
}
