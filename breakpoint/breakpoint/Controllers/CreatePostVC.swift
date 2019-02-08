//
//  CreatePostVC.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/7/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        sendBtn.bindToKeyboard()
        // could use bindToKeyboard() on these objects too
//        profileImage.bindToKeyboard()
//        emailLbl.bindToKeyboard()
    }
    
    // uploads post when send button is pressed
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if textView.text != nil && textView.text != "Say something here..." {
            // disable button so it can't be double, triple sent
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (isComplete) in
                if isComplete {
                    self.sendBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.sendBtn.isEnabled = true
                    print("There was an issue sending the message!")
                }
            }
        }
    }
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostVC: UITextViewDelegate {
    // if text view is edited textView.text turns to empty string so it's like a placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
