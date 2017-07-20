//
//  UserData.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 18/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserData {

    var imageURL : URL?
    var userID : String?
    var username : String?
    var email : String?
    
    
    init?(snapshot: DataSnapshot){
        
        self.userID = snapshot.key
        
        guard let dictionary = snapshot.value as? [String: Any] else { return nil }
        
        
        if let validImageURL = dictionary["profileImageURL"] as? String {
            
            self.imageURL = URL(string: validImageURL)
        }
        
        if let validUsername = dictionary["name"] as? String {
            
            self.username = validUsername
        }
        
        if let validEmail = dictionary["email"] as? String{
            self.email = validEmail
        }
        
      
        
        
    
    }


}
