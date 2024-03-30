//
//  FirebaseStorageWrapper.swift
//  ChatHub
//
//  Created by Arun on 02/03/24.
//

import Foundation
import FirebaseStorage
import UIKit

final class FirebaseStorageWrapper {
    
    private let storageRef = Storage.storage().reference()
    
    private let userStorageRef: StorageReference
    
    private let imageMetadata : StorageMetadata = {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        return metadata
    }()
    
    private static let imageExtension = "jpeg"
    
    private let profilePath = "Profile/profile.\(imageExtension)"
    
    private func getUniqueImagePath(msgId: String) -> String {
        "Send/\(msgId)/\(UUID().uuidString).\(FirebaseStorageWrapper.imageExtension)"
    }
    
    init(uid: String) {
        userStorageRef = storageRef.child(uid)
    }
    
    func uploadProfileImage(uid: String, profileImageData: Data) async throws -> URL {
        let profileRef = userStorageRef.child(profilePath)
        _ = try await uploadData(at: profileRef, data: profileImageData, metadata: imageMetadata)
        let url = try await profileRef.downloadURL()
        return url
    }
    
    func uploadData(at ref: StorageReference, data: Data, metadata: StorageMetadata) async throws -> StorageMetadata {
        let uploadResult = try await ref.putDataAsync(data, metadata: metadata)
        return uploadResult
    }
    
    func uploadImages(msgId: String, _ images: [UIImage]) async throws -> [URL] {
        
        let attachedImagesRef = userStorageRef.child("Send/\(msgId)")
        
        let urls = try await withThrowingTaskGroup(of: (URL?).self) { group in
            
            var urls = [URL]()
            
            for image in images {
                
                let imageRef = attachedImagesRef.child("\(UUID().uuidString).\(FirebaseStorageWrapper.imageExtension)")
                
                if let data = image.jpegData(compressionQuality: 0.6) {
                    group.addTask { [weak self] in
                        guard let self else { return nil}
                        let _ = try await uploadData(at: imageRef, data: data, metadata: imageMetadata)
                        let url = try await imageRef.downloadURL()
                        return url
                    }
                }
                
                for try await url in group {
                    if let url {
                        urls.append(url)
                    }
                }
            }
            
            return urls
        }
        
        return urls
    }
}
