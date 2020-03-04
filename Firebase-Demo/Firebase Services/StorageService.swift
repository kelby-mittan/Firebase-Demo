//
//  StorageService.swift
//  Firebase-Demo
//
//  Created by Kelby Mittan on 3/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    
    // in our app we will be uploading a photo to storage in two places
    // 1. ProfileViewController
    // 2. CreateItemViewController
    
    // we will be creating two different buckets of folders 1. UserProfilePhotos 2. ItemPhotos
    
    // let's create a reference to the Firebase storage
    private let storageRef = Storage.storage().reference()
    
    // default parameters in Swift
    public func uploadPhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL,Error>) -> ()) {
        
        // 1. convert UIImage to data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        // 2. establish which bucket we will be saving image to
        var photoReference: StorageReference!
        
        if let userId = userId { // coming from ProfileViewController
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        } else if let itemId = itemId { // coming from CreateItemViewController
            photoReference = storageRef.child("ItemsPhotos/\(itemId).jpg")
        }
        
        // 3. configure the metadata for the object being uploaded
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let _ = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
    
    
}
