import TeamGenFoundation
import UIKit

enum GroupsScreen {
    static func toViewState(state: GroupsViewModel.State) -> ViewState<GroupCellViewModel> {
        return .loaded([])
    }
    
    static var generator: (ViewState<GroupCellViewModel>, IndexPath) ->  UITableViewCell {
        return { viewState, indexPath in
            fatalError()
        }
    }
}
