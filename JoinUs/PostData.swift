//
//  PostData.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 20/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostData {
    
    var imageURL : URL?
    var username : String?
    var email : String?
    var category : String?
    var description : String?
    var postID : String?
    var userID : String
    var timestamp : Date
    var title : String
    var startAt: String
    var endAt: String
    var address : String?
    var lat : Double?
    var long : Double?
    
    
    init?(snapshot: DataSnapshot){
        
        self.postID = snapshot.key

        guard
            let dictionary = snapshot.value as? [String: Any],
            let validUsername = dictionary["username"] as? String,
            let validUserID = dictionary["userID"] as? String,
            let validTimestamp = dictionary["timestamp"] as? Double,
            let validTitle = dictionary["title"] as? String,
            let validDescription = dictionary["description"] as? String,
            let validStartAt = dictionary["startAt"] as? String,
            let validEndAt = dictionary["endAt"] as? String,
            let validCategory = dictionary["category"] as? String
        
        else { return nil }
        
        username = validUsername
        userID = validUserID
        timestamp = Date(timeIntervalSince1970: validTimestamp)
        title = validTitle
        description = validDescription
        startAt = validStartAt
        endAt = validEndAt
        category = validCategory
        
        if let validAddress = dictionary["locationAddress"] as? String{
            address = validAddress
        }
        
        if let validLat = dictionary["lat"] as? Double{
            lat = validLat
        }
        
        if let validLong = dictionary["long"] as? Double{
            long = validLong
        }
        
        if let validImageURL = dictionary["imageURL"] as? String{
            imageURL = URL(string: validImageURL)
        }
            
       
    }

}
