public typealias Reason = String

public enum CoreError: Error {
    case inserting(Reason)
    case updating(Reason)
    case reading(Reason)
    case deleting(Reason)
}

extension CoreError: Equatable {
    public static func ==(lhs: CoreError, rhs: CoreError) -> Bool {
        switch (lhs, rhs) {
        case let (.inserting(lhsReason), .inserting(rhsReason)):
            return lhsReason == rhsReason
        case let (.updating(lhsReason), .updating(rhsReason)):
            return lhsReason == rhsReason
        case let (.reading(lhsReason), .reading(rhsReason)):
            return lhsReason == rhsReason
        case let (.deleting(lhsReason), .deleting(rhsReason)):
            return lhsReason == rhsReason
        default:
            return false
        }
    }
}
