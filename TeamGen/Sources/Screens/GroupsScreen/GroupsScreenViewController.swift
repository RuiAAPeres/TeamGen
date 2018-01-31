import UIKit
import TeamGenFoundation

final class GroupsScreenViewController: UIViewController {
    private var viewModel: GroupsViewModel!

    func setup(with viewModel: GroupsViewModel) {
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
