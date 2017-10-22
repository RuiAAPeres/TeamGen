import UIKit
import SQLite

struct AppFlowController {
    private let builder: Builder
    private let flow: Flow

    init(dependencies: AppDependencies) {
        self.builder = AppFlowController.Builder(dependencies: dependencies)
        self.flow = dependencies.window.flow
    }

    func presentGroupsScreen(connection: Connection) {
        builder.makeGroupsScreen(with: connection)
            |> flip(curry(flow.present))(true)
    }
}

extension AppFlowController {
    struct Builder {
        private let dependencies: AppDependencies

        init(dependencies: AppDependencies) {
            self.dependencies = dependencies
        }

        func makeGroupsScreen(with connection: Connection) -> UIViewController {
            return UIViewController()
        }
    }
}
