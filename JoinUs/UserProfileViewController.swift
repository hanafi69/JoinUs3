//
//  UserProfileViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 20/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!{
        didSet{
            settingsButton.target = self
            settingsButton.action = #selector(didTappedSettingsButton)
        
        
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var userDetail: UserData?
    lazy var userID = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        
    }
    
    @IBAction func segmentedPicker(_ sender: Any) {
        if segmentedController.selectedSegmentIndex == 0 {
        
        
        }
        
        if segmentedController.selectedSegmentIndex == 1 {
        
        
        
        }
        
    }

    func didTappedSettingsButton() {
    
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        
        self.present(settingsViewController, animated: true, completion: nil)
    
    }
    
    func fetchData() {
        
        let ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = UserData(snapshot: snapshot){
                self.imageView.sd_setImage(with: data.imageURL)
            }
            
            if let name = UserData(snapshot: snapshot){
                self.usernameLabel.text = name.username
            }
            
            if let email = UserData(snapshot: snapshot){
            
                self.emailLabel.text = email.email
            
            }
            
        })
        
        
    }
    
}

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }


}
