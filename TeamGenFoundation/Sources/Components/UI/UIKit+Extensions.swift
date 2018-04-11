import UIKit

public extension UIView {
    @discardableResult
    func set<T>(path: WritableKeyPath<UIView, T>, value: T) -> UIView {
        var copy = self
        copy[keyPath: path] = value
        return copy
    }
}

public protocol Configure {}

public extension Configure where Self: UIView {
    @discardableResult public func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

extension NSObject: Configure {}
