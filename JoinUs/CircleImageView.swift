//
//  CircleImageView.swift
//  JoinUs
//
//  Created by Hanafi Hisyam on 17/07/2017.
//  Copyright © 2017 Hanafi Hisyam. All rights reserved.
//


import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        
        clipsToBounds = true
    }
    
}
