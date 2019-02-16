//
//  UserCell.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/13/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false
    
    // perform some logic when tableViewCell is set to selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // when selected
        if selected {
            // if showing is equal to false, set showing to true and show checkImage
            if showing == false {
                checkImage.isHidden = false
                showing = true
            } else {
                // otherwise, hide the image and set showing to false
                checkImage.isHidden = true
                showing = false
            }
        }
    }
    
    // called to configure cell
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
        self.profileImage.image = image
        self.emailLbl.text = email
        if isSelected {
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
    }

}
