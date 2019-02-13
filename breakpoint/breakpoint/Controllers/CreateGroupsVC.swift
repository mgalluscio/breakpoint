//
//  CreateGroupsVC.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/12/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController {
    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailTextField: InsetTextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupMemberLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnWasPressed(_ sender: Any) {
    }
    
}
