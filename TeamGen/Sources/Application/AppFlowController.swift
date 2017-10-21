import UIKit

struct AppFlowController {
    private let builder: Builder
    private let flow: Flow

    init(dependencies: AppDependencies) {
        self.builder = AppFlowController.Builder(dependencies: dependencies)
        self.flow = dependencies.window
    }

    func presentTeamsScreen() {
        builder.makeTeamScreen() |> flow.present
    }
}

extension AppFlowController {
    struct Builder {
        private let dependencies: AppDependencies

        init(dependencies: AppDependencies) {
            self.dependencies = dependencies
        }

        func makeTeamScreen() -> UIViewController {
            return UIViewController()
        }
    }
}
