import ReactiveSwift
import enum Result.NoError

public struct Relantionship<ParentEvent, ChildState> {
    private let observer: Signal<ParentEvent, NoError>.Observer
    private let transformation: (ChildState) -> ParentEvent?

    public init(_ observer: Signal<ParentEvent, NoError>.Observer, _ transformation: @escaping (ChildState) -> ParentEvent?) {
        self.observer = observer
        self.transformation = transformation
    }

    public func observe(_ state: ChildState) {
        state ?|> transformation ?|> observer.send(value:)
    }
}
