//
//  MainTabBarController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        setupTabBar()
    }
    
    private func setupTabBar() {
        viewControllers = [
            setupVC(viewController: FeedPageViewController(userManager: userManager), title: "Feed", image: UIImage(systemName: "house")),
            setupVC(viewController: ProfileViewController(userManager: userManager), title: "Profile", image: UIImage(systemName: "person"))
        ]
    }

    private func setupVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}
