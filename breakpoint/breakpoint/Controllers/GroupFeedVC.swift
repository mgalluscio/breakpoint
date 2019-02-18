//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/17/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class GroupFeedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var group: Group?
    
    // used to initialize group data from GroupsVC
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    // sets group title and group members every time view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // binds view to keyboard so it slides up with keyboard
        sendBtnView.bindToKeyboard()
    }
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendBtnWasPressed(_ sender: Any) {
    }
}
