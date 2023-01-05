//
//  UserManager.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

protocol UserManagerDelegate {
    func didUpdateUser()
    func didLogoutUser()
}

protocol ProfileManagerDelegate {
    func didUpdateUser()
}

final class UserManager {
    
    var user: User?
    var delegate: UserManagerDelegate?
    var profileDelegate: ProfileManagerDelegate?
    
    func fetchUser() {
        let auth = Auth.auth()
        if let email = auth.currentUser?.email, let id = auth.currentUser?.uid {
            user = User(id: id, email: email)
            fetchProfilePicture { [weak self] in
                self?.delegate?.didUpdateUser()
                self?.profileDelegate?.didUpdateUser()
            }
        } else if user != nil {
            user = nil
            delegate?.didLogoutUser()
        }
    }
    
    private func fetchProfilePicture(complition: @escaping () -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("\(user!.id)/profile_picture.jpg")
        fileRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard error == nil, data != nil else { return }
            let image = UIImage(data: data!)
            self?.user?.profilePicture = image
            complition()
        }
    }
    
    func registerUser(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self?.fetchUser()
        }
        
    }
    
    func logInUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            strongSelf.fetchUser()
        }
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        fetchUser()
    }
    
    func changeProfilePicture(to picture: UIImage) {
        
        guard let data = picture.jpegData(compressionQuality: 0.7) else { return }
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("\(user!.id)/profile_picture.jpg")
        let _ = fileRef.putData(data) { [weak self] metadata, error in
            guard error == nil else { return }
            
            self?.user?.profilePicture = picture
            self?.profileDelegate?.didUpdateUser()
        }
    }
    
    func changeUsername(to username: String) {
        user?.username = username
    }
    
    func changeAbout(to about: String) {
        user?.about = about
    }
}
