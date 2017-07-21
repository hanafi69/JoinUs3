//
//  SearchCell.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 21/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    var getData : PostData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
