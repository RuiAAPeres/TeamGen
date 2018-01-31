import UIKit

public protocol Flow {
    func present(_ viewController: UIViewController, animated: Bool)
    func dismiss(_ animated: Bool)
}

private struct ModalFlow: Flow {
    private let origin: UIViewController

    init(_ viewController: UIViewController) {
        self.origin = viewController
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        origin.present(viewController, animated: animated, completion: nil)
    }

    func dismiss(_ animated: Bool) {
        origin.dismiss(animated: animated, completion: nil)
    }
}

private struct NavigationFlow: Flow {
    private let origin: UINavigationController

    init(_ viewController: UINavigationController) {
        self.origin = viewController
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        origin.pushViewController(viewController, animated: animated)
    }

    func dismiss(_ animated: Bool) {
        origin.popViewController(animated: animated)
    }
}

private struct WindowFlow: Flow {
    private let window: UIWindow

    init(_ window: UIWindow) {
        self.window = window
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    func dismiss(_ animated: Bool) {
        window.rootViewController = nil
    }
}

public extension UIWindow {
    var flow: Flow {
        return WindowFlow(self)
    }
}

public extension UIViewController {
    var modalFlow: Flow {
        return ModalFlow(self)
    }

    var navigationFlow: Flow {
        guard let navigationController = self.navigationController else { return modalFlow }
        return NavigationFlow(navigationController)
    }
}
