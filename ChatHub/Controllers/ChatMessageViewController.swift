//
//  ChatViewController.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI

final class ChatMessageViewController: UIViewController {
    
    private var chatMessages = [ChatMessage]()
    
    private let chatWrapper = ChatWrapper()
    
    private let chatMessageView = ChatMessageView()
    
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
        InitData()
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
        view.addSubview(chatMessageView)
        view.backgroundColor = .systemBackground
        chatMessageView.translatesAutoresizingMaskIntoConstraints = false
        chatMessageView.delegate = self
        chatMessageView.tableViewDelegate = self
        addConstraints()
        setLogoutButton()
        
        func addConstraints() {
            NSLayoutConstraint.activate([
                chatMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                chatMessageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                chatMessageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                chatMessageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
    
    // Todo: get all messages initially
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
                    
                    let isAtBottom = chatMessageView.isAtBottom
                    self.chatMessageView.insertRows(at: indexPaths)
                    
                    if isAtBottom {
                        chatMessageView.scrollToRow(to: .init(row: endIndex, section: 0))
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
    
    private func InitData() {
        Task { @MainActor in
            do {
                let tempChatMessages = try await chatWrapper.getMessages()
                chatMessages.append(contentsOf: tempChatMessages)
                chatMessageView.reloadTableView()
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.microseconds(1), execute: { [weak self] in
                    
                    if let self {
                        self.chatMessageView.scrollToRow(to: IndexPath(row: self.chatMessages.count - 1, section: 0))
                    }
                })
            }
            catch {
                debugPrint("Error \(error)")
            }
        }
        
    }
}

extension ChatMessageViewController: ChatViewDelegate {
    
    func didTapMedia() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 2
            configuration.filter = .images
            
            let pickerViewController = PHPickerViewController(configuration: configuration)
            pickerViewController.delegate = self
            present(pickerViewController, animated: true)
            
        } else {
            //            let imagePickerController = UIImagePickerController()
            //            imagePickerController.sourceType = .photoLibrary
        }
    }
    
    func didTapSend(msg: String?, images: [UIImage]?) -> Bool {
        
        guard let msg else {
            debugPrint("Textfield is empty !!")
            return false
        }
        
        var newMessage = ChatMessage(
            id: UUID().uuidString,
            userId: user.uid,
            userName: user.displayName ?? "",
            message: msg
        )
        
        let firebaseStorage = FirebaseStorageWrapper(uid: user.uid)
        
        Task {
            
            do {
                if let images {
                    let result = try await firebaseStorage.uploadImages(msgId: newMessage.id, images)
                    var urlStrings = [String]()
                    for url in result {
                        urlStrings.append(url.absoluteString)
                    }
                    
                    newMessage.attachedImageNames = urlStrings
                }
                try chatWrapper.sendMessage(message: newMessage)
                
                DispatchQueue.main.async { [weak self] in
                    self?.chatMessageView.removeAllImagesFromMessage()
                }
                
            } catch {
                debugPrint("Error \(error)")
            }
        }
        
        return true
    }
}

extension ChatMessageViewController: ChatTableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = chatMessages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell {
            let myCell = chatMessage.userId == user.uid
            cell.configure(model: chatMessage, myCell)
            return cell
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatMessageTableHeaderView.identifier) as? ChatMessageTableHeaderView {
            
            return cell
        }
        
        return .init()
    }
}

extension ChatMessageViewController: PHPickerViewControllerDelegate {
    
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        if results.isEmpty {
            return
        }
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) == false {
                continue
            }
            
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                if let error {
                    print(error)
                }
                guard let selectedImage = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self?.chatMessageView.attachImageToMessage(selectedImage)
                }
            }
        }
    }
}
