
import UIKit
import RealmSwift

protocol MessageView {
    func setNavigationTitle(_ title: String)
    func setMessageHistories(_ messageHistories: Results<MessageHistory>)
    func reloadData()
}

class MessageViewController: UIViewController {
    
    private lazy var messageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let border: CALayer = {
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        return border
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "Aa..."
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = .gray
        textView.textContainerInset.left = 5
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        return textView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        return button
    }()
    
    private var presenter: MessagePresentation?
    
    private var messageHistories: Results<MessageHistory>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        messageCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        messageCollectionView.register(BubbleCell.self, forCellWithReuseIdentifier: BubbleCell.reuseIdentifiler)
        
        view.backgroundColor = .white
        
        view.addSubview(messageCollectionView)
        view.addSubview(containerView)
        view.addSubview(messageTextView)
        view.addSubview(placeholderLabel)
        view.addSubview(sendButton)
        
        containerView.layer.addSublayer(border)
        
        view.setNeedsUpdateConstraints()
        
        sendButton.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNotification(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideNotification(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        messageCollectionView.collectionViewLayout.invalidateLayout()
        messageCollectionView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        [
            placeholderLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            messageTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            messageTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            messageTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            messageTextView.heightAnchor.constraint(equalToConstant: 40),
            
            containerView.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),

            messageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            messageCollectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            messageCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            messageCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            sendButton.centerYAnchor.constraint(equalTo: placeholderLabel.centerYAnchor),
            sendButton.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 10)
        ]
            .forEach { $0.isActive = true }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        border.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
    }
    
    func inject(presenter: MessagePresentation) {
        self.presenter = presenter
    }
}

// MARK: - Selectors

extension MessageViewController {
    
    @objc func didTapSendButton(_ sender: UIButton) {
        if messageTextView.text.count > 0 {
            presenter?.didTapSendButton(message: messageTextView.text)
            messageTextView.text = ""
        }
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
            
            self.messageCollectionView.contentInset.top = rect.size.height + 10
            self.messageCollectionView.scrollIndicatorInsets.top = rect.size.height
        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
            
            self.messageCollectionView.contentInset.top = 10
            self.messageCollectionView.scrollIndicatorInsets.top = 0
        }
    }
}

// MARK: - MessageView

extension MessageViewController: MessageView {
    
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setMessageHistories(_ messageHistories: Results<MessageHistory>) {
        self.messageHistories = messageHistories
    }
    
    func reloadData() {
        messageCollectionView.reloadData()
        messageCollectionView.scrollToItem(at: IndexPath(item: messageHistories.count - 1, section: 0), at: .bottom, animated: false)
    }
}

// MARK: - UICollectionView Delegate DataSource

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageHistories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BubbleCell.reuseIdentifiler, for: indexPath) as! BubbleCell
        let messageHistory = messageHistories[indexPath.row]
        
        let size = CGSize(width: 250, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageHistory.message).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
        
        cell.messageTextView.text = messageHistory.message
        
        if messageHistory.isSender == 1 {
            cell.messageTextView.frame = CGRect(x: messageCollectionView.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: messageCollectionView.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16 + 16, height: estimatedFrame.height + 20)
            
            cell.bubbleImageView.image = BubbleCell.rightBubbleImage
            cell.bubbleImageView.tintColor = UIColor(displayP3Red: 92/255, green: 139/255, blue: 230/255, alpha: 1)
        }
        else {
            cell.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            
            cell.bubbleImageView.image = BubbleCell.leftBubbleImage
            cell.bubbleImageView.tintColor = UIColor(white: 0.90, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let messageHistory = messageHistories[indexPath.row]
        
        let size = CGSize(width: 250, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageHistory.message).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
        
        return CGSize(width: messageCollectionView.frame.width, height: estimatedFrame.height + 20)
    }
}

// MARK: - UITextView Delegate

extension MessageViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width * 0.8, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
    
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
        messageTextView.isScrollEnabled = estimatedSize.height > 100 ? true : false
    
        if estimatedSize.height < 100 {
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height < 40 ? 40 : estimatedSize.height
                }
            }
        }
    }
}
