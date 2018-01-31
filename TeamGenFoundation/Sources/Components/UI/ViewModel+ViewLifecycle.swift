import ReactiveSwift

public protocol ViewLifeCycleObservable {
    var viewLifecycle: MutableProperty<ViewLifeCycle> { get }
}

public enum ViewLifeCycle {
    case unknown
    case didLoad
    case didAppear
    case didDisappear
}
