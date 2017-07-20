//
//  MainViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 18/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class MainViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        }
    }
    
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!{
        didSet{
            addBarButtonItem.target = self
            addBarButtonItem.action = #selector(DidTappedAddBarButtonItem)
        
        }
    }
    
    var postEvents: [PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }

    func DidTappedAddBarButtonItem() {
    
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let addViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
            addViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: addViewController)

        self.present(navController, animated: true, completion: nil)
        
        
    }
    
    func passData(){
        
        dismiss(animated: true, completion: nil)
//        tableView.reloadData()
    }
    
    
    
    func fetchData() {
        
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            if let data = PostData(snapshot: snapshot) {
            
                self.postEvents.append(data)
                self.postEvents.sort(by: {$0.timestamp > $1.timestamp})
            
            }
            self.tableView.reloadData()
            
        })
    }
    



}

extension MainViewController: UITableViewDataSource, UITableViewDelegate, AddViewControllerDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postEvents.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        
        
        let post = postEvents[indexPath.row]
        
        cell.usernameLabel.text = post.username
        cell.categoryLabel.text = post.category
        cell.locationNameLabel.text = post.description
        cell.userImageView.sd_setImage(with: post.imageURL)
        return cell
        
    }



}


