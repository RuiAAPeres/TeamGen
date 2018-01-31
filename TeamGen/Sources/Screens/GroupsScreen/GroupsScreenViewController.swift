import UIKit
import TeamGenFoundation

final class GroupsScreenViewController: UIViewController {
    private var viewModel: GroupsScreenViewModel!

    func setup(with viewModel: GroupsScreenViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLifecycle.value = .didLoad
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewLifecycle.value = .didAppear
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewLifecycle.value = .didDisappear
    }
}
