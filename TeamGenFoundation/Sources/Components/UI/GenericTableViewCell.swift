/// Original idea from here: https://github.com/mergesort/GenericCells
import UIKit

public protocol ReusableView: AnyObject {}

public extension ReusableView where Self: UIView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

public extension UITableView {
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    public func register<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

public final class GenericTableCell<CustomView>: UITableViewCell where CustomView: UIView {
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(customView: CustomView) {
        self.contentView.addSubview(customView)
        self.contentView.preservesSuperviewLayoutMargins = false
        self.contentView.layoutMargins = .zero
        
        self.setupConstraints(for: customView)
    }
    
    private func setupConstraints(for view: CustomView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            view.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
