
import Foundation

protocol GitHubRequest {
    associatedtype Response: Decodable
    
    init(queryItems: [URLQueryItem]?, httpHeaderFields: [String: String]?)
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    
    var queryItems: [URLQueryItem]? { get set }
    var httpHeaderFields: [String: String]? { get set }
    
    func response(from data: Data, urlResponse: URLResponse) throws -> Response
}

extension GitHubRequest {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    func buildURLRequest() ->URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaderFields
        
        return urlRequest
    }
}

enum GitHubAPI {
    
    struct GetUsersRequest: GitHubRequest {
        typealias Response = [User]
        
        init(queryItems: [URLQueryItem]?, httpHeaderFields: [String : String]?) {
            self.queryItems = queryItems
            self.httpHeaderFields = httpHeaderFields
        }
        
        var path: String {
            return "users"
        }
        
        var method: HttpMethod {
            return .get
        }
        
        var queryItems: [URLQueryItem]?
        var httpHeaderFields: [String : String]?
        
        func response(from data: Data, urlResponse: URLResponse) throws -> [User] {
            if case (200...300)? = (urlResponse as? HTTPURLResponse)?.statusCode {
                return try JSONDecoder.init().decode(Response.self, from: data)
            }
            else {
                throw NSError()
            }
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
}
