import UIKit

struct AppDependencies {
    let window: UIWindow
    let bundle: Bundle

    init(window: UIWindow, bundle: Bundle) {
        self.window = window
        self.bundle = bundle
    }
}
