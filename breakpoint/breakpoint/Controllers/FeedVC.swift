//
//  FirstViewController.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/29/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // called every time the view DID appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // get all messages and copy them to local array then reload tableView so changes will appear
        DataService.instance.getAllFeedMessages { (returnedMessagesArray) in
            self.messageArray = returnedMessagesArray
            self.tableView.reloadData()
        }
    }
}

// extension to conform to proper protocols
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // safely create cell of type FeedCell. Otherwise, return empty cell.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return UITableViewCell() }
        let image = UIImage(named: "defaultProfileImage")
        // grabs message in array based on row of tableView
        let messages = messageArray[indexPath.row]
        // configure cell using function in FeedCell
        cell.configureCell(profileImage: image!, email: messages.senderId, content: messages.content)
        return cell
    }
}

