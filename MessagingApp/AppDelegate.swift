
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let rootRooter = RootRooter(window: UIWindow(frame: UIScreen.main.bounds))
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        rootRooter.showInitialView()
        return true
    }
}
