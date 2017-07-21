//
//  FullPageMainViewController.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 21/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit
import SDWebImage

class FullPageMainViewController: UIViewController {
    
    @IBOutlet weak var usernammeLabel: UILabel!
    @IBOutlet weak var nameOfEvent: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
   
    var getData: PostData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernammeLabel.text = getData?.username
        self.nameOfEvent.text = getData?.name
        self.descriptionLabel.text = getData?.eventDescription
        self.categoryLabel.text = getData?.category
        self.timeStartLabel.text = getData?.startAt
        self.timeEndLabel.text = getData?.endAt
        self.addressLabel.text = getData?.placemarkLocation
        self.imageView.sd_setImage(with: getData?.imageURL)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       self.navigationController?.isNavigationBarHidden = false

    }
   
}

