import ReactiveSwift
import enum Result.NoError
import SQLite

protocol GroupsBusinessControllerProtocol {
    func loadGroups() -> SignalProducer<[Group], NoError>
}

struct GroupsBusinessController {

    private let dataBaseConnection: Connection

    init(dataBaseConnection: Connection) {
        self.dataBaseConnection = dataBaseConnection
    }
}
