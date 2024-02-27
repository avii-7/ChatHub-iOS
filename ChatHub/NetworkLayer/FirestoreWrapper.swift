//
//  FirestoreWrapper.swift
//  ChatHub
//
//  Created by Arun on 24/02/24.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

class FirestoreWrapper {
    
    private let collectionRef: CollectionReference
    
    private var listener: ListenerRegistration?
    
    init(collectionName: String) {
        collectionRef = Firestore.firestore().collection(collectionName)
    }
    
    func registerLister(onChange: @escaping (([DocumentChange]) -> Void)) {

        listener = collectionRef.addSnapshotListener(includeMetadataChanges: false) { querySnapshot, error in
            if let changedDocs = querySnapshot?.documentChanges {
                onChange(changedDocs)
            }
        }
    }
    
    func getAllDocuments<T>(orderByTimeStamp: Bool = true) async throws -> [T] where T: Decodable {
        let querySnapshot: QuerySnapshot
        
        if orderByTimeStamp {
            querySnapshot = try await collectionRef
               .order(by: FieldPath.init(["timeStamp"])).getDocuments()
        }
        else {
            querySnapshot = try await collectionRef.getDocuments()
        }
        
        var docs = [T]()
        
        for document in querySnapshot.documents {
            let docData = try document.data(as: T.self, with: .estimate)
            docs.append(docData)
        }
        
        return docs
    }
    
    func addDocument<T>(doc: T) throws where T: Encodable {
        try collectionRef.document().setData(from: doc)
    }
    
    func unregisterListener() {
        listener?.remove()
    }
}
