import UIKit
import ReactiveSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {

            let dependencies = AppDependencies(window: window, bundle: Bundle.main)
            let appBuilder = AppBuilder(appDependencies: dependencies)

            let flowController = AppFlowController(flow: window.flow, builder: appBuilder)

            flowController.presentGroupsScreen()
            return true
    }
}
