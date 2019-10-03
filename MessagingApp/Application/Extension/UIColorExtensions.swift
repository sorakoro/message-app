
import UIKit

extension UIColor {
    
    func toImage(width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(self.cgColor)
        contextRef?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
