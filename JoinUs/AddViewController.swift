//
//  AddViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 18/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import MapKit

protocol AddViewControllerDelegate {
    func passData()
}

class AddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    
    
    @IBOutlet weak var startButton: UIButton!{
        didSet{
            startButton.addTarget(self, action: #selector(didTappedStartButton(_ :)), for: .touchUpInside)
            
        }
    }
    
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!{
        didSet{
        
            closeBarButtonItem.target = self
            closeBarButtonItem.action = #selector(didTappedCloseBarButtonItem)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
            mapView.mapType = .standard
            
            
        }
    }
    
  
    
    @IBOutlet weak var chooseCategoryList: UIPickerView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Give your JoinUs a name",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
        
            nameTextField.delegate = self
        }
    
    }
    
    @IBOutlet weak var descriptionTextField: UITextField!{
        didSet{
            descriptionTextField.attributedPlaceholder = NSAttributedString(string: "Descript it as simple as possible",
                                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        
            
            descriptionTextField.delegate = self
            descriptionTextField.returnKeyType = .done
            
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var userDetail: UserData?
    var locationManager = CLLocationManager()
    var placemarkLocation: String?
    var getLat: Double?
    var getLong: Double?
    let pinView = MKPointAnnotation()
    var selectedAnnotation: MKPointAnnotation?
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var categoryList = ["Outdoors & Adventure", "Tech", "Family", "Health & Wellness", "Sports & Fitness", "Learning", "Photograhy", "Food & Drinks", "Writing", "Language & Culture", "Music", "Movements", "Film", "Sci-Fi & Games", "Belief", "Arts", "Book Clubs", "Dance", "Pets", "Hobbies & Crafts", "Fashion & Beauty", "Sociol", "Social", "Career & Business"]
    var delegate: AddViewControllerDelegate?
    var getUsername : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchImage()
        getUsernameFromFirebase()
        Post()
        self.locationManager.delegate = self
        determineCurrentLocation()
        setupSpinner()
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.backgroundColor = UIColor.gray
        
        chooseCategoryList.dataSource = self
        chooseCategoryList.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupSpinner(){
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            descriptionTextField.becomeFirstResponder()
        }else if textField == descriptionTextField{
            descriptionTextField.resignFirstResponder()
        }
        return true
        
    }
    

    func didTappedCloseBarButtonItem() {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTappedStartButton(_ sender: Any){
        myActivityIndicator.startAnimating()
        
        if nameTextField.text == ""{
            
            self.warningAlert(warningMessage: "Please enter your location name")
            
        } else if descriptionTextField.text == "" {
            self.warningAlert(warningMessage: "Please enter your description")
            
        } else {
            
            Post()
            
        
        }
    }
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        self.myActivityIndicator.stopAnimating()
        
    }
    
    @IBAction func startDatePicker(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYY, HH:mm a"
        startLabel.text = formatter.string(from: startDate.date)
        
    }
    
    @IBAction func endDatePicker(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYY, HH:mm a"
        endLabel.text = formatter.string(from: endDate.date)
        
    }
    
    func loadPlaceMark(location: CLLocation ) {
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let validError = error{
                
                print(validError.localizedDescription)
                
            }
            
            if let placemark = placemarks?.first {
                
                self.placemarkLocation = "\(placemark.name ?? "") \(placemark.thoroughfare ?? "") \(placemark.locality ?? "")"
            
                var text : [String] = []
                
                for item in [placemark.name, placemark.thoroughfare, placemark.locality] {
                    
                    if let name = item { text.append(name) }
                }
                
                let finalText = text.joined(separator: ", ")
                
                self.placemarkLocation = finalText
                
                if let displayTextOnPin = self.placemarkLocation {
                    
                    self.selectedAnnotation?.title = "\(displayTextOnPin)"
                }
                
                
            }
            
        }
        
    }
    
    func Post(_ message: String? = nil, imageURL: String? = nil) {
    
        guard
            let userID = Auth.auth().currentUser?.uid,
            let description = descriptionTextField.text,
            let name = nameTextField.text,
            let startDate = startLabel.text,
            let endDate = endLabel.text,
            let latitude = getLat,
            let longtitude = getLong,
            let category = categoryLabel.text
            
            
        else { return }
        
        let now = Date()
        
        var param : [String:Any] = ["userID":userID,
                                    "timeStamp":now.timeIntervalSince1970,
                                    "description":description,
                                    "name":name,
                                    "username": self.getUsername,
                                    "timeStart":startDate,
                                    "timeEnd": endDate,
                                    "latitude":latitude,
                                    "longtitude":longtitude,
                                    "category": category,
                                    "placeMarkLocation": placemarkLocation ?? ""]
        
        if let validMessage = message {
            param["message"] = validMessage
        }
        
        if let validImageURL = imageURL {
            param["imageURL"] = validImageURL
        }
        
        let ref = Database.database().reference()
        ref.child("Posts").childByAutoId().setValue(param)
        nameTextField.text = nil
        
        
        let currentPID = ref.key
        print(currentPID)
        
        let updateUserPID = Database.database().reference().child("users").child(userID).child("Posts")
        updateUserPID.updateChildValues([currentPID: true])
        
        self.delegate?.passData()
    
    }
    
    
    func determineCurrentLocation() {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func getUsernameFromFirebase() {
        
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any],
                let name = dictionary["name"] as? String {
                
                self.getUsername = name
            }
        })
    }
    


    
    func fetchImage() {

        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = UserData(snapshot: snapshot){
                self.imageView.sd_setImage(with: data.imageURL)
            }
        })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryLabel.text = categoryList[row]
        
    }

}

extension AddViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKPinAnnotationView()
        annotationView.pinTintColor = .blue
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.isDraggable = true
        annotationView.canShowCallout = true
        
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Tapped")
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        switch newState {
            
        case .starting:
            print("dragging")
        case .ending, .canceling:
            guard
                
                let lat = view.annotation?.coordinate.latitude,
                let long = view.annotation?.coordinate.longitude
                
                else { return }
            
            let coordinates: CLLocation = CLLocation(latitude: lat, longitude: long)
            
            self.selectedAnnotation?.title = "SAVED"
            
            self.loadPlaceMark(location: coordinates)
            
            getLat = lat
            getLong = long
        default:
            
            break
            
            
        }
        
    }

}

extension AddViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegionMake(locValue, span)
        
        self.locationManager.stopUpdatingLocation()
        
        self.pinView.coordinate = locValue
        self.pinView.title = "CURRENT LOCATION"
        
        mapView.addAnnotation(self.pinView)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        selectedAnnotation = view.annotation as? MKPointAnnotation
    }
}

