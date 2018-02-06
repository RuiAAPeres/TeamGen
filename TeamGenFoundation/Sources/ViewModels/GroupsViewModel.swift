import ReactiveSwift
import ReactiveFeedback
import enum Result.NoError


public struct GroupsViewModel: ViewLifeCycleObservable {

    public let state: Property<State>
    public let route: Signal<Route, NoError>
    public let viewLifecycle: MutableProperty<ViewLifeCycle>
    public let addGroupAction: SignalProducer<Void, NoError>

    public init(groupsReposiotry: GroupsRepositoryProtocol) {

        let lifeCycle = MutableProperty<ViewLifeCycle>(.unknown)
        viewLifecycle = lifeCycle

        let (route, routeObserver) = Signal<Route, NoError>.pipe()
        self.route = route

        let (events, eventsObserver) = Signal<Event, NoError>.pipe()

        self.addGroupAction = SignalProducer<Void, NoError>.action {
            let addGroupRelationship = Relantionship<Event, AddGroupViewModel.State>(eventsObserver) { state in
                switch state {
                case .groupCreated: return .addedGroup
                default: return nil
                }
            }

            addGroupRelationship |> Route.addGroup |> routeObserver.send(value:)
        }

        state = Property(initial: .initial,
                         reduce: GroupsViewModel.reducer,
                         feedbacks: [
                            GroupsViewModel.addedGroup(events),
                            GroupsViewModel.readyToLoad(lifeCycle.producer),
                            GroupsViewModel.loadGroups(groupsReposiotry, route: routeObserver)
            ])
    }
}

public extension GroupsViewModel {
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
        case addedGroup
        case loaded([Group])

        public static func == (lhs: Event, rhs: Event) -> Bool {
            switch(lhs, rhs) {
            case (.viewIsReady, .viewIsReady): return true
            case (.addedGroup, .addedGroup): return true
            case (let .loaded(lhsGroup), let .loaded(rhsGroup)): return lhsGroup == rhsGroup
            default: return false
            }
        }
    }

    enum Route {
        case addGroup(Relantionship<GroupsViewModel.Event, AddGroupViewModel.State>)
        case showDetail(Group)
    }
}

extension GroupsViewModel {
    static func reducer(state: State,
                        event: Event)
        -> State {
            switch (state, event) {
            case (_, .viewIsReady):
                return .loading
            case (_, let .loaded(groups)):
                return .loaded(groups)
            case (_, .addedGroup):
                return .loading
            }
    }
}

extension GroupsViewModel {
    static func addedGroup(_ events: Signal<Event, NoError>) -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            guard case .loaded = state else { return .empty }
            return SignalProducer(events).filter { $0 == Event.addedGroup }
        }
    }

    static func loadGroups(_ groupsRepository: GroupsRepositoryProtocol,
                           route: Signal<GroupsViewModel.Route, NoError>.Observer)
        -> Feedback<State, Event> {
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
                .take(first: 1)
                .map { _ in Event.viewIsReady }
        }
    }
}
