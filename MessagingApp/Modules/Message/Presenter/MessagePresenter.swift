
import Foundation

protocol MessagePresentation {
    func viewDidLoad()
    func didTapSendButton(message: String)
}

final class MessagePresenter {
    
    private let user: User
    
    private let view: MessageView
    private let messageInteractor: MessageInteractorUsecase
    
    init(user: User, view: MessageView, messageInteractor: MessageInteractorUsecase) {
        self.user = user
        self.view = view
        self.messageInteractor = messageInteractor
    }
}

// MARK: - MessagePresentation

extension MessagePresenter: MessagePresentation {
    
    func viewDidLoad() {
        let messageHistories = messageInteractor.fetchMessageHistories(userId: user.id)
        
        view.setMessageHistories(messageHistories)
        view.setNavigationTitle("@\(user.screenName)")
        
        DispatchQueue.main.async {
            self.view.reloadData()
        }
    }
    
    func didTapSendButton(message: String) {
        let messageHistory = MessageHistory(value: ["userId": user.id, "isSender": 1, "message": message, "sendDate": Date()])
        messageInteractor.insertMessageHistory(messageHistory)
        view.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let repeatedMessage = String(repeating: message, count: 2)
            let messageHistory = MessageHistory(value: ["userId": self.user.id, "isSender": 2, "message": repeatedMessage, "sendDate": Date()])
            self.messageInteractor.insertMessageHistory(messageHistory)
            self.view.reloadData()
        }
    }
}
