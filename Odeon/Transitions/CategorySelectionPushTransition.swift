//
//  CategorySelectionPushTransition.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 1/18/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class CategorySelectionPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var cellFrame: CGRect
    var cellPosition: CGPoint
    var toViewOriginFrame: CGRect
    
    init(cellFrame: CGRect, cellPosition: CGPoint, toViewOriginFrame: CGRect) {
        self.cellFrame = cellFrame
        self.cellPosition = cellPosition
        self.toViewOriginFrame = toViewOriginFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to) as? CategoryDetailViewController else { return }
        
        var topDistance: CGFloat {
            get{
                if toViewController.navigationController != nil && !toViewController.navigationController!.navigationBar.isTranslucent{
                    return 0
                }else{
                    let barHeight = toViewController.navigationController?.navigationBar.frame.height ?? 0
                    let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                    return barHeight + statusBarHeight + 8
                }
            }
        }
        let widthConstraint = toViewController.headerView.widthAnchor.constraint(equalToConstant: cellFrame.size.height)
        let heightConstraint = toViewController.headerView.heightAnchor.constraint(equalToConstant: cellFrame.size.height)
        let topConstraint = toViewController.view.topAnchor.constraint(equalTo: toViewController.headerView.topAnchor)
        let bottomConstraint = toViewController.view.bottomAnchor.constraint(equalTo: toViewController.headerView.bottomAnchor)
        
        container.addSubview(toViewController.view)
        // Initial State
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, bottomConstraint, topConstraint])
        let translate = CATransform3DMakeTranslation(cellPosition.x, cellPosition.y + topDistance, 0.0)
        
        toViewController.view.frame.size.width = cellFrame.size.width
        toViewController.view.frame.size.height = cellFrame.size.height
        toViewController.view.layer.transform = translate
        toViewController.view.layer.zPosition = 999
        toViewController.view.layer.cornerRadius = 20
        toViewController.view.layer.masksToBounds = true
        toViewController.headerView.headerTitle.font = UIFont(name: Font.Animosa.ExtraBold, size: 26)
        toViewController.bannerView.alpha = 0
        container.layoutIfNeeded()
        
        
        
        let duration = self.transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.6) {
            // final state
            NSLayoutConstraint.deactivate([widthConstraint, heightConstraint, bottomConstraint, topConstraint])
            toViewController.view.frame.size.width = self.toViewOriginFrame.width
            toViewController.view.frame.size.height = self.toViewOriginFrame.height
            toViewController.view.layer.transform = CATransform3DIdentity
            toViewController.view.layer.cornerRadius = 0
            toViewController.headerView.headerTitle.font = UIFont(name: Font.Animosa.Bold, size: 36)
            toViewController.bannerView.alpha = 1
            
            container.layoutIfNeeded()
        }
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        animator.startAnimation()
    }
    
    
}
