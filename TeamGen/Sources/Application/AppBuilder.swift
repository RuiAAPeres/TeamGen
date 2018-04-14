import UIKit
import TeamGenFoundation
import ReactiveSwift

struct AppBuilder {
    let dependencies: AppDependencies

    func makeGroupsScreen() -> UIViewController {
//        let groupsRepository = GroupsRepository()
//        let viewModel = GroupsViewModel(groupsRepository: groupsRepository)
        let group = Group(name: "A group", players: [], skillSpec: [])
        let viewModel = Dummy_GroupsViewModel(state: Property(value: .groupsReady([group])))
        
        let viewController = GroupsScreenViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)

        let flowController = GroupsScreenFlowController(dependencies: dependencies,
                                                        modal: viewController.modalFlow,
                                                        navigation: navigationController.navigationFlow)

        viewModel.route.observeValues(flowController.observe)

        return navigationController
    }
}
