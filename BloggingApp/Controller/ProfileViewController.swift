//
//  ProfileViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let userManager: UserManager
    
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
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = userManager.user?.username
        return label
    }()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = userManager.user?.about
        return label
    }()

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
        layoutView()
    }
    
    @objc private func editButtonPressed() {
        let editProfileVC = EditProfileViewController(userManager: userManager)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func layoutView() {
        view.backgroundColor = .systemBackground
        view.addSubview(editButton)
        view.addSubview(profilePicture)
        view.addSubview(usernameLabel)
        view.addSubview(aboutLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        profilePicture.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 16).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        aboutLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

}
