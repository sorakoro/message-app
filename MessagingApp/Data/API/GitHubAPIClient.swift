
import Foundation

protocol GitHubRequestable {
    func send<Request: GitHubRequest>(request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class GitHubAPIClient {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

// MARK: - GitHubRequestable

extension GitHubAPIClient: GitHubRequestable {
    
    func send<Request: GitHubRequest>(request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        let urlRequest = request.buildURLRequest()
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            switch (data, response, error) {
            case (_, _, let error?):
                completion(.failure(error))
            case (let data?, let response?, _):
                do {
                    let response = try request.response(from: data, urlResponse: response)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(error))
                }
            default:
                completion(.failure(NSError()))
            }
        }
        .resume()
    }
}
