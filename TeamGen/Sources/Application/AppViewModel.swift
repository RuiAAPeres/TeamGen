import ReactiveSwift
import ReactiveFeedback
import SQLite

struct AppViewModel {

    let state: Property<State>

    init() {
        self.state = Property.init(initial: .initial,
                                   reduce: AppViewModel.reducer,
                                   feedbacks: [])
    }

    static func makeFeedbacks() -> [Feedback<State, Event>] {
        return []
    }
}

extension AppViewModel {
    enum State {
        case initial
        case loaded(Connection)
    }

    enum Event {
        case load(Connection)
    }
}

extension AppViewModel {
    static func reducer(state: State,
                        event: Event)
        -> State {
            switch (state, event) {
            case (.initial, let .load(connection)):
                return .loaded(connection)
            default:
                fatalError("w00t 🤔")
            }
    }
}
