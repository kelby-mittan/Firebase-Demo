//
//  DatabaseService.swift
//  Firebase-Demo
//
//  Created by Kelby Mittan on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let itemsCollection = "items" // collections
    
    // get a reference to the firestore data base
    private let db = Firestore.firestore()
    
    public func createItem(itemName: String, price: Double, category: Category, displayName: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        // generate a document from the "items" collection
        let documentRef = db.collection(DatabaseService.itemsCollection).document()
        
        // create a document in our item's collection
        
        /*
         these will be our keys
         let itemName: String
         let price: Double
         let itemId: String
         let listedDate: Date
         let sellerName: String
         let categoryName: String
         */
        db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName":itemName ,"price":price , "itemId":documentRef.documentID , "listedDate":Timestamp(date: Date()) , "sellerName":displayName , "sellerId": user.uid , "categoryName":category.name]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            
        }
    }
}
