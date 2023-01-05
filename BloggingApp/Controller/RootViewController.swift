//
//  RootViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class RootViewController: UIViewController {
    
    private var userManager = UserManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        userManager.delegate = self
        userManager.fetchUser()
        title = "Root"
        navigationController?.isNavigationBarHidden = true
    }


}

extension RootViewController: UserManagerDelegate {
    
    func didUpdateUser() {
        if userManager.user == nil {
            let loginViewController = LoginViewController(userManager: userManager)
            navigationController?.pushViewController(loginViewController, animated: false)
        } else {
            let mainTabBarController = MainTabBarController(userManager: userManager)
            navigationController?.pushViewController(mainTabBarController, animated: true)
        }
    }
    
    func didLogoutUser() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
