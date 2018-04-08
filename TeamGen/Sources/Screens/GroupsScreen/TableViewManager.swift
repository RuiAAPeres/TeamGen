import UIKit
import ReactiveSwift
import enum Result.NoError

enum ViewError: Error {
    case reason(String)
}

enum ViewState<T: Equatable> {
    case loading
    case loaded([T])
    case failure(ViewError)
}

final class TableViewManager<T: Equatable>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let dataSource: Property<ViewState<T>>
    private let generator: (ViewState<T>, IndexPath) -> UITableViewCell
    private let didTapCellObserver: Signal<(ViewState<T>, IndexPath), NoError>.Observer
    
    public let didTapCell: Signal<(ViewState<T>, IndexPath), NoError>
    
    init(dataSource: Property<ViewState<T>>,
         generator: @escaping (ViewState<T>, IndexPath) -> UITableViewCell) {
        self.dataSource = dataSource
        self.generator = generator
        (didTapCell, didTapCellObserver) = Signal<(ViewState<T>, IndexPath), NoError>.pipe()
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataSource.value {
        case let .loaded(viewModels):
            return viewModels.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generator(self.dataSource.value, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapCellObserver.send(value: (dataSource.value, indexPath))
    }
}
