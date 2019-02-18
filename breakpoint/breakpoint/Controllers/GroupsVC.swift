//
//  SecondViewController.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/29/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
    @IBOutlet weak var groupsTableView: UITableView!
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // created all observer because getAllGroups is only a single event so we OBSERVE every time a group is added, modified, deleted, etc. THEN call get all groups and reload groupsTableView
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupsTableView.reloadData()
            }
        }
    }


}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else { return UITableViewCell() }
        // grab group from groupsArray at indexPath.row
        let group = groupsArray[indexPath.row]
        // configure cell with data from array
        cell.configureCell(title: group.groupTitle, description: group.groupDescription, memberCount: group.memberCount)
        return cell
    }
    
    // function allows us to present proper GroupFeedVC based on chosen indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else { return }
        let group = groupsArray[indexPath.row]
        groupFeedVC.initData(forGroup: group)
        present(groupFeedVC, animated: true, completion: nil)
    }
}

