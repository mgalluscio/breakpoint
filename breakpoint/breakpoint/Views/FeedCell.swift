//
//  FeedCell.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/8/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

// custom class for FeedCell 
class FeedCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    // configures cell with content passed from parameters
    func configureCell(profileImage: UIImage, email: String, content: String) {
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = content
    }
    
}
