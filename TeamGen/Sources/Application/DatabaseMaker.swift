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
        return SignalProducer { observer, _ in
            defer { observer.sendCompleted() }
        }
    }
}
