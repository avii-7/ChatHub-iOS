//
//  ChatView.swift
//  ChatHub
//
//  Created by Arun on 25/02/24.
//

import UIKit

protocol ChatViewDelegate: AnyObject {
    func didTapSend(msg: String?) -> Bool
}

protocol ChatTableViewDelegate: UITableViewDataSource, UITableViewDelegate { }

final class ChatView: UIView {
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.backgroundColor = .red
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let messageInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .default
        textField.returnKeyType = .send
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    private let messageSendButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    func setUpViews() {
        addSubview(chatTableView)
        addSubview(messageInputField)
        addSubview(messageSendButton)
        
        setupSendButton()
        setupTableView()
        addConstraints()
    }
    
    private func setupSendButton() {
        messageSendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
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
            
            messageInputField.heightAnchor.constraint(equalToConstant: 45),
            messageInputField.topAnchor.constraint(equalTo: chatTableView.bottomAnchor),
            messageInputField.leftAnchor.constraint(equalTo:leftAnchor, constant: 10),
            messageInputField.bottomAnchor.constraint(equalTo:bottomAnchor, constant: -20),
            messageInputField.rightAnchor.constraint(equalTo: messageSendButton.leftAnchor, constant: -10),
            
            messageSendButton.centerYAnchor.constraint(equalTo: messageInputField.centerYAnchor),
            messageSendButton.rightAnchor.constraint(equalTo:rightAnchor),
            messageSendButton.widthAnchor.constraint(equalToConstant: 45),
            messageSendButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func didTapSendButton() {
        let text = messageInputField.text
        
        Task { @MainActor in
            let success = delegate?.didTapSend(msg: text)
            
            if let success, success {
                messageInputField.text = nil
            }
        }
    }
    
    @MainActor
    func insertRow(at indexPath: IndexPath) {
        chatTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @MainActor
    func reloadTableView() {
        chatTableView.reloadData()
    }
}
