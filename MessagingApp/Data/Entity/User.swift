
import Foundation

struct User: Codable {
    var id: Int
    var screenName: String
    var avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case screenName = "login"
        case avatarUrl = "avatar_url"
    }
}
