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
    private let storage = Storage.storage()
    
    // default parameters in Swift
    public func uploadPhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL,Error>) -> ()) {
        
        // 1. convert UIImage to data
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        
    }
    
    
}
