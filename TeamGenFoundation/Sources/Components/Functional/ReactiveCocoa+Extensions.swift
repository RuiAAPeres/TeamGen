import ReactiveSwift
import enum Result.NoError

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
}
