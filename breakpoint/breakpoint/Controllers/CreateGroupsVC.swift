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
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailTextField.delegate = self
        // calls textFieldDidChange based on when letters added, removed, etc. This is how we will monitor whether a user is typing in the textfield
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
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
        // configure cell with checkmark if chosenUserArray contains the user from emailArray at indexPath.row
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        } else {
            // otherwise, no checkmark.
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    // called when row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // grab chosen cell
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        // if the chosen email is not already in the array, add it, update label and display check button
        if !chosenUserArray.contains(cell.emailLbl.text!) {
            chosenUserArray.append(cell.emailLbl.text!)
            groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            // if they're already in the array we need to remove them
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLbl.text })
            // if there is one or more email in the array, show the new updated list.
            if chosenUserArray.count >= 1 {
                groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
            } else {
                // otherwise, show "ADD PEOPLE TO YOUR GROUP" label and hide the doneBtn
                groupMemberLbl.text = "ADD PEOPLE TO YOUR GROUP"
                doneBtn.isHidden = true
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

// conform to UITextField protocols so we can monitor when user starts typing
extension CreateGroupsVC: UITextFieldDelegate { }
