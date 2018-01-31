import ReactiveSwift
import enum Result.NoError

public extension SignalProducer {
    func ignoreError() -> SignalProducer<Value, NoError> {
        return self.flatMapError { _ in return SignalProducer<Value, NoError>.empty }
    }
}
