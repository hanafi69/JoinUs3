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
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

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
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!{
        didSet{
            fbLoginButton.delegate = self
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.backgroundColor = UIColor.gray
    }

    
    func didTappedRegisterButton(_ sender : Any) {
    
        let authStoryboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let registerViewController = authStoryboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
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
                let mainVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
                self.present(mainVC, animated: true, completion: nil)

            })
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            
            print(error.localizedDescription)
            fbAlert(message: "Please try again")
            return
            
        } else if (result.isCancelled == true){
            
            print("Cancelled")
            
        } else {
            
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                print("user logged in the firebase")
                
                let ref = Database.database().reference(fromURL: "https://joinus-1d50d.firebaseio.com/")
                
                guard let uid = user?.uid else {
                    return
                }
                
                let userReference = ref.child("users").child(uid)
                
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"])
                graphRequest.start(completionHandler: { (connection, result, error) in
                    if error != nil {
                        print("\(String(describing: error))")
                    } else {
                        let values : [String: Any] = result as! [String : Any]
                        
                        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print("\(String(describing: error))")
                                return
                            }
                            
                            // no error, so it means we've saved the user into our firebase database successfully
                            print("Save the user successfully into Firebase database")
                        })
                    }
                })
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
            self.present(mainVC, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook logout successfully!")
        fbAlert(message: "Facebook logout successfully!")
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
    
    func fbAlert(message: String){
        let alertController = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }


    
    

}
