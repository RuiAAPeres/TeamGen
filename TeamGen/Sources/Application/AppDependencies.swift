import UIKit
import SQLite

struct AppDependencies {
    let window: UIWindow
    let bundle: Bundle
    let databaseConnection: Connection

    init(window: UIWindow, bundle: Bundle, databaseConnection: Connection) {
        self.window = window
        self.bundle = bundle
        self.databaseConnection = databaseConnection
    }
}
