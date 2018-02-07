import ReactiveSwift
import ReactiveFeedback
import enum Result.NoError


public struct GroupsViewModel: ViewLifeCycleObservable {

    public let state: Property<State>
    public let route: Signal<Route, NoError>
    public let viewLifecycle: MutableProperty<ViewLifeCycle>
    public let addGroupAction: SignalProducer<Void, NoError>

    public init(groupsRepository: GroupsRepositoryProtocol) {

        let lifeCycle = MutableProperty<ViewLifeCycle>(.unknown)
        viewLifecycle = lifeCycle

        let (route, routeObserver) = Signal<Route, NoError>.pipe()
        self.route = route

        let (addGroupEvent, addGroupObserver) = Signal<Event, NoError>.pipe()

        self.addGroupAction = SignalProducer<Void, NoError>.action {
            let addGroupRelationship = Relantionship<Event, AddGroupViewModel.State>(addGroupObserver) { state in
                switch state {
                case let .groupCreated(group): return .saveGroup(group)
                default: return nil
                }
            }

            addGroupRelationship |> Route.addGroup |> routeObserver.send(value:)
        }

        state = Property(initial: .initial,
                         reduce: GroupsViewModel.reducer,
                         feedbacks: [
                            GroupsViewModel.addGroupEventTrigger(addGroupEvent),
                            GroupsViewModel.saveGroup(groupsRepository),
                            GroupsViewModel.readyToLoad(lifeCycle.producer),
                            GroupsViewModel.loadGroups(groupsRepository)
            ])
    }
}

public extension GroupsViewModel {
    enum State: Equatable {
        case initial
        case loading
        case savingGroup(Group)
        case groupsReady([Group])

        public static func == (lhs: State, rhs: State) -> Bool {
            switch(lhs, rhs) {
            case (.initial, .initial): return true
            case (.loading, .loading): return true
            case (let .savingGroup(lhsGroup), let .savingGroup(rhsGroup)): return lhsGroup == rhsGroup
            case (let .groupsReady(lhsGroup), let .groupsReady(rhsGroup)): return lhsGroup == rhsGroup
            default: return false
            }
        }
    }

    enum Event {
        case viewIsReady
        case reload
        case saveGroup(Group)
        case groupsReady([Group])

        public static func == (lhs: Event, rhs: Event) -> Bool {
            switch(lhs, rhs) {
            case (.viewIsReady, .viewIsReady): return true
            case (.reload, .reload): return true
            case (let .saveGroup(lhsGroup), let .saveGroup(rhsGroup)): return lhsGroup == rhsGroup
            case (let .groupsReady(lhsGroup), let .groupsReady(rhsGroup)): return lhsGroup == rhsGroup
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
    static func reducer(state: State, event: Event) -> State {
            switch (state, event) {
            case (_, .viewIsReady):
                return .loading
            case (_, let .groupsReady(groups)):
                return .groupsReady(groups)
            case (.groupsReady, let .saveGroup(group)):
                return .savingGroup(group)
            case (_ , .saveGroup):
                return state
            case (_, .reload):
                return .loading
            }
    }
}

extension GroupsViewModel {

    static func addGroupEventTrigger(_ event: Signal<Event, NoError>) -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            guard case .groupsReady = state else { return .empty }
            return SignalProducer(event)
        }
    }

    static func saveGroup(_ groupsRepository: GroupsRepositoryProtocol) -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            guard case let .savingGroup(group) = state else { return .empty }
            return groupsRepository.insert(group: group)
                .map { _ in Event.reload }
                .flatMapError { _ in .empty }
        }
    }

    static func loadGroups(_ groupsRepository: GroupsRepositoryProtocol)
        -> Feedback<State, Event> {
            return Feedback { state -> SignalProducer<Event, NoError> in
                guard state == State.loading else { return .empty }
                return groupsRepository.groups()
                    .map(Event.groupsReady)
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
