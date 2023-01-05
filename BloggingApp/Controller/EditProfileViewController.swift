//
//  EditProfileViewController.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit
import Photos
import PhotosUI

class EditProfileViewController: UIViewController {
    
    let userManager: UserManager
    var photo: UIImage?
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var changePictureButton: UIButton = {
        let button = UIButton()
        button.setImage(userManager.user?.profilePicture, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(changePictureButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.text = userManager.user?.username
        return textField
    }()
    
    private lazy var aboutTextView: UITextView = {
        let textView = UITextView()
        textView.text = userManager.user?.about
        textView.textColor = .secondaryLabel
        textView.isScrollEnabled = false
        return textView
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
        layoutView()
    }
    
    private func layoutView() {
        view.backgroundColor = .systemBackground
        view.addSubview(saveButton)
        view.addSubview(changePictureButton)
        view.addSubview(usernameTextField)
        view.addSubview(aboutTextView)
        setupConstrains()
    }
    
    private func setupConstrains() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        changePictureButton.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16).isActive = true
        
        changePictureButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant:  16).isActive = true
        changePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changePictureButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        usernameTextField.topAnchor.constraint(equalTo: changePictureButton.bottomAnchor, constant: 16).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        aboutTextView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16).isActive = true
        aboutTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16).isActive = true
        aboutTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16).isActive = true
    }
    
    @objc private func changePictureButtonPressed() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        
        let pickerVC = PHPickerViewController(configuration: configuration)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    @objc private func saveButtonPressed() {
        if let image = changePictureButton.imageView?.image, image != userManager.user?.profilePicture {
            userManager.changeProfilePicture(to: image)
        }
        if let username = usernameTextField.text, username != "", username != userManager.user?.username || aboutTextView.text != userManager.user?.about{
            userManager.changeUserInfo(to: username, about: aboutTextView.text)
        }
        navigationController?.popViewController(animated: true)
    }

}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { reading, error in
                if let image = reading as? UIImage {
                    DispatchQueue.main.async {
                        print("Selected image: \(image)")
                        self.changePictureButton.setImage(image, for: .normal)
                    }
                }
            })
        }
    }
}
