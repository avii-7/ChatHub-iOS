//
//  ChatViewController.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import UIKit
import FirebaseAuth

final class ChatViewController: UIViewController {
    
    private var chatMessages = [ChatMessage]()
    
    private let chatWrapper = ChatWrapper()
    
    private let chatView = ChatView()
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchAllMessages()
    }
    
    private func setupView() {
        view.addSubview(chatView)
        view.backgroundColor = .systemBackground
        chatView.translatesAutoresizingMaskIntoConstraints = false
        chatView.delegate = self
        chatView.tableViewDelegate = self
        addConstraints()
        setLogoutButton()
        
        func addConstraints() {
            NSLayoutConstraint.activate([
                chatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                chatView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                chatView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                chatView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
        
        func setLogoutButton() {
            navigationItem.rightBarButtonItem = .init(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(didTapCloseButton)
            )
        }
    }
    
    @objc
    private func didTapCloseButton() {
        do {
            try Auth.auth().signOut()
            navigationController?.setViewControllers([LoginViewController()], animated: true)
        } catch {
            debugPrint("Error \(error)")
        }
        
    }

    private func fetchAllMessages() {
        Task {
            do {
                let result = try await chatWrapper.getMessages()
                chatMessages.append(contentsOf: result)
                chatView.reloadTableView()
            }
            catch {
                debugPrint("Error \(error)")
            }
        }
    }
}

extension ChatViewController: ChatViewDelegate, ChatTableViewDelegate {
    
    func didTapSend(msg: String?) -> Bool {
        
        guard let msg else {
            debugPrint("Textfield is empty !!")
            return false
        }
        
        let newMessageIndex = chatMessages.count
        
        let newMessage = ChatMessage(
            id: UUID().uuidString,
            userId: user.uid,
            userName: user.displayName ?? "",
            message: msg,
            timeStamp: .init()
        )
        
        chatMessages.append(newMessage)
        chatView.insertRow(at: .init(row: newMessageIndex, section: 0))
        
        Task {
            do {
                try chatWrapper.sendMessage(message: newMessage)
            } catch {
                debugPrint("Error \(error)")
            }
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = chatMessages[indexPath.row]
        
        if chatMessage.userId == user.uid {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageTableViewCell.identifier, for: indexPath) as? MyMessageTableViewCell {
                cell.configure(message: chatMessage)
                return cell
            }
        }
        else {
            if let cell = tableView.dequeueReusableCell(
                    withIdentifier: OtherMessageTableViewCell.identifier,
                    for: indexPath
                ) as? OtherMessageTableViewCell {

                cell.configure(message: chatMessage)
                return cell
            }
        }
        
        return .init()
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

