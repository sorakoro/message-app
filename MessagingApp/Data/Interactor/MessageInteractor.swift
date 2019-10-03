
import Foundation
import RealmSwift

protocol MessageInteractorUsecase {
    func insertMessageHistory(_ messageHistory: MessageHistory)
    func fetchMessageHistories(userId: Int) -> Results<MessageHistory>
}

final class MessageInteractor: MessageInteractorUsecase {
    
    func insertMessageHistory(_ messageHistory: MessageHistory) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(messageHistory)
        }
    }
    
    func fetchMessageHistories(userId: Int) -> Results<MessageHistory> {
        let realm = try! Realm()
        
        return realm.objects(MessageHistory.self)
            .filter("userId = %@", userId)
            .sorted(byKeyPath: "sendDate", ascending: true)
    }
}
