import ReactiveSwift

protocol ViewLifeCycleObservable {
    var viewLifecycle: MutableProperty<ViewLifeCycle> { get }
}

enum ViewLifeCycle {
    case unknown
    case didLoad
    case didAppear
    case didDisappear
}
