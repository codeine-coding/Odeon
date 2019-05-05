//
//  EditingBarTransition.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 2/9/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class EditingBarTransition: NSObject, UIViewControllerAnimatedTransitioning {
//    let fromVC: UIViewController
//    let toVC: UIViewController
//
//    init(fromVC: UIViewController, toVC: UIViewController) {
//        self.fromVC = fromVC
//        self.toVC = toVC
//    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1.
        let incomingView = transitionContext.view(forKey: .to)!
        let outgoingView = transitionContext.view(forKey: .from)!
        
        // 2.
        let containerView = transitionContext.containerView
        
        // 3.
        incomingView.alpha = 0
        containerView.addSubview(incomingView)
        
        // 4.
        let outgoingAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            outgoingView.alpha = 0
        }
        
        let incomingAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            incomingView.alpha = 1
        }
        
        incomingAnimation.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        outgoingAnimation.addCompletion { _ in
            incomingAnimation.startAnimation()
        }
        outgoingAnimation.startAnimation()
        
//        UIView.animate(withDuration: 0.4, animations: {
//            outgoingView.alpha = 0
//            incomingView.alpha = 1.0
//        }) { (success) in
//            // 5.
//            transitionContext.completeTransition(success)
//        }
        
    }
    

}
