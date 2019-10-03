
import UIKit

extension UICollectionViewCell {
    
    static var reuseIdentifiler: String {
        return String(describing: self)
    }
}
