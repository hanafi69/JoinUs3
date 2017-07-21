//
//  UserSignUpViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 17/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserSignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{

            usernameTextField.attributedPlaceholder = NSAttributedString(string: "First and last name",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
            usernameTextField.delegate = self
            
        }
    }
    
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
        }
    }
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!{
        didSet{
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var changeButton: UIButton! {
        didSet{
            changeButton.addTarget(self, action: #selector(didTapSelectProfileButton(_:)), for: .touchUpInside)
        }
    }
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var isImageSelected : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.backgroundColor = UIColor.gray
        
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        buttonRadius()
        
    }
    
    
    func buttonRadius() {
        
        signUpButton.layer.cornerRadius = 5.0
        //        signUpButton.layer.borderWidth = 1.0
        //        signUpButton.layer.borderColor = UIColor.black.cgColor
        
        changeButton.layer.cornerRadius = 5.0
        //        logInButton.layer.borderWidth = 1.0
        //        logInButton.layer.borderColor = UIColor.white.cgColor
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
    }

    
    func imageTapped(sender: UITapGestureRecognizer) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let alertController = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true,completion: nil)
                return
            }
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        return true
    }
    
    func didTapSelectProfileButton(_ sender: Any){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    
    func didTapSignUpButton(_ sender: Any){
        self.myActivityIndicator.startAnimating()
        
        guard
            let name = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
            else { return; }
        
        if name == "" {
            self.warningAlert(warningMessage: "Please enter your first and last name")
            
        } else if password == "" {
            self.warningAlert(warningMessage: "Please enter your password")
            
        } else if password.characters.count < 6  {
            self.warningAlert(warningMessage: "Please enter minimum of 6 characters for password")
            
        } else if email == "" {
            self.warningAlert(warningMessage: "Please enter your email")
            
        } else if password != confirmPassword {
            self.warningAlert(warningMessage: "Please enter your password and confrim password correctly!")
            
        } else if isImageSelected == false {
            self.warningAlert(warningMessage: "Please select profile picture!")
            
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    self.warningAlert(warningMessage: "Please enter another email address!")
                    return;
                }
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                let storageRef = Storage.storage().reference()
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                let data = UIImageJPEGRepresentation(self.imageView.image!, 0.8)
                
                storageRef.child("\(uid).jpg").putData(data!, metadata: metadata) { (newMeta, error) in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        print(error!)
                    } else {
                        
                        defer{
                            self.dismiss(animated: true, completion: nil) //so the return function will return this
                        }
                        
                        if let foundError = error {
                            print(foundError.localizedDescription)
                            return
                        }
                        
                        guard let imageURL = newMeta?.downloadURLs?.first?.absoluteString else {
                            return
                        }
                        
                        let param : [String : Any] = ["name": name,
                                                      "email": email,
                                                      "profileImageURL": imageURL]
                        
                        let ref = Database.database().reference().child("users")
                        ref.child(uid).setValue(param)
                    }
                }
                
                self.myActivityIndicator.stopAnimating()
                
                print("User sign-up successfully! \(user?.uid ?? "")")
                print("User email address! \(user?.email ?? "")")
                print("Username is \(name)")
            })
        }
    }
    
    func setupSpinner(){
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
    }
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
        
    }
    
}

extension UserSignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //media is album , photo is picture. rmb to allow it in plist
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //cancel button in photo
        self.isImageSelected = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imageView.image = selectedImage
        
        self.isImageSelected = true
        
        dismiss(animated: true, completion: nil)
        
    }
}



