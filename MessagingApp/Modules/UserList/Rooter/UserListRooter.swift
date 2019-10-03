
import UIKit

protocol UserListWireframe {
    func showMessageView(user: User)
}

final class UserListRooter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules() -> UIViewController {
        let viewController = UserListViewController()
        let rooter = UserListRooter(viewController: viewController)
        let userListInteractor = UserListInteractor(client: GitHubAPIClient())
        
        let presenter = UserListPresenter(rooter: rooter, view: viewController, userListInteractor: userListInteractor)
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}

// MARK: - UserListWireframe

extension UserListRooter: UserListWireframe {
    
    func showMessageView(user: User) {
        let nextViewController = MessageRooter.assembleModules(user: user)
        viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
