//
//  Comment.swift
//  Firebase-Demo
//
//  Created by Kelby Mittan on 3/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    let commentDate: Timestamp
    let commentedBy: String
    let itemId: String
    let itemName: String
    let sellerName: String
    let text: String
    
}

extension Comment {
    init(_ dictionary: [String:Any]) {
        self.commentDate = dictionary["commentDate"] as? Timestamp ?? Timestamp(date: Date())
        self.commentedBy = dictionary["commentedBy"] as? String ?? "N/A"
        self.itemId = dictionary["itemId"] as? String ?? "N/A"
        self.itemName = dictionary["itemName"] as? String ?? "N/A"
        self.sellerName = dictionary["sellerName"] as? String ?? "N/A"
        self.text = dictionary["text"] as? String ?? "N/A"
    }
}
