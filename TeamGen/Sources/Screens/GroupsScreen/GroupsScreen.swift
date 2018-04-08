import TeamGenFoundation
import UIKit

enum GroupsScreen {
    
    static var generator: (ViewState<GroupCellViewModel>, IndexPath) ->  UITableViewCell {
        return { viewState, indexPath in
            fatalError()
        }
    }
    
    static func toViewState(state: GroupsViewModel.State) -> ViewState<GroupCellViewModel> {
        return .loaded([])
    }
    
    static func registerCells(tableView: UITableView) {
        tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
    }
}
