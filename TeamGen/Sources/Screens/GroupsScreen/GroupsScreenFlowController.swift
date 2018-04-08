import TeamGenFoundation

struct GroupsScreenFlowController {

    private let dependencies: AppDependencies
    private let modal: Flow
    private let navigation: Flow

    init(dependencies: AppDependencies, modal: Flow, navigation: Flow) {
        self.dependencies = dependencies
        self.modal = modal
        self.navigation = navigation
    }

    func observe(route: GroupsViewModel.Route) {
        switch route {
        case .addGroup: break
        case .showDetail(_): break
        }
    }
}
