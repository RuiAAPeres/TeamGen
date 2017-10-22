import ReactiveSwift
import ReactiveFeedback
import enum Result.NoError
import SQLite

struct AppViewModel {

    let state: Property<State>

    init(maker: DatabaseMakerProtocol) {

        let dataBaseCreationFeedback = makeDataBaseCreationFeedback(with: maker)

        self.state = Property.init(initial: .initial,
                                   reduce: AppViewModel.reducer,
                                   feedbacks: [dataBaseCreationFeedback])
    }
}

private func makeDataBaseCreationFeedback(with maker: DatabaseMakerProtocol)
    -> Feedback<AppViewModel.State, AppViewModel.Event> {
        return Feedback { state -> SignalProducer<AppViewModel.Event, NoError> in
            switch state {
            case .initial:
                return maker.makeDatabase()
                    .map(AppViewModel.Event.load)
            case .loaded:
                return .empty
            }
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
