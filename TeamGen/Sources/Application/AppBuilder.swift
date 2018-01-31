import UIKit
import TeamGenFoundation

struct AppBuilder {
    let dependencies: AppDependencies

    func makeGroupsScreen() -> UIViewController {
        let groupsRepository = GroupsRepository()
        let viewModel = GroupsScreenViewModel(groupsReposiotry: groupsRepository)
        let viewController = GroupsScreenViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let flowController = GroupsScreenFlowController(dependencies: dependencies,
                                                        modal: viewController.modalFlow,
                                                        navigation: navigationController.navigationFlow)

        viewController.setup(with: viewModel)
        viewModel.route.observeValues(flowController.observe)

        return navigationController
    }
}

