import UIKit

protocol Flow {
    func present(_ viewController: UIViewController)
    func dismiss()
}

extension UIWindow: Flow {
    func present(_ viewController: UIViewController) {
        self.rootViewController = viewController
        self.makeKeyAndVisible()
    }

    func dismiss() {
        self.rootViewController = nil
    }
}
