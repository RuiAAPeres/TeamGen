public enum ViewError: Error {
    case reason(String)
}

public enum ViewState<T: Equatable> {
    case loading
    case loaded([T])
    case failure(ViewError)
}
