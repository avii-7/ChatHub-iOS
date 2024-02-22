//
//  ChatViewController.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let chatMessages = ChatMessage.fakeMessages()
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let messageField: UITextField = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(chatTableView)
        view.addSubview(messageField)
        view.addSubview(messageSendButton)
//        view.addLayoutGuide(opaqueBox)
        
        setupSendButton()
        setupTableView()
        addConstraints()
    }
    
    private func setupSendButton() {
        messageSendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    
    @objc func didTapSendButton() {
        
    }
    
    private func setupTableView() {
        chatTableView.dataSource = self
        chatTableView.register(MyMessageTableViewCell.self, forCellReuseIdentifier: MyMessageTableViewCell.identifier)
        chatTableView.register(OtherMessageTableViewCell.self, forCellReuseIdentifier: OtherMessageTableViewCell.identifier)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            chatTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            messageField.topAnchor.constraint(equalTo: chatTableView.bottomAnchor),
            messageField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            messageField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            messageField.rightAnchor.constraint(equalTo: messageSendButton.leftAnchor, constant: -10),
            
            messageSendButton.centerYAnchor.constraint(equalTo: messageField.centerYAnchor),
            messageSendButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            messageSendButton.widthAnchor.constraint(equalToConstant: 45),
            messageSendButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherMessageTableViewCell.identifier, for: indexPath) as! OtherMessageTableViewCell
        let message = chatMessages[indexPath.row]
        cell.configure(message: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
