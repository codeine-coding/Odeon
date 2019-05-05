//
//  EditViewTabBarController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 2/7/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class EditViewTabBarController: UITabBarController {
    let backgroundEdit = BackgroundEditViewController()
    let fontEdit = FontEditViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    

    fileprivate func setupView() {
        backgroundEdit.title = "Background"
        backgroundEdit.tabBarItem.image = UIImage(named: "chooseBackground")
        fontEdit.title = "Text"
        fontEdit.tabBarItem.image = UIImage(named: "text")
        
        viewControllers = [
            backgroundEdit,
            fontEdit
        ]
        
        delegate = self
        tabBar.isTranslucent = false
//        tabBar.barStyle = .blackOpaque
    }

}

extension EditViewTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return EditingBarTransition()
    }
}

