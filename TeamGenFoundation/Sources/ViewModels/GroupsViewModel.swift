import ReactiveSwift
import ReactiveFeedback
import enum Result.NoError

protocol GroupsViewModelProtocol: ViewLifeCycleObservable {
    var state: Property<GroupsViewModel.State> { get }
    var route: Signal<GroupsViewModel.Route, NoError> { get }
    var viewLifecycle: MutableProperty<ViewLifeCycle> { get }
    var addGroupAction: SignalProducer<Void, NoError> { get }
}

public struct GroupsViewModel: GroupsViewModelProtocol {
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

        state = Property(initial: .loading,
                         reduce: GroupsViewModel.reducer,
                         feedbacks: [
                            GroupsViewModel.addGroupEventTrigger(addGroupEvent),
                            GroupsViewModel.saveGroup(groupsRepository),
                            GroupsViewModel.loadGroups(groupsRepository, lifeCycle.producer)
            ])
    }
}

public extension GroupsViewModel {
    enum State: Equatable {
        case loading
        case savingGroup(Group)
        case groupsReady([Group])
    }

    enum Event: Equatable {
        case viewIsReady
        case reload
        case saveGroup(Group)
        case groupsReady([Group])
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

    static func loadGroups(_ groupsRepository: GroupsRepositoryProtocol,
                           _ lifeCycle: SignalProducer<ViewLifeCycle, NoError>)
        -> Feedback<State, Event> {
            return Feedback { state -> SignalProducer<Event, NoError> in
                guard state == State.loading else { return .empty }
                return lifeCycle
                    .filter { $0 == .didLoad }
                    .flatMap(.latest) { _ in
                        groupsRepository.groups()
                        .map(Event.groupsReady)
                        .flatMapError { _ in .empty }
                    }
            }
    }
}
