//
//  StrangerProfileViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 06.01.2023.
//

import UIKit

class StrangerProfileViewController: UIViewController {

    let userManager: UserManager
    let followManager: FollowManager
    let strangerId: String
    
    init(userManager: UserManager, followManager: FollowManager, strangerId: String) {
        self.userManager = userManager
        self.followManager = followManager
        self.strangerId = strangerId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in stranger profile")
        layoutView()
        // Do any additional setup after loading the view.
    }
    
    func layoutView() {
        view.backgroundColor = .systemBackground
    }

}
