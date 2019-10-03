
import UIKit

final class RootRooter {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func showInitialView() {
        let initialView = UserListRooter.assembleModules()
        let navigationController = UINavigationController(rootViewController: initialView)
        
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}
