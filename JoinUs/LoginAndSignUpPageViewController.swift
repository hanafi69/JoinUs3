//
//  LoginAndSignUpPageViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 17/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit

class LoginAndSignUpPageViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            
            signUpButton.addTarget(self, action: #selector(didTappedSignUpButton(_ :)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var logInButton: UIButton! {
        didSet{
            logInButton.addTarget(self, action: #selector(didTappedLogInButton(_ :)), for: .touchUpInside)
            
        }
    }
    @IBOutlet weak var joinUsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonRadius()
        labelBorder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
    
    }
    
    
    
    func buttonRadius() {
        
        signUpButton.layer.cornerRadius = 15.0
//        signUpButton.layer.borderWidth = 1.0
//        signUpButton.layer.borderColor = UIColor.black.cgColor
        
        logInButton.layer.cornerRadius = 15.0
//        logInButton.layer.borderWidth = 1.0
//        logInButton.layer.borderColor = UIColor.white.cgColor
    
    
    }
    
    func labelBorder() {
    
        joinUsLabel.layer.borderColor = UIColor.black.cgColor
        joinUsLabel.layer.borderWidth = 2.0
    
    
    }
    
    func didTappedSignUpButton(_ sender : Any) {
    
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let registerViewController = storyboard.instantiateViewController(withIdentifier: "UserSignUpViewController") as! UserSignUpViewController
        
        self.navigationController?.pushViewController(registerViewController, animated: true)
    
    
    
    }
    
    func didTappedLogInButton(_ sender : Any){
        
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
    
    
    }

    

}
