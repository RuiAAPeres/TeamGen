import UIKit

struct AppFlowController {
    private let builder: AppBuilder
    private let flow: Flow

    init(flow: Flow, builder: AppBuilder) {
        self.builder = builder
        self.flow = flow
    }

    func presentGroupsScreen() {
        builder.makeGroupsScreen() |> flip(curry(flow.present))(true)
    }
}

