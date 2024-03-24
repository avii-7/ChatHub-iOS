//
//  ChatView.swift
//  ChatHub
//
//  Created by Arun on 25/02/24.
//

import UIKit

protocol ChatViewDelegate: AnyObject {
    func didTapSend(msg: String?, images: [UIImage]?) -> Bool
    func didTapMedia()
}

protocol ChatTableViewDelegate: UITableViewDataSource, UITableViewDelegate { }

final class ChatView: UIView {
    
    private var attachedImages = [UIImage]()
    
    private let chatTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        return view
    }()
    
    private let messageView : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 10
        return view
    }()
    
    private let messageImageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .equalCentering
        //view.isHidden = true
        return view
    }()
    
    private let messageFieldStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .default
        textField.returnKeyType = .send
        return textField
    }()
    
    private let messageSendButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "arrow.right.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.isHidden = false
        return button
    }()
    
    private let messageMediaButton: UIButton = {
        let view = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 27, weight: .medium, scale: .default)
        let image = UIImage(systemName: "photo.on.rectangle", withConfiguration: config)
        view.setImage(image, for: .normal)
        view.isHidden = false
        return view
    }()
    
    private var attachedImageView : CustomImageView {
        let view = CustomImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 70).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return view
    }
    
    private let invisibleView: UILayoutGuide = {
        let layoutGuide = UILayoutGuide()
        return layoutGuide
    }()
    
    weak var delegate: ChatViewDelegate?
    
    weak var tableViewDelegate: ChatTableViewDelegate? {
        didSet {
            chatTableView.delegate = tableViewDelegate
            chatTableView.dataSource = tableViewDelegate
            chatTableView.reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubview(chatTableView)
        addSubview(messageView)
        //addSubview(messageSendButton)
        
        setupMessageView()
        setupTableView()
        addConstraints()
    }
    
    private func setupMessageView() {
        messageView.addArrangedSubview(messageImageStackView)
        messageView.addArrangedSubview(messageFieldStackView)
        messageFieldStackView.addArrangedSubview(messageTextField)
        messageFieldStackView.addArrangedSubview(messageSendButton)
        messageFieldStackView.addArrangedSubview(messageMediaButton)
        
        messageSendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        messageMediaButton.addTarget(self, action: #selector(didTapMediaButton), for: .touchUpInside)
    }
    
    private func setupTableView() {
        chatTableView.register(MyMessageTableViewCell.self, forCellReuseIdentifier: MyMessageTableViewCell.identifier)
        chatTableView.register(OtherMessageTableViewCell.self, forCellReuseIdentifier: OtherMessageTableViewCell.identifier)
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo:topAnchor),
            chatTableView.leftAnchor.constraint(equalTo:leftAnchor),
            chatTableView.rightAnchor.constraint(equalTo:rightAnchor),
            
            messageView.topAnchor.constraint(equalTo: chatTableView.bottomAnchor, constant: 15),
            messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            messageTextField.heightAnchor.constraint(equalToConstant: 45),
            messageSendButton.widthAnchor.constraint(equalToConstant: 45),
            messageSendButton.heightAnchor.constraint(equalToConstant: 45),
            
            messageMediaButton.widthAnchor.constraint(equalToConstant: 45),
            messageMediaButton.widthAnchor.constraint(equalToConstant: 45),
            
            messageFieldStackView.rightAnchor.constraint(equalTo: messageView.rightAnchor)
        ])
    }
    
    @objc
    private func didTapSendButton() {
        let text = messageTextField.text
        
        var attachedImages = [UIImage]()
        
        for view in messageImageStackView.arrangedSubviews {
            if let imageView = view as? CustomImageView, let image = imageView.image {
                attachedImages.append(image)
            }
        }
        
        Task { @MainActor in
            
            let success = delegate?.didTapSend(msg: text, images: attachedImages)
            
            if let success, success {
                messageTextField.text = nil
            }
        }
    }
    
    @objc
    private func didTapMediaButton() {
        delegate?.didTapMedia()
    }
    
    func insertRows(at indexPaths: [IndexPath]) {
        chatTableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func reloadTableView() {
        chatTableView.reloadData()
    }
    
    var isAtBottom: Bool {
        let canScroll = chatTableView.contentSize.height > chatTableView.frame.height
        if canScroll {
            let bottomHitOffset = chatTableView.contentSize.height - chatTableView.frame.height
            
            if Int(bottomHitOffset) == Int(chatTableView.contentOffset.y) {
                return true
            }
        }
        return false
    }
    
    func scrollToRow(to indexPath: IndexPath) {
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func attachImageToMessage(_ image: UIImage) {
        let imageView = attachedImageView
        imageView.image = image
        messageImageStackView.isHidden = false
        messageImageStackView.addArrangedSubview(imageView)
    }
    
    func removeAllImagesFromMessage() {
        messageImageStackView.arrangedSubviews.forEach { messageImageStackView.removeArrangedSubview($0) }
        messageImageStackView.isHidden = true
    }
    
    private class CustomImageView: UIView {
        
        var image: UIImage? = nil {
            didSet {
                imageView.image = image
            }
        }
        
        private let imageView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            view.isUserInteractionEnabled = true
            return view
        }()
        
        private let crossButton: UIButton = {
            let view = UIButton()
            let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .default)
            let image = UIImage(systemName: "multiply.circle.fill", withConfiguration: config)
            view.setImage(image, for: .normal)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tintColor = .black
            return view
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
            addConstraints()
        }
        
        convenience init() {
            self.init(frame: .zero)
        }
        
        convenience init(image: UIImage) {
            self.init()
            self.image = image
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupViews() {
            addSubview(imageView)
            imageView.addSubview(crossButton)
            crossButton.layer.zPosition = 22
            imageView.image = image
            crossButton.addTarget(self, action: #selector(didTapCross), for: .touchUpInside)
        }
        
        private func addConstraints() {
            NSLayoutConstraint.activate([
                imageView.leftAnchor.constraint(equalTo: leftAnchor),
                imageView.rightAnchor.constraint(equalTo: rightAnchor),
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                crossButton.widthAnchor.constraint(equalToConstant: 35),
                crossButton.heightAnchor.constraint(equalToConstant: 35),
                
                crossButton.topAnchor.constraint(equalTo: imageView.topAnchor),
                crossButton.rightAnchor.constraint(equalTo: imageView.rightAnchor),
            ])
        }
        
        @objc
        private func didTapCross() {
            removeFromSuperview()
        }
    }
}
