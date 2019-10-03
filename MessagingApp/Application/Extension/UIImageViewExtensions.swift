
import UIKit

extension UIImageView {
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    func setImage(from url: String) {
        if let cacheImage = UIImageView.imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        let imageUrl = URL(string: url)
        
        self.image = UIColor.lightGray.toImage(width: 60, height: 60)
        
        URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
            switch (data, response, error) {
            case (_, _, let error?):
                print(error)
            case (let data?, _, _):
                let image = UIImage(data: data)
                UIImageView.imageCache.setObject(image!, forKey: url as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = image
                }
            default:
                break
            }
        }
        .resume()
    }
}
