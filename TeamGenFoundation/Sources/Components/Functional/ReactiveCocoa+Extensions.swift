import ReactiveSwift
import enum Result.NoError

public extension Signal {
    @discardableResult
    public func injectSideEffect(_ next: @escaping (Value) -> Void) -> Signal<Value, Error> {
        return self.on(value: next)
    }
    
    public func discardValues() -> Signal<Void, Error> {
        return map { _ in }
    }
}

public extension SignalProducer {
    func ignoreError() -> SignalProducer<Value, NoError> {
        return self.flatMapError { _ in return SignalProducer<Value, NoError>.empty }
    }
    
    static func action(run: @escaping () -> Void) -> SignalProducer {
        return SignalProducer { o, _ in
            defer { o.sendCompleted() }
            run()
        }
    }
    
    public func discardValues() -> SignalProducer<Void, Error> {
        return map { _ in }
    }
}

public extension Action where Output == Void, Error == NoError {
    public convenience init(_ execute: @escaping (Input) -> Void) {
        self.init { input -> SignalProducer<Output, Error> in
            execute(input)
            return .empty
        }
    }
}
