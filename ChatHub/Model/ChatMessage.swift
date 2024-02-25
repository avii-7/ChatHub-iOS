//
//  ChatMessage.swift
//  ChatHub
//
//  Created by Arun on 22/02/24.
//

import Foundation

struct ChatMessage: Encodable {
    var id: String
    var userId: String
    var userName: String
    var message: String
    var timeStamp: Date
    var attachedImageNames: [String]?
    
    static var randomNames = ["Rahul", "Ronak", "Gulab", "Gogi", "Priyanshu"]
    
    static var randomMessages = ["Yeh my boy !", "Kaise Ho ?", "I'm Good !", "Super duper", "Chilling beach side"]
    
    static func fakeMessages() -> [ChatMessage] {
        
        var chatMessages = [ChatMessage]()
        
        for _ in 0...10 {
            chatMessages.append(.init(id: UUID().uuidString, userId: UUID().uuidString, userName: randomNames.randomElement()!, message: randomMessages.randomElement()!, timeStamp: .init(), attachedImageNames: nil))
        }
        
        return chatMessages
    }
}





