import ReactiveSwift

struct GroupsScreenViewModel: ViewLifeCycleObservable {

    let state: Property<State>
    let viewLifecycle: MutableProperty<ViewLifeCycle>

    init(groupsBusinessController: GroupsBusinessControllerProtocol) {
        state = Property.init(initial: .loading,
                              reduce: GroupsScreenViewModel.reducer,
                              feedbacks: [])

        viewLifecycle = MutableProperty(.unknown)
    }
}

extension GroupsScreenViewModel {
    enum State {
        case initial
        case loading
        case empty
        case loaded([Group])
    }

    enum Event {
        case startLoadingGroups
        case loaded([Group])
    }
}

extension GroupsScreenViewModel {
    static func reducer(state: State,
                        event: Event)
        -> State {
            switch (state, event) {
            case (_, .startLoadingGroups):
                return .loading
            case (_, let .loaded(groups)) where groups.count == 0:
                return .empty
            case (_, let .loaded(groups)):
                return .loaded(groups)
            }
    }
}
