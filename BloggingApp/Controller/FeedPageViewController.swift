//
//  MainPageViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class FeedPageViewController: UIViewController {
    
    private var userManager: UserManager
    private var postManager = PostManager()
    
    private lazy var postTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.textColor = .tertiaryLabel
        textView.text = "What's up?"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .label
        return textView
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var postsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .fill
        stackView.alignment = .top
        return stackView
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
        postTextView.delegate = self
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.register(PostsTableViewCell.self, forCellReuseIdentifier: "postCell")
        postManager.delegate = self
        postManager.fetchPosts(forUser: userManager.user!)
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        title = "Main"
        layoutView()
    }
    
    @objc private func postButtonPressed() {
        if let message = postTextView.text, let user = userManager.user, message != "" {
            postManager.post(message: message, user: user)
        }
        postTextView.text = nil
        postTextView.resignFirstResponder()
    }
    
    func layoutView() {
        topStackView.addArrangedSubview(postTextView)
        topStackView.addArrangedSubview(postButton)
        view.addSubview(topStackView)
        view.addSubview(postsTableView)
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.showsVerticalScrollIndicator = false
        
        setupConstrains()
    }
    
    func setupConstrains() {
        postTextView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.8).isActive = true
        
        topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
        
        postsTableView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 16).isActive = true
        postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

extension FeedPageViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.isFirstResponder {
            postTextView.text = nil
            postTextView.textColor = .label
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == nil || textView.text == "" {
            textView.textColor = .tertiaryLabel
            textView.text = "What's up?"
        }
        return true
    }
}

extension FeedPageViewController: PostManagerDelegate {
    
    func didUpdatePosts() {
        postsTableView.reloadData()
    }
}

extension FeedPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FeedPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postManager.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostsTableViewCell {
            let time = getPostTime(date: postManager.posts[indexPath.row].date)
            cell.setFeedCell(withMessage: postManager.posts[indexPath.row].message, time: time)
            return cell
        }
        fatalError("Could not dequeue reusable cell")
    }
    
    func getPostTime(date: Date) -> String {
        let formattedDate = date.formatted(date: .numeric, time: .shortened)
        return formattedDate
    }
}
