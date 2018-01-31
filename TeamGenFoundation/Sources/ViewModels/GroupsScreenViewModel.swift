import ReactiveSwift
import ReactiveFeedback
import enum Result.NoError

public struct GroupsScreenViewModel: ViewLifeCycleObservable {

    public let state: Property<State>
    public let route: Signal<Route, NoError>
    private let routeObserver: Signal<Route, NoError>.Observer
    public let viewLifecycle: MutableProperty<ViewLifeCycle>

    public init(groupsReposiotry: GroupsRepositoryProtocol) {

        let lifeCycle = MutableProperty<ViewLifeCycle>(.unknown)
        viewLifecycle = lifeCycle

        state = Property(initial: .initial,
                         reduce: GroupsScreenViewModel.reducer,
                         feedbacks: [
                            GroupsScreenViewModel.readyToLoad(lifeCycle.producer),
                            GroupsScreenViewModel.loadGroups(groupsReposiotry)
            ])

        (route, routeObserver) = Signal<Route, NoError>.pipe()
    }
}

public extension GroupsScreenViewModel {
    enum State: Equatable {
        case initial
        case loading
        case loaded([Group])

        public static func == (lhs: State, rhs: State) -> Bool {
            switch(lhs, rhs) {
            case (.initial, .initial): return true
            case (.loading, .loading): return true
            case (let .loaded(lhsGroup), let .loaded(rhsGroup)): return lhsGroup == rhsGroup
            default: return false
            }
        }
    }

    enum Event {
        case viewIsReady
        case loaded([Group])
    }

    enum Route {
        case addGroup
        case showDetail(Group)
    }
}

extension GroupsScreenViewModel {
    static func reducer(state: State,
                        event: Event)
        -> State {
            switch (state, event) {
            case (_, .viewIsReady):
                return .loading
            case (_, let .loaded(groups)):
                return .loaded(groups)
            }
    }
}

extension GroupsScreenViewModel {
    static func loadGroups(_ groupsRepository: GroupsRepositoryProtocol) -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            guard state == State.loading else { return .empty }
            return groupsRepository.groups()
                .map(Event.loaded)
                .flatMapError { _ in .empty }
        }
    }

    static func readyToLoad(_ lifeCycle: SignalProducer<ViewLifeCycle, NoError>) -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            guard state == State.initial else { return .empty }
            return lifeCycle
                .filter { $0 == .didLoad }
                 // shouldn't be needed, since `.didLoad` by definition should be only sent once.
                .take(first: 1)
                .map { _ in Event.viewIsReady }
        }
    }
}
