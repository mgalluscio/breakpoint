//
//  UIViewControllerExt.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/19/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

// custom extension to build our own present and dismiss segue
extension UIViewController {
    // function is called instead of standard present, takes view to present
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        // create/instantiate transition
        let transition = CATransition()
        // choose duration, type and subtype
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        // add to view
        self.view.window?.layer.add(transition, forKey: kCATransition)
        // call present with passed viewController, no animation because we overwrote defaults
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    // function is called instead of standard dismiss function
    func dismissDetail() {
        // create/instantiate transition
        let transition = CATransition()
        // choose duration, type and subtype
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        // add to view
        self.view.window?.layer.add(transition, forKey: kCATransition)
        // call dismiss, no animation because we overwrote default
        dismiss(animated: false, completion: nil)
    }
}
