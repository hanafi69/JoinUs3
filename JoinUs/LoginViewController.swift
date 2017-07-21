//
//  LoginViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 17/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
            passwordTextField.returnKeyType = .done
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        }
    }

    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.addTarget(self, action: #selector(didTappedRegisterButton(_ :)), for: .touchUpInside)
        
        }
    }
    
    
    
        
    @IBOutlet weak var joinUsLabel: UILabel!
    
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.backgroundColor = UIColor.gray
        labelBorder()
        buttonRadius()
    }
    
    func buttonRadius() {
        
        loginButton.layer.cornerRadius = 5.0
        registerButton.layer.cornerRadius = 5.0
        
    }

    

    
    func labelBorder() {
        
        joinUsLabel.layer.borderColor = UIColor.black.cgColor
        joinUsLabel.layer.borderWidth = 2.0
        
        
    }

    
    func didTappedRegisterButton(_ sender : Any) {
    
        let authStoryboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let registerViewController = authStoryboard.instantiateViewController(withIdentifier: "UserSignUpViewController") as! UserSignUpViewController
        self.navigationController?.pushViewController(registerViewController, animated: true)
    
    
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didTapLoginButton(_ sender: Any){
        myActivityIndicator.startAnimating()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {
                return;
        }
        
        if emailTextField.text == ""{
            
            self.warningAlert(warningMessage: "Please enter your email")
            
        } else if password == "" || password.characters.count < 6 {
            self.warningAlert(warningMessage: "Please enter your password")
            
        } else {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    self.warningAlert(warningMessage: "Please enter your email or password correctly!")
                    return;
                }
                
                print("User exist \(user?.uid ?? "")")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                self.present(mainVC, animated: true, completion: nil)

            })
        }
    }
    
    
    
    func setupSpinner(){
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
        }
        return true
        
    }
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
        
    }
    

    
    

}
