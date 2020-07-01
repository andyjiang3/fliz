//
//  PresentAndDismiss.swift
//  FlashQuiz
//
//  Created by Andy Jiang on 1/5/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit

extension UIViewController {

        //Present view controllers animation
        func presentDetail(_ viewControllerToPresent: UIViewController) {
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            
            self.present(viewControllerToPresent, animated: false)
        }
    
        //Dismiss view controllers animation
        func dismissDetail() {
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.view.window!.layer.add(transition, forKey: kCATransition)
            
            dismiss(animated: false)
        }
    

 
}


