//
//  MainTabBarController.swift
//  Odeon
//
//  Created by Allen Whearry on 4/11/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {

        let QotdController = UINavigationController(rootViewController: HomeViewController())
        QotdController.title = "QoTD"
        QotdController.tabBarItem.image = UIImage(named: "qotd")

        let categoriesController = UINavigationController(rootViewController: CategoriesViewController())
        categoriesController.title = "Categories"
        categoriesController.tabBarItem.image = UIImage(named: "category")

        let discoverController = UINavigationController(rootViewController: DiscoverViewController())
        discoverController.title = "Discover"
        discoverController.tabBarItem.image = UIImage(named: "discover")

        let bookmarksController = UINavigationController(rootViewController: BookmarksViewController())
        bookmarksController.title = "Bookmarks"
        bookmarksController.tabBarItem.image = UIImage(named: "bookmark")

//        let settingsController = UINavigationController(rootViewController: SettingsViewController())
//        settingsController.title = "Settings"
//        settingsController.tabBarItem.image = UIImage(named: "settings")

        self.viewControllers = [
            QotdController,
            categoriesController,
            discoverController,
            bookmarksController,
//            settingsController,
        ]
        self.selectedIndex = 0
//        self.delegate = self
        self.tabBar.isTranslucent = false

    }


}
