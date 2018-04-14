import ReactiveSwift
import ReactiveFeedback
import enum Result.NoError

public struct AddGroupViewModel {
    public let state: Property<State>
    public let route: Signal<Route, NoError>
    private let routeObserver: Signal<Route, NoError>.Observer
    public let viewLifecycle: MutableProperty<ViewLifeCycle>
    public let addGroup: Action<Group, Void, NoError>

    public init(groupsReposiotry: GroupsRepositoryProtocol,
                sendGroup: @escaping (Group) -> Void) {
        let lifeCycle = MutableProperty<ViewLifeCycle>(.unknown)
        viewLifecycle = lifeCycle
        (route, routeObserver) = Signal<Route, NoError>.pipe()

        state = Property(initial: .initial,
                         reduce: AddGroupViewModel.reducer,
                         feedbacks: [
                            AddGroupViewModel.add(.empty, using: groupsReposiotry)
            ])
        
        addGroup = Action(sendGroup)
    }
}

public extension AddGroupViewModel {
    enum State: Equatable {
        case initial
        case groupCreated(Group)
    }

    enum Event {
        case addingGroup(Group)
    }

    enum Route {
        case dismiss
    }
}

extension AddGroupViewModel {
    static func reducer(state: State,
                        event: Event)
        -> State {
            switch (state, event) {
            case (_, let .addingGroup(group)):
                return .groupCreated(group)
            }
    }
}

extension AddGroupViewModel {
    static func add(_ group: SignalProducer<Group, NoError>, using groupsRepository: GroupsRepositoryProtocol)
        -> Feedback<State, Event> {
            return Feedback { state -> SignalProducer<Event, NoError> in
                guard state == State.initial else { return .empty }
                
                return group.flatMap(.latest, groupsRepository.insert(group:))
                    .map(Event.addingGroup)
                    .flatMapError { _ in .empty }
            }
    }
}
