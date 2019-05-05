//
//  CategoryDetailPopTransition.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 1/20/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class CategoryDetailPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var cellFrame: CGRect
    var cellPosition: CGPoint
    var fromViewOriginFrame: CGRect
    
    init(cellFrame: CGRect, cellPosition: CGPoint, fromViewOriginFrame: CGRect) {
        self.cellFrame = cellFrame
        self.cellPosition = cellPosition
        self.fromViewOriginFrame = fromViewOriginFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromViewControiller = transitionContext.viewController(forKey: .from) as? CategoryDetailViewController else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
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
        
        container.insertSubview(toViewController.view, belowSubview: fromViewControiller.view)
//        NSLayoutConstraint.deactivate([widthConstraint, heightConstraint, bottomConstraint, topConstraint])
        fromViewControiller.view.frame.size.width = self.fromViewOriginFrame.width
        fromViewControiller.view.frame.size.height = self.fromViewOriginFrame.height
        fromViewControiller.view.layer.transform = CATransform3DIdentity
        fromViewControiller.view.layer.cornerRadius = 0
        fromViewControiller.headerView.headerTitle.font = UIFont(name: Font.Animosa.Bold, size: 36)
        fromViewControiller.bannerView.alpha = 1
        
        container.layoutIfNeeded()
        
        
        let duration = self.transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.6) {
            
            let translate = CATransform3DMakeTranslation(self.cellPosition.x, self.cellPosition.y + topDistance, 0.0)
            
            fromViewControiller.view.frame.size.width = self.cellFrame.size.width
            fromViewControiller.view.frame.size.height = self.cellFrame.size.height
            fromViewControiller.view.layer.transform = translate
//            fromViewControiller.view.layer.zPosition = 999
            fromViewControiller.view.layer.cornerRadius = 20
            fromViewControiller.view.layer.masksToBounds = true
            fromViewControiller.headerView.headerTitle.font = UIFont(name: Font.Animosa.ExtraBold, size: 26)
            fromViewControiller.bannerView.alpha = 0
            fromViewControiller.view.alpha = 0
            container.layoutIfNeeded()
        }
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        animator.startAnimation()
    }
    
}
