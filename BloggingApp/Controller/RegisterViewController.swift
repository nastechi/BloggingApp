//
//  RegisterViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var userManager: UserManager

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .label
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        //textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .label
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
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
        view.backgroundColor = .systemBackground
        title = "Register"
        layoutView()
    }
    
    @objc private func registerButtonPressed() {
        if isValid() {
            errorMessageLabel.text = ""
            userManager.registerUser(withEmail: emailTextField.text!, password: passwordTextField.text!)
        } else {
            errorMessageLabel.text = "Please fill all the fields. The password should be at least 6 characters long."
        }
    }
    
    private func isValid() -> Bool {
        if let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, password.count > 5 {
            return true
        }
        return false
    }
    
    private func layoutView() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
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
        
        registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: view.frame.height / 4).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        errorMessageLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16).isActive = true
        errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16).isActive = true
        errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16).isActive = true
    }

}
