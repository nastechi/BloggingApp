//
//  LoginViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var userManager: UserManager
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .label
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .label
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToRegistrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Not registered yet?", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(goToRegistrationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .systemBackground
        title = "Login"
        print("Did load view for logging in")
        layoutView()
    }
    
    @objc private func loginButtonPressed() {
        if isValid() {
            userManager.logInUser(withEmail: emailTextField.text!, password: passwordTextField.text!)
        } else {
            errorMessageLabel.text = "Please fill all the fields."
        }
    }
    
    private func isValid() -> Bool {
        if let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty {
            return true
        }
        return false
    }
    
    @objc private func goToRegistrationButtonPressed() {
        let registerViewController = RegisterViewController(userManager: userManager)
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    private func layoutView() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(goToRegistrationButton)
        view.addSubview(errorMessageLabel)
        setupConstrains()
    }
    
    private func setupConstrains() {
        emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 5).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: view.frame.height / 4).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goToRegistrationButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        goToRegistrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        errorMessageLabel.topAnchor.constraint(equalTo: goToRegistrationButton.bottomAnchor, constant: 16).isActive = true
        errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16).isActive = true
        errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16).isActive = true
    }

}
