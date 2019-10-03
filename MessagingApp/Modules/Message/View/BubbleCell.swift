
import UIKit

class BubbleCell: UICollectionViewCell {
    
    static let leftBubbleImage = UIImage(named: "left_bubble")?
        .resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 21, bottom: 15, right: 21))
        .withRenderingMode(.alwaysTemplate)
    
    static let rightBubbleImage = UIImage(named: "right_bubble")?
        .resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 21, bottom: 15, right: 21))
        .withRenderingMode(.alwaysTemplate)
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = BubbleCell.leftBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        textBubbleView.addSubview(bubbleImageView)
        
        [
            bubbleImageView.topAnchor.constraint(equalTo: textBubbleView.topAnchor),
            bubbleImageView.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor),
            bubbleImageView.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor),
            bubbleImageView.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor),
        ]
            .forEach { $0.isActive = true }
    }
}
