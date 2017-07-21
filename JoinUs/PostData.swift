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
    var eventDescription : String?
    var postID : String?
    var userID : String
    var timestamp : Date
    
    var startAt: String
    var endAt: String
    var placemarkLocation : String?
    var lat : Double?
    var long : Double?
    var name: String?
    
    
    init?(snapshot: DataSnapshot){
        
        self.postID = snapshot.key

        guard let dictionary = snapshot.value as? [String : Any] else { return nil }
        guard let validUsername = dictionary["username"] as? String else { return nil }
        guard let validName = dictionary["name"] as? String else { return nil }
        guard let validUserID = dictionary["userID"] as? String else { return nil }
        guard let validTimestamp = dictionary["timeStamp"] as? Double else { return nil }
        guard let validDescription = dictionary["eventDescription"] as? String else { return nil }
        guard let validStartAt = dictionary["timeStart"] as? String else { return nil }
        guard let validEndAt = dictionary["timeEnd"] as? String else { return nil }
        guard let validCategory = dictionary["category"] as? String else { return nil }
        
        username = validUsername
        userID = validUserID
        timestamp = Date(timeIntervalSince1970: validTimestamp)
        
        eventDescription = validDescription
        startAt = validStartAt
        endAt = validEndAt
        category = validCategory
        name = validName
        
        if let validPlacemark = dictionary["placeMarkLocation"] as? String{
            placemarkLocation = validPlacemark
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
