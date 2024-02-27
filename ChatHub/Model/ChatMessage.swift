//
//  ChatMessage.swift
//  ChatHub
//
//  Created by Arun on 22/02/24.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Codable {
    let id: String
    let userId: String
    let userName: String
    let message: String
    @ServerTimestamp var timeStamp: Timestamp?
    var attachedImageNames: [String]?
    
//    static var randomNames = ["Rahul", "Ronak", "Gulab", "Gogi", "Priyanshu"]
//    
//    static var randomMessages = ["Yeh my boy !", "Kaise Ho ?", "I'm Good !", "Super duper", "Chilling beach side"]
//    
//    static func fakeMessages() -> [ChatMessage] {
//        
//        var chatMessages = [ChatMessage]()
//        
//        for _ in 0...10 {
//            chatMessages.append(.init(id: UUID().uuidString, userId: UUID().uuidString, userName: randomNames.randomElement()!, message: randomMessages.randomElement()!, timeStamp: .init(), attachedImageNames: nil))
//        }
//        
//        return chatMessages
//    }
}





