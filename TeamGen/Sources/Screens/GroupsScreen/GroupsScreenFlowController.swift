struct GroupsScreenFlowController {

    private let dependencies: AppDependencies
    private let modal: Flow
    private let navigation: Flow

    init(dependencies: AppDependencies, modal: Flow, navigation: Flow) {
        self.dependencies = dependencies
        self.modal = modal
        self.navigation = navigation
    }

    func observe(route: GroupsScreenViewModel.Route) {
        switch route {
        case .addGroup: break
        case let .showDetail(group): break
        }
    }
}
