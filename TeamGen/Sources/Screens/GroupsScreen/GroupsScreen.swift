import TeamGenFoundation
import UIKit
import Overture

enum GroupsScreen {
    static var generator: (ViewState<GroupCellViewModel>, IndexPath, UITableView) -> UITableViewCell {
        return { viewState, indexPath, tableView in
            let makeCell = curry(toCell)(tableView)(indexPath)
            switch viewState {
            case let .loaded(groups):
                return groups[indexPath.row] |> makeCell
            case .loading:
                return .loading |> makeCell
            case .failure(_):
                fatalError("generator.failure")
            }
        }
    }
    
    static func toViewState(state: GroupsViewModel.State) -> ViewState<GroupCellViewModel> {
        switch state {
        case let .groupsReady(groups):
            
            let appendAddButton: ([GroupCellViewModel]) -> [GroupCellViewModel] = {
                return $0 + [.addGroup(AddGroupViewModel(title: "Add Group"))]
            }
            
            return groups
                .map(GroupDigestViewModel.init >>> GroupCellViewModel.group)
                |> appendAddButton
                |> ViewState.loaded
        case .loading:
            return .loading
        default:
            fatalError("toViewState")
        }
    }
    
    static func registerCells(tableView: UITableView) {
        tableView.register(GenericTableCell<GroupDigestView>.self)
        tableView.register(GenericTableCell<AddGroupView>.self)
        tableView.register(GenericTableCell<SpinnerView>.self)
    }
    
    static func toCell(tableView: UITableView,
                       indexPath: IndexPath,
                       groupCellViewModel: GroupCellViewModel) -> UITableViewCell {
        
        switch groupCellViewModel {
        case let .group(viewModel):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                as GenericTableCell<GroupDigestView>

            return viewModel |> GroupDigestView.init(with:)
                             |> cell.setup(customView:)
            
        case let .addGroup(viewModel):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                as GenericTableCell<AddGroupView>
            
            return viewModel |> AddGroupView.init(with:)
                             |> cell.setup(customView:)
        case .loading:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                as GenericTableCell<SpinnerView>
            
            return SpinnerView() |> cell.setup(customView:)
        }
    }
}
