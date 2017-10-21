import UIKit

protocol Flow {
    func present(_ viewController: UIViewController, animated: Bool)
    func dismiss(_ animated: Bool)
}

extension UIWindow: Flow {
    func present(_ viewController: UIViewController, animated: Bool) {
        self.rootViewController = viewController
        self.makeKeyAndVisible()
    }

    func dismiss(animated: Bool) {
        self.rootViewController = nil
    }
}

extension UINavigationController: Flow {
    func present(_ viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: animated)
    }

    func dismiss(_ animated: Bool) {
        self.popViewController(animated: animated)
    }
}

extension UIViewController: Flow {
    func present(_ viewController: UIViewController, animated: Bool) {
        self.present(viewController, animated: animated, completion: nil)
    }

    func dismiss(_ animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }
}

extension UIViewController {
    var modalFlow: Flow {
        return self
    }

    var navigationFlow: Flow? {
        return self.navigationController
    }
}
