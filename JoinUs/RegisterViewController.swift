//
//  RegisterViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 17/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailButton: UIButton!{
        didSet{
            emailButton.addTarget(self, action: #selector(didTappedEmailButton(_ :)), for: .touchUpInside)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func didTappedEmailButton(_ sender : Any){
    
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let userSigUpViewController = storyboard.instantiateViewController(withIdentifier: "UserSignUpViewController")
        self.navigationController?.pushViewController(userSigUpViewController, animated: true)
    
    }


}
