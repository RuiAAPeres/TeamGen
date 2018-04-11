import UIKit
import TeamGenFoundation
import TinyConstraints

final class GroupsScreenViewController: UIViewController {
    private var viewModel: GroupsViewModelProtocol!
    private var tableView = UITableView(frame: .zero, style: .plain).configure { tableView in
        tableView.tableFooterView = UIView()
    }
    private var tableViewManager: TableViewManager<GroupCellViewModel>

    public init(viewModel: GroupsViewModelProtocol) {
        GroupsScreen.registerCells(tableView: tableView)

        self.viewModel = viewModel
        self.tableViewManager = TableViewManager<GroupCellViewModel>(
            tableView: tableView,
            dataSource: viewModel.state.map(GroupsScreen.toViewState),
            generator: GroupsScreen.generator)

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.addSubview(tableView)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLifecycle.value = .didLoad
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.edgesToSuperview(usingSafeArea: true)
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


