//
//  SubscriptionsViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 06.01.2023.
//

import UIKit

class SubscriptionsViewController: UIViewController {
    
    let userManager: UserManager
    let followManager: FollowManager

    private lazy var searchTextField: UITextField = {
        let textView = UITextField()
        textView.textColor = .tertiaryLabel
        textView.placeholder = "Search for user"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .label
        return textView
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .fill
        stackView.alignment = .top
        return stackView
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

        layoutView()
    }
    
    @objc private func searchButtonPressed() {
        guard let username = searchTextField.text, !username.isEmpty else {
            // error enter username
            return
        }
        
        followManager.searchUser(withUsername: username) { [weak self] id in
            guard let id = id else {
                // error no such user found
                return
            }
            guard let self = self else { return }
            let strangerProfileVC = StrangerProfileViewController(userManager: self.userManager, followManager: self.followManager, strangerId: id)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(strangerProfileVC, animated: true)
            }
        }
        searchTextField.resignFirstResponder()
    }
    
    func layoutView() {
        view.backgroundColor = .systemBackground
        topStackView.addArrangedSubview(searchTextField)
        topStackView.addArrangedSubview(searchButton)
        
        view.addSubview(topStackView)
        
        setConstrains()
    }
    
    func setConstrains() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

}
