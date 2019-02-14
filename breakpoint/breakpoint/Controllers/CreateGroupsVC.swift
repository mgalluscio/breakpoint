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
    
    var emailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailTextField.delegate = self
        // calls textFieldDidChange based on when letters added, removed, etc. This is how we will monitor whether a user is typing in the textfield
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // function called by addedTarget in viewDidLoad
    @objc func textFieldDidChange() {
        // if emailTextField is blank, empty array and reload table view
        if emailTextField.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            // otherwise, get email by textField text and set self.email array equal to returned data. Finally, reload tableView
            DataService.instance.getEmail(forSearchQuery: emailTextField.text!) { (emailArray) in
                self.emailArray = emailArray
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnWasPressed(_ sender: Any) {
    }
    
}

// conform to UiTableView protocols
extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileImage = UIImage(named: "defaultProfileImage")
        cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

// conform to UITextField protocols so we can monitor when user starts typing
extension CreateGroupsVC: UITextFieldDelegate { }
