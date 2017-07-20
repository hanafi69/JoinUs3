//
//  MainTableViewCell.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 20/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
//  @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var cellData: PostData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
