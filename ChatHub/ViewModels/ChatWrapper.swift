//
//  ChatViewViewModel.swift
//  ChatHub
//
//  Created by Arun on 23/02/24.
//

import Foundation
import FirebaseFirestore

enum ChatError {
    case somethingWentWrong
}

struct ChatWrapper {
    
    let firestoreWrapper: FirestoreWrapper
    
    init() {
        firestoreWrapper = FirestoreWrapper(collectionName: "conversation")
    }
    
    func getMessages() async throws -> [ChatMessage] {
        
        var chatMessages = [ChatMessage]()
        
        let docDict = try await firestoreWrapper.getAllDocuments()
        for document in docDict {
            chatMessages.append(.init(
                id: document["id"] as? String ?? "",
                userId: document["userId"] as? String ?? "",
                userName: document["userName"] as? String ?? "",
                message: document["message"] as? String ?? "",
                timeStamp: .init(),
                attachedImageNames: nil
            ))
        }
        
        if chatMessages.isEmpty == false {
            
        }
        
        return chatMessages
    }
    
    func sendMessage(message: ChatMessage) throws {
        try firestoreWrapper.addDocument(doc: message)
    }
}
