//
//  FirestoreWrapper.swift
//  ChatHub
//
//  Created by Arun on 24/02/24.
//

import Foundation
import FirebaseFirestore

struct FirestoreWrapper {
    
    private let collectionRef: CollectionReference
    
    init(collectionName: String) {
        collectionRef = Firestore.firestore().collection(collectionName)
    }
    
    func getAllDocuments() async throws -> [[String: Any]] {
        let querySnapshot = try await collectionRef.getDocuments()
        
        var docs = [[String: Any]]()
        
        for document in querySnapshot.documents {
            let docData = document.data()
            docs.append(docData)
        }
        
        return docs
    }
    
    func addDocument<T>(doc: T) throws where T: Encodable {
        let jsonData = try JSONEncoder().encode(doc)
        
        let dict = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? [String: Any]
        
        if let dict {
            collectionRef.addDocument(data: dict)
        }
    }
    
    func addListner() {
        
    }
}
