typealias Reason = String

enum CoreError: Error {
    case creatingDatabase(Reason)
    case inserting(Reason)
    case updating(Reason)
    case removing(Reason)
    case deleting(Reason)
}
