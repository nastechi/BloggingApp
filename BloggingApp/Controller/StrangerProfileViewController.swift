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
    let strangerUser: User
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = strangerUser.profilePicture
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = strangerUser.username
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(13)
        return label
    }()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = strangerUser.about
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(userManager: UserManager, followManager: FollowManager, strangerUser: User) {
        self.userManager = userManager
        self.followManager = followManager
        self.strangerUser = strangerUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followManager.delegate = self
        followManager.fetchFollowers(forId: strangerUser.id)
        layoutView()
    }
    
    @objc private func followButtonPressed() {
        followManager.follow(userWithId: strangerUser.id)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func layoutView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(backButton)
        view.addSubview(profilePicture)
        view.addSubview(usernameLabel)
        view.addSubview(followersLabel)
        view.addSubview(aboutLabel)
        view.addSubview(followButton)
        
        setupConstrains()
    }
    
    private func setupConstrains() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        profilePicture.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 16).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        followersLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16).isActive = true
        followersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        aboutLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 16).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        followButton.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 16).isActive = true
        followButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

}

extension StrangerProfileViewController: FollowManagerDelegate {
    func didFetchFollowers() {
        followersLabel.text = "\(followManager.getFollowers().count) followers"
    }
    
    func didFetchSubscriptions() {}
}
