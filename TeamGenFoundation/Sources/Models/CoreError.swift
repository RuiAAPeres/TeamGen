public typealias Reason = String

public enum CoreError: Error, Equatable {
    case inserting(Reason)
    case updating(Reason)
    case reading(Reason)
    case deleting(Reason)
}
