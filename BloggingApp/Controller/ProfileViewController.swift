//
//  ProfileViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let userManager: UserManager
    let followManager: FollowManager
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("edit", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = userManager.user?.profilePicture
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = userManager.user?.username
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(13)
        label.text = "\(followManager.getFollowers().count) followers"
        return label
    }()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = userManager.user?.about
        return label
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(userManager: UserManager) {
        self.userManager = userManager
        self.followManager = FollowManager(user: userManager.user!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager.profileDelegate = self
        navigationController?.isNavigationBarHidden = true
        layoutView()
    }
    
    @objc private func editButtonPressed() {
        let editProfileVC = EditProfileViewController(userManager: userManager)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc private func logoutButtonPressed() {
        userManager.logOut()
    }
    
    private func layoutView() {
        view.backgroundColor = .systemBackground
        view.addSubview(editButton)
        view.addSubview(profilePicture)
        view.addSubview(usernameLabel)
        view.addSubview(followersLabel)
        view.addSubview(aboutLabel)
        view.addSubview(logoutButton)
        setConstraints()
    }
    
    private func setConstraints() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        profilePicture.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 16).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        followersLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16).isActive = true
        followersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        aboutLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 16).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}

extension ProfileViewController: ProfileManagerDelegate {
    
    func didUpdateUser() {
        profilePicture.image = userManager.user?.profilePicture
        usernameLabel.text = userManager.user?.username
        aboutLabel.text = userManager.user?.about
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}
