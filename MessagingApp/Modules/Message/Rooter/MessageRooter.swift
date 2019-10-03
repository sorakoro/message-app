
import UIKit

protocol MessageViewWireframe {}

final class MessageRooter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules(user: User) -> UIViewController {
        let viewController = MessageViewController()
        let messageInteractor = MessageInteractor()
        let presenter = MessagePresenter(user: user, view: viewController, messageInteractor: messageInteractor)
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}

// MARK: - MessageViewWireframe

extension MessageViewController: MessageViewWireframe {}
