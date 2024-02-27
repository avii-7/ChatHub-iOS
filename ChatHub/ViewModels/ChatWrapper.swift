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
        let chatMessages: [ChatMessage] = try await firestoreWrapper.getAllDocuments()
        return chatMessages
    }
    
    func sendMessage(message: ChatMessage) throws {
        try firestoreWrapper.addDocument(doc: message)
    }
    
    func registerLister(onChange: @escaping (([DocumentChange]) -> Void)) {
        firestoreWrapper.registerLister(onChange: onChange)
    }
    
    func unregisterListener() {
        firestoreWrapper.unregisterListener()
    }
}
