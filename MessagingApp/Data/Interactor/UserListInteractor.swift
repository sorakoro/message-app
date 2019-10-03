
import Foundation

protocol UserListInteractorUsecase {
    func getUsers(sinceValue: String, completion: @escaping (Result<[User], Error>) -> Void)
}

final class UserListInteractor {
    
    private let client: GitHubRequestable
    
    init(client: GitHubRequestable) {
        self.client = client
    }
}

// MARK: - UserListInteractorUsecase

extension UserListInteractor: UserListInteractorUsecase {
    
    func getUsers(sinceValue: String, completion: @escaping (Result<[User], Error>) -> Void) {
        let request = GitHubAPI.GetUsersRequest(queryItems: [URLQueryItem(name: "since", value: sinceValue)], httpHeaderFields: nil)
        
        self.client.send(request: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
