import TeamGenFoundation
import UIKit
import Overture

enum GroupsScreen {
    static var generator: (ViewState<GroupCellViewModel>, IndexPath, UITableView) -> UITableViewCell {
        return { viewState, indexPath, tableView in
            switch viewState {
            case let .loaded(groups):
                return groups[indexPath.row] |> curry(toCell)(tableView)(indexPath)
            default:
                fatalError("generator")
            }
        }
    }
    
    static func toViewState(state: GroupsViewModel.State) -> ViewState<GroupCellViewModel> {
        switch state {
        case let .groupsReady(groups):
            return groups
                .map(GroupDigestViewModel.init >>> GroupCellViewModel.group)
                |> ViewState.loaded
        default:
            fatalError("toViewState")
        }
    }
    
    static func registerCells(tableView: UITableView) {
        tableView.register(GenericTableCell<GroupDigestView>.self)
    }
    
    static func toCell(tableView: UITableView,
                       indexPath: IndexPath,
                       groupCellViewModel: GroupCellViewModel) -> UITableViewCell {
        
        switch groupCellViewModel {
        case let .group(viewModel):
            let view = GroupDigestView(with: viewModel)
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                as GenericTableCell<GroupDigestView>
            
            cell.setup(customView: view)
            
            return cell
            
        case .addGroup(_):
            fatalError("toCell(groupCellViewModel")
        }
    }
}









