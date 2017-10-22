import UIKit
import SQLite
import ReactiveSwift
import enum Result.NoError

typealias AppDependenciesMaker = (Connection) -> AppDependencies

struct AppFlowController {
    private let builder: Builder
    private let flow: Flow

    init(flow: Flow, maker : @escaping AppDependenciesMaker ) {
        self.builder = AppFlowController.Builder(maker: maker)
        self.flow = flow
    }

    func observe(state: Signal<AppViewModel.State, NoError>) {
        state.observe(on: UIScheduler())
            .take(last: 1)
            .observeValues { value in
                switch value {
                case .initial:
                    break
                case let .loaded(connection):
                    self.presentGroupsScreen(connection: connection)
                }
        }
    }

    private func presentGroupsScreen(connection: Connection) {
        builder.makeGroupsScreen(with: connection)
            |> flip(curry(flow.present))(true)
    }
}

extension AppFlowController {
    struct Builder {
        private let maker: AppDependenciesMaker

        init(maker: @escaping AppDependenciesMaker) {
            self.maker = maker
        }

        func makeGroupsScreen(with connection: Connection) -> UIViewController {
            return UIViewController()
        }
    }
}
