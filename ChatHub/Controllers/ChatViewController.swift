//
//  ChatViewController.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerListner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregiseterLister()
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
    
    private func registerListner() {
        chatWrapper.registerLister { @MainActor [weak self] docsSnapshot in
            
            do {
                
                var newChatMessages = [ChatMessage]()
                
                try docsSnapshot.forEach { docSnapshot in
                    
                    if docSnapshot.type == .added {
                        let message = try docSnapshot.document.data(as: ChatMessage.self)
                        newChatMessages.append(message)
                    }
                }
                
                guard let self else { return }
                
                if newChatMessages.isEmpty == false {
                    let startIndex = self.chatMessages.count
                    self.chatMessages.append(contentsOf: newChatMessages)
                    let endIndex = chatMessages.count - 1
                    
                    let newRowRange = startIndex...endIndex
                    var indexPaths = [IndexPath]()
                    
                    for i in newRowRange {
                        indexPaths.append(.init(row: i, section: 0))
                    }
                    
                    let isAtBottom = chatView.isAtBottom
                    self.chatView.insertRows(at: indexPaths)
                    
                    if isAtBottom {
                        chatView.scrollToRow(to: .init(row: endIndex, section: 0))
                    }
                }
            }
            catch {
                debugPrint("Error \(error)")
            }
        }
    }
    
    private func unregiseterLister(){
        chatWrapper.unregisterListener()
    }
}

extension ChatViewController: ChatViewDelegate {
    
    func didTapSend(msg: String?) -> Bool {
        
        guard let msg else {
            debugPrint("Textfield is empty !!")
            return false
        }
        
        let newMessage = ChatMessage(
            id: UUID().uuidString,
            userId: user.uid,
            userName: user.displayName ?? "",
            message: msg
        )
        
        do {
            try chatWrapper.sendMessage(message: newMessage)
        } catch {
            debugPrint("Error \(error)")
        }
        
        return true
    }
}

extension ChatViewController: ChatTableViewDelegate {
    
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
