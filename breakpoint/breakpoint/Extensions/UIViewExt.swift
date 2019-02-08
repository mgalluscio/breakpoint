//
//  UIViewExt.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/8/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

// binds any object that inherits from UIView class (really UIControl, but could be imageView, button, textView, etc.) to keyboard
extension UIView {
    // utilizes notification center observer for whenever the keyboardWillChangeFrame is called. For performs action when that notification is called.
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // function called by observer in bindToKeyboard. Takes one parameter, a notification which tells the function what object is calling it.
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        // mimicks the way the keyboard animates up
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // subtracts the y values from endFrame and beginningFrame so we know the height of the keyboard
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        // animates frames -- makes the magic happen
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            // adds the height (deltaY) to the frame being animated
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
