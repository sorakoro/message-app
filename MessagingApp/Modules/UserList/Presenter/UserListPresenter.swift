
import Foundation

protocol UserListPresentation {
    func viewDidLoad()
    func searchButtonClicked(value: String?)
    func didSelectRow(user: User)
}

final class UserListPresenter {
    
    private let rooter: UserListWireframe
    private let view: UserListView
    private let userListInteractor: UserListInteractorUsecase
    
    init(rooter: UserListWireframe, view: UserListView, userListInteractor: UserListInteractorUsecase) {
        self.rooter = rooter
        self.view = view
        self.userListInteractor = userListInteractor
    }
    
    private func gerUsers(sinceValue: String) {
        userListInteractor.getUsers(sinceValue: sinceValue) { [weak self] result in
            switch result {
            case .success(let users):
                self?.view.setUsers(users)
            case .failure:
                print("エラー")
            }
        }
    }
}

// MARK: - UserListPresentation

extension UserListPresenter: UserListPresentation {
    
    func viewDidLoad() {
        gerUsers(sinceValue: "135")
    }
    
    func searchButtonClicked(value: String?) {
        guard let value = value else {
            return
        }
        
        gerUsers(sinceValue: value)
    }
    
    func didSelectRow(user: User) {
        rooter.showMessageView(user: user)
    }
}
