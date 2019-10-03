
import Foundation
import RealmSwift

class MessageHistory: Object {
    
    @objc dynamic var userId: Int = 0
    @objc dynamic var isSender: Int = 0
    @objc dynamic var message = ""
    @objc dynamic var sendDate = Date()
}
