
import UIKit

extension UITableViewCell {
    
    static var reuseIdentifiler: String {
        return String(describing: self)
    }
}
