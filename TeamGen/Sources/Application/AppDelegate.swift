import UIKit
import ReactiveSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {

            let dependenciesCreator = curry(AppDependencies.init)(window)(Bundle.main)
            let flowController = AppFlowController(flow: window.flow, maker: dependenciesCreator)
            let viewModel = AppViewModel { makeDataBase() }

            flowController.observe(state: viewModel.state.signal)

            return true
    }
}
