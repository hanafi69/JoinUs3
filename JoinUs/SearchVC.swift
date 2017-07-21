//
//  SearchVC.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 21/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        
        }
    
    }
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var getPost: [PostData] = []
    var searchPost: [PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDetails()

    }
    
    func getDetails() {
        
            let ref = Database.database().reference()
            
            ref.child("Posts").observe(.childAdded, with: { (snapshot) in
                if let data = PostData(snapshot: snapshot) {
                    
                    self.getPost.append(data)
                    
                }
                
                self.searchPost = self.getPost
                self.tableView.reloadData()
            })
    }
}


extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        
        let post = searchPost[indexPath.row]
        
        cell.usernameLabel.text = post.username
        cell.categoryLabel.text = post.category
        cell.locationNameLabel.text = post.name
        cell.postImageView.sd_setImage(with: post.imageURL)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return searchPost.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = searchPost[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let fullPageVC = storyboard.instantiateViewController(withIdentifier: "FullPageMainViewController") as! FullPageMainViewController
        fullPageVC.getData = post
        
        
        self.navigationController?.pushViewController(fullPageVC, animated: true)
        
    }

}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchPost = searchText.isEmpty ? getPost : getPost.filter { (item: PostData) -> Bool in
            return item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        
    }
}
