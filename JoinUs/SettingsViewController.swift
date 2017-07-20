//
//  SettingsViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 20/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit
import SDWebImage

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!{
        didSet{
            signOutButton.addTarget(self, action: #selector(didTappedSignOutButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!{
        didSet{
            
            closeBarButtonItem.target = self
            closeBarButtonItem.action = #selector(didTappedCloseBarButtonItem)
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var userDetail: UserData?
    lazy var userID = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchImage()
    }
    
    func fetchImage() {
        
        let ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = UserData(snapshot: snapshot){
                self.imageView.sd_setImage(with: data.imageURL)
            }
            
            if let name = UserData(snapshot: snapshot){
                self.usernameLabel.text = name.username
            }
            
        })
        
        
    }
    
    

    func didTappedSignOutButton(_ sender : Any){
        
        let firebaseAuth = Auth.auth()
        let loginManager = FBSDKLoginManager() //FB system logout
        
        do {
            try firebaseAuth.signOut()
            loginManager.logOut()
            
            print ("Logged out successfully!")
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
            return
        }
        
    }
    
    func didTappedCloseBarButtonItem() {
    
        self.dismiss(animated: true, completion: nil)
    
    
    }


}
